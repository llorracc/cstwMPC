% This script sets up the OpenCL life cycle solver, simulator, and moment comparison.

tic
% Globalize variables that will be used by OpenCL
global CoeffsLifeX mGridLifeX aGridLifeX RLifeX FancyGLifeX DiscountBaseX ThetaValsLifeX PsiValsLifeX ThetaProbsLifeX PsiProbsLifeX aLowerBoundLifeX rhoVecX bethVecX cVecX cPVecX mVecX IntegerInputsX MPCoutX ThetaGrid
global WealthOutX ConOutX WealthInitX ThetaGridX PsiGridX aLowerBoundLifeZX FancyGLifeZX RLifeZX IntegerInputs  MaxThreads DiscountBase RLife FancyGLife DeltahLife aLowerBoundLife aPoints YoungT alphaVecX nuVecX gammaVecX
global ocl SolveLifeCycleKernel SimulationKernel mGridLifeAll CoeffsLifeAll PermIncomeGrid PopWeight TotalOutput SimWealth KYratioData LorenzData UnemployedAll EmployedAll BequestFromX BequestStartX BequestCountX BequestX BequestScaleX BequestKernel

% Find the indices of the requested quantiles
MaxParamCount = TypeCount*3;

% Specify number of periods to solve
YoungT = 41;
OldT = 55;
BigT = (YoungT + OldT)*4; % quarterly model

% Choose some basic parameters
R = 1.04; % annual interest rate throughout life
PopGrowth = 1.010; % annual growth rate of population, or how much bigger each cohort is than previous one
TFPGrowth = 1.015; % annual growth rate of total factor productivity; economic growth rate
R = R^0.25; % quarterly interest rate
PopGrowth = PopGrowth^0.25; % quarterly rate 
TFPGrowth = TFPGrowth^0.25;
NoHSpct = 0.11;
HSpct = 0.55; % distribution of education in the population at age 25
NoHSBaseIncome = 20/4;
HSBaseIncome = 30/4;
ColBaseIncome = 48/4;
PermIncomeSigma = 0.4;
Colpct = 0.34;
UnemploymentRate = 0.07;
ReplacementRate = 0.15; % fraction of permanent income received as unemployment benefit
Mho = UnemploymentRate; % probability of receiving no income when working
MhoRetired = 0.0005; % probability of receiving no income when retired
FailProb = 0.01; % probability that UI is not received when unemployed
FailRate = 0.000; % income when UI is not received
TailMean = 0.3; % center of upper tail distribution
TailStd = 0.6; % standard deviation of upper tail distribution
ProbInTail = 0.005; % probability of getting the tail draw

% Generate permanent and transitory shocks for the entire life cycle
PsiStdYoung = sqrt((0.00011342*((24:0.25:64.75)' - 47).^2 + 0.01)/4);
ThetaStdYoung = sqrt([(0.1:0.00125:0.12)'; 0.12*ones(18,1); (0.12:-0.00075:0.075)'; (0.075:-0.0011194:0.00)']);
ThetaStdYoung(YoungT*4) = 0.01;
PsiStdLife = [zeros(OldT*4+1,1); flipud(PsiStdYoung)];
ThetaStdLife = [zeros(OldT*4+1,1); flipud(ThetaStdYoung)];
PsiValsLife = nan(PsiPoints+TailPoints,BigT+1);
ThetaValsLife = nan(ThetaPoints+1,BigT+1);
PsiProbsLife = nan(PsiPoints+TailPoints,BigT+1);
ThetaProbsLife = nan(ThetaPoints+1,BigT+1);

% Fill in shocks and probabilities when young
TailVals = MakeShocks(TailPoints,TailMean,TailStd)';
TailProbs = ProbInTail/TailPoints*ones(TailPoints,1);
TailAdj = (1 - ProbInTail*exp(TailMean))/(1 - ProbInTail);
for t = (BigT+1):(-1):(OldT*4+2),
    ThetaVals = MakeShocks(ThetaPoints-1,0,ThetaStdLife(t))'*(1/(1-Mho));
    PsiVals = MakeShocks(PsiPoints,0,PsiStdLife(t))'*TailAdj;
    PsiValsLife(:,t) = [PsiVals; TailVals];
    ThetaValsLife(:,t) = [FailRate; ReplacementRate; ThetaVals];
    PsiProbsLife(:,t) = [1/PsiPoints*(ones(PsiPoints,1) - ProbInTail); TailProbs];
    ThetaProbsLife(:,t) = [FailProb*Mho; (1-FailProb)*Mho; (1-Mho)/(ThetaPoints-1)*ones(ThetaPoints-1,1)];
end

% Fill in shocks and probabilities when old
ThetaRetired = 1/(1-MhoRetired);
for t = (OldT*4+1):(-1):1,
    PsiValsLife(:,t) = ones(PsiPoints+TailPoints,1);
    ThetaValsLife(:,t) = [0; ThetaRetired; zeros(ThetaPoints-1,1)];
    PsiProbsLife(:,t) = [1; zeros(PsiPoints+TailPoints-1,1)];
    ThetaProbsLife(:,t) = [MhoRetired; (1-MhoRetired); zeros(ThetaPoints-1,1)];
end
PsiPoints = PsiPoints + TailPoints;

% Define survival probabilities for each education level (for white women)
RawActuarialData = importdata('USactuarial.txt');
ActuarialData = str2double(RawActuarialData.textdata);
BaseDeathProb = ActuarialData(26:120,5);
EducAdjData = importdata('EducMortAdj.txt');
NoHSAdj = EducAdjData(:,2);
NoHSAdj = [NoHSAdj; NoHSAdj(76)*ones(19,1)];
HSAdj = EducAdjData(:,3);
HSAdj = [HSAdj; HSAdj(76)*ones(19,1)];
ColAdj = EducAdjData(:,4);
ColAdj = [ColAdj; ColAdj(76)*ones(19,1)];
NoHSDeathProb = BaseDeathProb.*NoHSAdj;
HSDeathProb = BaseDeathProb.*HSAdj;
ColDeathProb = BaseDeathProb.*ColAdj;
SurvivalProbs = flipud(1 - [NoHSDeathProb, HSDeathProb, ColDeathProb]);
SurvivalProbs = reshape(permute(repmat(SurvivalProbs.^0.25,[1 1 4]),[3 1 2]),[(BigT-4) 3]); % quarterly model
SurvivalProbs = [repmat(SurvivalProbs(1,:),[4 1]); SurvivalProbs];

% Make the vectors of lifetime average growth factors
NoHSGrowth = 1 + [5.2522391e-002  5.0039782e-002  4.7586132e-002  4.5162424e-002  4.2769638e-002  4.0408757e-002  3.8080763e-002  3.5786635e-002  3.3527358e-002  3.1303911e-002  2.9117277e-002  2.6968437e-002  2.4858374e-002  2.2788068e-002  2.0758501e-002  1.8770655e-002  1.6825511e-002  1.4924052e-002  1.3067258e-002  1.1256112e-002  9.4915947e-003  7.7746883e-003  6.1063742e-003  4.4876340e-003  2.9194495e-003  1.4028022e-003 -6.1326258e-005 -1.4719542e-003 -2.8280999e-003 -4.1287819e-003 -5.3730185e-003 -6.5598280e-003 -7.6882288e-003 -8.7572392e-003 -9.7658777e-003 -1.0713163e-002 -1.1598112e-002 -1.2419745e-002 -1.3177079e-002 -1.3869133e-002 -4.3985368e-001 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003 -8.5623256e-003]';
HSGrowth = 1 + [4.1102173e-002  4.1194381e-002  4.1117402e-002  4.0878307e-002  4.0484168e-002  3.9942056e-002  3.9259042e-002  3.8442198e-002  3.7498596e-002  3.6435308e-002  3.5259403e-002  3.3977955e-002  3.2598035e-002  3.1126713e-002  2.9571062e-002  2.7938153e-002  2.6235058e-002  2.4468848e-002  2.2646594e-002  2.0775369e-002  1.8862243e-002  1.6914288e-002  1.4938576e-002  1.2942178e-002  1.0932165e-002  8.9156095e-003  6.8995825e-003  4.8911556e-003  2.8974003e-003  9.2538802e-004 -1.0178097e-003 -2.9251214e-003 -4.7894755e-003 -6.6038005e-003 -8.3610250e-003 -1.0054077e-002 -1.1675886e-002 -1.3219380e-002 -1.4677487e-002 -1.6043137e-002 -5.5864350e-001 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002 -1.0820465e-002]';
ColGrowth = 1 + [3.9375106e-002  3.9030288e-002  3.8601230e-002  3.8091011e-002  3.7502710e-002  3.6839406e-002  3.6104179e-002  3.5300107e-002  3.4430270e-002  3.3497746e-002  3.2505614e-002  3.1456953e-002  3.0354843e-002  2.9202363e-002  2.8002591e-002  2.6758606e-002  2.5473489e-002  2.4150316e-002  2.2792168e-002  2.1402124e-002  1.9983263e-002  1.8538663e-002  1.7071404e-002  1.5584565e-002  1.4081224e-002  1.2564462e-002  1.1037356e-002  9.5029859e-003  7.9644308e-003  6.4247695e-003  4.8870812e-003  3.3544449e-003  1.8299396e-003  3.1664424e-004 -1.1823620e-003 -2.6640003e-003 -4.1251914e-003 -5.5628564e-003 -6.9739162e-003 -8.3552918e-003 -6.8938447e-001 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004 -6.1023256e-004]';
NoHSGrowth = [NoHSGrowth; NoHSGrowth(65)*ones(31,1)];
HSGrowth = [HSGrowth; HSGrowth(65)*ones(31,1)];
ColGrowth = [ColGrowth; ColGrowth(65)*ones(31,1)];
NoHSRetire = NoHSGrowth(41);
HSRetire = HSGrowth(41);
ColRetire = ColGrowth(41);
NoHSGrowth(41) = NoHSGrowth(40);
HSGrowth(41) = HSGrowth(40);
ColGrowth(41) = ColGrowth(40);
NoHSGrowth = reshape(repmat(NoHSGrowth.^0.25,[1 4])',[BigT 1]); % convert to quarterly
HSGrowth = reshape(repmat(HSGrowth.^0.25,[1 4])',[BigT 1]);
ColGrowth = reshape(repmat(ColGrowth.^0.25,[1 4])',[BigT 1]);
NoHSGrowth(41*4) = NoHSRetire;
HSGrowth(41*4) = HSRetire;
ColGrowth(41*4) = ColRetire;

% Calculate the social security tax required in this economy
NoHSIncome = NoHSBaseIncome*[1; cumprod(NoHSGrowth)];
HSIncome = HSBaseIncome*[1; cumprod(HSGrowth)];
ColIncome = ColBaseIncome*[1; cumprod(ColGrowth)];
Temp = PopGrowth.^-(0:BigT)';
CohortWeight = [Temp*NoHSpct, Temp*HSpct, Temp*Colpct];
TFPWeight = repmat(TFPGrowth.^-(0:BigT)',[1 3]);
SurvivalWeight = [ones(1,3); cumprod(flipud(SurvivalProbs))];
WeightedIncomeProfiles = [NoHSIncome, HSIncome, ColIncome].*CohortWeight.*TFPWeight.*SurvivalWeight;
IncomeProfile = sum(WeightedIncomeProfiles,2);
SSTaxRate = sum(IncomeProfile((YoungT*4+1):(BigT+1)))/sum(IncomeProfile(1:(YoungT*4)));

% Calculate unemployment insurance tax and total tax
UTaxRate = UnemploymentRate*((1-FailProb)*ReplacementRate + FailProb*FailRate);
TaxRate = SSTaxRate + UTaxRate;

% Make the vector of lifetime interest rates
RLife = [R*ones(BigT+1,1)];

% Define the grid of end of period assets for each period of life
LL = @(x) log(1 + log(1 + log(1 + x)));
ee = @(x) exp(exp(exp(x)-1)-1)-1;
aMinL = LL(aMin);
aMaxL = LL(aMax);
aStep = (aMaxL - aMinL)/(aPoints-1);
aGridL = (aMinL:aStep:aMaxL)';
aGrid = sort([0.03; ee(aGridL)]); % adds an extra point at 0.03 ELIMINATE THIS?
%aGrid = ee(aGridL);

% Define the lower bound on assets / resources and the life cycle histories of Deltah
aLowerBoundLife = nan(BigT+1,3);
aLowerBoundLife(1,:) = 0;
DeltahLife = nan(BigT+1,3);
DeltahLife(1,:) = 0;
hMinNow = zeros(1,3);
hExpNow = zeros(1,3);
GrowthRates = flipud([NoHSGrowth, HSGrowth, ColGrowth]);
for t = 1:BigT,
    if (t <= OldT*4),
        yExp = 1;
    else
        yExp = 1 - SSTaxRate;
    end
    yMin = ThetaValsLife(1,t);
    gMin = min(PsiValsLife(:,t))*GrowthRates(t,:);
    aLowerBoundt = -gMin.*hMinNow/RLife(t+1);
    hMinNow = -aLowerBoundt + yMin;
    hExpNow = GrowthRates(t,:).*hExpNow/RLife(t+1) + yExp;
    DeltahLife(t+1,:) = hExpNow - hMinNow;
    aLowerBoundLife(t+1,:) = aLowerBoundt;
end
DeltahLife = repmat(DeltahLife,[1 TypeCount]);
ThetaValsLife(3:(ThetaPoints+1),(OldT*4+1):BigT) = ThetaValsLife(3:(ThetaPoints+1),(OldT*4+1):BigT)*(1-TaxRate); % this applies taxes to employed individuals

% Construct end of period asset grids
aGridLife = repmat(aGrid,[1,BigT+1,3]) + repmat(permute(aLowerBoundLife(1:(BigT+1),:),[3 1 2]),[numel(aGrid),1,1]);
aGridLife = reshape(aGridLife,[numel(aGrid),BigT+1,3]);
aGridLife = repmat(aGridLife,[1,1,TypeCount]);

% Make growth structures and discount structures
DiscountBase = [zeros(1,3*TypeCount); repmat(SurvivalProbs,[1,TypeCount])];
FancyGLife = [ones(1,3*TypeCount); repmat(GrowthRates,[1,TypeCount])];
aLowerBoundLife = repmat(aLowerBoundLife,[1 TypeCount]);

% Specify the distribution of initial wealth states
%Wealth0Dist = [-3.7, 0.1; -0.37, 0.1; -0.05, 0.1; 0.075, 0.1; 0.18, 0.1; 0.37, 0.1; 0.55, 0.1; 0.87, 0.1; 1.41, 0.1; 4.6, 0.1];
Wealth0Dist = [0.17, 1/3; 0.5, 1/3; 0.83, 1/3];
WealthInit = nan(SimPop*TypeCount*3,1);
RandFloor = 0;
RandAssign = rand(SimPop*TypeCount*3,1);
for z = 1:size(Wealth0Dist,1);
    RandCeil = RandFloor + Wealth0Dist(z,2);
    These = find((RandFloor < RandAssign) & (RandCeil > RandAssign));
    WealthInit(These) = Wealth0Dist(z,1);
    RandFloor = RandCeil;
end

% Make simulation shocks
PsiGrid = nan(SimPop*TypeCount*3,SimT);
ThetaGrid = nan(SimPop*TypeCount*3,SimT);
UnemployedAll = nan(SimPop*TypeCount*3,SimT);
for t = 1:SimT,
    PsiStd = PsiStdLife(min(BigT,BigT-t+2));
    ThetaStd = ThetaStdLife(min(BigT,BigT-t+2));
    PsiMin = min(PsiValsLife(:,min(BigT,BigT-t+2))); % these lines ensure we never violate aLowerBound
    ThetaMin = ThetaValsLife(3,min(BigT,BigT-t+2));
    if t <= YoungT*4,
        Mho = UnemploymentRate;
        Benefit = ReplacementRate;
        BadBenefit = FailRate;
        PsiGrid(:,t) = max(logninv(rand(SimPop*TypeCount*3,1),-0.5*PsiStd^2,PsiStd)*TailAdj,PsiMin);
        ThetaGrid(:,t) = logninv(rand(SimPop*TypeCount*3,1),-0.5*ThetaStd^2,ThetaStd)*(1/(1-Mho)*(1-TaxRate));
        TailShocks = max(logninv(rand(SimPop*TypeCount*3,1),TailMean-0.5*TailStd^2,TailStd),PsiMin);
        These = find(rand(SimPop*TypeCount*3,1) < ProbInTail);
        PsiGrid(These,t) = TailShocks(These);
    else
        Mho = MhoRetired;
        Benefit = 0;
        BadBenefit = 0;
        PsiGrid(:,t) = 1;
        ThetaGrid(:,t) = 1/(1-Mho);
    end
    Unemployed = rand(SimPop*TypeCount*3,1) < Mho;
    UnemployedAll(:,t) = Unemployed;
    Unemployed = find(Unemployed);
    ThetaGrid(Unemployed,t) = Benefit;
    Failure = Unemployed(find(rand(numel(Unemployed),1) < FailProb)); % these people get no UI
    ThetaGrid(Failure,t) = BadBenefit;
end
UnemployedAll = reshape(UnemployedAll,[SimPop*SimT*TypeCount*3,1]);
EmployedAll = find(1-UnemployedAll);
UnemployedAll = find(UnemployedAll);

% Specify the distribution of initial permanent income
PermIncomeInit = logninv(rand(SimPop*TypeCount*3,1),-(PermIncomeSigma^2)/2,PermIncomeSigma);

% Calculate permanent income over the life cycle for each simulated individual
GrowthRatesZ = flipud(GrowthRates);
PermIncomeBase = repmat([NoHSBaseIncome*ones(SimPop,SimT).*repmat(cumprod(GrowthRatesZ(1:SimT,1))',[SimPop,1]); HSBaseIncome*ones(SimPop,SimT).*repmat(cumprod(GrowthRatesZ(1:SimT,2))',[SimPop,1]); ColBaseIncome*ones(SimPop,SimT).*repmat(cumprod(GrowthRatesZ(1:SimT,3))',[SimPop,1])],[TypeCount, 1]).*repmat(PermIncomeInit,[1,SimT]);
PermIncomeGrid = cumprod(PsiGrid(:,1:SimT),2).*PermIncomeBase.*repmat(TFPWeight(1:SimT,1)',[SimPop*TypeCount*3, 1]);

% Make population weights for simulated data
BasePopWeight = CohortWeight.*SurvivalWeight;
PopSum = sum(sum(BasePopWeight(1:SimT,:)));
PopWeightTemp = BasePopWeight(1:SimT,:)/(PopSum*SimPop*TypeCount);
PopWeight = repmat([repmat(PopWeightTemp(:,1)',[SimPop,1]); repmat(PopWeightTemp(:,2)',[SimPop,1]); repmat(PopWeightTemp(:,3)',[SimPop,1])],[TypeCount,1]);

% Calculate the total output of the economy
TotalOutput = sum(sum(PermIncomeGrid(:,1:(YoungT*4)).*PopWeight(:,1:(YoungT*4))))/sum(sum(PopWeight(:,1:(YoungT*4))));

% Reshape the previous objects
PermIncomeGrid = reshape(PermIncomeGrid,[numel(PermIncomeGrid),1]);
PopWeight = reshape(PopWeight,[numel(PopWeight),1]);

% Choose a random person in the population for each other person in the population
ObCutoffs = cumsum(reshape(BasePopWeight(1:SimT,:)'/PopSum,[1,(SimT)*3]),2);
BequestDraws = rand(SimT*TypeCount*3*SimPop,1);
BequestAllocation = nan(size(BequestDraws));
for j = 1:numel(BequestDraws),
    BequestAllocation(j) = find(BequestDraws(j) < ObCutoffs, 1);
end
eTemp = mod(BequestAllocation-1,3);
tTemp = (BequestAllocation-1-eTemp)./3;
iTemp = ceil(SimPop*rand(SimT*TypeCount*3*SimPop,1));
bTemp = floor(TypeCount*rand(SimT*TypeCount*3*SimPop,1));
BequestAllocation = tTemp*SimPop*3*TypeCount + bTemp*SimPop*3 + eTemp*SimPop + iTemp;
clear eTemp tTemp iTemp bTemp

% Calculate the adjustment factor for each bequest
DeathProbs = 1 - flipud(SurvivalProbs);
DeathProbsBig = reshape(repmat(reshape(repmat(DeathProbs(1:SimT,:)',[TypeCount,1]),[1,SimT*TypeCount*3]),[SimPop,1]),[SimT*TypeCount*3*SimPop,1]);
BequestAdjustment = DeathProbsBig.*(PopWeight./PopWeight(BequestAllocation)).*(PermIncomeGrid./PermIncomeGrid(BequestAllocation));

% Rearrange the bequests into useful objects
[BequestTo,BequestFrom] = sort(BequestAllocation);
BequestCount = zeros(SimT*TypeCount*3*SimPop,1);
for j = 1:(SimT*TypeCount*3*SimPop),
    z = BequestTo(j);
    BequestCount(z) = BequestCount(z) + 1;
end
BequestStart = cumsum([0; BequestCount(1:(numel(BequestCount)-1))]);
BequestScale = BequestAdjustment(BequestFrom);
BequestFrom = BequestFrom - 1;

% Specify the Lorenz curve key points to match: fraction of wealth owned by top 20, 40, 60, 80 percent
if MatchLiquid,
    KYratioData = 6.6;
    LorenzData = [88.3, 97.5, 99.6, 100.0]/100;
else
    KYratioData = 10.26;
    if MatchNine,
        LorenzData = [69.8, 83.1, 90.3, 94.7, 97.4, 99.0, 99.9, 100.2, 100.2]/100;
    else
        LorenzData = [83.1, 94.7, 99.0, 100.2]/100;
    end
end

% Initialize the OpenCL toolbox and load in the kernel
ocl = opencl();
ocl.initialize(Platform,Device);
ocl.addfile('BufferSaving.cl');
ocl.build();
MaxThreads = ocl.platforms(Platform).devices(Device).max_work_group_size;
ComputeUnits = ocl.platforms(Platform).devices(Device).max_compute_units;

% Determine the workgroup size, etc
ShockPoints = PsiPoints*(ThetaPoints+1);
if DefaultWGS,
    WorkGroupSize = min(2^ceil(log(aPoints+1)/log(2)),MaxThreads);
end

% Make buffer objects for each input and output in the life cycle solver
CoeffsLifeX = clbuffer('rw', 'double', (aPoints+2)*4*(BigT+1)*MaxParamCount);
mGridLifeX = clbuffer('rw', 'double', (aPoints+1)*(BigT+1)*MaxParamCount);
aGridLifeX = clbuffer('ro', 'double', numel(aGridLife));
RLifeX = clbuffer('ro', 'double', numel(RLife));
FancyGLifeX = clbuffer('ro', 'double', numel(FancyGLife));
DiscountBaseX = clbuffer('ro', 'double', numel(DiscountBase));
ThetaValsLifeX = clbuffer('ro', 'double', numel(ThetaValsLife));
PsiValsLifeX = clbuffer('ro', 'double', numel(PsiValsLife));
ThetaProbsLifeX = clbuffer('ro', 'double', numel(ThetaProbsLife));
PsiProbsLifeX = clbuffer('ro', 'double', numel(PsiProbsLife));
aLowerBoundLifeX = clbuffer('ro', 'double', numel(aLowerBoundLife));
rhoVecX = clbuffer('ro', 'double', MaxParamCount);
bethVecX = clbuffer('ro', 'double', MaxParamCount);
alphaVecX = clbuffer('ro', 'double', MaxParamCount);
nuVecX = clbuffer('ro', 'double', MaxParamCount);
gammaVecX = clbuffer('ro', 'double', MaxParamCount);
IntegerInputsX = clbuffer('ro', 'int32', int32(10));
mVecX = clbuffer('rw', 'double', (aPoints+1)*MaxParamCount);
cVecX = clbuffer('rw', 'double', (aPoints+1)*MaxParamCount);
cPVecX = clbuffer('rw', 'double', (aPoints+1)*MaxParamCount);

% Initialize the values in the buffers for the life cycle solver
CoeffsLifeX.set(zeros((aPoints+2)*4*(BigT+1)*MaxParamCount,1));
mGridLifeX.set(zeros((aPoints+1)*(BigT+1)*MaxParamCount,1));
aGridLifeX.set(aGridLife);
RLifeX.set(RLife);
FancyGLifeX.set(FancyGLife);
DiscountBaseX.set(DiscountBase);
ThetaValsLifeX.set(ThetaValsLife);
PsiValsLifeX.set(PsiValsLife);
ThetaProbsLifeX.set(ThetaProbsLife);
PsiProbsLifeX.set(PsiProbsLife);
aLowerBoundLifeX.set(aLowerBoundLife);
mVecX.set(zeros((aPoints+1)*MaxParamCount,1));
cVecX.set(zeros((aPoints+1)*MaxParamCount,1));
cPVecX.set(zeros((aPoints+1)*MaxParamCount,1));
IntegerInputs = int32([(aPoints+1), (ThetaPoints+1), PsiPoints, BigT, MaxParamCount, WorkGroupSize, ceil((aPoints+1)/WorkGroupSize), 0, SimT, SimPop]');
IntegerInputsX.set(IntegerInputs);

% Make buffer objects for the simulation process
WealthOutX = clbuffer('wo', 'double', SimPop*SimT*MaxParamCount);
MPCoutX = clbuffer('wo', 'double', SimPop*SimT*MaxParamCount);
ConOutX = clbuffer('wo', 'double', SimPop*SimT*MaxParamCount);
WealthInitX = clbuffer('ro', 'double', SimPop*MaxParamCount);
ThetaGridX = clbuffer('ro', 'double', SimPop*SimT*TypeCount*3);
PsiGridX = clbuffer('ro', 'double', SimPop*SimT*TypeCount*3);
aLowerBoundLifeZX = clbuffer('ro', 'double', (BigT+1)*MaxParamCount);
FancyGLifeZX = clbuffer('ro', 'double', (BigT+1)*MaxParamCount);
RLifeZX = clbuffer('ro', 'double', BigT+1);
BequestFromX = clbuffer('ro','int32', SimPop*SimT*TypeCount*3);
BequestStartX = clbuffer('ro','int32', SimPop*SimT*TypeCount*3);
BequestCountX = clbuffer('ro','int32', SimPop*SimT*TypeCount*3);
BequestScaleX = clbuffer('ro','double', SimPop*SimT*TypeCount*3);
BequestX = clbuffer('rw','double', SimPop*SimT*TypeCount*3);

% Initialize the values in the buffers for the simulation process
WealthInitX.set(WealthInit);
ThetaGridX.set(ThetaGrid);
PsiGridX.set(PsiGrid);
aLowerBoundLifeZX.set(flipud(aLowerBoundLife));
FancyGLifeZX.set(flipud(FancyGLife));
RLifeZX.set(flipud(RLife));
BequestFromX.set(int32(BequestFrom));
BequestStartX.set(int32(BequestStart));
BequestCountX.set(int32(BequestCount));
BequestScaleX.set(BequestScale);
BequestX.set(zeros(SimPop*SimT*TypeCount*3,1));

% Make the OpenCL kernel functions
SolveLifeCycleKernel = clkernel('SolveLifeCycle', [MaxParamCount*WorkGroupSize, 0,0], [int32(WorkGroupSize),0,0]);
SimulationKernel = clkernel('SimMultiPeriod', [ceil(SimPop*TypeCount*3/MaxThreads)*MaxThreads, 0,0], [MaxThreads,0,0]);
BequestKernel = clkernel('CalculateBequest', [ceil(SimPop*TypeCount*3/MaxThreads)*MaxThreads,0,0], [MaxThreads,0,0]);
ocl.wait();

SetupTime = toc;
disp(['Set up the model in ' num2str(SetupTime) ' seconds.']);

% Tell the user about the environment that has been set up
DeviceName = strtrim(ocl.platforms(Platform).devices(Device).name);
disp(['Ready to use OpenCL to estimate the life cycle model with ' num2str(aPoints+1) ' asset gridpoints (range of ' num2str(aMin) ' to ' num2str(aMax) ').']);
disp(['The process will solve ' num2str(BigT) ' non-terminal periods and simulate ' num2str(SimPop) ' individuals for ' num2str(SimT) ' periods.']);
disp(['The discrete approximation to the lognormal distribution has ' num2str(ThetaPoints) ' transitory shocks and ' num2str(PsiPoints) ' permanent shocks.']);
if DefaultWGS,
    disp(['The number of threads per workgroup has been selected by default as ' num2str(WorkGroupSize) '.']);
else
    disp(['The number of threads per workgroup has been manually selected as ' num2str(WorkGroupSize) '.']);
end
disp(['Processes will run on the device ' DeviceName ', which has ' num2str(ComputeUnits) ' compute units.']);
disp(' ');
