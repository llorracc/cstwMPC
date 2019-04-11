(* EstimateIncVarsCastaneda.m *)
(* This file estimates income variances implied by Castaneda *)

(*
SetDirectory[NotebookDirectory[]];
<<PrepareEverything.m;        (* Setup everything (routines etc.) *)
*) 

TransitionProbMat = {{96.24, 1.14, .39, .006},
                     {3.07, 94.33, .37, 0},
                     {1.50, .43, 95.82, .020},
                     {10.66, .49, 6.11, 80.51}}/100; (* Params from Castaneda et al (2003) *)

For[l = 1, l <= 4,
  TransitionProbMat[[l]] = 
   TransitionProbMat[[l]]/Total[TransitionProbMat[[l]]]; l++]; (* Scaled up so that sum becomes 1 *)

TransitionCumProbMatTranspose = Transpose[TransitionProbMat];

TransitionCumProbMat = TransitionCumProbMatTranspose;

For[l = 2, l <= 4,
  TransitionCumProbMat[[l]] = 
   TransitionCumProbMat[[l - 1]] + TransitionCumProbMatTranspose[[l]];
   l++];

TransitionCumProbMat = Transpose[TransitionCumProbMat];

WageVec    = {1, 3.15, 9.78, 1061.0};

(*  Simulate *)
NumOfPeriodToSimulate = 100000; (* 50000 is default *)
StateList      = LogWageList = Table[0, {NumOfPeriodToSimulate}];
StateList[[1]] = 1;

For[periodt = 2, periodt <= NumOfPeriodToSimulate,
  r = Random[];
  StateList[[periodt]] = 
   FirstElementGreaterThan[
    TransitionCumProbMat[[StateList[[periodt - 1]]]], r];
  periodt++];

WageList = WageVec[[StateList]];

(*
WageList = Table[Total[Take[WageList, {(i - 1)*4 + 1, (i - 1)*4 + 4}]]/4, {i, 
   Length[WageList]/4}]; (* calculated annual income *)
*) (* this part is not needed since castaneda is calbrated annually *)

(* Estimates of income vars *) 
IntervalUsedToCalcVar = 5; 

(* No sample restriction *)
LogWageList = Log[WageList];
MyReg[Drop[LogWageList,{1}], Transpose[{Drop[LogWageList,{-1}]}]] (* Calc AR1 coeff *)
Diffn      = Drop[LogWageList,{1,IntervalUsedToCalcVar}] - Drop[LogWageList,{-IntervalUsedToCalcVar,-1}]; 
Diffnm1    = Drop[LogWageList,{1,(IntervalUsedToCalcVar-1)}] - Drop[LogWageList,{-(IntervalUsedToCalcVar-1),-1}];

VARn       = Variance[Diffn]; 
VARnm1     = Variance[Diffnm1]; 

VarPermCas = VARn- VARnm1;                                (* Variance of perm shocks *)
VarTranCas = (VARn - IntervalUsedToCalcVar*VarPermCas)/2; (* Varinace of tran shocks *)

Print[" Variances of perm shocks and trans shocks implied by Castaneda (no sample restriction): ", {VarPermCas, VarTranCas}];

(* Below is used if a set of obs is dropped if the min inc is less than 20 percent of the average during the 7-year period *)
Diffn   = {0};
Diffnm1 = {0};
For[i = 1, i <= Length[WageList] - 7 + 1, (* 7 means that 7 periods is taken as in Carroll and Samwick (1997) *)
 WageListTemp     = Take[WageList, {i, i + 6}];
 WageListTempMean = Mean[WageListTemp];
 If[Min[WageListTemp] > 0.2 WageListTempMean, 

  (*if yes *)
  AppendTo[Diffn, 
   Table[Log[WageListTemp[[j + IntervalUsedToCalcVar ]]] - 
     Log[WageListTemp[[j]]]
    , {j, 1, 7 - IntervalUsedToCalcVar}]];
  AppendTo[Diffnm1, 
   Table[Log[WageListTemp[[j + IntervalUsedToCalcVar - 1]]] - 
     Log[WageListTemp[[j]]]
    , {j, 1, 7 - (IntervalUsedToCalcVar - 1)}]];
  
  ];
 
 i++
 ];
Diffn = Drop[Flatten[Diffn], 1]; (* remove the first element *)
Diffnm1 = Drop[Flatten[Diffnm1], 1];  (* remove the first element *)

VARn       = Variance[Diffn]; 
VARnm1     = Variance[Diffnm1]; 

VarPermCas = VARn- VARnm1;                                (* Variance of perm shocks *)
VarTranCas = (VARn - IntervalUsedToCalcVar*VarPermCas)/2; (* Varinace of tran shocks *)

Print[" Variances of perm shocks and trans shocks implied by Castaneda (dropping samples if annual income is below 20 percent of the 7-year average): ", {VarPermCas, VarTranCas}];


