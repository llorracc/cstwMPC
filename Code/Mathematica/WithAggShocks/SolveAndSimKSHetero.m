(* SolveAndSimKSHetero.m *)
(* This file runs KSHetero model. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Run KSHetero model"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running KSHetero model..."];
ModelType = KSHetero;(* Indicate that model is KSHetero *)
Rep       = False;   (* Indicate that model is not rep agent model *)

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;                (* Setup everything (routines etc.) *)
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

While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. at least TimesToEstimateSmall+2 times. *), 

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


(* export mRatt for later use *)
mRattKSHetero = Import["mRatt.txt","List"]; 
Export["mRattKSHetero.txt", mRattKSHetero, "Table"]; 

(* for plotting consumption function *)
maxisKSHetero = Table[0.2 m, {m, -maxDebtKSHeteroLev/AdjustedLByAggState[[1]]/wSS/(0.2), 400}];
  (* Horizonal axis is (needs to be) cash on hand normalized by p (t)*wSS *)
mlist = maxisKSHetero wSS; (* c func (normalized by AdjustedLByAggState but not wSS) can be used after multiplying by wSS *)
caxisKSHeteroHigh   =  KSIndcFunc[mlist, 1, 1, kSS, 3] /wSS; (* agg state is 1 (good). emp state is 1 (employed) *)
  (* need to divide just by wSS bc when calculating c func, vars are (already) normalized by AdjustedLByAggState *)
caxisKSHeteroMiddle =  KSIndcFunc[mlist, 1, 1, kSS, 2] /wSS;
caxisKSHeteroLow    =  KSIndcFunc[mlist, 1, 1, kSS, 1] /wSS;
(*
mlist = maxisKSHetero wSS/AdjustedLByAggState[[1]]; (* Horizonal axis is cash on hand normalized by p (t)*wSS *)
caxisKSHeteroHigh   =  KSIndcFunc[mlist, 1, 1, kSS, 3] AdjustedLByAggState[[1]]/wSS; (* agg state is 1 (good). emp state is 1 (employed) *)
caxisKSHeteroMiddle =  KSIndcFunc[mlist, 1, 1, kSS, 2] AdjustedLByAggState[[1]]/wSS;
caxisKSHeteroLow    =  KSIndcFunc[mlist, 1, 1, kSS, 1] AdjustedLByAggState[[1]]/wSS;
*)

Export["maxisKSHetero.txt",       maxisKSHetero, "Table"]; 
Export["caxisKSHeteroHigh.txt",   caxisKSHeteroHigh, "Table"]; 
Export["caxisKSHeteroMiddle.txt", caxisKSHeteroMiddle, "Table"]; 
Export["caxisKSHeteroLow.txt",    caxisKSHeteroLow, "Table"]; 


(* Export results *)
kLevListKSHeteroWithAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListKSHetero.txt", kLevListKSHeteroWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListKSHeteroWithAggShock.txt", kLevListKSHeteroWithAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsKSHeteroWithAggShock.txt", AggStatsWithAggShock, "Table"];
Export["MPCsListKSHetero.txt", MPCt, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListKSHeteroWithAggShock.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCKSHeteroWithAggShock.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];

Export[ParentDirectory[] <> "/Results/kAR1Coeff1GoodKSHetero.tex", Round[1000 kAR1ByAggState[[1,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2GoodKSHetero.tex", Round[1000 kAR1ByAggState[[1,2]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff1BadKSHetero.tex",  Round[1000 kAR1ByAggState[[3,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2BadKSHetero.tex",  Round[1000 kAR1ByAggState[[3,2]]]/1000//N, "Table"];


(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run KSHetero model (minutes): ", (TimeEnd - TimeStart)/60] 