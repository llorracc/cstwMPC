% This function solves the life cycle problem, simulates data, and then
% compares the simulated data to the SCF to produce a single real output.
% This version solves many typse simultaneously, discretely approximating a
% uniform distribution of beth: beth ~ U[beth-nabla,beth+nabla]

function [MomentSum,Timing] = ObjectiveFuncOpenCL(Params)
close all

% Globalize variables that will be used by OpenCL
global CoeffsLifeX mGridLifeX aGridLifeX RLifeX FancyGLifeX DiscountBaseX ThetaValsLifeX PsiValsLifeX ThetaProbsLifeX PsiProbsLifeX aLowerBoundLifeX rhoVecX bethVecX alphaVecX nuVecX gammaVecX cVecX cPVecX mVecX IntegerInputsX MPCoutX
global WealthOutX ConOutX WealthInitX ThetaGridX PsiGridX aLowerBoundLifeZX FancyGLifeZX RLifeZX BigT SimPop SimT MaxParamCount TypeCount LorenzData KYratioData UnemployedAll EmployedAll rhoDist
global ocl ShowTiming SolveLifeCycleKernel SimulationKernel DrawFig SimWealth aLowerBoundLife aPoints mGridLifeAll CoeffsLifeAll YoungT PermIncomeGrid PopWeight TotalOutput RatioWeight LorenzWeight MatchNine
global AvgMPCPopulation AvgMPCbyWYratio AvgMPCbyPermY AvgMPCUnemployed AvgMPCEmployed MPCplot LorenzPlot BequestFromX BequestStartX BequestCountX BequestX BequestScaleX BequestKernel ThetaGrid MPCbyAge MPCbyAgeImpatient MPCbyAgePatient
% Initialize timings
SolveTime = 0;
SimTime = 0;
SumTime = 0;

% Unpack the input parameters
rho = Params(1);
beth = Params(2);
nabla = Params(3);
alpha = Params(4);
nu = Params(5);
gamma = Params(6);

if ShowTiming,
    tic;
end
% Make the discrete distribution of types
if rhoDist,
    bethVec = beth*ones(1,TypeCount*3);
    rhoVec = reshape(repmat(rho - nabla + 2*nabla/(1+TypeCount)*(1:TypeCount),[3,1]),[1,TypeCount*3]);
else
    %bethVec = reshape(repmat(beth - nabla + 2*nabla/(1+TypeCount)*(1:TypeCount),[3,1]),[1,TypeCount*3]);
    bethVec = reshape(repmat(beth + nabla*((-(TypeCount-1)/2):((TypeCount-1)/2))./(TypeCount/2),[3,1]),[1,TypeCount*3]);
    rhoVec = rho*ones(1,TypeCount*3);
end
alphaVec = alpha*ones(1,TypeCount*3);
nuVec = nu*ones(1,TypeCount*3);
gammaVec = gamma*ones(1,TypeCount*3);

% Set buffers that depend on the inputs
rhoVecX.set(rhoVec');
bethVecX.set(bethVec');
alphaVecX.set(alphaVec');
nuVecX.set(nuVec');
gammaVecX.set(gammaVec');
ocl.wait();

% Solve the life cycle backwards from the terminal period
SolveLifeCycleKernel(CoeffsLifeX,mGridLifeX,cVecX,cPVecX,mVecX,aGridLifeX,RLifeX,FancyGLifeX,DiscountBaseX,ThetaValsLifeX,PsiValsLifeX,ThetaProbsLifeX,PsiProbsLifeX,aLowerBoundLifeX,bethVecX,rhoVecX,alphaVecX,nuVecX,gammaVecX,IntegerInputsX);
ocl.wait();
if ShowTiming,
    SolveTime = SolveTime + toc;
end

% Simulate data using the solved life cycle
if ShowTiming,
    tic;
end
SimulationKernel(WealthOutX,MPCoutX,ConOutX,WealthInitX,ThetaGridX,PsiGridX,mGridLifeX,CoeffsLifeX,aLowerBoundLifeZX,FancyGLifeZX,RLifeZX,BequestX,IntegerInputsX);
ocl.wait();
if ShowTiming,
    SimTime = SimTime + toc;
end

% Compare to empirical wealth distribution
if ShowTiming,
    tic;
end
[SimWealth,Order] = sort(WealthOutX.get()'.*PermIncomeGrid);
WWeight = PopWeight(Order);
CumWealthDist = cumsum(WWeight);
CumWealth = cumsum(SimWealth.*WWeight);
TotalWealth = CumWealth(numel(CumWealth));
CumWealth = CumWealth/TotalWealth;
KYratioSim = TotalWealth/TotalOutput;
RatioMoment = (KYratioSim - KYratioData)^2;
if LorenzWeight > 0,
    if MatchNine,
        LorenzSim = 1 - [CumWealth(find(CumWealthDist > 0.9,1)), CumWealth(find(CumWealthDist > 0.8,1)), CumWealth(find(CumWealthDist > 0.7,1)), CumWealth(find(CumWealthDist > 0.6,1)), CumWealth(find(CumWealthDist > 0.5,1)), CumWealth(find(CumWealthDist > 0.4,1)), CumWealth(find(CumWealthDist > 0.3,1)), CumWealth(find(CumWealthDist > 0.2,1)) CumWealth(find(CumWealthDist > 0.1,1))];
    else     
        LorenzSim = 1 - [CumWealth(find(CumWealthDist > 0.8,1)), CumWealth(find(CumWealthDist > 0.6,1)), CumWealth(find(CumWealthDist > 0.4,1)), CumWealth(find(CumWealthDist > 0.2,1))];
    end
else
    LorenzSim = 0;
end
LorenzMoment = sum((LorenzSim - LorenzData).^2,2);
MomentSum = RatioWeight*RatioMoment + LorenzWeight*LorenzMoment;
if ShowTiming,
    SumTime = SumTime + toc;
end
%MomentSum = KYratioSim;

% Tell the user about how long the process took
if ShowTiming,
    disp(['Solving the life cycle took ' num2str(SolveTime) ' seconds.']);
    disp(['Simulating data took ' num2str(SimTime) ' seconds.']);
    disp(['Calculating the moment sum took ' num2str(SumTime) ' seconds.']);
    disp(['Total run time was ' num2str(SolveTime + SimTime + SumTime) ' seconds.']);
    Timing = [SolveTime, SimTime, SumTime];
else
    Timing = [NaN, NaN, NaN];
end

% Draw the figure showing simulated and actual wealth ratio quantiles
if DrawFig,
    mGridLifeAll = reshape(mGridLifeX.get(),[aPoints+1,BigT+1,MaxParamCount]);
    mGridLife = mGridLifeAll(:,:,1);
    CoeffsLifeAll = reshape(CoeffsLifeX.get(),[4,aPoints+2,BigT+1,MaxParamCount]);
    CoeffsLife = CoeffsLifeAll(:,:,:,1);
    PlotConFuncs;
    
    % Generage MPC statistics for the results table, first by wealth to income ratio
    f = @(x) 1 - (1-max(min(x,1),0)).^4;
    Count = numel(PopWeight);
    SimMPC = f(MPCoutX.get()');
    [~,Order] = sort(WealthOutX.get()');
    SimMPC = SimMPC(Order);
    kWeight = PopWeight(Order);
    AvgMPCPopulation = sum(SimMPC.*kWeight);
    CumMPCdist = cumsum(kWeight);
    TheseLevels = flipud([0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99]');
    AvgMPCbyWYratio = nan(numel(TheseLevels)+1,1);
    for j = 1:numel(TheseLevels),
        Level = TheseLevels(j);
        Index = find(CumMPCdist > Level,1);
        AvgMPCbyWYratio(j) = (sum(SimMPC(Index:Count).*kWeight(Index:Count)))/(1-Level);
        if Level==0.5,
            AvgMPCbyWYratio(numel(TheseLevels)+1) = sum(SimMPC(1:Index).*kWeight(1:Index))/Level;
        end
    end
    
    % Now calculate MPC statistics by permanent income
    SimMPC = f(MPCoutX.get()');
    [~,Order] = sort(PermIncomeGrid.*reshape(ThetaGrid,[numel(ThetaGrid),1]));
    SimMPC = SimMPC(Order);
    kWeight = PopWeight(Order);
    CumMPCdist = cumsum(kWeight);
    TheseLevels = flipud([0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.99]');
    AvgMPCbyPermY = nan(numel(TheseLevels)+1,1);
    for j = 1:numel(TheseLevels),
        Level = TheseLevels(j);
        Index = find(CumMPCdist > Level,1);
        AvgMPCbyPermY(j) = (sum(SimMPC(Index:Count).*kWeight(Index:Count)))/(1-Level);
        if Level==0.5,
            AvgMPCbyPermY(numel(TheseLevels)+1) = sum(SimMPC(1:Index).*kWeight(1:Index))/Level;
        end
    end
    
    % Finally, calculate MPC by employment status
    SimMPC = f(MPCoutX.get()');
    AvgMPCUnemployed = sum(SimMPC(UnemployedAll).*PopWeight(UnemployedAll))/sum(PopWeight(UnemployedAll));
    AvgMPCEmployed = sum(SimMPC(EmployedAll).*PopWeight(EmployedAll))/sum(PopWeight(EmployedAll));
    
    figure;
    hold on;
    box on;
    TheseLevels = (0:0.005:0.995)';
    LorenzPlot = nan(numel(TheseLevels),1);
    for j = 1:numel(TheseLevels),
        Level = TheseLevels(j);
        LorenzPlot(j) = CumWealth(find(CumWealthDist > Level,1));
    end
    SCFlorenz = [0, (100 - 100.2)/100, (100 - 100.2)/100, (100-99.9)/100, (100-99.0)/100, (100-97.4)/100, (100-94.7)/100, (100-90.3)/100, (100-83.1)/100, (100-69.8)/100, (100-57.8)/100, (100-33.7)/100, 1];
    SCFxaxis = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100]'/100;
    plot(SCFxaxis,SCFlorenz,'-k','LineWidth',1.5);
    plot([0; TheseLevels; 1],[0; LorenzPlot; 1],'--k','LineWidth',1.5)
    legend({'US data, SCF 2004','Simulated data'},'Location','NorthWest','FontSize',12);
    xlabel('Wealth percentile','FontSize',14);
    ylabel('Cumulative wealth holdings','FontSize',14);
    ylim([-0.05,1]);
    xlim([0 1]);
    plot([0 1]',[0 0]','--k');
    hold off;
    LorenzPlot = [LorenzPlot; 1];
    
    [SimMPC,Order] = sort(MPCoutX.get()');
    kWeight = PopWeight(Order);
    CumMPCdist = cumsum(kWeight);
    SimMPC = f(SimMPC);
    TheseLevels = (0:0.005:0.995)';
    MPCplot = nan(numel(TheseLevels),1);
    for j = 1:numel(TheseLevels),
        Level = TheseLevels(j);
        MPCplot(j) = SimMPC(find(CumMPCdist > Level,1));
    end
    figure;
    plot(MPCplot,TheseLevels,'-k');
    ylim([0 1]);
    
    % Calculate MPC stats by age
    SimMPC = f(reshape(MPCoutX.get()',[SimPop*TypeCount*3,SimT]));
    PopWeightX = reshape(PopWeight,[SimPop*TypeCount*3,SimT]);
    MPCbyAge = (sum(SimMPC.*PopWeightX,1)./sum(PopWeightX,1))';
    if TypeCount > 1,
        These = 1:(SimPop*3);
        MPCbyAgeImpatient = (sum(SimMPC(These,:).*PopWeightX(These,:),1)./sum(PopWeightX(These,:),1))';
        These = (TypeCount - 1)*3*SimPop + (1:(SimPop*3));
        MPCbyAgePatient = (sum(SimMPC(These,:).*PopWeightX(These,:),1)./sum(PopWeightX(These,:),1))';
    end
    
    % And also calculate the wealth quintile breakdown of the high 1/3 MPCs
    SimMPC = f(MPCoutX.get()');
    [Wealth,Order] = sort(WealthOutX.get()'.*PermIncomeGrid);
    SimMPC = SimMPC(Order);
    kWeight = PopWeight(Order);
    CumWealthDist = cumsum(kWeight);
    WealthQuintile = ceil(CumWealthDist*5);
    [SimMPC,Order] = sort(SimMPC);
    kWeight = kWeight(Order);
    WealthQuintile = WealthQuintile(Order);
    CumMPCdist = cumsum(kWeight);
    MPCTertile = ceil(CumMPCdist*3);
    
    ShowMPCstats
    
    disp('Among households in the top one third of MPCs...');
    disp(['...' num2str(100*sum(kWeight((WealthQuintile==1)&(MPCTertile==3)))/sum(kWeight(MPCTertile==3))) '% are in the poorest wealth quintile,']);
    disp(['...' num2str(100*sum(kWeight((WealthQuintile==2)&(MPCTertile==3)))/sum(kWeight(MPCTertile==3))) '% are in the second wealth quintile,']);
    disp(['...' num2str(100*sum(kWeight((WealthQuintile==3)&(MPCTertile==3)))/sum(kWeight(MPCTertile==3))) '% are in the third wealth quintile,']);
    disp(['...' num2str(100*sum(kWeight((WealthQuintile==4)&(MPCTertile==3)))/sum(kWeight(MPCTertile==3))) '% are in the fourth wealth quintile,']);
    disp(['... and ' num2str(100*sum(kWeight((WealthQuintile==5)&(MPCTertile==3)))/sum(kWeight(MPCTertile==3))) '% are in the richest wealth quintile.']);
end



