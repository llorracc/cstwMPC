This folder contains the files used in the life cycle / overlapping generations models of cstwMPC.
Most of the files are Matlab scripts and functions, along with a couple small data files.  One file
contains the main code in OpenCL, a new-ish parallel / heterogeneous computing language.  Running
the code requires the user to successfully install both OpenCL itself, available at www.khronos.org/opencl/,
and Radford Juang's Matlab-OpenCL toolkit, available at http://www.mathworks.com/matlabcentral/fileexchange/30109-opencl-toolbox-v0-17

Once OpenCL and the Matlab toolkit are installed, you will need to manually check which platforms
and devices are available.  At the MATLAB prompt, do "ocl = opencl();", then "ocl.platforms(1).devices(#)".
Depending on your computer, there might also be devices in platform 2 (or even 3, maybe).  The size
of this model is small enough that running on a GPU is not particularly useful, so it's probably best
to simply select the CPU.  Once you have selected your device, change the lines that set the vari-
ables Platform and Device in EstimateModel.m and FindAltMPC.m.

A brief description of each file follows:

MATLAB code:
- DoAllForPaper.m            - Estimates the three specifications reported in cstwMPC by calling EstimateModel.m
- DoAllExtra.m               - Estimates twelve specifications using bequest distribution (takes about a day to run)
- EstimateModel.m            - Estimates a single specification by taking a string input, loads the specification from the Specifications folder
- FindAltMPC.m               - Calculates the alternate MPC using a simulation method (for the main specification)
- ObjectiveFunctionOpenCL.m  - Function that takes a set of parameter inputs and returns the model fit (Lorenz curve or K/Y matching)
- UpdateBequests.m           - Uses the current behavioral functions to find consistent bequests in the economy
- SetupProblem.m             - Does the vast bulk of initialization work to set up the model for the specification selected
- LorenzFitAtTargetKYratio.m - Holding nabla constant, finds the beth (beta-grave) that matches the K/Y target, then reports the Lorenz fit
- MakeShocks.m               - Calculates discrete approximation to a lognormal distribution (written by Jaoxiong Yao, slightly modified here)
- PlotConFuncs.m             - Plots the consumption function at a variety of ages for one type
- MultiWrapper.m             - Wrapper function that allows ObjectiveFunctionOpenCL to be used with MyNMsearch (take multiple inputs)
- MyNMsearch.m               - Performs the Nelder-Mead simplex search algorithm until stopping criteria are met
- ShowMPCstats.m             - Displays summary statistics about the specification just estimated (for putting into tables)

OpenCL code:
- BufferSaving.m             - Contains OpenCL functions for solving the model, simulating data, and updating bequests.  Assumes double precision capability.

Data files:
USactuarial.txt              - U.S. mortality data by age (for women), taken from SSA 2010 actuarial table
EducMortAdj.txt              - Adjustments to mortality based on education level, taken from Brown, Liebman, and Pollett (2002)

Subdirectories:
Specifications               - Contains fifteen .mat files, each containing parameters that define a specification (used by EstimateModel)
Results                      - Stores .mat files for each specification run for later reading and transfer to tables
Figures                      - Stores .txt files for some specifications, along with Mathematica files to produce figures
