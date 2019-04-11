(* do_KS_RepAgent.m *)
(* This file solves for behavior of representative agent with aggregate shocks *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)

TimeStart = SessionTime[]; 

Print["Running rep agent model with aggregate shocks ... "];
Rep  = True;

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;     (* Setup everything (routines etc.) *)
PeriodsToUse      = Round[.90 PeriodsToSimulate];

(* Construct PF rep agent consumption function *)
Backwardshoot;

(* Construct rep agent consumption function with aggregate shocks starting from PF consumption function *)
cInterpFunc[MRatt_,AggStatet_,PeriodsToIterate+1] := PFRepcFunc[MRatt]; (* Starting from PF func *)
cInterpFuncList = {Table[PFRepcFunc,{4}]}; (* List of consumption function *)
ConstructKSRepcFunc;

(* Simulate and show results *)
SimulateKSRepAgent;                        (* Run simulation *)

(* Estimate agg process *)
EstimateAR1;                                    
kAR1ByAggState = {KARg,KARg,KARb,KARb};
Print[" Estimates of agg process:"]
Print[Flatten[{KARg, KARb}]];

(* Export results *)
Export[ParentDirectory[] <> "/Results/AggStatsRepWithAggShock.txt", AggStatsWithAggShock, "Table"];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run rep agent model with aggregate shocks (seconds): ", TimeEnd - TimeStart] 