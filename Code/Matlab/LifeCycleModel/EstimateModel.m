% This function estimates the beta-point or beta-dist model, reading in model parameters from the selected file.
% beta-point is run when TypeCount == 1, else beta-dist is run.

function Null = EstimateModel(InputFile)
rng(138);
close all;

global aPoints BigT SimPop SimT WorkGroupSize ShowTiming MaxParamCount DrawFig TypeCount LorenzWeight RatioWeight myGuess
global AvgMPCPopulation AvgMPCbyWYratio AvgMPCbyPermY AvgMPCUnemployed AvgMPCEmployed MPCplot LorenzPlot MatchNine rhoDist MPCbyAge MPCbyAgeImpatient MPCbyAgePatient

% Choose whether to display timings and other initializations (that shouldn't be changed)
ShowTiming = false;
DrawFig = false;
LorenzWeight = 0;
RatioWeight = 1;
MatchNine = false; % deprecated functionality: match 10-20-...-90th percentiles rather than 20-40-60-80
rhoDist = false; % deprecated functionality: match distribution of rho rather than beta

% Load in the specification file
cd Specifications
LoadString = [InputFile '.mat'];
load(LoadString);
cd ..
disp(['Now estimating the specification in ' LoadString]);

% Choose the OpenCL platform and device (manually look at list and choose)
Platform = 1;
Device = 3;
WorkGroupSize = 1;
DefaultWGS = true; % when this is true, SetupProblem automatically chooses work group size

% Specify number of shock points for permanent and transitory income shocks
PsiPoints = 10;
ThetaPoints = 10;
TailPoints = 0;

% Specify number of end-of-period assets points (and the limits of the range)
aPoints = 7;
aMin = 0.001;
aMax = 30;

% Choose the number of people and periods to simulate
SimPop = 2000;
SimT = 300;

% Choose starting beth (beta-grave) and nabla
beth = 0.98;
if TypeCount > 1,
    nabla = 0.015;
else
    nabla = 0;
end
if rhoDist, % This is never used
    myGuess = rho;
else
    myGuess = beth;
end

% Use the selected settings to set up the model
SetupProblem;

% Set the initial guess and perturbation, along with search options
Guess = [rho, beth, nabla, Alpha, nu, Gamma]';
MyOptions.Resume = false;
MyOptions.SaveEveryT = 0;
MyOptions.DispEveryT = 1;
if TypeCount > 1, 
    Perturb = [0,0,0.005,0,0.00,0.0]';
    MyFunc = @(x) -LorenzFitAtTargetKYratio(x);
    MyOptions.ValTol = 10^-7;
    MyOptions.SpanTol = 10^-6;
    MyOptions.MaxIter = 100;
    MyOptions.DataFile = 'DistEstimation.mat';
else
    Perturb = [0, 0.005, 0.000, 0, 0, 0]';
    MyFunc = @(x) -MultiWrapper(x);
    MyOptions.ValTol = 10^-10;
    MyOptions.SpanTol = 10^-12;
    MyOptions.MaxIter = 1000;
    MyOptions.DataFile = 'PointEstimation.mat';
end

% Run the estimation (multiple times if distributing bequests)
BequestAvg = nan(BequestLoops,1);
NablaHistory = nan(BequestLoops,1);
for b = 1:BequestLoops,
    [MaxParams, MaxVal] = MyNMsearch(MyFunc,Guess,Perturb,MyOptions);
    if (b < BequestLoops),
        UpdateBequests;
    end
    BequestAvg(b) = sum(BequestX.get()'.*PopWeight,1);
    NablaHistory(b) = MaxParams(3);
    Guess = MaxParams;
    disp(['Finished estimation ' num2str(b) ' of ' num2str(BequestLoops) ' after ' num2str(toc) ' seconds.']);
end
if TypeCount > 1,
    [Fit,beth] = LorenzFitAtTargetKYratio(MaxParams);
    DrawFig = true;
    MaxParams(2) = beth;
    ObjectiveFuncOpenCL(MaxParams);
else
    DrawFig = true;
    MyFunc(MaxParams);
end

% Save the output for viewing later and making figures
cd Results;
save([InputFile 'MPCstats.mat'],'MaxParams','AvgMPCPopulation','AvgMPCbyWYratio','AvgMPCbyPermY','AvgMPCUnemployed','AvgMPCEmployed','MPCplot','LorenzPlot','MPCbyAge','MPCbyAgeImpatient','MPCbyAgePatient');
cd ..
if UsedForFigs,
    cd Figures;
    save([InputFile 'Lorenz.txt'],'LorenzPlot','-ascii');
    save([InputFile 'MPClist.txt'],'MPCplot','-ascii');
    save([InputFile 'MPCbyAge.txt'],'MPCbyAge','-ascii');
    save([InputFile 'MPCbyAgePatient.txt'],'MPCbyAgePatient','-ascii');
    save([InputFile 'MPCbyAgeImpatient.txt'],'MPCbyAgeImpatient','-ascii');
    cd ..
end
Null = nan;
