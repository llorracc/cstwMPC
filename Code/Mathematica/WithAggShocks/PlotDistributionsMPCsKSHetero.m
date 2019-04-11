(* PlotDistributionsMPCsKSHetero.m *)
(* Plot dist of MPCs *)


SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)

Maxx = 100;

(* MPCs matching net worth *)
MPCsListKSHeteroTemp  = Import["MPCsListKSHetero.txt","List"]; (* Import data *)
MPCsListKSHeteroTemp  = Sort[1-(1-MPCsListKSHeteroTemp)^4];
xAxisTemp = 100 Table[i/Length[MPCsListKSHeteroTemp], {i, 1, Length[MPCsListKSHeteroTemp]}];
xAxis     = Table[5 i, {i, 0, 19}];
xAxis     = Flatten[{xAxis, {96, 97, 98, 99, 100}}];
MPCsListKSHetero  = Interpolation[Transpose[{xAxisTemp, MPCsListKSHeteroTemp}]][xAxis];



MPCsKSHeteroPlot = ListLinePlot[Transpose[{xAxis, MPCsListKSHetero}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, Maxx}, {0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];


DistributionsMPCsKSHeteroPlot = Show[
   {MPCsKSHeteroPlot}

   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, "    Annual MPC"}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}
   , TextStyle -> {FontSize -> 14}
   ]

(*

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsKSHeteroPlot.EPS", DistributionsMPCsKSHeteroPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/figures/DistributionsMPCsKSHeteroPlot.PNG", DistributionsMPCsKSHeteroPlott, "PNG"];

*)