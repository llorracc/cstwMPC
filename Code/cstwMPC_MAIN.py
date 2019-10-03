'''
This is the main file for the cstwMPC project.  It estimates one version of the model
each time it is executed.  The following parameters *must* be defined in the __main__
namespace in order for this file to run correctly:
    
param_name : str
    Which parameter to introduce heterogeneity in (usually DiscFac).
dist_type : str
    Which type of distribution to use (can be 'uniform' or 'lognormal').
do_param_dist : bool
    Do param-dist version if True, param-point if False.
do_lifecycle : bool
    Use lifecycle model if True, perpetual youth if False.
do_agg_shocks : bool
    Whether to solve the FBS aggregate shocks version of the model or use idiosyncratic shocks only.
do_liquid : bool
    Matches liquid assets data when True, net worth data when False.
do_tractable : bool
    Whether to use an extremely simple alternate specification of households' optimization problem.
run_estimation : bool
    Whether to actually estimate the model specified by the other options.
run_sensitivity : [bool]
    Whether to run each of eight sensitivity analyses; currently inoperative.  Order:
    rho, xi_sigma, psi_sigma, mu, urate, mortality, g, R
find_beta_vs_KY : bool
    Whether to computes K/Y ratio for a wide range of beta; should have do_param_dist = False and param_name = 'DiscFac'.
    Currently inoperative.
path_to_models : str
    Absolute path to the location of this file.
    
All of these parameters are set when running this file from one of the do_XXX.py
files in the root directory.
'''
from __future__ import division, print_function
from __future__ import absolute_import

from builtins import str
from builtins import range

import os

import numpy as np
from copy import copy, deepcopy
from time import clock
from HARK.utilities import approxMeanOneLognormal, combineIndepDstns, approxUniform, \
                           getPercentiles, getLorenzShares, calcSubpopAvg, approxLognormal
from HARK.simulation import drawDiscrete
from HARK import Market
import HARK.ConsumptionSaving.ConsIndShockModel as Model
from HARK.ConsumptionSaving.ConsAggShockModel import CobbDouglasEconomy, AggShockConsumerType
from HARK.cstwMPC.cstwMPC import cstwMPCagent, cstwMPCmarket, getKYratioDifference, findLorenzDistanceAtTargetKY, calcStationaryAgeDstn
from scipy.optimize import brentq, minimize_scalar
import matplotlib.pyplot as plt

from IPython import get_ipython # Needed to test whether being run from command line or interactively

import SetupParamsCSTW as Params

mystr = lambda number : "{:.3f}".format(number)

# Construct the name of the specification from user options
if param_name == 'DiscFac':
    param_text = 'beta'
elif param_name == 'CRRA':
    param_text = 'rho'
else:
    param_text = param_name
if do_lifecycle:
    life_text = 'LC'
else:
    life_text = 'PY'
if do_param_dist:
    model_text = 'Dist'
else:
    model_text = 'Point'
if do_liquid:
    wealth_text = 'Liquid'
else:
    wealth_text = 'NetWorth'
if do_agg_shocks:
    shock_text = 'Agg'
else:
    shock_text = 'Ind'
spec_name = life_text + param_text + model_text + shock_text + wealth_text

if do_param_dist:
    pref_type_count = 7       # Number of discrete beta types in beta-dist
else:
    pref_type_count = 1       # Just one beta type in beta-point

###############################################################################
### ACTUAL WORK BEGINS BELOW THIS LINE  #######################################
###############################################################################

if __name__ == '__main__':
  
    # Set targets for K/Y and the Lorenz curve based on the data
    if do_liquid:
        lorenz_target = np.array([0.0, 0.004, 0.025,0.117])
        KY_target = 6.60
    else: # This is hacky until I can find the liquid wealth data and import it
        lorenz_target = getLorenzShares(Params.SCF_wealth,weights=Params.SCF_weights,percentiles=Params.percentiles_to_match)
        lorenz_long_data = np.hstack((np.array(0.0),getLorenzShares(Params.SCF_wealth,weights=Params.SCF_weights,percentiles=np.arange(0.01,1.0,0.01).tolist()),np.array(1.0)))
        #lorenz_target = np.array([-0.002, 0.01, 0.053,0.171])
        KY_target = 10.26
        
    # Set total number of simulated agents in the population
    if do_param_dist:
        if do_agg_shocks:
            Population = Params.pop_sim_agg_dist
        else:
            Population = Params.pop_sim_ind_dist
    else:
        if do_agg_shocks:
            Population = Params.pop_sim_agg_point
        else:
            Population = Params.pop_sim_ind_point
    
    # Make AgentTypes for estimation
    if do_lifecycle:
        DropoutType = cstwMPCagent(**Params.init_dropout)
        DropoutType.AgeDstn = calcStationaryAgeDstn(DropoutType.LivPrb,True)
        HighschoolType = deepcopy(DropoutType)
        HighschoolType(**Params.adj_highschool)
        HighschoolType.AgeDstn = calcStationaryAgeDstn(HighschoolType.LivPrb,True)
        CollegeType = deepcopy(DropoutType)
        CollegeType(**Params.adj_college)
        CollegeType.AgeDstn = calcStationaryAgeDstn(CollegeType.LivPrb,True)
        DropoutType.update()
        HighschoolType.update()
        CollegeType.update()
        EstimationAgentList = []
        for n in range(pref_type_count):
            EstimationAgentList.append(deepcopy(DropoutType))
            EstimationAgentList.append(deepcopy(HighschoolType))
            EstimationAgentList.append(deepcopy(CollegeType))
    else:
        if do_agg_shocks:
            PerpetualYouthType = cstwMPCagent(**Params.init_agg_shocks)
        else:
            PerpetualYouthType = cstwMPCagent(**Params.init_infinite)
        PerpetualYouthType.AgeDstn = np.array(1.0)
        EstimationAgentList = []
        for n in range(pref_type_count):
            EstimationAgentList.append(deepcopy(PerpetualYouthType))
    
    # Give all the AgentTypes different seeds
    for j in range(len(EstimationAgentList)):
        EstimationAgentList[j].seed = j
    
    # Make an economy for the consumers to live in
    market_dict = copy(Params.init_market)
    market_dict['AggShockBool'] = do_agg_shocks
    market_dict['Population'] = Population
    EstimationEconomy = cstwMPCmarket(**market_dict)
    EstimationEconomy.agents = EstimationAgentList
    EstimationEconomy.KYratioTarget = KY_target
    EstimationEconomy.LorenzTarget = lorenz_target
    EstimationEconomy.LorenzData = lorenz_long_data
    if do_lifecycle:
        EstimationEconomy.PopGroFac = Params.PopGroFac
        EstimationEconomy.TypeWeight = Params.TypeWeight_lifecycle
        EstimationEconomy.T_retire = Params.working_T-1
        EstimationEconomy.act_T = Params.T_sim_LC
        EstimationEconomy.ignore_periods = Params.ignore_periods_LC
    else:
        EstimationEconomy.PopGroFac = 1.0
        EstimationEconomy.TypeWeight = [1.0]
        EstimationEconomy.act_T = Params.T_sim_PY
        EstimationEconomy.ignore_periods = Params.ignore_periods_PY
    if do_agg_shocks:
        EstimationEconomy(**Params.aggregate_params)
        EstimationEconomy.update()
        EstimationEconomy.makeAggShkHist()
    
    # Estimate the model as requested
    if run_estimation:
        print('Beginning an estimation with the specification name ' + spec_name + '...')
        
        # Choose the bounding region for the parameter search
        if param_name == 'CRRA':
            param_range = [0.2,70.0]
            spread_range = [0.00001,1.0]
        elif param_name == 'DiscFac':
            param_range = [0.95,0.995]
            spread_range = [0.006,0.008]
        else:
            print('Parameter range for ' + param_name + ' has not been defined!')
    
        if do_param_dist:
            # Run the param-dist estimation
            paramDistObjective = lambda spread : findLorenzDistanceAtTargetKY(
                                                            Economy = EstimationEconomy,
                                                            param_name = param_name,
                                                            param_count = pref_type_count,
                                                            center_range = param_range,
                                                            spread = spread,
                                                            dist_type = dist_type)
            t_start = clock()
            spread_estimate = (minimize_scalar(paramDistObjective,bracket=spread_range,tol=1e-4,method='brent')).x
            center_estimate = EstimationEconomy.center_save
            t_end = clock()
        else:
            # Run the param-point estimation only
            paramPointObjective = lambda center : getKYratioDifference(Economy = EstimationEconomy,
                                                 param_name = param_name,
                                                 param_count = pref_type_count,
                                                 center = center,
                                                 spread = 0.0,
                                                 dist_type = dist_type)
            t_start = clock()
            center_estimate = brentq(paramPointObjective,param_range[0],param_range[1],xtol=1e-6)
            spread_estimate = 0.0
            t_end = clock()
    
        # Display statistics about the estimated model
        #center_estimate = 0.986609223266
        #spread_estimate = 0.00853886395698
        EstimationEconomy.LorenzBool = True
        EstimationEconomy.ManyStatsBool = True
        EstimationEconomy.distributeParams(param_name, pref_type_count,center_estimate,spread_estimate, dist_type)
        EstimationEconomy.solve()
        EstimationEconomy.calcLorenzDistance()
        print('Estimate is center=' + str(center_estimate) + ', spread=' + str(spread_estimate) + ', took ' + str(t_end-t_start) + ' seconds.')
        EstimationEconomy.center_estimate = center_estimate
        EstimationEconomy.spread_estimate = spread_estimate
        EstimationEconomy.showManyStats(spec_name)
        print('These results have been saved to ./Code/Results/' + spec_name + '.txt\n\n')
