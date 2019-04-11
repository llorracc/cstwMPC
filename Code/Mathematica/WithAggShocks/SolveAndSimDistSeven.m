(* SolveAndSimDistSeven.m *)
(* This file runs \[Beta]-Dist (uniformly distributed \[Beta]) model with time pref factors approximated by seven points. In the model, there are seven types of households. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Run \[Beta]-Dist model with time pref factors approximated by seven points"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running \[Beta]-Dist model with time pref factors approximated by seven points... "];
ModelType         = Dist;   (* Indicate that the model is Dist *) 
NumOfApproxPoints = 7;      (* Time pref factors approximated by seven points *)
Rep               = False;

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;        (* Setup everything (routines etc.) *)
\[Beta]middle = Import["BetamiddleWithAggShocks.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffWithAggShocks.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)
Print["\[EmptyDownTriangle]/3.5, \[Beta]middle: "];
Print[{diff, \[Beta]middle}];
TimesToEstimateSmall = 5;       (* Number of times to estimate agg process with small(er) number of people *) 

NumPeopleToSim       = 5600;    (* Number of people to simulate *)
NumPeopleToSimLarge  = NumPeopleToSim*10;   (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)

(*
NumPeopleToSim       = 7000;    (* Number of people to simulate *)
NumPeopleToSimLarge  = 70000;   (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)
*)

(* Generate steady state distribution of Pt (PtSSDist) *)
PeriodsToGenPtSSDist   = 5000;            (* Periods to use in generating steady state distribution of Pt *)
NumPeopleToGenPtSSDist = NumPeopleToSim;  (* Number of people to simulate to gen steady state distribution of Pt *)
GenPtSSDist;

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the Dist model. *)
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. Iterate at least TimesToEstimateSmall+2 times. *), 

   Print["Iteration ", Estimatet];   
       
    (* Construct consumption function *)
    StartConstructingFunc = SessionTime[]; 
(*
    Print[" Solving ind consumption function(s)..."];
*)


    \[Beta] = (\[Beta]middle + 3 diff)  (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList1];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,1] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList1 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle + 2 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList2];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,2] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList2 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle +   diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList3];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,3] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList3 = cInterpFuncList; 

    \[Beta] = \[Beta]middle (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList4];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,4] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList4 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle -  diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList5];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,5] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList5 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle - 2 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList6];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,6] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList6 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle - 3 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1 || RunModelt>1, cInterpFuncList = cInterpFuncList7];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,7] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList7 = cInterpFuncList; 

    EndConstructingFunc   = SessionTime[]; 

    If[Estimatet==1 || TimesToEstimateSmall>3, 
    Print[" Time spent to solve consumption function(s) (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60]
    ]; 

   (* Run simulation, show results, and estimate agg process *)
   SimulateKSInd;
       
   Estimatet++;

   ]; (* End While *)

(* export mRatt for later use *)
mRattDistSevenWithAggShock = Import["mRatt.txt","List"]; 
Export["mRattDistSevenWithAggShock.txt", mRattDistSevenWithAggShock, "Table"]; 

(* Plot consumption function *)
maxisSeven = Table[0.2 m, {m, 0, 400}]; (* Horizonal axis is cash on hand normalized by p (t)*wSS *)
mlist = maxisSeven wSS; (* c func (normalized by AdjustedLByAggState but not wSS) can be used after multiplying by wSS *)
caxisSevenHigh =  KSIndcFunc[mlist, 1, 1, kSS, 1] /wSS; (* agg state is 1 (good). emp state is 1 (employed) *)
  (* need to divide just by wSS bc when calculating c func, vars are (already) normalized by AdjustedLByAggState *)
caxisSevenLow  =  KSIndcFunc[mlist, 1, 1, kSS, 7] /wSS;
(*
mlist = maxisSeven wSS/
   AdjustedLByAggState[[1]];(*Horizonal axis is cash on hand normalized by p (t)*wSS *)
caxisSevenHigh =  KSIndcFunc[mlist, 1, 1, kSS, 1] AdjustedLByAggState[[1]]/wSS; (* agg state is 1 (good). emp state is 1 (employed) *)
caxisSevenLow  =  KSIndcFunc[mlist, 1, 1, kSS, 7] AdjustedLByAggState[[1]]/wSS;
*)

Print[" Consumption function"]

Export["maxisSeven.txt", maxisSeven, "Table"]; 
maxisSeven = Import["maxisSeven.txt","List"]; 
Export["caxisSevenHigh.txt", caxisSevenHigh, "Table"]; 
caxisSevenHigh = Import["caxisSevenHigh.txt","List"]; 
Export["caxisSevenLow.txt", caxisSevenLow, "Table"]; 
caxisSevenLow = Import["caxisSevenLow.txt","List"]; 

<<PlotCFuncsDistSeven.m;

(* Export data on wealth distribution etc *)
kLevListDistSevenWithAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListDistSeven.txt", kLevListDistSevenWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListDistSevenWithAggShock.txt", kLevListDistSevenWithAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsDistSevenWithAggShock.txt", AggStatsWithAggShock, "Table"];
Export["MPCsList.txt", MPCt, "Table"];

Export[ParentDirectory[] <> "/Results/MPCListDistSevenWithAggShock.txt",             MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListRecessionDistSevenWithAggShock.txt",    MPCListRecessionWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListExpansionDistSevenWithAggShock.txt",    MPCListExpansionWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListEntRecessionDistSevenWithAggShock.txt", MPCListEntRecessionWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListEntExpansionDistSevenWithAggShock.txt", MPCListEntExpansionWithAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/MPCDistSevenWithAggShock.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];
Export[ParentDirectory[] <> "/Results/MPCDistSevenBottomHalf.tex", Round[100 MeanMPCBottomHalfBykAnnual]/100//N, "Table"];


Export[ParentDirectory[] <> "/Results/ShareMostImpatientIncLevBot20Pct.tex", ShareMostImpatientIncLevBot20Pct//N, "Table"];  (* share of most impatient in the bottom 20% of the consumption distribution *)
Export[ParentDirectory[] <> "/Results/Share2ndImpatientIncLevBot20Pct.tex",  Share2ndImpatientIncLevBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share3rdImpatientIncLevBot20Pct.tex",  Share3rdImpatientIncLevBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share4thImpatientIncLevBot20Pct.tex",  Share4thImpatientIncLevBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share5thImpatientIncLevBot20Pct.tex",  Share5thImpatientIncLevBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share6thImpatientIncLevBot20Pct.tex",  Share6thImpatientIncLevBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share7thImpatientIncLevBot20Pct.tex",  Share7thImpatientIncLevBot20Pct//N, "Table"];

Export[ParentDirectory[] <> "/Results/FracMostImpatientcLevInBot20Pct.tex",  FracMostImpatientcLevInBot20Pct//N, "Table"]; (* fraction of most impatient whose consumption level is in the bottom 20% of the distribution *)
Export[ParentDirectory[] <> "/Results/Frac2ndImpatientcLevInBot20Pct.tex",   Frac2ndImpatientcLevInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac3rdImpatientcLevInBot20Pct.tex",   Frac3rdImpatientcLevInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac4thImpatientcLevInBot20Pct.tex",   Frac4thImpatientcLevInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac5thImpatientcLevInBot20Pct.tex",   Frac5thImpatientcLevInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac6thImpatientcLevInBot20Pct.tex",   Frac6thImpatientcLevInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac7thImpatientcLevInBot20Pct.tex",   Frac7thImpatientcLevInBot20Pct//N, "Table"];
Print["Share (%) of households in the bottom 20% of consumption level (most impatient/2nd impatient.../least (7th) impatient): "]; 
Print[{ShareMostImpatientIncLevBot20Pct, Share2ndImpatientIncLevBot20Pct, Share3rdImpatientIncLevBot20Pct, Share4thImpatientIncLevBot20Pct, Share5thImpatientIncLevBot20Pct, Share6thImpatientIncLevBot20Pct, Share7thImpatientIncLevBot20Pct}]; 
Print["Fraction (%) of most impatient/2nd impatient.../least (7th) impatient households whose consumption level is in the bottom 20%: "];
Print[{FracMostImpatientcLevInBot20Pct,  Frac2ndImpatientcLevInBot20Pct,  Frac3rdImpatientcLevInBot20Pct,  Frac4thImpatientcLevInBot20Pct,  Frac5thImpatientcLevInBot20Pct,  Frac6thImpatientcLevInBot20Pct,  Frac7thImpatientcLevInBot20Pct }]; 


(*
Export[ParentDirectory[] <> "/Results/AveragecRattMostImpatient.tex", AveragecRattMostImpatient//N, "Table"]; 
Export[ParentDirectory[] <> "/Results/AveragecRatt2ndImpatient.tex",  AveragecRatt2ndImpatient//N, "Table"];
Export[ParentDirectory[] <> "/Results/AveragecRatt3rdImpatient.tex",  AveragecRatt3rdImpatient//N, "Table"];
Export[ParentDirectory[] <> "/Results/AveragecRatt4thImpatient.tex",  AveragecRatt4thImpatient//N, "Table"];
Export[ParentDirectory[] <> "/Results/AveragecRatt5thImpatient.tex",  AveragecRatt5thImpatient//N, "Table"];
Export[ParentDirectory[] <> "/Results/AveragecRatt6thImpatient.tex",  AveragecRatt6thImpatient//N, "Table"];
Export[ParentDirectory[] <> "/Results/AveragecRatt7thImpatient.tex",  AveragecRatt7thImpatient//N, "Table"];
Print["consumption income ratio (most impatient/2nd impatient.../least (7th) impatient):"]; 
Print[{AveragecRattMostImpatient, AveragecRatt2ndImpatient, AveragecRatt3rdImpatient, AveragecRatt4thImpatient, AveragecRatt5thImpatient, AveragecRatt6thImpatient, AveragecRatt7thImpatient}]; 

Export[ParentDirectory[] <> "/Results/ShareMostImpatientIncRatBot20Pct.tex", ShareMostImpatientIncRatBot20Pct//N, "Table"];  (* share of most impatient in the bottom 20% of the distribution of consumption income ratio *)
Export[ParentDirectory[] <> "/Results/Share2ndImpatientIncRatBot20Pct.tex",  Share2ndImpatientIncRatBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share3rdImpatientIncRatBot20Pct.tex",  Share3rdImpatientIncRatBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share4thImpatientIncRatBot20Pct.tex",  Share4thImpatientIncRatBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share5thImpatientIncRatBot20Pct.tex",  Share5thImpatientIncRatBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share6thImpatientIncRatBot20Pct.tex",  Share6thImpatientIncRatBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Share7thImpatientIncRatBot20Pct.tex",  Share7thImpatientIncRatBot20Pct//N, "Table"];

Export[ParentDirectory[] <> "/Results/FracMostImpatientcRatInBot20Pct.tex",  FracMostImpatientcRatInBot20Pct//N, "Table"]; (* fraction of most impatient whose consumption income ratio is in the bottom 20% of the distribution *)
Export[ParentDirectory[] <> "/Results/Frac2ndImpatientcRatInBot20Pct.tex",   Frac2ndImpatientcRatInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac3rdImpatientcRatInBot20Pct.tex",   Frac3rdImpatientcRatInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac4thImpatientcRatInBot20Pct.tex",   Frac4thImpatientcRatInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac5thImpatientcRatInBot20Pct.tex",   Frac5thImpatientcRatInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac6thImpatientcRatInBot20Pct.tex",   Frac6thImpatientcRatInBot20Pct//N, "Table"];
Export[ParentDirectory[] <> "/Results/Frac7thImpatientcRatInBot20Pct.tex",   Frac7thImpatientcRatInBot20Pct//N, "Table"];
Print["Share (%) of households in the bottom 20% of consumption income ratio (most impatient/2nd impatient.../least (7th) impatient): "]; 
Print[{ShareMostImpatientIncRatBot20Pct, Share2ndImpatientIncRatBot20Pct, Share3rdImpatientIncRatBot20Pct, Share4thImpatientIncRatBot20Pct, Share5thImpatientIncRatBot20Pct, Share6thImpatientIncRatBot20Pct, Share7thImpatientIncRatBot20Pct}]; 
Print["Fraction (%) of most impatient/2nd impatient.../least (7th) impatient households whose consumption income ratio is in the bottom 20%: "];
Print[{FracMostImpatientcRatInBot20Pct,  Frac2ndImpatientcRatInBot20Pct,  Frac3rdImpatientcRatInBot20Pct,  Frac4thImpatientcRatInBot20Pct,  Frac5thImpatientcRatInBot20Pct,  Frac6thImpatientcRatInBot20Pct,  Frac7thImpatientcRatInBot20Pct }]; 
*)


Export[ParentDirectory[] <> "/Results/kAR1Coeff1GoodDistSeven.tex", Round[1000 kAR1ByAggState[[1,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2GoodDistSeven.tex", Round[1000 kAR1ByAggState[[1,2]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff1BadDistSeven.tex",  Round[1000 kAR1ByAggState[[3,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2BadDistSeven.tex",  Round[1000 kAR1ByAggState[[3,2]]]/1000//N, "Table"];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Dist model with time pref factors approximated by seven points (minutes): ",(TimeEnd - TimeStart)/60]; 