(* PPlotDistributionsMPCsDistSevenPerm.m *)
(* Comparions of MPCs (with time pref factors approximated by 7 points) etc. MPCs matching net worth and finanical assets. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggPermShocksDir, SetDirectory[WithAggPermShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggPermShocks". *)
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


MPCsDistPlot = ListLinePlot[Transpose[{xAxis, MPCsList}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];


(* MPCs matching Finanical assets *)
MPCsLiqFinPlsRetListTemp  = Import["MPCsLiqFinPlsRetList.txt","List"]; (* Import data *)

MPCsLiqFinPlsRetListTemp  = Sort[1-(1-MPCsLiqFinPlsRetListTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsLiqFinPlsRetListTemp], {i, 1, Length[MPCsLiqFinPlsRetListTemp]}];
MPCsLiqFinPlsRetList  = Interpolation[Transpose[{xAxisTemp, MPCsLiqFinPlsRetListTemp}]][xAxis];
(*
MPCsLiqFinPlsRetList = {0,0.3, 0.2, 0.5, 0.8, 1}; 
xAxisTemp       = {0, 1, 10, 20, 50, 100};
*)

MPCsLiqFinPlsRetDistPlot = ListLinePlot[Transpose[{xAxis, MPCsLiqFinPlsRetList}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];

(* MPCs matching liquid Finanical assets *)
MPCsListLiqFinTemp  = Import["MPCsListLiqFin.txt","List"]; (* Import data *)
MPCsListLiqFinTemp  = Sort[1-(1-MPCsListLiqFinTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListLiqFinTemp], {i, 1, Length[MPCsListLiqFinTemp]}];
MPCsListLiqFin  = Interpolation[Transpose[{xAxisTemp, MPCsListLiqFinTemp}]][xAxis];

MPCsLiqFinDistPlot = ListLinePlot[Transpose[{xAxis, MPCsListLiqFin}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Thickness[0.004]}
];

(* MPCs produced by the KS original *)
MPCsListKSTemp  = Import["MPCsListKS.txt","List"]; (* Import data *)
MPCsListKSTemp  = Sort[1-(1-MPCsListKSTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListKSTemp], {i, 1, Length[MPCsListKSTemp]}];
MPCsListKS  = Interpolation[Transpose[{xAxisTemp, MPCsListKSTemp}]][xAxis];

MPCsKSPlot = ListLinePlot[Transpose[{xAxis, MPCsListKS}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}
];

DistributionsMPCsDistSevenPermShocksLiqFinPlsRetPlot = Show[
   {MPCsDistPlot, MPCsLiqFinPlsRetDistPlot (* , MPCsLiqFinDistPlot *) (*,  CumDistPlot *)}

   , Graphics[Text[" Matching net worth "          ,{55, 0.1},  {-1,0}]]
   , Graphics[Text[" Matching liquid financial assets + retirement assets"    ,{7, 0.6}, {-1,0}]]
(*
   , Graphics[Text[" Matching liquid financial assets"    , {15, 0.8}, {-1, 0}]]
*)
   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, "    Annual MPC"}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}
   , TextStyle -> {FontSize -> 14}
   ]

DistributionsMPCsDistSevenAndKSPermShocksLiqFinPlsRetPlot = Show[
   {MPCsDistPlot, MPCsLiqFinPlsRetDistPlot (* , MPCsLiqFinDistPlot *) (*,  CumDistPlot *) , MPCsKSPlot}

   , Graphics[Text[" KS-JEDC "          ,{65, 0.1},  {-1,0}]]

   , Graphics[Text[" Matching net worth "          ,{48, 0.315},  {-1,0}]]
   , Graphics[Text[" \[DownArrow] "          ,{60, 0.23},  {-1,0}]]

   , Graphics[Text[" Matching liquid financial assets + retirement assets"    ,{7, 0.65}, {-1,0}]]
(*
   , Graphics[Text[" Matching liquid financial assets"    , {15, 0.8}, {-1, 0}]]
*)
   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, "    Annual MPC"}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}
   , TextStyle -> {FontSize -> 14}
   ]


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenAndKSPermShocksPlot.EPS", DistributionsMPCsDistSevenAndKSPermShocksLiqFinPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenAndKSPermShocksPlot.PNG", DistributionsMPCsDistSevenAndKSPermShocksLiqFinPlsRetPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsDistSevenAndKSPermShocksPlot.pdf", DistributionsMPCsDistSevenAndKSPermShocksLiqFinPlsRetPlot, "pdf"];