(* SolveAndSimDistSeven.m *)
(* This file runs \[Beta]-Dist (uniformly distributed \[Beta]) model with time pref factors approximated by seven points. In the model, there are seven types of households. *)

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running \[Beta]-Dist model with time pref factors approximated by seven points... "];
ModelType         = Dist;   (* Indicate that the model is Dist *) 
NumOfApproxPoints = 7;      (* Time pref factors approximated by seven points *)
Rep               = False;

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;        (* Setup everything (routines etc.) *)
(* Overwrite params *)
(*
MaxGap      = 0.03;            (* Apply loose criteria for the convergence of consumption function(s) *)
*)
PeriodsToSimulate = 10000;
PeriodsToUse      = Round[(1/3) PeriodsToSimulate];   (* Periods to use in estimation *)
(*
PeriodsToUse      = Round[(10/11) PeriodsToSimulate]; (* Periods to use in estimation *)
*)
AggState          = Take[AggStatecstCode, PeriodsToSimulate];
(*
\[Beta]middle = Import["BetamiddleSolution.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffSolution.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)
*)
\[Beta]middle = 0.985582; 
diff          = 0.0020;

(*
\[Beta]middle = 0.985207; 
diff          = 0.0021;
*)

Print["\[EmptyDownTriangle]/3.5, \[Beta]middle: "];
Print[{diff, \[Beta]middle}];
kAR1ByAggState  = kAR1ByAggStateRep; (* Use agg process estimated by the rep agent model *)
TimesToEstimate = 1;                 (* Number of times to estimate agg process *)
NumOfSims       = 30;  

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1; (* Iterate only once because agg law matters very little in terms of wealth dist *)
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the Dist model. *)

(* Run sim with 7 households *)
While[Estimatet <= TimesToEstimate, 

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

    Print[" Time spent to solve consumption function(s) (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60];

   (* Run simulation and estimate agg process *)
   StatsMat = Table[SimulateKSIndIntGuess;
                    N[{
                       100 kLevTop1Percent, 
                       100 kLevTop5Percent, 
                       100 kLevTop10Percent, 
                       100 kLevTop20Percent, 
                       100 kLevTop25Percent, 
                       100 kLevTop40Percent, 
                       100 kLevTop50Percent, 
                       100 kLevTop60Percent, 
                       100 kLevTop80Percent, 
                       GiniCoeff}], 
                       {NumOfSims}
                        ]; (* End Table *)

   StatsMatMean = Mean[StatsMat]; 
   SumOfDevSq   =  (StatsMatMean[[4]]-79.5)^2 
                 + (StatsMatMean[[6]]-92.9)^2
                 + (StatsMatMean[[8]]-98.7)^2
                 + (StatsMatMean[[9]]-100.4)^2;
   AppendTo[StatsMatMean, SumOfDevSq];
   

   Print[" Distribution of wealth (k) 1%, 5%, 10%, 20%, 25%, 40%, 50%, 60%, 80%, Gini coeff (mean), SumOfDevSq: "];
   Print[StatsMatMean];


   Estimatet++;

   ]; (* End While *)   

(* Test results *)
(*
kRatt
EmpStatet
Print["Xit"];
Xit
yRatt
Print["mRatt"];
mRatt
Print["cRatt"];
cRatt
Print["sRatt"];
sRatt
Gt
*)


(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Dist model with time pref factors approximated by seven points (minutes): ",(TimeEnd - TimeStart)/60]; 