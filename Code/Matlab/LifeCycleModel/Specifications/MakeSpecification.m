% This file provides a template for creating specification files to be used in EstimateModel

SpecName = 'LiquidAltMotiveBetaDist';
TypeCount = 10; % the number of discrete beta types (total types x3 due to education)
rho = 1; % CRRA coefficient for consumption
Alpha = 1; % magnitude of bequest motive intensity; set very low (0.01) to turn off
nu = 1/2; % relative risk aversion paramter / curvature of bequest motive
Gamma = 4; % shifter for bequest motive
BequestLoops = 6; % number of times to update the bequest distribution (less 1; set to 1 when no bequests, 6-10 with bequests)
MatchLiquid = true; % set to true to match liquid + retirement assets rather than net worth
UsedForFigs = false;
save([SpecName '.mat'],'TypeCount','rho','Alpha','nu','Gamma','BequestLoops','MatchLiquid','UsedForFigs');
