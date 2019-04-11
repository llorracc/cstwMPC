(* SolveAndSimKSHeteroNoAggShock.m *)
(* This file runs KSHetero model without aggregate shock *)

Off[Power::"infy"];
Off[Inverse::"luc"];

SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)
NoAggShockDir    = Directory[];
WithAggShocksDir = ParentDirectory[] <> "/WithAggShocks";

SetDirectory[WithAggShocksDir]; 

Print["============================================================="];
Print["Run KSHetero model without aggregate shock"];

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running KSHetero model without aggregate shock..."];
ModelType = KSHetero;(* Indicate that model is KSHetero *)
Rep       = False;   (* Indicate that model is not rep agent model *)
kAR1ByAggState = {{0,1},{0,1},{0,1},{0,1}};

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;         (* Setup everything (routines etc.) *)
SetDirectory[NoAggShockDir]; 
<<ParamsNoAggShock.m;          (* Load parameters for no agg shock case *)

maxDebtKSHeteroLev = 2.4/0.3271 lbar; (* Level of maximum borrowing. 2.4 is from Krusell and Smith (1998). 0.3271 is KS's adj factor (see footnote 13 of Carroll (2000) *)
UnempWage           = 0.09 lbar;      (* 0.09 is from Krusell and Smith (1998). *) 
etValsByAggEmpState = {{UnempWage, (1-(ug UnempWage)/LLevelByAggState[[1]]) lbar},
                       {UnempWage, (1-(ub UnempWage)/LLevelByAggState[[2]]) lbar},
                       {UnempWage, (1-(ub UnempWage)/LLevelByAggState[[3]]) lbar},
                       {UnempWage, (1-(ug UnempWage)/LLevelByAggState[[4]]) lbar}};
\[Beta]List = {0.9858, 0.9894, 0.9930}; 
p12 = p32 = 1/200; (* The average duration of low/high beta is 50 years *)
p21 = p23 = 1/1600; 
pMat = {{1-p12, p12,       0},
        {p21,   1-p21-p23, p23}, 
        {0,     p32,       1-p32}};

SetDirectory[WithAggShocksDir]; 
TimesToEstimateSmall = 4;       (* Minimum mumber of times to estimate agg process -2 *) 
NumPeopleToSim       = 6000;    (* Number of people to simulate *)
NumPeopleToSimLarge  = 30000;   (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)
(*
NumPeopleToSimLarge  = 6000; 
*)

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the model. *)

(*
ConstructKSHeteroIndFunc;
Plot[{KSIndcFunc[x, 1, 1, kSS, 1], 
      KSIndcFunc[x, 1, 1, kSS, 2],
      KSIndcFunc[x, 1, 1, kSS, 3]}, 
     {x, -maxDebtKSHeteroLev/AdjustedLByAggState[[1]], 2}, PlotRange -> Full]
*)

While[(* GapCoeff > MaxGapCoeff || *) Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. at least TimesToEstimateSmall+2 times. *), 

   Print["Iteration ", Estimatet];   
       
   (* Construct consumption function *)
   StartConstructingFunc = SessionTime[]; 
(*
   Print[" Solving ind consumption function..."];
*)

   ConstructKSHeteroIndFunc;

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
kLevListKSHeteroNoAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0};
Export["kLevListKSHeteroNoAggShock.txt", kLevListKSHeteroNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/FracBetween05And15MeanKSHeteroNoAggShock.tex", 10 Round[FracBetween05And15Mean/10], "Table"];
Export[ParentDirectory[] <> "/Results/kLevListKSHeteroNoAggShock.txt", kLevListKSHeteroNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCKSHeteroNoAggShock.txt", MeanMPCAnnual, "Table"]; 
Export[ParentDirectory[] <> "/Results/KYKSHeteroNoAggShock.txt", KYRatio, "Table"];



(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run KSHetero model (minutes): ", (TimeEnd - TimeStart)/60] 