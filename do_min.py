'''
This file will run the absolute minimum amount of work that actually produces
relevant output-- no aggregate shocks, perpetual youth, matching net worth.
Will run both beta-point and beta-dist versions.
'''
import os

here = os.path.dirname(os.path.realpath(__file__))
my_path = os.path.join(here,'')
path_to_models = os.path.join(my_path,'Code')
path_to_options = os.path.join(path_to_models,'Options')

# Set up basic options
os.chdir(path_to_options)
exec(open('UseUniformBetaDist.py').read())
exec(open('DoStandardWork.py').read())

# Run beta-point model
exec(open('SimpleSpecPoint.py').read())
os.chdir(path_to_models)
exec(open('cstwMPC_MAIN.py').read())

# Run beta-dist model
os.chdir(path_to_options)
exec(open('SimpleSpecDist.py').read())
os.chdir(path_to_models)
exec(open('cstwMPC_MAIN.py').read())
