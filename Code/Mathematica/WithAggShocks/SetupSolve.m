(* SetupSolve.m *)
(* This file constructs routines to be used for solution. Simulation routines are defined in SetupSim.m. *)


(* "Backwardshoot" constructs perfect foresight representative agent consumption function, using "backward shooting method." The idea of this method is to obtain a sequence of {k, c=c(k)} starting with a point close to the steady state. *)
Backwardshoot := Block[{},
  (* Backward shoot from below *)
  kBelowSeed   = {kSS - \[Epsilon], cSS - \[Epsilon] ckSSFunc[\[Rho]]}; (* Pick a point slightly below the steady state *)
  ResultsSoFar = Append[{{kSS, cSS}}, kBelowSeed];
  While[0.1 < Last[ResultsSoFar][[kPOS]], 
        StepBackOneMorePeriod;
        ]; (* End While *)
  ShootBackFromKBelowList = ResultsSoFar; (* List obtained by backward shooting from below *)

  (* Backward shoot from above *)      
  kAboveSeed   = {kSS + \[Epsilon], cSS + \[Epsilon] ckSSFunc[\[Rho]]}; (* Pick a point slightly above the steady state *)
  ResultsSoFar = Append[{{kSS, cSS}}, kAboveSeed];
  While[5 kSS > Last[ResultsSoFar][[kPOS]], 
        StepBackOneMorePeriod;
        ]; (* End While *)
  ShootBackFromKAboveList = ResultsSoFar; (* List obtained by backward shooting from above *)

  (* Construct perfect foresight representative agent consumption function *)
  PFRepData      = Union[{{0,0}}, ShootBackFromKBelowList, ShootBackFromKAboveList];
  {KList, CList} = Transpose[PFRepData][[{kPOS, cPOS}]];
  If[KList[[1]] < 0, KList = Drop[KList, 1]; CList = Drop[CList, 1]]; 

  MList          = (1-\[Delta]) KList + F[KList];
  PFRepcFunc     = Interpolation[Transpose[{MList, CList}], InterpolationOrder -> 1];
]; (* End "Backwardshoot" *)

(* "StepBackOneMorePeriod" is used in "Backwardshoot" *)
{kPOS, cPOS} = {1, 2}; (* Position of k: 1, c: 2*)
StepBackOneMorePeriod := Block[{KRatt,CRatt,Rt,CRattm1,KRattm1Approx},
  KRatt         = ResultsSoFar[[-1,kPOS]];
  CRatt         = ResultsSoFar[[-1,cPOS]];
  Rt            = (1-\[Delta]+FP[KRatt]);
  CRattm1       = nP[\[Beta] Rt uP[CRatt]]; (* CRat(t-1), obtained from FOC given CRat(t). *)                      
  KRattm1Approx = (KRatt - (1-\[Alpha])*KRatt^\[Alpha] + CRattm1)/(1-\[Delta]+FP[KRatt]);
  (* Approximated KRat(t-1), obtained from FOC given KRat(t) and CRat(t). Now we have another {k, c=c(k)} = {KRattm1Approx, CRattm1}. *)
  ResultsSoFar = Append[ResultsSoFar, {KRattm1Approx, CRattm1}]; 
]; (* End "StepBackOneMorePeriod" *)  

(* Function to find MPC out of capital near steady state (used in "Backwardshoot" which constructs representative agent PF consumption function) *)
ckSSFunc[\[Rho]val_] := ckSeek /. FindRoot[ckSeek == (1-\[Delta]+ FP[kSS] - ckSeek) (ckSeek - (cSS \[Beta] \[Alpha] (\[Alpha]-1) kSS^(\[Alpha]-2) )/\[Rho]val), {ckSeek, 0.001, 0.1}];


(* "ConstructKSRepcFunc" constructs representative agent consumption function with aggregate shocks, using "SolveAnotherPeriodRep" defined below *)
ConstructKSRepcFunc := Block[{},

 (* Iterate until consumption func converges *)
 Iteration      = 0;
 CalculatedGap  = 1; (* Initial value of calulcated gap *)
 MRatGridTest   = mSS{0.9, 1, 1.1};

 While[CalculatedGap > MaxGap (* Iterate while calculated (max) gap is more than MaxGap *), 
       Iteration++;  

       cInterpFuncListTemp = Table[SolveAnotherPeriodRep; (* Solve another period, given LifePosn and aggregate state *)
                                   cInterpFuncTemp,
                                   {AggStatetTemp,NumOfAggStates}];(* End Table *)      
       AppendTo[cInterpFuncList,cInterpFuncListTemp]; 
       CalculatedGap = Max[Abs[Join[cInterpFuncList[[-1, 1]][MRatGridTest]/cInterpFuncList[[-2,1]][MRatGridTest]-1,
                                    cInterpFuncList[[-1, 2]][MRatGridTest]/cInterpFuncList[[-2,2]][MRatGridTest]-1]]];
       (* Print[CalculatedGap]; *)
       ]; (* End While *)

cInterpFunc[MRatt_,AggStatet_,1] := cInterpFuncList[[-1,AggStatet]][MRatt]; (* Define c func *)

]; (* End "ConstructKSRepcFunc" *)

(* "SolveAnotherPeriodRep" is used in "ConstructKSRepcFunc". 
  This code follows "The Method of Endogenous Gridpoints for Solving Dynamic Stochastic Optimization Problems" by Christopher D. Carroll. *)
SolveAnotherPeriodRep := Block[{},

\[Chi]VecTemp = nP[\[GothicV]P[SRatVec,AggStatetTemp]];
\[Mu]VecTemp  = \[Chi]VecTemp + SRatVec;
TempData      = Transpose[{\[Mu]VecTemp,\[Chi]VecTemp}];

    cInterpFuncTemp = Interpolation[
      Union[
        Chop[
          Prepend[TempData, {0.,0.}] (* Prepending {0,0} handles potential liquidity constraint *)
        ]                            (* Chop cuts off numerically insignificant digits *)
      ]                              (* Union removes duplicate entries *)
    ,InterpolationOrder->1] (* Piecewise linear interpolation *)
]; (* End SolveAnotherPeriodRep *)

(* Expected marginal value of saving function \[GothicV](t)'(SRat(t)) used in model of representative agent with aggregate shocks *)
\[GothicV]P[SRatt_,AggStatet_] := \[Beta] Sum[
      AggStatetp1 = AggStatetp1Loop;                    (* AggState(t+1) *)
      Gtp1        = GrowthByAggState[[AggStatetp1]];    (* G(t+1) *)
      KRattp1     = SRatt/Gtp1;                         (* KRat(t+1) *)
      MRattp1     = (1-\[Delta]) KRattp1 + F[KRattp1];  (* MRat(t+1) *)
      AggStateTransitionMatrix[[AggStatet,AggStatetp1]] (1-\[Delta]+FP[KRattp1]) uP[Gtp1 cInterpFuncList[[-1,AggStatetp1]][MRattp1]],
      {AggStatetp1Loop,NumOfAggStates}
]; (* End of Sum *)


(* "ConstructKSIndFunc" constructs consumption function with idiosyncratic shocks, using "SolveAnotherPeriodInd" defined below *)
ConstructKSIndFunc := Block[{},

 (* Construct last period consumption function *)
  If[Estimatet==1 && RunModelt==1 (* If in the first iteration of the first estimation *),

     HumanWealth = wSS (1/(1-1/RSS)-1);                (* Human wealth *)
     MTC         = (1-(RSS \[Beta])^(1/\[Rho])/RSS); (* Marginal tendency to consume *)

     cFuncLast[mRatt_,AggState_,EmpState_,KRatt_] := If[mRatt < MTC (mRatt + HumanWealth   MeanOfL/AdjustedLByAggState[[AggState]]),
                  (* true *) mRatt,
                  (* else *) MTC (mRatt + HumanWealth MeanOfL/AdjustedLByAggState[[AggState]])];

     (* Construct interpolation function for later use *)
     cInterpFuncListTemp = Table[AggStatetTemp = AggStatetLoop;
                                 EmpStatetTemp = EmpStatetLoop-1;
                                   mKinked = MTC (HumanWealth MeanOfL/AdjustedLByAggState[[AggStatetTemp]])/(1 - MTC);
                                   mRattVec = {0, mKinked, kSS};
                                   KRattVec = {0.5 kSS, 2 kSS};
                                   cInterpFuncTemp = Interpolation[Partition[Flatten[Table[{mRattVec[[mRattVecLoop]],KRattVec[[KRattVecLoop]], cFuncLast[mRattVec[[mRattVecLoop]], AggStatetTemp, EmpStatetTemp, KRattVec[[KRattVecLoop]]]},
                                     {mRattVecLoop, Length[mRattVec]}, 
                                     {KRattVecLoop, Length[KRattVec]}]
                                      ], (* End Flatten *) 
                                    3] (* End Partition *) 
                                   ,InterpolationOrder -> 1];
                                   cInterpFuncTemp,
                                   {AggStatetLoop,NumOfAggStates/2},
                                   {EmpStatetLoop,NumOfEmpStates}];(* End Table *)      
     cInterpFuncList = Join[cInterpFuncListTemp,{cInterpFuncListTemp[[2]],cInterpFuncListTemp[[1]]}];

     ]; (* If in the very first estimation. If in the second estimation or after, then this code is skipped and the final function in the previous estimation is used as the starting point for iteration. *)

 (* Iterate until consumption func converges *)
 Iteration      = 0;
 CalculatedGap  = 1; (* Initial value of calulcated gap *)
 mRatGridTest   = mSS {0.01, 0.5, 1, 3, 5, 10};

 While[CalculatedGap > MaxGap (* Iterate while calculated (max) gap is more than MaxGap *), 
       Iteration++;  
(*
       If[Iteration==1 || Mod[Iteration,10]==0, Print[" Solving period ",Iteration]];
*)

       cInterpFuncListTemp = Table[AggStatetTemp = AggStatetLoop;
                                   EmpStatetTemp = EmpStatetLoop-1;
                                   SolveAnotherPeriodInd; (* Solve another period, given LifePosn, aggregate state and employment state *)
                                   cInterpFuncTemp,
                                   {AggStatetLoop,NumOfAggStates/2},
                                   {EmpStatetLoop,NumOfEmpStates}];(* End Table *)      
       cInterpFuncListTemp = Join[cInterpFuncListTemp,{cInterpFuncListTemp[[2]],cInterpFuncListTemp[[1]]}];
       CalculatedGap = Max[Abs[Join[cInterpFuncListTemp[[1 (* Agg state is good *), 1 (* unemployed *)]][mRatGridTest,kSS]/cInterpFuncList[[1, 1]][mRatGridTest,kSS]-1,
                                    cInterpFuncListTemp[[2 (* Agg state is bad  *), 1 (* unemployed *)]][mRatGridTest,kSS]/cInterpFuncList[[2, 1]][mRatGridTest,kSS]-1,
                                    cInterpFuncListTemp[[1, 2 (* employed *)]][mRatGridTest,kSS]/cInterpFuncList[[1, 2]][mRatGridTest,kSS]-1,
                                    cInterpFuncListTemp[[2, 2 (* employed *)]][mRatGridTest,kSS]/cInterpFuncList[[2, 2]][mRatGridTest,kSS]-1
]]]; (* Calculating max difference beween current consumption function and previoius one *)
       cInterpFuncList = cInterpFuncListTemp; (* Rename function *)
       (* Print[CalculatedGap]; *)
       ]; (* End While *)

  KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_] := cInterpFuncList[[AggStatet,EmpStatet+1]][mRatt,KRatt]; (* Define converged consumption function with idiosyncratic shocks *)

]; (* End "ConstructKSIndFunc" *)

(* "SolveAnotherPeriodInd" is used in "ConstructKSIndFunc". 
  This code follows "The Method of Endogenous Gridpoints for Solving Dynamic Stochastic Optimization Problems" by Christopher D. Carroll. 
  Note that grid in cInterpData (data for interpolation) has to be "regular"; if not, two dimensional interpolation does not work. *)
SolveAnotherPeriodInd := Block[{},

 (* Data for interpolation given KRat = kSS *)
 KRat          = kSS;
 \[Chi]TempVec = nP[\[GothicV]IndP[sRatVec,AggStatetTemp,EmpStatetTemp,KRat]];
 \[Mu]TempVec  = sRatVec + \[Chi]TempVec;
 TempData      = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3]; 
 cInterpData = Union[
                 Chop[
                   Prepend[TempData, {0.,KRat,0.}         
                ]                (* Prepending {0,KRat,0} handles potential liquidity constraint *)
             ]                   (* Chop cuts off numerically insignificant digits *)
           ];                    (* Union removes duplicate entries *)

 (* Construct \[Mu]Vec (\[Mu]: possible values of cash on hand) *)   
 \[Mu]Vec = Transpose[cInterpData][[1]];

 (* Data for interpolation given KRat = kSS[[1]] *)
 KRat = KRatVec[[1]];
 \[Chi]TempVec   = nP[\[GothicV]IndP[sRatVec,AggStatetTemp,EmpStatetTemp,KRat]];
 \[Mu]TempVec    = sRatVec + \[Chi]TempVec;
 TempData        = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3];
 (* Construct interp consumption functiontion given KRat *)
 Temp = Interpolation[
                  Union[
                     Chop[
                    Prepend[TempData, {0.,KRat,0.}        
                ]                  (* Prepending {0,KRat,0} handles potential liquidity constraint *)
             ]                     (* Chop cuts off numerically insignificant digits *)
           ]                       (* Union removes duplicate entries *)
     ,InterpolationOrder->1];      (* Piecewise linear interpolation *)

 (* Construct data for interpolation, using function "Temp" defined above. *)
 cInterpData = Transpose[{\[Mu]Vec, KRat Table[1,{Length[\[Mu]Vec]}], Temp[\[Mu]Vec,KRat]}];
   (* This step is necessary to make grid regular *)  

 (* Data for interpolation. *) 
 For[i  = 2,
     i <= Length[KRatVec],
     KRat          = KRatVec[[i]];
     \[Chi]TempVec = nP[\[GothicV]IndP[sRatVec,AggStatetTemp,EmpStatetTemp,KRat]];
     \[Mu]TempVec  = sRatVec + \[Chi]TempVec;
     TempData      = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3];

    (* Construct interp consumption functiontion given KRat *)
     Temp = Interpolation[
                     Union[
                       Chop[
                    Prepend[TempData, {0.,KRat,0.}         
                ]                  (* Prepending {0,KRat,0} handles potential liquidity constraint *)
             ]                     (* Chop cuts off numerically insignificant digits *)
           ]                       (* Union removes duplicate entries *)
     ,InterpolationOrder->1];      (* Piecewise linear interpolation *)

    (* Construct data for interpolation, using function "Temp" defined above. *)
     cInterpDataTemp = Transpose[{\[Mu]Vec, KRat Table[1,{Length[\[Mu]Vec]}], Temp[\[Mu]Vec,KRat]}]; (* This step is necessary to make grid regular *)   

     cInterpData     = Join[cInterpData,cInterpDataTemp];  

     i  = i + 1
     ]; (* End loop *)

 (* Construct interp consumption function *)
 cInterpFuncTemp = Interpolation[cInterpData,InterpolationOrder->1];

]; (* End SolveAnotherPeriodInd *)


(* "ConstructKSHeteroIndFunc" constructs consumption function with idiosyncratic shocks, using "SolveAnotherPeriodKSHeteroInd" defined below *)
ConstructKSHeteroIndFunc := Block[{},

 (* Construct last period consumption function *)
  If[Estimatet==1 && RunModelt==1 (* If in the first iteration of the first estimation *),


     (* Construct interpolation function for later use *)
     cInterpFuncListTemp = Table[AggStatetTemp = AggStatetLoop;
                                 EmpStatetTemp = EmpStatetLoop-1;

                                   mRattVec = {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]], kSS};
                                   KRattVec = {0.5 kSS, 2 kSS};
                                   cInterpFuncTemp = Interpolation[Partition[Flatten[Table[{mRattVec[[mRattVecLoop]],KRattVec[[KRattVecLoop]], mRattVec[[mRattVecLoop]]+maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]]},
                                     {mRattVecLoop, Length[mRattVec]}, 
                                     {KRattVecLoop, Length[KRattVec]}]
                                      ], (* End Flatten *) 
                                    3] (* End Partition *) 
                                   ,InterpolationOrder -> 1];
                                   cInterpFuncTemp,
                                   {AggStatetLoop,NumOfAggStates/2},
                                   {EmpStatetLoop,NumOfEmpStates}];(* End Table *)      
     cInterpFuncList = Join[cInterpFuncListTemp,{cInterpFuncListTemp[[2]],cInterpFuncListTemp[[1]]}];

     cInterpFuncList = {cInterpFuncList, cInterpFuncList, cInterpFuncList};


     ]; (* If in the very first estimation. If in the second estimation or after, then this code is skipped and the final function in the previous estimation is used as the starting point for iteration. *)

 (* Iterate until consumption func converges *)
 Iteration      = 0;
 CalculatedGap  = 1; (* Initial value of calulcated gap *)
 mRatGridTest   = mSS {0.01, 0.5, 1, 3, 5, 10};

 While[CalculatedGap > MaxGap (* Iterate while calculated (max) gap is more than MaxGap *), 
       Iteration++;  

(*
       If[Iteration==1 || Mod[Iteration,10]==0, Print[" Solving period ",Iteration]];
*)

  cInterpFuncListTemp = Table[BetaPostTemp = BetaPostLoop;

       cInterpFuncListTempTemp = Table[AggStatetTemp = AggStatetLoop;
                                   EmpStatetTemp = EmpStatetLoop-1;
                                   SolveAnotherPeriodKSHeteroInd; (* Solve another period, given LifePosn, aggregate state and employment state *)
                                   cInterpFuncTemp,

                                   {AggStatetLoop,NumOfAggStates/2},
                                   {EmpStatetLoop,NumOfEmpStates}];(* End Table *)  
    
       Join[cInterpFuncListTempTemp,{cInterpFuncListTempTemp[[2]],cInterpFuncListTempTemp[[1]]}],
       {BetaPostLoop,Length[\[Beta]List]}];(* End Table *)    

       CalculatedGap = Max[Abs[Join[cInterpFuncListTemp[[3]][[1 (* Agg state is good *), 1 (* unemployed *)]][mRatGridTest,kSS]/cInterpFuncList[[3]][[1, 1]][mRatGridTest,kSS]-1,
                                    cInterpFuncListTemp[[3]][[2 (* Agg state is bad  *), 1 (* unemployed *)]][mRatGridTest,kSS]/cInterpFuncList[[3]][[2, 1]][mRatGridTest,kSS]-1,
                                    cInterpFuncListTemp[[3]][[1, 2 (* employed *)]][mRatGridTest,kSS]/cInterpFuncList[[3]][[1, 2]][mRatGridTest,kSS]-1,
                                    cInterpFuncListTemp[[3]][[2, 2 (* employed *)]][mRatGridTest,kSS]/cInterpFuncList[[3]][[2, 2]][mRatGridTest,kSS]-1
]]]; (* Calculating max difference beween current consumption function and previoius one using high beta (patient) case *)

       cInterpFuncList = cInterpFuncListTemp; (* Rename function *)
       (* Print[CalculatedGap]; *)
       ]; (* End While *)

  KSIndcFunc[mRatt_,AggStatet_,EmpStatet_,KRatt_,BetaPostTemp_] := cInterpFuncList[[BetaPostTemp]][[AggStatet,EmpStatet+1]][mRatt,KRatt]; (* Define converged consumption function with idiosyncratic shocks *)

]; (* End "ConstructKSHeteroIndFunc" *)

(* "SolveAnotherPeriodKSHeteroInd" is used in "ConstructKSHeteroIndFunc". 
  This code follows "The Method of Endogenous Gridpoints for Solving Dynamic Stochastic Optimization Problems" by Christopher D. Carroll. 
  Note that grid in cInterpData (data for interpolation) has to be "regular"; if not, two dimensional interpolation does not work. *)
SolveAnotherPeriodKSHeteroInd := Block[{},

 (* Data for interpolation given KRat = kSS *)
 KRat          = kSS;

 \[Chi]TempVec = nP[Sum[pMat[[BetaPostTemp,BetaPostTempp1Loop]] \[GothicV]KSHeteroIndP[sRatVec-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],AggStatetTemp,EmpStatetTemp,KRat,BetaPostTempp1Loop] , {BetaPostTempp1Loop, Length[\[Beta]List]}] (* End Sum *) ];
 \[Mu]TempVec  = sRatVec-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]] + \[Chi]TempVec;
 TempData      = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3]; 

 cInterpData = Union[
                 Chop[
                   Prepend[TempData, {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]], KRat, 0.}         
                ]                (* Prepending {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],KRat,0} handles potential liquidity constraint *)
             ]                   (* Chop cuts off numerically insignificant digits *)
           ];                    (* Union removes duplicate entries *)

 (* Construct \[Mu]Vec (\[Mu]: possible values of cash on hand) *)   
 \[Mu]Vec = Transpose[cInterpData][[1]];

 (* Data for interpolation given KRat = kSS[[1]] *)
 KRat = KRatVec[[1]];
 \[Chi]TempVec = nP[Sum[pMat[[BetaPostTemp,BetaPostTempp1Loop]] \[GothicV]KSHeteroIndP[sRatVec-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],AggStatetTemp,EmpStatetTemp,KRat,BetaPostTempp1Loop] , {BetaPostTempp1Loop, Length[\[Beta]List]}] (* End Sum *) ];
 \[Mu]TempVec    = sRatVec-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]] + \[Chi]TempVec;
 TempData        = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3];

 (* Construct interp consumption functiontion given KRat *)
 Temp = Interpolation[
                  Union[
                     Chop[
                    Prepend[TempData, {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]], KRat, 0.}        
                ]                  (* Prepending {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],KRat,0} handles potential liquidity constraint *)
             ]                     (* Chop cuts off numerically insignificant digits *)
           ]                       (* Union removes duplicate entries *)
     ,InterpolationOrder->1];      (* Piecewise linear interpolation *)

 (* Construct data for interpolation, using function "Temp" defined above. *)
 cInterpData = Transpose[{\[Mu]Vec, KRat Table[1,{Length[\[Mu]Vec]}], Temp[\[Mu]Vec,KRat]}];
   (* This step is necessary to make grid regular *)  

 (* Data for interpolation. *) 
 For[i  = 2,
     i <= Length[KRatVec],
     KRat          = KRatVec[[i]];
     \[Chi]TempVec = nP[Sum[pMat[[BetaPostTemp,BetaPostTempp1Loop]] \[GothicV]KSHeteroIndP[sRatVec-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],AggStatetTemp,EmpStatetTemp,KRat,BetaPostTempp1Loop] , {BetaPostTempp1Loop, Length[\[Beta]List]}] (* End Sum *) ];
     \[Mu]TempVec  = sRatVec-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]] + \[Chi]TempVec;
     TempData      = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3];

    (* Construct interp consumption functiontion given KRat *)
     Temp = Interpolation[
                     Union[
                       Chop[
                    Prepend[TempData, {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],KRat,0.}         
                ]                  (* Prepending {-maxDebtKSHeteroLev/AdjustedLByAggState[[AggStatetTemp]],KRat,0} handles potential liquidity constraint *)
             ]                     (* Chop cuts off numerically insignificant digits *)
           ]                       (* Union removes duplicate entries *)
     ,InterpolationOrder->1];      (* Piecewise linear interpolation *)

    (* Construct data for interpolation, using function "Temp" defined above. *)
     cInterpDataTemp = Transpose[{\[Mu]Vec, KRat Table[1,{Length[\[Mu]Vec]}], Temp[\[Mu]Vec,KRat]}]; (* This step is necessary to make grid regular *)   

     cInterpData     = Join[cInterpData,cInterpDataTemp];  

     i  = i + 1
     ]; (* End loop *)

 (* Construct interp consumption function *)
 cInterpFuncTemp = Interpolation[cInterpData,InterpolationOrder->1];

]; (* End SolveAnotherPeriodKSHeteroInd *)


(* Expected marginal value of saving function \[GothicV](t)'(sRat(t)) used in model with idiosyncratic shocks *)
\[GothicV]IndP[sRatt_,AggStatet_,EmpStatet_,KRatt_] := \[Beta] Sum[
      AggStatetp1 = AggStatetp1Loop;                                     (* AggState(t+1) *)
      EmpStatetp1 = EmpStatetp1Loop-1;                                   (* EmpState(t+1), 0 or 1 *)
      ThetaVec     = {{etValsByAggEmpState[[AggStatetp1, 1]]},etValsByAggEmpState[[AggStatetp1, 2]] ThetaVecOrig};
      ThetaVecProb = {{EmpStateTransitionMatrix[[AggStatetp1,EmpStatet+1,1]] },EmpStateTransitionMatrix[[AggStatetp1,EmpStatet+1,2]]  ThetaVecProbOrig};

      KLevt       = KRatt AdjustedLByAggState[[AggStatet]];
      KRattp1     = Exp[kAR1ByAggState[[AggStatetp1]].{1,Log[KLevt]}]/AdjustedLByAggState[[AggStatetp1]]; 
                                                                         (* KRat(t+1) *)
      RE          = (1-\[Delta]+FP[KRattp1]) /(1-ProbOfDeath);           (* Effective interest rate *)

      Sum[PsiVecPostp1   = PsiVecPosLoop;
          ThetaVecPostp1 = ThetaVecPosLoop;
          Gtp1           = GrowthByAggState[[AggStatetp1]] ;             (* G(t+1) *) 
          kRattp1        = sRatt/(Gtp1 PsiVec[[PsiVecPostp1]]);          (* kRat(t+1) *)
          Thetatp1       = ThetaVec[[EmpStatetp1+1,ThetaVecPostp1]];     (* Theta(t+1) *)
          mRattp1        = RE kRattp1 + (wFunc[KRattp1]/LLevelByAggState[[AggStatetp1]]) Thetatp1;
                                                                         (* mRat(t+1) *)
          AggStateTransitionMatrix[[AggStatet,AggStatetp1]] PsiVecProb[[PsiVecPostp1]] ThetaVecProb[[EmpStatetp1+1,ThetaVecPostp1]] RE uP[(Gtp1 PsiVec[[PsiVecPostp1]]) cInterpFuncList[[AggStatetp1,EmpStatetp1+1]][mRattp1,KRattp1]],

          {ThetaVecPosLoop,Length[ThetaVec[[EmpStatetp1+1]]]},
          {PsiVecPosLoop,Length[PsiVec]}
          ],

      {EmpStatetp1Loop,NumOfEmpStates},
      {AggStatetp1Loop, 2 t[AggStatet]+1, 2 t[AggStatet] +2} 
         (* This loop for AggStatetp1 speeds up the solution; when AggStatet=1 (2), cases with AggStatetp1 = 3 or 4 (1 or 2) are not calculated. *)
]; (* End of Sum *)


(* Expected marginal value of saving function \[GothicV](t)'(sRat(t)) used in model with idiosyncratic shocks *)
\[GothicV]KSHeteroIndP[sRatt_,AggStatet_,EmpStatet_,KRatt_,betapostp1_] := \[Beta]List[[BetaPostTemp]] (* \[Beta]List[[betapostp1]] *) Sum[
      AggStatetp1 = AggStatetp1Loop;                                     (* AggState(t+1) *)
      EmpStatetp1 = EmpStatetp1Loop-1;                                   (* EmpState(t+1), 0 or 1 *)
      ThetaVec     = {{etValsByAggEmpState[[AggStatetp1, 1]]},etValsByAggEmpState[[AggStatetp1, 2]] ThetaVecOrig};
      ThetaVecProb = {{EmpStateTransitionMatrix[[AggStatetp1,EmpStatet+1,1]] },EmpStateTransitionMatrix[[AggStatetp1,EmpStatet+1,2]]  ThetaVecProbOrig};

      KLevt       = KRatt AdjustedLByAggState[[AggStatet]];
      KRattp1     = Exp[kAR1ByAggState[[AggStatetp1]].{1,Log[KLevt]}]/AdjustedLByAggState[[AggStatetp1]]; 
                                                                         (* KRat(t+1) *)
      RE          = (1-\[Delta]+FP[KRattp1]) /(1-ProbOfDeath);           (* Effective interest rate *)

      Sum[PsiVecPostp1   = PsiVecPosLoop;
          ThetaVecPostp1 = ThetaVecPosLoop;
          Gtp1           = GrowthByAggState[[AggStatetp1]] ;             (* G(t+1) *) 
          kRattp1        = sRatt/(Gtp1 PsiVec[[PsiVecPostp1]]);          (* kRat(t+1) *)
          Thetatp1       = ThetaVec[[EmpStatetp1+1,ThetaVecPostp1]];     (* Theta(t+1) *)
          mRattp1        = RE kRattp1 + (wFunc[KRattp1]/LLevelByAggState[[AggStatetp1]]) Thetatp1;
                                                                         (* mRat(t+1) *)
          AggStateTransitionMatrix[[AggStatet,AggStatetp1]] PsiVecProb[[PsiVecPostp1]] ThetaVecProb[[EmpStatetp1+1,ThetaVecPostp1]] RE uP[(Gtp1 PsiVec[[PsiVecPostp1]]) cInterpFuncList[[betapostp1]][[AggStatetp1,EmpStatetp1+1]][mRattp1,KRattp1]],

          {ThetaVecPosLoop,Length[ThetaVec[[EmpStatetp1+1]]]},
          {PsiVecPosLoop,Length[PsiVec]}
          ],

      {EmpStatetp1Loop,NumOfEmpStates},
      {AggStatetp1Loop, 2 t[AggStatet]+1, 2 t[AggStatet] +2} 
         (* This loop for AggStatetp1 speeds up the solution; when AggStatet=1 (2), cases with AggStatetp1 = 3 or 4 (1 or 2) are not calculated. *)
]; (* End of Sum *)

(* t[] is a function whic gives 0 with input 1 or 4, and 1 with input 2 or 3. This is used in \[GothicV]IndP[]. *)
(* t[x_] := 1- Mod[Mod[x, 3], 2]; *)
t[1] = 0; t[2] = 1; t[3] = 1; t[4] = 0; 