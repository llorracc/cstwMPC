(* FindBetaDistSeven1stStage *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];

TimeS = SessionTime[];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 
kAR1ByAggStateRep = kAR1ByAggState; (* Keep agg process estimated by the rep agent model *)

Print["========================================="];
ModelType         = Dist;   (* Indicate that the model is Dist *) 
NumOfApproxPoints = 7;      (* Time pref factors approximated by seven points *)
Rep               = False;
(* Generate steady state distribution of Pt (PtSSDist) *)
<<PrepareEverything.m;
PeriodsToGenPtSSDist   = 5000;   (* Periods to use in generating steady state distribution of Pt *)
NumPeopleToGenPtSSDist = 10000;  (* Number of people to simulate to gen steady state distribution of Pt *)
GenPtSSDist;

(* Test run *)
<<SolveAndSimDistSevenIntGuess20.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

<<SolveAndSimDistSevenIntGuess21.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

Print["========================================="];
Print["========================================="];
Print["See whether PtSSDist matters"]
GenPtSSDist; (* Regenerate PtSSDist *)
<<SolveAndSimDistSevenIntGuess20.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

<<SolveAndSimDistSevenIntGuess21.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

(*
Print["========================================="];
Print["========================================="];
Print["See whether PtSSDist matters"]
GenPtSSDist; (* Regenerate PtSSDist *)
<<SolveAndSimDistSevenIntGuess20.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];
<<SolveAndSimDistSevenIntGuess20.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

<<SolveAndSimDistSevenIntGuess21.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];
<<SolveAndSimDistSevenIntGuess21.m;
RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];
*)

(*  Recover origianl RunModelt  *)
RunModelt = 1;
Export["RunModelt.txt", RunModelt, "Table"];


(* Display time spent *)
Print[" Time spent to obtain initial parameter estiamtes for \[Beta]-Dist model with time pref factors approximated by seven points (minutes):  ", (SessionTime[] - TimeS)/60];