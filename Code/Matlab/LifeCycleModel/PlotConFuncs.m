% This script uses the solved life cycle and plots consumption functions
% for various periods of life.

aLowerBoundRev = flipud(aLowerBoundLife);
PlotTheseAges = [[1:10:381], 382:385];
Deltam = (0.0001:0.01:6.0001)';

ConFig = figure;
hold on;
box on;
xlabel('Cash on hand','FontSize',14);
ylabel('Consumption','FontSize',14);
title('Consumption functions across life cycle','FontSize',14);
xlim([0 6]);
ylim([0 2.5]);
%set(gca,'XTick',0:0.5:6);
%set(gca,'YTick',0:0.25:2.5);

for j = 1:numel(PlotTheseAges),
    t = PlotTheseAges(j);
    aLowerBound = aLowerBoundRev(t);
    
    m = Deltam + aLowerBound;
    mGrid = mGridLife(:,t)';
    Index = sum(repmat(Deltam,[1,aPoints+1]) > repmat(mGrid,[numel(Deltam),1]),2);
    
    mLower = mGrid(max(Index,1))';
    mUpper = mGrid(min(Index+1,aPoints+1))';
    Span = ones(size(Deltam));
    These = (mLower < mUpper);
    Span(These) = mUpper(These) - mLower(These);
    mX = Deltam;
    mX(These) = (Deltam(These) - mLower(These))./Span(These);
    
    b0 = CoeffsLife(1,Index+1,t)';
    b1 = CoeffsLife(2,Index+1,t)';
    b2 = CoeffsLife(3,Index+1,t)';
    b3 = CoeffsLife(4,Index+1,t)';
    c = min([b0 + mX.*(b1 + mX.*(b2 + mX.*(b3))), Deltam],[],2);
    
    if (t > YoungT*4),
        plot(m,c,'-k');
    else
        plot(m,c,'-r');
    end

end
hold off;

%saveas(ConFig,'ConFuncFig.pdf')
