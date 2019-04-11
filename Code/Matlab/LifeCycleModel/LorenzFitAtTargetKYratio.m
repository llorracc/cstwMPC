% This function takes a vector of nabla values as inputs, finds the beth
% that fits the target KY ratio for each one, and reports the Lorenz curve
% fit for each nabla.

function [FitVec, bethVec] = LorenzFitAtTargetKYratio(Params)
global LorenzWeight RatioWeight myGuess rhoDist

if rhoDist,
    Perturb = [0.1, 0, 0.000, 0, 0, 0]';
else
    Perturb = [0, 0.005, 0.000, 0, 0, 0]';
end
MyFunc = @(x) -MultiWrapper(x);

MyOptions.ValTol = 10^-10;
MyOptions.SpanTol = 10^-10;
MyOptions.MaxIter = 1000;
MyOptions.Resume = false;
MyOptions.DataFile = 'DistEstimation.mat';
MyOptions.SaveEveryT = 0;
MyOptions.DispEveryT = 0;

bethVec = nan(1,size(Params,2));
FitVec = nan(1,size(Params,2));
for z = 1:size(Params,2),
    LorenzWeight = 0;
    RatioWeight = 1;
    if rhoDist,
        rho = myGuess;
        beth = Params(2,z);
    else
        rho = Params(1,z);
        beth = myGuess;
    end
    nabla = Params(3,z);
    alpha = Params(4,z);
    nu = Params(5,z);
    gamma = Params(6,z);
    Guess = [rho, beth, nabla, alpha, nu, gamma]';
    [MaxParams, MaxVal] = MyNMsearch(MyFunc,Guess,Perturb,MyOptions);
    LorenzWeight = 1;
    RatioWeight = 0;
    if rhoDist,
        optrho = MaxParams(1);
        bethVec(z) = optrho;
        Guess(1) = optrho;
        FitVec(z) = ObjectiveFuncOpenCL(Guess);
        myGuess = optrho;
    else
        optbeth = MaxParams(2);
        bethVec(z) = optbeth;
        Guess(2) = optbeth;
        FitVec(z) = ObjectiveFuncOpenCL(Guess);
        myGuess = optbeth;
    end
end

