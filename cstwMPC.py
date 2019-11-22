# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:percent
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.2'
#       jupytext_version: 1.2.4
#   kernelspec:
#     display_name: Python 3
#     language: python
#     name: python3
# ---

# %% [markdown]
# # The Distribution of Wealth and the MPC
#

# %% [markdown]
# This notebook presents a selection of results from the paper [The Distribution of Wealth and the Marginal Propensity to Consume](http://econ.jhu.edu/people/ccarroll/papers/cstwMPC), using the [Econ-ARK/HARK](https://github.com/econ-ark/HARK) toolkit.  It sketches the steps that would need to be taken to solve the model using the [dolARK](https://github.com/EconForge/dolARK) modeling system.

# %%
# This cell does some standard python setup

# Tools for navigating the filesystem
import sys
import os

# Import related generic python packages
import numpy as np
from time import clock
mystr = lambda number : "{:.4f}".format(number)
from copy import copy, deepcopy

# Plotting tools
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.pyplot import plot, draw, show

# iPython gives us some interactive and graphical tools
from IPython import get_ipython # In case it was run from python instead of ipython

# The warnings package allows us to ignore some harmless but alarming warning messages
import warnings
warnings.filterwarnings("ignore")

# %% [markdown]
# ## Contribution
#
# A principle problem in consumption economics is the development of a model
# that fits the empirical distribution of the marginal propensity to consume (MPC) as
# a function of wealth, given that the is high wealth inequality.
#
# Prior macroeconomic models that have assumed homogeneous agents have had the results
# of low wealth inequality. Krusell and Smith (1998) were the first to explain inequality in wealth through heterogeneity of agent discount factors. They modeled each intergenerational dynasty as having a discount factor that varies over time as a Markov process. They found this increase wealth inequality.
#
# This work finds a greater fit to the empirical distribution of wealth can be attained by modeling heterogeneity in discount factors as stable across generations. The discount factor distribution is uniform, with the breadth of the distribution determined by one free paramater. Fitting this parameter with a simple estimation process results in a model which fits the empirics better than Krusell and Smith (1998).

# %% [markdown]
# ## Notation For the Core Model
#
# We define the following notation.
#
# | Parameter | Description | Code | Value |
# | :---: | ---         | ---  | :---: |
# | $\newcommand{\PLives}{\Lambda} \PLives$ | Probability of living | $\texttt{\PLives}$ | 0.99375
# | $\newcommand{\Discount}{\beta}\Discount$ | Time Preference Factor | $\texttt{Discount}$ | 0.96 |
# | $\newcommand{\CRRA}{\rho}\CRRA$ | Coeﬃcient of Relative Risk Aversion| $\texttt{CRRA}$ | 2 |
#
# | Exogenous Variable | Description | Code | Value |
# | :---: | ---         | ---  | :---: |
# | $\newcommand{\tshk}{\zeta}\tshk$ | Transitory Income | $\texttt{tshk}$ |  |
# | $\newcommand{\pshk}{\psi}\pshk$ | Permanent Shock | $\texttt{pshk}$ |  |
# | $\sigma_\tshk$ | Transitory Income Standard Deviation |  | 0.1  |
# | $\sigma_\pshk$ | Permanent Shock Standard Deviation | | 0.1 |
#
# | Variable | Description | Code | Value |
# | :---: | ---         | ---  | :---: |
# | $\newcommand{\aRat}{a}\aRat$ | Assets | $\texttt{aRat}$ |  |
# | $\newcommand{\mRat}{m}\mRat$ | Market resources | $\texttt{mRt}$ |  |
# | $\newcommand{\KLev}{K}\KLev$ | Capital Aggregate | $\texttt{KLev}$
# | $\newcommand{\kapShare}{\alpha}\kapShare$ | Capital share | $\texttt{kapShare}$
# | $\newcommand{\LLev}{L}\LLev$ | Labor Aggregate | $\texttt{LLev}$
# | $\newcommand{\labor}{\ell}\labor$ | Labor share | $\texttt{labor}$ |
# | $\newcommand{\kRat}{k}\kRat$ | | $\texttt{kRAt}$ |  |
# | $\newcommand{\pRat}{p}\pRat$ | Permanent Income | $\texttt{pRat}$ |  |
# | $\newcommand{\rProd}{r}\rProd$ | | $\texttt{rProd}$ |  |
# | $\newcommand{\yLev}{y} \yLev$ | Income | $\texttt{yLev}$ | 
# | $\newcommand{\Wage}{W}\Wage$ | Aggregate Wage Rate | $\texttt{Wage}$ |  |
#
# | Functions | Description | Code | Value |
# | :---: | ---         | ---  | :---: |
# | $\newcommand{\cFunc}{\mathrm{c}}\cFunc$ | Consumption | $\texttt{cFunc}$ |  |
# | $\newcommand{\valfn}{\mathrm{v}} \valfn$ | Value | $\texttt{valfn}$
# | $\newcommand{\uFunc}{{\mathrm{u}}}\uFunc$ | Utility | $\texttt{uFunc}$ |  |
#
# $\newcommand{\cRat}{c}$
# $\newcommand{\Ex}{\mathbb{E}}$
# $\newcommand{\PDies}{\mathsf{P}}$
# $\newcommand{\ptyLev}{a}$
# $\newcommand{\YLev}{Y}$
# $\newcommand{\wEndRat}{\aRat}$

# %% [markdown]
# The consumer has a standard Constant Relative Risk Aversion utility function $$u(c)=\frac{c^{1-\rho}}{1-\rho}$$

# %% [markdown]
# Idiosyncratic (household) income process is logarithmic Friedman:
# \begin{eqnarray*}
# \yLev_{t+1}&=&\pRat_{t+1}\tshk_{t+1}\Wage\\
# \pRat_{t+1}&=&\pRat_{t}\pshk_{t+1}
# \end{eqnarray*}

# %% [markdown]
# Bellman form of the value function for households is:
#
# \begin{eqnarray}
# \valfn(\mRat_{t})&=&\underset{\cFunc_{t}}{\max } ~~ \uFunc(\cFunc_{t}(\mRat_t))+\Discount \PLives \Ex_{t}\left[ \pshk_{t+1}^{1-\CRRA}\valfn(\mRat_{t+1})
# \right]   \\
# \notag &\text{s.t.}&\\
# \wEndRat_{t} &=&\mRat_{t}-\cRat_{t},\\
# \wEndRat_{t} &\geq &0, \\
# \kRat_{t+1} &=&\wEndRat_{t}/(\PLives \pshk_{t+1}),
# \\
# \mRat_{t+1} &=&(\daleth +\rProd_t)\kRat_{t+1}+\tshk_{t+1},\\
# \rProd &=&\kapShare\ptyLev(\KLev/\labor\LLev)^{\kapShare-1}\\
# \end{eqnarray}

# %% [markdown]
# ## Time Preference Heterogeneneity
#
# Our specific approach is to replace the assumption that all households have the same time
# preference factor with an assumption that, for some dispersion $\nabla$, time
# preference factors are distributed uniformly in the population between
# $\grave{\Discount}-\nabla$ and $\grave{\Discount}+\nabla$ (for this reason, the model is referred to as the $\Discount$-Dist model).  Then,
# using simulations, we search for the values of $\grave{\Discount}$ and
# $\nabla$ for which the model best matches the fraction of net worth held by the top $20$, $40$, $60$, and $80$ percent of the population, while at the same time matching
# the aggregate capital-to-output ratio from the perfect foresight
# model. Specifically, defining $w_{i}$ and $\omega _{i}$ as the proportion of total aggregate net worth held by the top $i$ percent in our model and in the data, respectively, we solve the following minimization problem:
#
# $$  \{\grave{\Discount}, \nabla\}= \underset{\{{\Discount}, \nabla\}}{\text{argmin} }\Big(\sum_\text{i=20, 40, 60, 80}
#   \big(w_{i}({\Discount}, \nabla)-\omega _{i}\big)^{2}\Big)^{1/2}$$
#   subject to the constraint that the aggregate wealth (net worth)-to-output ratio in the model matches the aggregate
# capital-to-output ratio from the perfect foresight model ($\KLev_{PF}/\YLev_{PF}$). When solving the problem for the FBS specification we shut down the aggregate shocks (practically, this does not affect the estimates given their small size).
#  
# $$\KLev / \YLev = \KLev_{PF} / \YLev_{PF}$$
#
# The solution to this problem is $\{\grave{\Discount}, \nabla\}=\{0.9867, 0.0067\}$
# , so that the discount factors are evenly spread roughly between 0.98 and 0.99. We call the optimal value of the objective function the 'Lorenz distance' and use it as a measure of fit of the models.
#
# The introduction of even such a relatively modest amount of time
# preference heterogeneity sharply improves the model's fit to the targeted
# proportions of wealth holdings, bringing it reasonably in line with the data.

# %%
'''
This will run the absolute minimum amount of work that actually produces
relevant output-- no aggregate shocks, perpetual youth, matching net worth.
Will run both beta-point and beta-dist versions.
'''
import os

'''
Copied here from do_min.py.
Design decisions about whether to include this code explicitly,
or import it, or execute it as is here, TBD.
'''

here = os.path.dirname(os.path.realpath("cstwMPC.ipynb"))
my_path = os.path.join(here,'')
path_to_models = os.path.join(my_path,'Code')

# %%
# For speed here, use the "tractable" version of the model
'''
This options file specifies parameter heterogeneity, making the choice in the paper:
uniformly distributed discount factors.
'''
param_name = 'DiscFac'        # Which parameter to introduce heterogeneity in
dist_type = 'uniform'         # Which type of distribution to use

'''
This options file specifies the "standard" work options for cstwMPC, estimating the model only.
'''
run_estimation = True         # Runs the estimation if True
run_sensitivity = [False, False, False, False, False, False, False, False] # Choose which sensitivity analyses to run: rho, xi_sigma, psi_sigma, mu, urate, mortality, g, R
find_beta_vs_KY = False       # Computes K/Y ratio for a wide range of beta; should have do_beta_dist = False
do_tractable = True          # Uses a "tractable consumer" rather than solving full model when True


# %%
# Solve for the $\beta-Point$ (do_param_dist=False) for speed
'''
This options file establishes the second simplest model specification possible:
with heterogeneity, no aggregate shocks, perpetual youth model, matching net worth.
'''
do_param_dist = False          # Do param-dist version if True, param-point if False
do_lifecycle = False          # Use lifecycle model if True, perpetual youth if False
do_agg_shocks = False         # Solve the FBS aggregate shocks version of the model
do_liquid = True             # Matches liquid assets data when True, net worth data when False


os.chdir(path_to_models)
exec(open('cstwMPC_MAIN.py').read())

# %%
'''
This options file establishes the second simplest model specification possible:
with heterogeneity, no aggregate shocks, perpetual youth model, matching net worth.
'''
do_param_dist = True          # Do param-dist version if True, param-point if False
do_lifecycle = False          # Use lifecycle model if True, perpetual youth if False
do_agg_shocks = False         # Solve the FBS aggregate shocks version of the model
do_liquid = False             # Matches liquid assets data when True, net worth data when False

os.chdir(path_to_models)
exec(open('cstwMPC_MAIN.py').read())
