(* SolveAndSimPoint.m *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggPermShocksDir, SetDirectory[WithAggPermShocksDir]];

Print["============================================================="];
Print["Run \[Beta]-Point model"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 
Print["========================================="];
Print["Running \[Beta]-Point model ... "];
ModelType    = Point;   (* Indicate that model is Point *)
Rep          = False;   (* Indicate that model is not rep agent model *)
DeathFromAge = False;   (* Death from age at 100 yrs is incorporated *)

(* Solve model *)
<<PrepareEverything.m;
TimesToEstimateSmall   = 5;         (* Number of times to estimate agg process with a small 3 of people *) 
\[Beta] = Import["Beta.txt","List"][[1]]; (* Raw time preference factor *) 
\[Beta] = \[Beta] (1-ProbOfDeath);        (* Effective time preference factor *) 

NumPeopleToSim         = 3200;      (* Number of people to simulate *)
 (* NumOfPeople needs to be a multiple of 1/ProbOfDeath *)
NumPeopleToSimLarge    = NumPeopleToSim*10;     (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)

(*
NumPeopleToSim         = 3000;      (* Number of people to simulate *)
NumPeopleToSimLarge    = 30000;     (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)
*)

(* Construct converged consumption function and run simulation *)
cInterpFunc = {Interpolation[{{0, 0, 0}, {1000, 0, 1000}, {0, 1000, 0}, {1000, 1000, 1000}}]};

GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. Iterate at least TimesToEstimateSmall+2. *), 

       Print["Iteration ", Estimatet];   
       
       (* Construct consumption function *)
       StartConstructingFunc = SessionTime[]; 
       Print[" Solving ind consumption function..."];
       ConstructIndcFunc;
       EndConstructingFunc   = SessionTime[]; 

       Print[" Time spent to solve consumption function (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60]; 

       (* Run simulation, show results, and estimate agg process *)
       SimulateInd;
       
       Estimatet++;

       ]; (* End While *)

(* Data for consumption function *)
maxis = Table[0.2 m, {m, 0, 400}];
mlist = maxis wSS;   (* Horizonal axis is cash on hand normalized by p (t)*wSS *)
caxis = Last[cInterpFunc][mlist, kSS]/wSS;

Export["maxis.txt", maxis, "Table"]; 
Export["caxis.txt", caxis, "Table"]; 
maxis = Import["maxis.txt","List"]; 
caxis = Import["caxis.txt","List"]; 

(* Export data on wealth distribution *)
kLevListPointWithAggPermShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListPoint.txt", kLevListPointWithAggPermShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListPointWithAggPermShock.txt", kLevListPointWithAggPermShock, "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsPointWithAggPermShocks.txt", AggStatsWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListPointWithAggPermShocks.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCPointWithAggPermShocks.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Point model (mins): ", (TimeEnd - TimeStart)/60] 
