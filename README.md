# cstwMPC-Ur

-- to generate model estimates and output like that in the paper: 
1. Install Anaconda for Python 2 or 3
2. In the Anaconda terminal (Windows) or Unix-like terminal (other OS):
    - Navigate to ./Code/
    - run "pip install -r requirements.txt"
3. Run Spyder, and open ./do_min or ./do_mid.py
4. Run the code by clicking the green arrow button.

Running do_min.py will estimate two simple specifications of the model, with no aggregate shocks.
    This takes a few minutes to run-- approximately 10-15 minutes on a typical computer.

Running do_mid.py will estimate the two main specifications reported in the paper (beta point and
    beta dist) with FBS-style aggregate shocks; target data is net worth.  This takes several hours to run.

Running do_custom.py will let you choose exactly which model is estimated, choosing options manually.

Progress will be printed to screen when these files are run.