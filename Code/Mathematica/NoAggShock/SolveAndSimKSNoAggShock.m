(* SolveAndSimKSNoAggShock.m *)
(* This file runs KS-JEDC model without aggregate shock. *)

Off[Power::"infy"];
Off[Inverse::"luc"];

SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)
NoAggShockDir    = Directory[];
WithAggShocksDir = ParentDirectory[] <> "/WithAggShocks";

SetDirectory[WithAggShocksDir]; 

Print["============================================================="];
Print["Run KS-JEDC model without aggregate shock "];

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running KS-JEDC model without aggregate shock..."];
ModelType = KS;      (* Indicate that model is KS *)
Rep       = False;   (* Indicate that model is not rep agent model *)
kAR1ByAggState = {{0,1},{0,1},{0,1},{0,1}};

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;         (* Setup everything (routines etc.) *)
SetDirectory[NoAggShockDir]; 
<<ParamsNoAggShock.m;          (* Load parameters for no agg shock case *)
SetDirectory[WithAggShocksDir]; 
TimesToEstimateSmall = 4;       (* Number of times to estimate agg process *) 
NumPeopleToSim       = 3000;    (* Number of people to simulate *)

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the model. *)
While[ (* GapCoeff > MaxGapCoeff ||*) Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. Iterate at least TimesToEstimateSmall+2. *), 

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
CalcDistStas;
CalcMPC;
MLev = MRat AdjustedLByAggState[[AggState]];
YLev = MLev - (1-\[Delta]) KLev;
KLevUsedt    = Take[KLev,     -PeriodsToUse];
YLevUsed     = Take[YLev,     -PeriodsToUse];
KYRatio      = Mean[KLevUsedt/YLevUsed]; 

SetDirectory[NoAggShockDir];
kLevListKSNoAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0};
Export["kLevListKSNoAggShock.txt", kLevListKSNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/FracBetween05And15MeanKSNoAggShock.tex", 10 Round[FracBetween05And15Mean/10], "Table"];
Export[ParentDirectory[] <> "/Results/kLevListKSNoAggShock.txt", kLevListKSNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCKSNoAggShock.txt", MeanMPCAnnual, "Table"]; 
Export[ParentDirectory[] <> "/Results/KYKSNoAggShock.txt", KYRatio, "Table"];


(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run KS-JEDC model (minutes): ", (TimeEnd - TimeStart)/60] 