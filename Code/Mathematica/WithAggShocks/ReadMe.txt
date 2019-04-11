This directory contains Mathematica programs that produce the results of the model with Krusell-Smith aggregate shocks. 

 - SolveAndSimRepAgent.nb: runs rep agent model with agg shocks.  * Takes 5 second using Core 2 Duo (2.5GHz)

 - SolveAndSimKS.nb: runs KS-JEDC model.     * Takes (at most) 10 mins using Core 2 Duo (2.5GHz). (Runing KS model itself takes only 3 mins, but estimating KS and Castaneda income variances takes several minutes.)

 - SolveAndSimKSHetero.nb: runs KS-Hetero model.     * Takes (at most) 20 mins using Core 2 Duo (2.5GHz). 

 - SolveAndSimPoint.nb: runs \[Beta]-Point model and plots consumption function. 
                                             * Takes 30 mins using Core 2 Duo (2.5GHz)

 - FindBetaDistSeven.nb: estimates parameter values for \[Beta]-Dist model (with aggregate shocks) 
                                             * Takes several hours using Core 2 Duo (2.5GHz)

 - SolveAndSimDistSeven.nb: runs \[Beta]-Dist model (with seven types). * Takes 3-4 hours using Core 2 Duo (2.5GHz)

 - SolveAndSimKS_experiments.nb: gives results of the experiment in the paper using KS-JEDC model. 

 - PlotDistributionsWealthLevSCF_CastanedaAndDistSeven.nb: plots cumulative distributions of wealth (levels) of the KS-JEDC, KS-Hetero, \[Beta]-Point and \[Beta]-Dist models, and the US data. The numbers for the KS-JEDC, \[Beta]-Point and \[Beta]-Dist models are obtained, by running SolveAndSimKS.nb, SolveAndSimPoint.nb, and SolveAndSimDistSeven.nb, respectively.  

- PlotDistributionsMPCsDistSevenKSAggShocks.nb: plots the distribution of MPCs of \[Beta]-Dist model (matching net worth and liquid financial assets)  

- If "Fin" is included in the file name, the distribution of financial assets is matched to obtain the solution. Similarly, if "LiqFinPlsRet" means liquid financial assets and retirement assets and "LiqFin" means liquid financial assets. 




