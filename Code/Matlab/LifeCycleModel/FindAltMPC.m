% This script calculates the "alternate MPC" by giving a $1000 stimulus to
% each household (at each age) and calculating the total change in
% consumption over the next four quarters.

clear all;
close all;
clc;
rng(138);

global aPoints BigT SimPop SimT WorkGroupSize ShowTiming MaxParamCount DrawFig TypeCount LorenzWeight RatioWeight myGuess
global AvgMPCPopulation AvgMPCbyWYratio AvgMPCbyPermY AvgMPCUnemployed AvgMPCEmployed MPCplot LorenzPlot MatchNine rhoDist MPCbyAge MPCbyAgeImpatient MPCbyAgePatient

% Choose whether to display timings
ShowTiming = false;
DrawFig = false;

% Choose the OpenCL platform and device (manually look at list and choose)
Platform = 1;
Device = 3;
WorkGroupSize = 1;
DefaultWGS = true; % when this is true, SetupProblem automatically chooses work group size
TypeCount = 10;

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

% Choose moment weightings and which data to match
LorenzWeight = 0;
RatioWeight = 1;
MatchLiquid = false;
MatchNine = false;
rhoDist = false;

% Use the selected parameters to set up the problem
SetupProblem;

% Load in the estimated parameters for the main specification
cd Results
load('NetWorthNoBequestsBetaDistMPCstats.mat','MaxParams');
cd ..
Guess = MaxParams;

% Solve the model at the estimated parameters
ObjectiveFuncOpenCL(Guess);

% Calculate the alternative MPC for each period
f = @(x) 1 - (1-max(min(x,1),0)).^4;
AlternativeMPC = nan(SimPop*3*TypeCount,SimT-3);
BaseConsumption = reshape(ConOutX.get()'.*PermIncomeGrid,[SimPop*3*TypeCount,SimT]);
BaseMPC = f(MPCoutX.get()');
BaseMPC = BaseMPC(1:(SimPop*3*TypeCount*(SimT-3)));
MyPopWeight = PopWeight(1:(SimPop*3*TypeCount*(SimT-3)));
PermIncomeGridZ = reshape(PermIncomeGrid,[SimPop*3*TypeCount,SimT]);
for t = 1:(SimT-3),
    Bonus = PermIncomeGridZ(:,t).^(-1);
    ThetaGrid(:,t) = ThetaGrid(:,t) + Bonus;
    ThetaGridX.set(ThetaGrid);
    SimulationKernel(WealthOutX,MPCoutX,ConOutX,WealthInitX,ThetaGridX,PsiGridX,mGridLifeX,CoeffsLifeX,aLowerBoundLifeZX,FancyGLifeZX,RLifeZX,BequestX,IntegerInputsX);
    ocl.wait();
    Consumption = reshape(ConOutX.get()'.*PermIncomeGrid,[SimPop*3*TypeCount,SimT]);
    NewCon = sum(Consumption(:,t:(t+3)),2);
    OldCon = sum(BaseConsumption(:,t:(t+3)),2);
    AlternativeMPC(:,t) = NewCon - OldCon;
    ThetaGrid(:,t) = ThetaGrid(:,t) - Bonus;
    if mod(t,10) == 0,
        disp(['Finished period ' num2str(t) ' of ' num2str(SimT-3) '.']); 
    end
end
AlternativeMPC = reshape(AlternativeMPC,[SimPop*3*TypeCount*(SimT-3),1]);
disp(['Aggregate alternative MPC is ' num2str(sum(AlternativeMPC.*MyPopWeight,1)/sum(MyPopWeight)) ' vs standard MPC of ' num2str(sum(BaseMPC.*MyPopWeight,1)/sum(MyPopWeight))]);

