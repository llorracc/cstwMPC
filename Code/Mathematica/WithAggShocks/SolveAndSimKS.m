(* SolveAndSimKS.m *)
(* This file runs KS-JEDC model. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Run KS-JEDC model"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running KS-JEDC model..."];
ModelType = KS;      (* Indicate that model is KS *)
Rep       = False;   (* Indicate that model is not rep agent model *)

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;         (* Setup everything (routines etc.) *)
TimesToEstimateSmall = 4;       (* Number of times to estimate agg process *) 
NumPeopleToSim       = 3000;    (* Number of people to simulate *)

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

(* Export results *)
Export[ParentDirectory[] <> "/Results/VarPermKS.tex",  Round[1000 VarPerm]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/VarTranKS.tex",  Round[1000 VarTran]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/VarPermCas.tex",  Round[1000 VarPermCas]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/VarTranCas.tex",  Round[1000 VarTranCas]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/WageListKS.txt", WageListKS, "Table"];


Export["kAR1ByAggStateList.txt", Flatten[{kAR1ByAggState[[1]],kAR1ByAggState[[3]]}], "Table"];

kLevListKSWithAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListKS.txt", kLevListKSWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListKSWithAggShock.txt", kLevListKSWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/mRatMedianMeanKS.tex",        Round[10 mRatMedianMean]/10//N, "Table"];
Export[ParentDirectory[] <> "/Results/mRatMedianMeanAnnualKS.tex",  Round[10 mRatMedianMean/4]/10//N, "Table"];
Export[ParentDirectory[] <> "/Results/FracmRatBelow20MeanKS.tex",        Round[10 FracmRatBelow20Mean]/10//N, "Table"];
Export[ParentDirectory[] <> "/Results/FracmRatBelow05MeanAnnualKS.tex",  Round[10 FracmRatBelow20Mean]/10//N, "Table"]; (* fraction of mRat below 0.5 in annual terms *)

Export["dlCLevUsedKS.txt", dlCLevUsed, "Table"];
Export[ParentDirectory[ParentDirectory[]] <> "/Stata/KS/dlCLevUsedKS.txt", dlCLevUsed, "Table"];
Export["RUsedKS.txt", Drop[RUsed, 1], "Table"];
Export[ParentDirectory[ParentDirectory[]] <> "/Stata/KS/RUsedKS.txt", Drop[RUsed, 1], "Table"];
Export["AggStateUsedKS.txt", Take[AggState, -(PeriodsToUse-1)], "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsKSWithAggShock.txt", AggStatsWithAggShock, "Table"];
Export["MPCsListKS.txt", MPCt, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/MPCsListKS.txt", MPCt, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/kLevListKS.txt", kLevListKSWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListKSWithAggShock.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCKSWithAggShock.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];

Export[ParentDirectory[] <> "/Results/kAR1Coeff1GoodKS.tex", Round[1000 kAR1ByAggState[[1,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2GoodKS.tex", Round[1000 kAR1ByAggState[[1,2]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff1BadKS.tex",  Round[1000 kAR1ByAggState[[3,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2BadKS.tex",  Round[1000 kAR1ByAggState[[3,2]]]/1000//N, "Table"];


Clear[KSIndcFunc];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run KS-JEDC model (minutes): ", (TimeEnd - TimeStart)/60] 