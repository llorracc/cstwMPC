(* PlotWYRatioSCF_AndHeteroSeven.m *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file, current folder is changed to "NoAggShock". *)
(*
ClearAll["Global`*"];
*)

(*
(* US data: SCF1998 *)
CumWGT  = {5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,97.5,99};
WYRATIO = {-.8792994,0,0.2281167,0.6820689,1.214626,1.977011,2.626601,3.414838,4.319429,5.406697,6.699872,7.967956,9.574286,11.74213,13.97388,17.33793,21.43363,29.33885,44.01223,64.69572, 117.5374};
*)

(* US data: SCF2004 *)
CumWGT  = {5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,99};
WYRATIO = {
0.5250399       ,
1.268496	,
1.615913	,
2.057317	,
2.644069	,
3.40921	,
4.254416	,
5.083199	,
6.209029	,
7.21517	,
8.610896	,
10.07715	,
11.98737	,
14.05547	,
16.43126	,
19.84864	,
24.23599	,
31.01201	,
44.85695	,
118.7264	
};


WYRatioSCFListLinePlot = 
 ListLinePlot[Transpose[{CumWGT, WYRATIO}], 
  InterpolationOrder -> 1, PlotRange -> {{0, 100}, {0, 100}}, 
  PlotStyle  -> {Black, Dashing[{0.015, 0.015}],  Thickness[0.004]}
];

(* Data generated using Reiter's (transition matrix) method *)
WYRatioDistList = Import["WYRatioDistList.txt","List"]; (* Import data *)
(*
WYRatioDistList = {0, 2.1, 3.8, 5.1, 6.9, 10.6, 17.1, 35.7, 65.8}; (* Reesults obtained matching with SCF1998 *)
*)
(*
WYRatioDistList = {0, 1.56642, 2.81955, 3.57143, 5.07519, 8.08271, 14.7243, 35.6516, 70.4887}; (* Reesults obtained matching with SCF1992 *)
*)
xAxis             = {0, 20, 40, 50, 60, 70, 80, 85, 90, 93, 95, 97, 99};
WYRatioDistListLinePlot = 
 ListLinePlot[Transpose[{xAxis, WYRatioDistList}], 
  InterpolationOrder -> 1, PlotRange -> {{0, 100}, {0, 100}}, 
  PlotStyle -> {Black, Thickness[0.005]}];

(* Show graph *)
WYRatioPlot = Show[{WYRatioDistListLinePlot, WYRatioSCFListLinePlot},
 Graphics[Text[" \[UpArrow] \[Beta]-Dist (solid line) ", {60, 4}, {-1, 0}]],
 Graphics[Text[" US data (SCF) \[DownArrow] ", {35, 10}, {-1, 0}]],
 Graphics[Text[" Percentile" , {87, -10}, {-1,0}]],

 PlotRangeClipping -> False,
 ImagePadding -> 29,
 AxesLabel -> {None, "\[ScriptK]"}, 
 ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 

 Ticks -> {{0, 25, 50, 75, 100}, {0, 25, 50, 75, 100}}, 
 TextStyle -> {FontSize -> 14}]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/WYRatioPlot.EPS", WYRatioPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/WYRatioPlot.PNG", WYRatioPlot, "PNG"];