(* SolveAndSimDistNine.m *)
(* This file runs \[Beta]-Dist (uniformly distributed \[Beta]) model with time pref factors approximated by nine points. In the model, there are nine types of households. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]];
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Run \[Beta]-Dist model with time pref factors approximated by nine points"];

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running \[Beta]-Dist model with time pref factors approximated by nine points... "];
ModelType         = Dist; (* Indicate that the model is Dist *) 
NumOfApproxPoints = 9;      (* Time pref factors approximated by nine points *)
Rep               = False;

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;         (* Setup everything (routines etc.) *)
(*
\[Beta]middle       = 0.986617; (* Mean of time pref factors *)
*)
\[Beta]middle = Import["BetamiddleNine.txt","List"][[1]]; (* Mean of time pref factors *)
(*
diff                = 0.0012;   (* Diff between approximated points (of time pref factors) *)
*)
diff = Import["diffNine.txt","List"][[1]]; (* Diff between approximated points (of time pref factors) *)
TimesToEstimateSmall = 5;      (* Number of times to estimate agg process *) 

NumPeopleToSim       = 7200;    (* Number of people to simulate *)
NumPeopleToSimLarge  = NumPeopleToSim*10;   (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)

(*
NumPeopleToSim       = 9000;     (* Number of people to simulate *)
NumPeopleToSimLarge  = 90000;    (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)
*)

(* Construct converged consumption function and run simulation *)
GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
RunModelt  = Import["RunModelt.txt","List"][[1]]; (* This starts with 1 when we run the model. *)
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. Iterate at least TimesToEstimateSmall+2. *), 

   Print["Iteration ", Estimatet];   
       
    (* Construct consumption function *)
    StartConstructingFunc = SessionTime[]; 
    Print[" Solving ind consumption function(s)..."];

    \[Beta] = (\[Beta]middle + 4 diff)  (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList1];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,1] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList1 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle + 3 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList2];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,2] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList2 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle + 2 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList3];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,3] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList3 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle +   diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList4];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,4] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList4 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList5];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,5] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList5 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle -  diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList6];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,6] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList6 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle - 2 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList7];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,7] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList7 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle - 3 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList8];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,8] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList8 = cInterpFuncList; 

    \[Beta] = (\[Beta]middle - 4 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFuncList = cInterpFuncList9];
    ConstructKSIndFunc; 
    KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,9] = KSIndcFunc[mRatt,AggStatet,EmpStatet,KRatt];
    cInterpFuncList9 = cInterpFuncList; 

    EndConstructingFunc   = SessionTime[]; 
    Print[" Time spent to solve consumption function(s) (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60]; 

   (* Run simulation, show results, and estimate agg process *)
   SimulateKSInd;
       
   Estimatet++;

   ]; (* End While *)

(* Export data on wealth distribution *)
Export["kLevListDistNine.txt", {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}, "Table"];

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Dist model with time pref factors approximated by nine points (minutes): ", (TimeEnd - TimeStart)/60]; 