(* SolveAndSimPoint.m *)
(* This file runs the \[Beta]-Point model with point (unique) \[Beta] *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)

Print["============================================================="];
Print["Run \[Beta]-Point model"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running \[Beta]-Point model... "]
ModelType = Point;   (* Indicate that model is Point  *)
Rep       = False;   (* Indicate that model is not rep agent model *)

(* Setup routines and set parameter values specific to this file *)
<<Params.m;                 (* Set up params *)
\[Sigma]Theta         = (0.15*4)^0.5;      (* Standard deviation of lognormal distribution of transitory shocks *)
\[Sigma]Psi           = (0.01/(11/4))^0.5; (* Standard deviation of lognormal distribution of permanent shocks *)
(*
\[Sigma]Psi           = (0.01/4)^0.5;      (* Standard deviation of lognormal distribution of permanent shocks *)
*)

<<SetupFuncs.m;             (* Set up basic funcs *)
<<SetupSolve.m;             (* Set up routines for solution (except for sim routines) *) 
<<MakeAssetGridRep.m;       (* Set up grids for solving rep func *)
<<MakeAssetGridInd.m;       (* Set up grids for solving ind funcs *)
<<MakeShocksDiscreteGrid.m; (* Set up shocks *) 
<<SimFuncs.m;               (* Set up sim funcs and routines *)
<<SetupAggstatelist.m;      (* Load list of agg state list *)
AggState = Take[AggStatecstCode, PeriodsToSimulate];

TimesToEstimateSmall = 5;          (* Number of times to estimate agg process *) 
(*
\[Beta] = 0.98875;                 (* Raw time preference factor *) 
*)
\[Beta] = Import["BetaHighTran.txt","List"][[1]]; (* Raw time preference factor *) 
\[Beta] = \[Beta] (1-ProbOfDeath); (* Effective time preference factor *) 

NumPeopleToSim         = 8000;               (* Number of people to simulate *)
 (* NumOfPeople needs to be a multiple of 1/ProbOfDeath *)
NumPeopleToSimLarge    = NumPeopleToSim;     (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)

(*
NumPeopleToSim         = 9000;     (* Number of people to simulate *)
NumPeopleToSimLarge    = 9000;     (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)
*)

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the model. *)
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. at least TimesToEstimateSmall+2 times. *), 

   Print["Iteration ", Estimatet];   
       
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

   (* Run simulation, show results, and estimate agg process *)
   SimulateKSInd;
       
   Estimatet++;

   ]; (* End While *)

(* Plot consumption function *)
maxis = Table[0.2 m, {m, 0, 400}];
mlist = maxis wSS; (*Horizonal axis is cash on hand normalized by p (t)*wSS *)
caxis =  KSIndcFunc[mlist, 1, 1, kSS, 1] /wSS;
(*
mlist = maxis wSS/AdjustedLByAggState[[1]]; (*Horizonal axis is cash on hand normalized by p (t)*wSS *)
caxis =  KSIndcFunc[mlist, 1, 1, kSS, 1] AdjustedLByAggState[[1]]/wSS;
*)

Print[" Consumption function"]

Export["maxis.txt", maxis, "Table"]; 
Export["caxis.txt", caxis, "Table"]; 
maxis = Import["maxis.txt","List"]; 
caxis = Import["caxis.txt","List"]; 

<<PlotCFuncs.m;

(* Export data on wealth distribution *)
kLevListPointWithAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListPointHighTran.txt", kLevListPointWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListPointWithAggShockHighTran.txt", kLevListPointWithAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsPointWithAggShockHighTran.txt", AggStatsWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListPointWithAggShockHighTran.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCPointWithAggShockHighTran.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];

Export[ParentDirectory[] <> "/Results/kAR1Coeff1GoodPointHighTran.tex", Round[1000 kAR1ByAggState[[1,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2GoodPointHighTran.tex", Round[1000 kAR1ByAggState[[1,2]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff1BadPointHighTran.tex",  Round[1000 kAR1ByAggState[[3,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2BadPointHighTran.tex",  Round[1000 kAR1ByAggState[[3,2]]]/1000//N, "Table"];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Point model(minutes): ", (TimeEnd - TimeStart)/60]; 