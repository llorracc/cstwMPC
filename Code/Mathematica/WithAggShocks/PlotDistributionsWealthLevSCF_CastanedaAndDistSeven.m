(* PlotDistributionsWealthLevSCF_CastanedaAndDistSeven.m *)
(* Comparions of wealth levels (SCF (from Castaneda) and Dist (with time pref factors approximated by 7 points) etc. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];
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
   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];

(* Plot simulated data *)
kLevListKS       = Import["kLevListKS.txt","List"]/100; (* Import data *)
kLevtsortedCumKS = 1-kLevListKS; 
(*
kLevtsortedCumKS  = {0,  1-0.900, 1-0.747, 1-0.655, 1-0.554, 1-0.382, 1-0.318, 1-0.177, 1-0.097, 1-0.023,   1};
*)
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
(*
kLevtsortedCumPoint  = {0,  1-0.970, 1-0.888, 1-0.829, 1-0.756, 1-0.610, 1-0.548, 1-0.385, 1-0.266, 1-0.107,   1};
*) 
yAxisPoint           = {0,       20,      40,      50,      60,      75,      80,      90,      95,      99, 100};

CumPointPlot     = ListLinePlot[Transpose[{yAxisPoint, kLevtsortedCumPoint}] 
   , InterpolationOrder -> 3
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
   ];

(* Stats produced matching 20%, 40% and 60%. *)
kLevListDistSeven       = Import["kLevListDistSeven.txt","List"]/100; (* Import data *)
kLevtsortedCumDistSeven = 1-kLevListDistSeven; 
(*
kLevtsortedCumDistSeven  = {0,  1-0.993, 1-0.971, 1-0.953, 1-0.925, 1-0.847, 1-0.802, 1-0.649, 1-0.499, 1-0.243,   1};
*)
yAxisDistSeven           = {0,       20,      40,      50,      60,      75,      80,      90,      95,      99, 100};

CumDistSevenPlot     = ListLinePlot[Transpose[{yAxisDistSeven, kLevtsortedCumDistSeven}] 
   , InterpolationOrder -> 3
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Thickness[0.004]}

   ];


CumWLevSCFCastanedaAndDistSevenPlot = Show[
   {CumSCFPlot, CumKSPlot, CumKSDistPlot, CumPointPlot, CumDistSevenPlot (*,  CumDistPlot *)}

   , Graphics[Text[" \[UpArrow] US data (SCF) "              ,{55, 0.025},{-1,0}]]
   , Graphics[Text[" KS-JEDC \[RightArrow]"                       ,{47, 0.6}, {-1,0}]]
   , Graphics[Text[" \[UpArrow] KS-Hetero"                   ,{78, 0.065}, {-1,0}]]
   , Graphics[Text[" \[Beta]-Point \[RightArrow]"                 ,{46, 0.3}, {-1,0}]]
   , Graphics[Text[" \[Beta]-Dist (solid line)"              ,{20, 0.35}, {-1,0}]]
   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , Graphics[{Arrowheads[.02],Arrow[{{35,0.3},{35,0.02}}]}]
   , PlotRangeClipping -> False
   , ImagePadding -> 29

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}
   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}
   , TextStyle -> {FontSize -> 14}
   ]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndDistSevenPlot.EPS", CumWLevSCFCastanedaAndDistSevenPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndDistSevenPlot.PNG", CumWLevSCFCastanedaAndDistSevenPlot, "PNG"];
