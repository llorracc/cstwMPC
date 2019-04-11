(* SolveAndSimKS_experiments.m *)
(* This file performs experiments using KS-JEDC model *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];
(*
ClearAll["Global`*"];
*)

TimeStart = SessionTime[]; 

Print["============================================================="];
Print["KS-JEDC model (experiment)"];
ModelType = KS;  (* Indicate that model is KS *)
Rep       = False;

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;      (* Setup everything (routines etc.) *)
TimesToEstimateSmall = 1; 
NumPeopleToSim       = 9000;   (* Number of people to simulate *)
PeriodsToSimulate    = 960;    (* Number of periods to simulate *)
PeriodsToUse   = Round[(1/6) PeriodsToSimulate]; (* Periods to use in estimation *)
kAR1ByAggStateList = Import["kAR1ByAggStateList.txt","List"]; 
kAR1ByAggState     = {{kAR1ByAggStateList[[1]], kAR1ByAggStateList[[2]]}, 
                      {kAR1ByAggStateList[[1]], kAR1ByAggStateList[[2]]}, 
                      {kAR1ByAggStateList[[3]], kAR1ByAggStateList[[4]]}, 
                      {kAR1ByAggStateList[[3]], kAR1ByAggStateList[[4]]}}; (* Agg process estimates *)
AggState   = Flatten[Table[Flatten[{4, Table[1, {7}], 2, Table[3, {7}]}], {PeriodsToSimulate/16}]];

Estimatet  = TimesToEstimateSmall;               (* Indicate that only one iteration *)
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the model. *)

(* Construct consumption function *)
StartConstructingFunc = SessionTime[]; 
(*
Print[" Solving ind consumption function..."];
*)
ConstructKSIndFunc;  
KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,1] := KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];

EndConstructingFunc   = SessionTime[]; 
(*
Print[" Time spent to solve consumption function (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60]; 
*)

(* Run simulation, show results and estimate agg process *)
SimulateKSInd;

(* Plot agg vars *)
RUsedChop = Take[RUsed, -24];
RPlot = ListPlot[RUsedChop, 
   Joined -> True, 
   ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
   PlotRange -> {{0, 25}, {0.03, 0.038}}, 
   PlotStyle -> {Black, Thickness[0.006]}
(*
,  TextStyle -> {FontSize -> 14}
*)
];

RPlot = Show[RPlot, 
  Graphics[Text[" period", {22, 0.0305}, {-1, 0}], 
   PlotRangeClipping -> False, ImagePadding -> 29]]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/RPlot.EPS", RPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/RPlot.PNG", RPlot, "PNG"];

dlCLevUsedChop = Take[dlCLevUsed, -24];
dlAggCtPlot = 
  ListPlot[dlCLevUsedChop, 
   Joined -> True, 
   ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
   PlotRange -> {{0, 25}, {-0.02, 0.02}}, 
   PlotStyle -> {Black, Thickness[0.005]}
(*
  ,TextStyle -> {FontSize -> 14}
*)
];
dlAggCtPlot = 
 Show[dlAggCtPlot, 
  Graphics[Text[" period", {22, -0.004}, {-1, 0}], 
   PlotRangeClipping -> False, ImagePadding -> 29]]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/dlAggCtPlot.EPS", dlAggCtPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/dlAggCtPlot.PNG", dlAggCtPlot, "PNG"];

CLevUsedChop = Take[CLevUsed, -24];
AggCtPlot = ListPlot[CLevUsedChop  
   , Joined -> True 
   , ImageSize  -> {72. 6.5,72. 6.5/GoldenRatio}
   , PlotRange  -> {{0, 25}, {2.5, 3.2}}
   , PlotStyle  -> {Black, Thickness[0.005]}
(*
   , TextStyle  -> {FontSize -> 14}
*)
   ]

YLevUsedChop = Take[YLevUsed, -24];
AggYtPlot = ListPlot[YLevUsedChop 
   , Joined -> True 
   , ImageSize  -> {72. 6.5,72. 6.5/GoldenRatio}
   , PlotRange  -> {{0, 25}, {3.0, 5.5}}
   , PlotStyle  -> {Black, Thickness[0.006]}
(*
   , TextStyle  -> {FontSize -> 14}
*)
   ]

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run KS-JEDC model (experiment) (minutes): ", (TimeEnd - TimeStart)/60] 