(* SolveAndSimDistSevenLiqFinPlsRet.m *)
(* This file runs \[Beta]-Dist (uniformly distributed \[Beta]) model with time pref factors approximated by seven points. In the model, there are seven types of households. Using parameter values estimated by matching liquid FINANCIAL assets plus retirement assets. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Run \[Beta]-Dist model with time pref factors approximated by seven points"];
Print["Using parameter values estimated by matching liquid FINANCIAL assets plus retirement assets"];

MatchLiqFinPlsRetAssets  = Yes;    (* Matching liquid financial assets plus ret assets, not net worth *)

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
\[Beta]middle = Import["BetamiddleWithAggShocksLiqFinPlsRet.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffWithAggShocksLiqFinPlsRet.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)
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

(* Export data on wealth distribution *)
kLevListDistSevenWithAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListDistSevenLiqFinPlsRet.txt",                                           kLevListDistSevenWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListDistSevenWithAggShockLiqFinPlsRet.txt", kLevListDistSevenWithAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/mRatMedianMeanDistSevenWithAggShockLiqFinPlsRet.tex",        Round[10 mRatMedianMean]/10//N, "Table"];
Export[ParentDirectory[] <> "/Results/mRatMedianMeanAnnualDistSevenWithAggShockLiqFinPlsRet.tex",  Round[10 mRatMedianMean/4]/10//N, "Table"];
Export[ParentDirectory[] <> "/Results/FracmRatBelow20MeanDistSevenWithAggShockLiqFinPlsRet.tex",        Round[10 FracmRatBelow20Mean]/10//N, "Table"];
Export[ParentDirectory[] <> "/Results/FracmRatBelow05MeanAnnualDistSevenWithAggShockLiqFinPlsRet.tex",  Round[10 FracmRatBelow20Mean]/10//N, "Table"]; (* fraction of mRat below 0.5 in annual terms *)


Export[ParentDirectory[] <> "/Results/AggStatsDistSevenWithAggShockLiqFinPlsRet.txt", AggStatsWithAggShock, "Table"];
Export["MPCsListLiqFinPlsRet.txt", MPCt, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListDistSevenWithAggShockLiqFinPlsRet.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCDistSevenWithAggShockLiqFinPlsRet.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];
Export[ParentDirectory[] <> "/Results/MPCDistSevenBottomHalfLiqFinPlsRet.tex", Round[100 MeanMPCBottomHalfBykAnnual]/100//N, "Table"];

(*
Export[ParentDirectory[] <> "/Results/kAR1Coeff1GoodDistSevenLiqFinPlsRet.tex", Round[1000 kAR1ByAggState[[1,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2GoodDistSevenLiqFinPlsRet.tex", Round[1000 kAR1ByAggState[[1,2]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff1BadDistSevenLiqFinPlsRet.tex",  Round[1000 kAR1ByAggState[[3,1]]]/1000//N, "Table"];
Export[ParentDirectory[] <> "/Results/kAR1Coeff2BadDistSevenLiqFinPlsRet.tex",  Round[1000 kAR1ByAggState[[3,2]]]/1000//N, "Table"];
*)

Clear[MatchFinAssets]; (* Clear MatchFinAssets var *)

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Dist model with time pref factors approximated by seven points (minutes): ",(TimeEnd - TimeStart)/60]; 