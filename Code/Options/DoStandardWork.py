'''
This options file specifies the "standard" work options for cstwMPC, estimating the model only.
'''
run_estimation = True         # Runs the estimation if True
run_sensitivity = [False, False, False, False, False, False, False, False] # Choose which sensitivity analyses to run: rho, xi_sigma, psi_sigma, mu, urate, mortality, g, R
find_beta_vs_KY = False       # Computes K/Y ratio for a wide range of beta; should have do_beta_dist = False
do_tractable = False          # Uses a "tractable consumer" rather than solving full model when True
