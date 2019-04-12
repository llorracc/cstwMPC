'''
This module runs a custom model specification, with all options specified by the user.
'''

import os
here = os.path.dirname(os.path.realpath(__file__))
my_path = os.path.join(here,'')
path_to_models = os.path.join(my_path,'Code')
path_to_options = os.path.join(path_to_models,'Options')

param_name = 'DiscFac'        # Which parameter to introduce heterogeneity in
dist_type = 'uniform'         # Which type of distribution to use
do_param_dist = False         # Do param-dist version if True, param-point if False

do_lifecycle = False          # Use lifecycle model if True, perpetual youth if False
do_agg_shocks = False         # Solve the FBS aggregate shocks version of the model
do_liquid = False             # Matches liquid assets data when True, net worth data when False

run_estimation = True         # Runs the estimation if True
run_sensitivity = [False, False, False, False, False, False, False, False] # Choose which sensitivity analyses to run: rho, xi_sigma, psi_sigma, mu, urate, mortality, g, R
find_beta_vs_KY = False       # Computes K/Y ratio for a wide range of beta; should have do_beta_dist = False
do_tractable = False          # Uses a "tractable consumer" rather than solving full model when True

# Run the custom model
os.chdir(path_to_models)
exec(open('cstwMPC_MAIN.py').read())