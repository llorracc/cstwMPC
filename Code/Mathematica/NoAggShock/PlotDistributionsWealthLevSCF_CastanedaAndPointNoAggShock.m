(* PlotDistributionsWealthLevSCF_CastanedaAndPointNoAggShock.m *)

(* Comparions of wealth levels (SCF (from Castaneda) and Dist (with time pref factors approximated by 7 PointNoAggShocks) etc. *)



SetDirectory[NotebookDirectory[]];

If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)

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

kLevListKSNoAggShock       = Import["kLevListKSNoAggShock.txt","List"]/100; (* Import data *)

kLevtsortedCumKS = 1-kLevListKSNoAggShock; 

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



CumKSHeteroPlot     = ListPlot[Transpose[{yAxisKSDist, kLevtsortedCumKSDist}] 



   , Joined     -> True

   , PlotRange  -> {{0, Maxx}, {0, 1}}



   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}



   ];



kLevListPointNoAggShock       = Import["kLevListPointNoAggShock.txt","List"]/100; (* Import data *)

kLevtsortedCumPointNoAggShock = 1-kLevListPointNoAggShock; 

(*

kLevtsortedCumPointNoAggShock  = {0,  1-0.970, 1-0.888, 1-0.829, 1-0.756, 1-0.610, 1-0.548, 1-0.385, 1-0.266, 1-0.107,   1};

*) 

yAxisPointNoAggShock           = {0,       20,      40,      50,      60,      75,      80,      90,      95,      99, 100};



CumPointNoAggShockPlot     = ListLinePlot[Transpose[{yAxisPointNoAggShock, kLevtsortedCumPointNoAggShock}] 

   , InterpolationOrder -> 3

   , PlotRange  -> {{0, Maxx}, {0, 1}}

   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}

   ];



(* Stats produced matching 20%, 40% and 60%. *)

kLevListDistSevenNoAggShock       = Import["kLevListDistSevenNoAggShock.txt","List"]/100; (* Import data *)

kLevtsortedCumDistSevenNoAggShock = 1-kLevListDistSevenNoAggShock; 

(*

kLevtsortedCumDistSevenNoAggShock  = {0,  1-0.993, 1-0.971, 1-0.953, 1-0.925, 1-0.847, 1-0.802, 1-0.649, 1-0.499, 1-0.243,   1};

*)

yAxisDistSevenNoAggShock           = {0,       20,      40,      50,      60,      75,      80,      90,      95,      99, 100};



CumDistSevenNoAggShockPlot     = ListLinePlot[Transpose[{yAxisDistSevenNoAggShock, kLevtsortedCumDistSevenNoAggShock}] 

   , InterpolationOrder -> 3

   , PlotRange  -> {{0, Maxx}, {0, 1}}

(*

   , PlotStyle  -> {Black, Thickness[0.004]}

*)

   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}



   ];

CumSCFlegend = ListLinePlot[{{2,0.9},{15,0.9}}   , InterpolationOrder -> 1   , PlotStyle  -> {Black, Thickness[0.004]}];

CumKSlegend = ListLinePlot[{{2,0.8},{15,0.8}}   , InterpolationOrder -> 1   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}];

BetaPointLegend = ListLinePlot[{{2,0.7},{15,0.7}}   , InterpolationOrder -> 1   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}];

BetaDistLegend = ListLinePlot[{{2,0.6},{15,0.6}}   , InterpolationOrder -> 1   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}];





CumWLevSCFCastanedaAndPointNoAggShockPlot = Show[

   {CumSCFPlot, CumKSPlot, (* CumKSHeteroPlot, *) CumPointNoAggShockPlot (*, CumDistSevenNoAggShockPlot *) (*,  CumDistPlot *), CumSCFlegend, CumKSlegend, BetaPointLegend (*, BetaDistLegend*) }



   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , Graphics[Text["US data (SCF)",{17,0.9},{-1,0}]]   
   , Graphics[Text["KS-JEDC",{17,0.8},{-1,0}]]   
   , Graphics[Text["FBS Income Process",{17,0.7},{-1,0}]]   
(*
   , Graphics[Text["\[Beta]-Dist",{17,0.6},{-1,0}]]
*)

   , PlotRangeClipping -> False

   , ImagePadding -> 29

   , AxesLabel -> {None, \[ScriptCapitalF]}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}



   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}

   , TextStyle -> {FontSize -> 14}

   ]



Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS", CumWLevSCFCastanedaAndPointNoAggShockPlot, "EPS"];

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG", CumWLevSCFCastanedaAndPointNoAggShockPlot, "PNG"];

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf", CumWLevSCFCastanedaAndPointNoAggShockPlot, "pdf"];

