(* PlotfCrossSectionVar.m *)
(* Plot Cross-Sectional Variance of Income Processes and Data *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, 
  SetDirectory[
   WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)



(* FBS income process *)
varHorizon = 36;
varTran    = 0.01;
varPerm    = 0.01;

HoriozonAxis = Table[i, {i, varHorizon - 1}];

numOfPeriodToSimulate = 30000;

TranList = 
  RandomVariate[
   NormalDistribution[0, varTran^0.5], {numOfPeriodToSimulate}]; 

PermShockListTemp = 
  RandomVariate[
   NormalDistribution[0, varPerm^0.5], {numOfPeriodToSimulate}]; 

PermList = 
  Table[Total[Take[PermShockListTemp, {1, i}]], {i, numOfPeriodToSimulate}];

lWageListFBS = TranList + PermList;

varDFBS = 
  Table[Variance[
    Take[lWageListFBS, {1 + i, Length[lWageListFBS]}] - 
     Take[lWageListFBS, {1, Length[lWageListFBS] - i}]], {i, varHorizon - 1}];

(* KS income process *)
WageListKS = 
  Import[ParentDirectory[] <> "/Results/WageListKS.txt", "List"];

NumOfYears  = 250;
NumOfHH     = 1000; 
lWageListKS = Log[WageListKS]; 
lWageListKS = Partition[lWageListKS, {NumOfYears}];

vardKS = Table[
   (* calc variance given horizon diff *)
   Variance[Flatten[Table[
      Take[lWageListKS[[i]], {1 + diff, Length[lWageListKS[[i]]]}] - 
       Take[lWageListKS[[i]], {1, Length[lWageListKS[[i]]] - diff}]
      , {i, 1, NumOfHH}] (* end Table *)
     ] (* end Flatten *)
    ],(* end Variance *)
   {diff, varHorizon - 1}];
(* i indicates hh *)

(*
vardKS=Table[
(* calc variance given horizon diff *)
Variance[Flatten[Table[
Take[lWageListKS[[i]],{1+diff,1+diff}]-Take[lWageListKS[[i]],{1,1}]
,{i,1,NumOfHH}]
]
],{diff,varHorizon-1}]
(* i indicates hh *)
*)



(* Data from DeBacker et al.(2013),figure IVa *)
deBackerData = {0.5451695, 0.5560548, 0.5582893, 0.5858898, 0.5818885,
    0.5889212, 0.6118942, 0.6047204, 0.6228368, 0.6339358, 0.6610016, 
   0.6581055, 0.6928705, 0.6858122, 0.7081838, 0.7087426, 0.7206724, 
   0.6963386, 0.7133623, 0.7451317, 0.7432642, 0.735323, 0.7383844, 
   0.7490977, 0.7517942, 0.7752254, 0.7624419, 0.7843037, 0.7751844, 
   0.7890681, 0.8172325, 0.8141932, 0.8322015, 0.8302645, 0.8362534};

deBackerData = 
  deBackerData - deBackerData[[1]] + 0.5*(vardKS[[1]] + varDFBS[[1]]);

(* Plot *)
varDFBSPlot = ListLinePlot[Transpose[{HoriozonAxis, varDFBS}],
     PlotStyle -> {Black, Thickness[0.006]}
   ];

vardKSPlot = ListLinePlot[Transpose[{HoriozonAxis, vardKS}],
     PlotStyle -> {Black, Dashing[{0.02, 0.02}], Thickness[0.006]}];

deBackerDataPlot = ListPlot[Transpose[{HoriozonAxis, deBackerData}],
   PlotStyle -> {PointSize[Large]}
   ];

(* plot Cross-Sectional Variance of Income Processes and Data *)
fCrossSectionVar = Show[{varDFBSPlot, vardKSPlot, deBackerDataPlot}
  , Graphics[Text["Data \[DownArrow]", {17, 0.29}, {-1, 0}]]
  , Graphics[Text["\[UpArrow] FBS (solid line)", {21, 0.21}, {-1, 0}]]
  , Graphics[Text["KS Process ", {22, 0.12}, {-1, 0}]]
     , AxesLabel -> {"Horizon r", None}
     , ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}
     , TextStyle -> {FontSize -> 14}
  ]

(* export figure *)
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/fCrossSectionVar.EPS", fCrossSectionVar, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/fCrossSectionVar.PNG", fCrossSectionVar, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/fCrossSectionVar.pdf", fCrossSectionVar, "pdf"];