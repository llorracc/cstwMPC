(* SolveAndSimDistSevenFinInEstimation.m *)
(* This file is used in estimating parameters in FindBetaDistSevenFin.m *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];

TimeStart = SessionTime[]; 

ModelType         = Dist;   (* Indicate that the model is Dist *) 
NumOfApproxPoints = 7;      (* Time pref factors approximated by seven points *)
Rep               = False;

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;        (* Setup everything (routines etc.) *)
(*
MaxGapCoeff = 0.03;            (* Apply loose criteria for the convergence of agg law 3% *)
*)
\[Beta]middle = Import["BetamiddleFin.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffFin.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)
Print["-----------------------------------------"];
Print["\[EmptyDownTriangle]/3.5, \[Beta]middle: "];
Print[{diff, \[Beta]middle}];
kAR1ByAggState = kAR1ByAggStateRep;                   (* Use agg process estimated by the rep agent model *)

TimesToEstimateSmall = 0;       (* Number of times to estimate agg process with small(er) number of people *) 
NumPeopleToSim       = 5600;    (* Number of people to simulate *)
NumPeopleToSimLarge  = NumPeopleToSim;   (* same as above *)

(*
NumPeopleToSim       = 7000;    (* Number of people to simulate *)
NumPeopleToSimLarge  = 7000;    (* Same size as above *)
*)

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the Dist model. *)
If[RunModelt == 1, TimesToEstimateSmall = 1, TimesToEstimateSmall = 0]; (* If in the first estimation (of agg process), set this at 1 (meaning that iterate the model 3 times) *)

While[Estimatet <= TimesToEstimateSmall+2 (* Iterate TimesToEstimateSmall+2 times *), 

(*
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. Iterate at least TimesToEstimateSmall+2. *), 
*)

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
(*
    If[TimesToEstimateSmall>3, 
    Print[" Time spent to solve consumption function(s) (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60];
    ]; 
*)
   (* Run simulation, show results, and estimate agg process *)
   SimulateKSInd;
       
   Estimatet++;

   ]; (* End While *)

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Dist model with time pref factors approximated by seven points (minutes): ",(TimeEnd - TimeStart)/60]; 