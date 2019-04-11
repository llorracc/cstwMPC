(* FindBetaDistSeven *)
(* This file estimates parameter values for \[Beta]-Dist (uniformly distributed \[Beta]) model with aggregate shocks. Time pref factors approximated by seven points. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];

TimeS = SessionTime[];

Print["============================================================="];
Print["Estimate parameter values using \[Beta]-Dist model with time pref factors approximated by seven points"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<< SolveAndSimRepAgent.m;
kAR1ByAggStateRep = kAR1ByAggState; (* Keep agg process estimated by the rep agent model *)

Print["========================================="];
Print["Estimating difference between approximated points of \[Beta] (\[EmptyDownTriangle]/3.5) given \[Beta]middle ... "];

(*  Save the original estiamtes from the model without agg shock *)
\[Beta]middle = Import["Betamiddle.txt", "List"][[1]];
Export["BetamiddleOriginal.txt", \[Beta]middle, "Table"]; 

(*  Initial params  *)
initialdiff = 0.0028;                 (* Initial difference beteen approximated points of \[Beta] *)
initial\[Beta]middle = \[Beta]middle; (* Use \[Beta]middle estimated in the model without agg shock *)
Export["Betamiddle.txt", initial\[Beta]middle, "Table"]; 
RunModelt = 1; Export["RunModelt.txt", RunModelt, "Table"]; (* This param is 1 when Dist model has not been run yet. *)

(* Generate steady state distribution of Pt (PtSSDist) *)
ModelType         = Dist;      (* Indicate that the model is Dist *) 
NumOfApproxPoints = 7;         (* Time pref factors approximated by seven points *)
Rep               = False;
<<PrepareEverything.m;
PeriodsToGenPtSSDist   = 5000; (* Periods to use in generating steady state distribution of Pt *)
NumPeopleToGenPtSSDist = 5600; (* Number of people to simulate to gen steady state distribution of Pt *)
(*
NumPeopleToGenPtSSDist = 7000; (* Number of people to simulate to gen steady state distribution of Pt *)
*)
GenPtSSDist;

(*  Search for diff (\[EmptyDownTriangle]/3.5) given \[Beta]middle. This method works because \[Beta]middle little affects wealth distribution.  *)
StatsMat = Table[
   diff = initialdiff + 0.0001 iStatsMat;
   Export["diff.txt", diff, "Table"];
   <<SolveAndSimDistSevenInEstimation.m;
   RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

   Find\[Beta]middleSolution; 
   Export["Betamiddle.txt", Import["BetamiddleOriginal.txt", "List"][[1]], "Table"]; (* Recover initial Betamiddle *)

   {diff, \[Beta]middle, KLevMean, SumOfDevSq},
   {iStatsMat, -1, 0}];


While[StatsMat[[-1, -1]] < StatsMat[[-2, -1]] (* Increase diff until dev starts to increase *), 
  diff = StatsMat[[-1, 1]] + 0.0001;
  Export["diff.txt", diff, "Table"];
  <<SolveAndSimDistSevenInEstimation.m;
  RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

  Find\[Beta]middleSolution; 
  Export["Betamiddle.txt", Import["BetamiddleOriginal.txt", "List"][[1]], "Table"]; (* Recover initial Betamiddle *)
  (* Note that as a result of this line, \[Beta]middle is not equal to nitial\[Beta]middle - 0.001.  *)

  (* Append results *)
  StatsMat = 
   Append[StatsMat, {diff, \[Beta]middle, KLevMean, SumOfDevSq}]];

While[StatsMat[[1, -1]] < StatsMat[[2, -1]] (* Decrease diff until dev starts to increase *), 
  diff = StatsMat[[1, 1]] - 0.0001;
  Export["diff.txt", diff, "Table"];
  <<SolveAndSimDistSevenInEstimation.m;
  RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"];

  Find\[Beta]middleSolution; 
  Export["Betamiddle.txt", Import["BetamiddleOriginal.txt", "List"][[1]], "Table"]; (* Recover initial Betamiddle *)

  (* Append results *)
  StatsMat = 
   Prepend[StatsMat, {diff, \[Beta]middle, KLevMean, SumOfDevSq}]];

(* Find position where deviation (of wealth distribution from the US data) is minimized *)
SumOfDevSqList = Transpose[StatsMat][[-1]];
PosMin         = Ordering[SumOfDevSqList][[1]];(* Position which gives min *)

diffSolution          = StatsMat[[PosMin, 1]]; (* Solution of diff *)
\[Beta]middleSolution = StatsMat[[PosMin, 2]]; (* Solution of \[Beta]middle *)

Print["-----------------------------------------"];
Print["Solution: "];
Print[" Difference beteen approximated points of \[Beta] (\[EmptyDownTriangle]/3.5), \[Beta]middle (\[Beta]grave in the text), \[Beta]middle-\[EmptyDownTriangle],  \[Beta]middle+\[EmptyDownTriangle]"];
Print[{diffSolution, 
       \[Beta]middleSolution, 
       \[Beta]middleSolution - (NumOfApproxPoints/2) diffSolution, 
       \[Beta]middleSolution + (NumOfApproxPoints/2) diffSolution}];

Export["diffWithAggShocks.txt", diffSolution, "Table"];
Export["BetamiddleWithAggShocks.txt", \[Beta]middleSolution, "Table"];

Export[ParentDirectory[] <> "/Results/BetamiddleWithAggShocks.tex",  Round[10000 \[Beta]middleSolution]/10000//N, "Table"];
Export[ParentDirectory[] <> "/Results/NablaWithAggShocks.tex",       Round[10000 3.5 diffSolution]/10000//N, "Table"];


(*  Recover origianl RunModelt  *)
RunModelt = 1;
Export["RunModelt.txt", RunModelt, "Table"];

(*  Recover original params in Betamiddle and diff files  *)
Export["Betamiddle.txt", Import["BetamiddleOriginal.txt", "List"][[1]], "Table"];

(* Display time spent *)
Print[" Time spent to find parameter values for \[Beta]-Dist model with time pref factors approximated by seven points (minutes):  ", (SessionTime[] - TimeS)/60];