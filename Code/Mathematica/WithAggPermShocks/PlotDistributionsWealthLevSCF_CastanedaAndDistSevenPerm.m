(* PlotDistributionsWealthLevSCF_CastanedaAndDistSevenPerm.m *)
(* Comparions of wealth levels (SCF (from Castaneda) and Dist (with time pref factors approximated by 7 PointPerms) etc. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggPermShocksDir, SetDirectory[WithAggPermShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggPermShocks". *)
(*
ClearAll["Global`*"];
*)


Maxx = 100;

(* SCF from Castaneda. *)
WSCFCum  = {0,  0, (100-99.0)/100, (100-94.7)/100, (100-82.9)/100, (100-69.7)/100, (100-57.9)/100, (100-33.9)/100, 1} ; (* SCF2004 *)
(*
WSCFCum  = {0,  0, 0.013, 0.071, 0.205, 0.339, 0.465, 0.705, 1} ; (* SCF1992 from castaneda 2003 *)
*)

yAxisSCF = {0, 20,    40,    60,    80,    90,    95,    99, 100};

CumSCFPlot = ListLinePlot[Transpose[{yAxisSCF, WSCFCum}]
   , InterpolationOrder -> 3
   , PlotRange  -> {{0, Maxx}, {0, 1}}

   , PlotStyle  -> {Black, Thickness[0.004]}

];

(* Plot simulated data *)
kLevListKS       = Import["kLevListKS.txt","List"]/100; (* Import data *)
kLevtsortedCumKS = 1-kLevListKS; 
yAxisKS           = {0,       20,      40,      50,      60,      75,      80,      90,      95, 99, 100};

CumKSPlot     = ListLinePlot[Transpose[{yAxisKS, kLevtsortedCumKS}] 
   , InterpolationOrder -> 3
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}
   ];

kLevtsortedCumKSDist  = {1-0.92, 1-0.88, 1-0.73, 1-0.55, 1-0.24};
yAxisKSDist           = {    70,     80,     90,     95,     99};

CumKSDistPlot     = ListPlot[Transpose[{yAxisKSDist, kLevtsortedCumKSDist}] 

   , Joined     -> True
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}
(*
CumKSDistPlot     = ListPlot[Transpose[{yAxisKSDist, kLevtsortedCumKSDist}] 
   , PlotStyle -> {Black, Thick, PointSize[Large]}
*)
   ];

kLevListPoint       = Import["kLevListPoint.txt","List"]/100; (* Import data *)
kLevtsortedCumPoint = 1-kLevListPoint; 
yAxisPoint           = {0,       20,      40,      50,      60,      75,      80,      90,      95,      99, 100};

CumPointPlot     = ListLinePlot[Transpose[{yAxisPoint, kLevtsortedCumPoint}] 
   , InterpolationOrder -> 3
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
   ];

(* Stats produced matching 20%, 40% and 60%. *)
kLevListDistSeven       = Import["kLevListDistSeven.txt","List"]/100; (* Import data *)
kLevtsortedCumDistkLevListDistSeven = 1-kLevListDistSeven; 
yAxisDistkLevListDistSeven           = {0,       20,      40,      50,      60,      75,      80,      90,      95,      99, 100};

CumDistkLevListDistSevenPlot     = ListLinePlot[Transpose[{yAxisDistkLevListDistSeven, kLevtsortedCumDistkLevListDistSeven}] 
   , InterpolationOrder -> 3
   , PlotRange  -> {{0, Maxx}, {0, 1}}

   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
   ];


CumWLevSCFCastanedaAndDistSevenPermPlot = Show[
   {CumSCFPlot, CumKSPlot, CumKSDistPlot, CumPointPlot, CumDistkLevListDistSevenPlot (*,  CumDistPlot *)}

   , Graphics[Text[" \[UpArrow] US data (SCF) "              ,{56, 0.025},{-1,0}]]
   , Graphics[Text[" KS-JEDC \[RightArrow]"                  ,{50, 0.6}, {-1,0}]]
(*
   , Graphics[Text[" \[UpArrow] KS-Orig Hetero"                   ,{78, 0.065}, {-1,0}]]
*)
   , Graphics[Text[" \[LeftArrow] \[Beta]-Point"             ,{68, 0.3}, {-1,0}]]
   , Graphics[Text[" \[Beta]-Dist (dashed line)"              ,{20, 0.40}, {-1,0}]]
   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , Graphics[{Arrowheads[.02],Arrow[{{35,0.3},{35,0.02}}]}]
   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, \[ScriptCapitalF]}
   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}
   , TextStyle -> {FontSize -> 14}
   ]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndDistSevenPermPlot.EPS", CumWLevSCFCastanedaAndDistSevenPermPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndDistSevenPermPlot.PNG", CumWLevSCFCastanedaAndDistSevenPermPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndDistSevenPermPlot.pdf", CumWLevSCFCastanedaAndDistSevenPermPlot, "PDF"];
