% This script runs the three life cycle estimations that are reported in the paper.
% clear all must be run before each estimation to prevent an OpenCL-related crash

clear all
EstimateModel('NetWorthNoBequestsBetaPoint');
clear all
EstimateModel('NetWorthNoBequestsBetaDist');
clear all
EstimateModel('LiquidNoBequestsBetaDist');
clear all

% Find the "alternate MPC" by simulation experiment
FindAltMPC;
clear all
