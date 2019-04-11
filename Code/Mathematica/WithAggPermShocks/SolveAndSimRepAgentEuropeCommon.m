
SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggPermShocksDir, SetDirectory[WithAggPermShocksDir]];

Rep  = True;

(* Solve PF rep agent model *)
(* Print["Running PF rep agent model ... "]; *)
<<PrepareEverything.m;
\[CapitalPsi]Vec     = \[CapitalTheta]Vec     = {1.};
\[CapitalPsi]VecProb = \[CapitalTheta]VecProb = {1.};

cInterpFunc={Interpolation[{{0.,0.},{1000.,1000.}},InterpolationOrder->1]}; (* Initial function *)
ConstructRepcFunc;
(* Print[" # of times iterated: ", Iteration]; *)
cInterpFuncPF = cInterpFunc; 
(* SimulateRep; *)

(* Solve rep agent model with agg perm shocks *)
TimeStart = SessionTime[]; 
Print["Running rep agent model with permanent shocks ... "];
<<PrepareEverything.m;
ConstructRepcFunc;
cInterpFuncRep = cInterpFunc;
(* Print[" # of times iterated: ", Iteration]; *)
SimulateRep; (* Simulate *)

(*
Export[ParentDirectory[] <> "/Results/AggStatsRepWithAggPermShocks.txt", AggStatsWithAggShock, "Table"];
*)

(* Display time spent *)  
TimeEnd = SessionTime[];  
(*
*)
Print[" Time spent to run rep agent model with permanent shocks (seconds): ", TimeEnd - TimeStart] 