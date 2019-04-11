% This script runs the twelve life cycle estimations that are not reported in the paper.
% The beta-dist specifications each take 3-4 hours to run because the model
% is estimated six times to ensure consistency of bequests; beta-point
% specifations take about 3-4 minutes each.
% clear all must be run before each estimation to prevent an OpenCL-related crash

% Estimate the model with no bequest motive (but bequests are distributed)
clear all
EstimateModel('NetWorthNoMotiveBetaPoint');
clear all
EstimateModel('NetWorthNoMotiveBetaDist');
clear all
EstimateModel('LiquidNoMotiveBetaDist');

% Estimate the model with a small bequest motive (alpha = 1)
clear all
EstimateModel('NetWorthSmallMotiveBetaPoint');
clear all
EstimateModel('NetWorthSmallMotiveBetaDist');
clear all
EstimateModel('LiquidSmallMotiveBetaDist');

% Estimate the model with a large bequest motive (alpha = 9)
clear all
EstimateModel('NetWorthBigMotiveBetaPoint');
clear all
EstimateModel('NetWorthBigMotiveBetaDist');
clear all
EstimateModel('LiquidBigMotiveBetaDist');

% Estimate the model with an alternative bequest motive (alpha = 1, nu = 1/2, gamma = 4)
clear all
EstimateModel('NetWorthAltMotiveBetaPoint');
clear all
EstimateModel('NetWorthAltMotiveBetaDist');
clear all
EstimateModel('LiquidAltMotiveBetaDist');

clear all
