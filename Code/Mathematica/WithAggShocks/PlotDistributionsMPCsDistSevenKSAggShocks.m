(* PlotDistributionsMPCsDistSevenKSAggShocks.m *)
(* Comparions of MPCs (with time pref factors approximated by 7 points) etc. MPCs matching net worth and finanical assets. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)


Maxx = 100;

(* MPCs matching net worth *)
MPCsListTemp  = Import["MPCsList.txt","List"]; (* Import data *)
MPCsListTemp  = Sort[1-(1-MPCsListTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListTemp], {i, 1, Length[MPCsListTemp]}];
xAxis     = Table[5 i, {i, 0, 19}];
xAxis     = Flatten[{xAxis, {96, 97, 98, 99, 100}}];
MPCsList  = Interpolation[Transpose[{xAxisTemp, MPCsListTemp}]][xAxis];


(*
MPCsList = {0,0.1, 0.2, 0.3, 1, 1}; 
xAxisTemp   = {0, 1, 10, 20, 50, 100};
*)


MPCsDistPlot = ListLinePlot[Transpose[{MPCsList, xAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1}, {0, Maxx}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];


(* MPCs matching Finanical assets *)
MPCsListLiqFinPlsRetTemp  = Import["MPCsListLiqFinPlsRet.txt","List"]; (* Import data *)

MPCsListLiqFinPlsRetTemp  = Sort[1-(1-MPCsListLiqFinPlsRetTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListLiqFinPlsRetTemp], {i, 1, Length[MPCsListLiqFinPlsRetTemp]}];
MPCsListLiqFinPlsRet  = Interpolation[Transpose[{xAxisTemp, MPCsListLiqFinPlsRetTemp}]][xAxis];
(*
MPCsListLiqFinPlsRet = {0,0.3, 0.2, 0.5, 0.8, 1}; 
xAxisTemp       = {0, 1, 10, 20, 50, 100};
*)

MPCsLiqFinPlsRetDistPlot = ListLinePlot[Transpose[{MPCsListLiqFinPlsRet, xAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1}, {0, Maxx}}
   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];

(* MPCs matching liquid Finanical assets *)
MPCsListLiqFinTemp  = Import["MPCsListLiqFin.txt","List"]; (* Import data *)
MPCsListLiqFinTemp  = Sort[1-(1-MPCsListLiqFinTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListLiqFinTemp], {i, 1, Length[MPCsListLiqFinTemp]}];
MPCsListLiqFin  = Interpolation[Transpose[{xAxisTemp, MPCsListLiqFinTemp}]][xAxis];

MPCsLiqFinDistPlot = ListLinePlot[Transpose[{MPCsListLiqFin, xAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1}, {0, Maxx}}
   , PlotStyle  -> {Black, Thickness[0.004]}
];

(* MPCs produced by the KS original *)
MPCsListKSTemp  = Import["MPCsListKS.txt","List"]; (* Import data *)
MPCsListKSTemp  = Sort[1-(1-MPCsListKSTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListKSTemp], {i, 1, Length[MPCsListKSTemp]}];
MPCsListKS  = Interpolation[Transpose[{xAxisTemp, MPCsListKSTemp}]][xAxis];

MPCsKSPlot = ListLinePlot[Transpose[{MPCsListKS, xAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1}, {0, Maxx}}   
   , PlotStyle  -> {Black, Dashing[{0.045, 0.045}],Thickness[0.004]}
];

(* MPCs produced by the KSHetero original *)
MPCsListKSHeteroTemp  = Import["MPCsListKSHetero.txt","List"]; (* Import data *)
MPCsListKSHeteroTemp  = Sort[1-(1-MPCsListKSHeteroTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListKSHeteroTemp], {i, 1, Length[MPCsListKSHeteroTemp]}];
MPCsListKSHetero  = Interpolation[Transpose[{xAxisTemp, MPCsListKSHeteroTemp}]][xAxis];

MPCsKSHeteroPlot = ListLinePlot[Transpose[{MPCsListKSHetero, xAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1}, {0, Maxx}}   
   , PlotStyle  -> {Black, Dashing[{0.03, 0.03}],Thickness[0.004]}
];

NetWorthLegend = ListLinePlot[{{.85,20},{.99,20}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];

LiqFinRetLegend = ListLinePlot[{{.85,10},{.99,10}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];

KSHeterolegend = ListLinePlot[{{.85,30},{.99,30}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.03, 0.03}],Thickness[0.004]}
];

KSlegend = ListLinePlot[{{.85,40},{.99,40}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.045, 0.045}],Thickness[0.004]}
];



DistributionsMPCsDistSevenKSAggShocksLiqFinPlsRetPlot = Show[
   {MPCsDistPlot, MPCsLiqFinPlsRetDistPlot (* , MPCsLiqFinDistPlot *) (*,  CumDistPlot *)}

(*
   , Graphics[Text[" Matching net worth "          ,{55, 0.1},  {-1,0}]]
   , Graphics[Text[" Matching liquid financial assets + retirement assets"    ,{12, 0.7}, {-1,0}]]
*)
   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, "Percentile"}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, .25, .50, .75, 1},{0, 25, 50, 75, 100}}
   , TextStyle -> {FontSize -> 14}
   ]

DistributionsMPCsDistSevenAndKSKSAggShocksLiqFinPlsRetPlot = Show[
   {MPCsDistPlot, MPCsLiqFinPlsRetDistPlot (* , MPCsLiqFinDistPlot *) (*,  CumDistPlot *) , MPCsKSPlot, MPCsKSHeteroPlot, NetWorthLegend, LiqFinRetLegend, KSHeterolegend, KSlegend  }

(*
   , Graphics[Text[" KS-JEDC "          ,{65, 0.1},  {-1,0}]]

   , Graphics[Text[" Matching net worth "          ,{49, 0.38},  {-1,0}]]
   , Graphics[Text[" \[DownArrow] "          ,{55, 0.275},  {-1,0}]]

   , Graphics[Text[" Matching liquid financial assets + retirement assets"    ,{12, 0.7}, {-1,0}]]
(*
   , Graphics[Text[" Matching liquid financial assets"    , {15, 0.8}, {-1, 0}]]
*)
*)

   , Graphics[Text["Annual MPC" , {0.78, -8}, {-1,0}]]
   , Graphics[Text["KS-JEDC" , {0.83, 40}, {1,0}]]  
   , Graphics[Text["KS-Hetero" , {0.83, 30}, {1,0}]]   
   , Graphics[Text["Matching net worth" , {0.83, 20}, {1,0}]]   
   , Graphics[Text["Matching liquid financial + retirement assets" , {0.83, 10}, {1,0}]]


   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, "Percentile"}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, .25, .50, .75, 1},{0, 25, 50, 75, 100}}
   , TextStyle -> {FontSize -> 14}
   ]


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenKSAggShocksPlot.EPS", DistributionsMPCsDistSevenKSAggShocksLiqFinPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenKSAggShocksPlot.PNG", DistributionsMPCsDistSevenKSAggShocksLiqFinPlsRetPlot, "PNG"];

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS", DistributionsMPCsDistSevenAndKSKSAggShocksLiqFinPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG", DistributionsMPCsDistSevenAndKSKSAggShocksLiqFinPlsRetPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf", DistributionsMPCsDistSevenAndKSKSAggShocksLiqFinPlsRetPlot, "pdf"];