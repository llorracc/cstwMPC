% This script iterates the simulation and bequest updater to find
% "consistent" bequest levels.

%tic
UpdateCount = 20;
%AvgVec = nan(UpdateCount,1);
for u = 1:UpdateCount,
    SimulationKernel(WealthOutX,MPCoutX,ConOutX,WealthInitX,ThetaGridX,PsiGridX,mGridLifeX,CoeffsLifeX,aLowerBoundLifeZX,FancyGLifeZX,RLifeZX,BequestX,IntegerInputsX);
    BequestKernel(WealthOutX,BequestX,BequestFromX,BequestStartX,BequestCountX,BequestScaleX,IntegerInputsX);
    %AvgVec(u) = mean(BequestX.get()');
end
ocl.wait();
%toc
