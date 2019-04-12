'''
This options file establishes the second simplest model specification possible:
with heterogeneity, no aggregate shocks, perpetual youth model, matching net worth.
'''
do_param_dist = True          # Do param-dist version if True, param-point if False
do_lifecycle = False          # Use lifecycle model if True, perpetual youth if False
do_agg_shocks = False         # Solve the FBS aggregate shocks version of the model
do_liquid = False             # Matches liquid assets data when True, net worth data when False