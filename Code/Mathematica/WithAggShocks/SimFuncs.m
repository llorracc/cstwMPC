(* SimFuncs.m *)
(* This file constructs functions and routines used in simulations *)

(*       
Letter cases:
Lower - Variable that keeps track of experiences of simulated individuals
Upper - Variable that keeps track of population mean or aggregate experiences
Suffix: 
Lev - Variable that has not been normalized
Rat - Variable that has been normalized

e.g.
cLev - level of individual consumption
CRat - Normalized aggregate consumption 
*)

<< Combinatorica`;

(* "SimulateKSRepAgent" runs simulation with representative agent model with aggregate shocks *) 
SimulateKSRepAgent := Block[{},
  (* First period *)
  KRat     = {InitialCapital};
  MRat     = {(1-\[Delta]) KRat[[1]] + F[KRat[[1]]]};
  CRat     = {cInterpFunc[MRat[[1]],AggState[[1]],1]};
   
  (* 2nd period and thereafter *)
  Periodt = 2;
  Do[SimulateAnotherPeriodRep, {PeriodsToSimulate-1}];

  (* Display business cycle statistics *)
  KLev = KRat AdjustedLByAggState[[AggState]];
  CalcAggStatsKS; 
]; (* SimulateKSRepAgent *) 

(* "SimulateAnotherPeriodRep" simulates the rep model one more period *)
SimulateAnotherPeriodRep := Block[{},
  AppendTo[KRat, (MRat[[Periodt-1]] - CRat[[Periodt-1]])/GrowthByAggState[[AggState[[Periodt]]]]];
  AppendTo[MRat, (1-\[Delta]) KRat[[Periodt]] + F[KRat[[Periodt]]]];
  AppendTo[CRat, cInterpFunc[MRat[[Periodt]],AggState[[Periodt]],1]];
  Periodt = Periodt+1
]; (* End SimulateAnotherPeriodRep *)

(* "AggStateSetup" sets up agg state list *)
AggStateSetup      := Block[{},
  AggState      = Table[0,{PeriodsToSimulate}];
  AggState[[1]] = 1; (* Aggregate state is 1 in first period *)
  For[Periodt  =  2,
      Periodt <= PeriodsToSimulate,
      AggState[[Periodt]] = DrawAggState[AggState[[Periodt-1]]]; 
      Periodt = Periodt+1;
      ]; (* End Periodt loop *)
]; (* End AggStateSetup *)  

(* Function to give aggregate state in simulation *)
DrawAggState[AggStatetm1_] := FirstElementGreaterThan[CumAggStateTransitionMatrix[[AggStatetm1]],Random[]];


(* "SimulateKSInd" runs simulation of model with individuals and idiosyncratic shocks (KS, KSHetero, Point, Dist) *) 
SimulateKSInd     := Block[{},
(*
  If[Print[" Simulating..."]];  
*)

  StartSimulation = SessionTime[]; 

  (* Set up lists *)   
  <<MakeShocksDiscreteGrid.m; (* Set up ThetaDrawList, using MakeShocksDiscreteGrid.m *)
  If[Estimatet==1 && RunModelt == 1 (* If in the first iteration of the first estimation (of agg process) *), 

     kRatt  = InitialCapital Table[1,{NumPeopleToSim}]; 
     If[ModelType == Dist, 
        PeriodsToSimulateOrig = PeriodsToSimulate;  (* Save *)
        PeriodsToUseOrig      = PeriodsToUse;       (* Save *)
        PeriodsToSimulate     = 10000;
        PeriodsToUse          = Round[(1/3) PeriodsToSimulate];   (* Periods to use in estimation *)
        AggState              = Take[AggStatecstCode, PeriodsToSimulate];
        Print[" Produce initial distribution of capital income ratio"];
        SimulateKSIndIntGuess;
        kRatt = Flatten[
                 Table[MeankRatByType[[i]] 
                  Table[1, {Round[NumPeopleToSim/NumOfApproxPoints]}], 
                       {i, 1, NumOfApproxPoints}]]; 
        PeriodsToSimulate     = PeriodsToSimulateOrig;                  (* Recover original value *)
        PeriodsToUse          = PeriodsToUseOrig;                       (* Recover original value *)
        AggState              = Take[AggStatecstCode, PeriodsToSimulate];(* Recover original AggState *)
        ]; (* Calculate average capital inncome ratio by type *)

(*
       Print[" Finished producing initial distribution of capital income ratio"];
*)

     Pt = Table[1,{NumPeopleToSim}]; 
     If[ModelType == Dist, Pt = PtSSDist]; (* If in the first iteration of the first estimation. After that, use Pt at the end of the prev iteration. *)
     Psit   = Table[1,{NumPeopleToSim}];   (* Psi shock (permanent shock). For KS, KSHetero, this list does not change over time. *) 

     (* List of patient indicator *)
     If[Estimatet==1  (* If in the first iteration *) && (ModelType == KS || ModelType == Point),
        PatientIndicatorList = Table[PatientIndicator,{NumPeopleToSim}]; (* All the consumers are patient when model is KS or Point. *)
        ]; (* End If *)

     If[Estimatet==1 && ModelType == KSHetero,
        PatientIndicatorList = Flatten[{Table[1, {0.1 NumPeopleToSim}], 
                                        Table[2, {0.8 NumPeopleToSim}], 
                                        Table[3, {0.1 NumPeopleToSim}]}]
        ]; (* End If *)

     If[Estimatet==1 && ModelType == Dist,
        PatientIndicatorList = Flatten[Table[
          Table[i, {Round[NumPeopleToSim/NumOfApproxPoints]}], {i, 1,NumOfApproxPoints}]];
        ]; (* End If *)


        ]; (* Second iteration and thereafter, kRatt, Pt, PatientIndicatorList are those in the final iteration in previous estimation *)


  (* Replicate lists (now the size of sim is larger) *)
  If[Estimatet == TimesToEstimateSmall+1 && (ModelType == KSHetero || ModelType == Point),
     NumPeopleToSimOrig    = NumPeopleToSim;
     NumPeopleToSim        = NumPeopleToSimLarge;

     PatientIndicatorList = Flatten[Table[PatientIndicatorList, {NumPeopleToSim/NumPeopleToSimOrig}]]; (* Replicate PatientIndicatorList *)
     kRatt                = Flatten[Table[kRatt, {NumPeopleToSim/NumPeopleToSimOrig}]]; (* Replicate kRatt *)
     Pt                   = Flatten[Table[Pt,    {NumPeopleToSim/NumPeopleToSimOrig}]]; (* Replicate Pt *)
     Psit                 = Table[1,{NumPeopleToSim}]; (* Psi shock (permanent shock). *) 
     ]; (* End If *)
 
  If[Estimatet == TimesToEstimateSmall+1 && ModelType == Dist,

     NumPeopleToSimOrig    = NumPeopleToSim;
     NumPeopleToSim        = NumPeopleToSimLarge;

     PatientIndicatorList = Flatten[Table[
       Table[i, {Round[NumPeopleToSim/NumOfApproxPoints]}], {i, 1,NumOfApproxPoints}]];

     kRatt = Flatten[Table[
       Table[Take[kRatt, {Round[NumPeopleToSimOrig/NumOfApproxPoints] (i - 1) + 1, Round[NumPeopleToSimOrig/NumOfApproxPoints] i}], 
        {NumPeopleToSim/NumPeopleToSimOrig}], {i, 1, NumOfApproxPoints}]];

     Pt = Flatten[Table[
       Table[Take[Pt, {Round[NumPeopleToSimOrig/NumOfApproxPoints] (i - 1) + 1, Round[NumPeopleToSimOrig/NumOfApproxPoints] i}], 
        {NumPeopleToSim/NumPeopleToSimOrig}], {i, 1, NumOfApproxPoints}]];

    Psit   = Table[1,{NumPeopleToSim}]; (* Psi shock (permanent shock). *) 

    ]; (* End If *)  

  (* First period *)
  If[(ModelType == KSHetero || ModelType == Dist) && Estimatet  > TimesToEstimateSmall+1 && TimesToEstimateSmall > 3, 
     Print[" Simulating period 1"]]; (* TimesToEstimateSmall > 3 is NOT to print when estimating parameters using a smaller simulation. *) 
  KRat = {(kRatt.Pt)/Length[kRatt]};

  (* Distribution of wealth (capital) *)
  kLevtsorted     = Sort[kRatt Pt AdjustedLByAggState[[AggState[[1]]]]]; (* Sort by k level *)
  kLevtsortedSum  = Total[kLevtsorted];
  kLevtsortedMean = kLevtsortedSum/NumPeopleToSim;
  DumBetween05And15t  =  Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];

  GiniCoeff     = {(2/(NumPeopleToSim^2 kLevtsortedMean)) (Table[i,{i,1,NumPeopleToSim}].(kLevtsorted-kLevtsortedMean))};
  kLevtsorted        = Reverse[kLevtsorted];
  kLevTop1Percent    = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.01]}]]/kLevtsortedSum};
  kLevTop5Percent    = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.05]}]]/kLevtsortedSum};
  kLevTop10Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.10]}]]/kLevtsortedSum};
  kLevTop20Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.20]}]]/kLevtsortedSum};
  kLevTop25Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.25]}]]/kLevtsortedSum};
  kLevTop40Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.40]}]]/kLevtsortedSum};
  kLevTop50Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.50]}]]/kLevtsortedSum};
  kLevTop60Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.60]}]]/kLevtsortedSum};
  kLevTop80Percent   = {Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.80]}]]/kLevtsortedSum};
  FracBetween05And15 = {Total[DumBetween05And15t]/NumPeopleToSim};



 (* Calculate cRatt *)
  EmpStatet = RandomPermutation[Join[Table[0,{Round[NumPeopleToSim ug]}],Table[1,{NumPeopleToSim - Round[NumPeopleToSim ug]}]]]; (* EmpState is 0 (unemployed) or 1 (employed). In the first period the agg state is good. *)
  Thetat = Flatten[Table[RandomPermutation[ThetaVecOrig ], {NumPeopleToSim/Length[ThetaVecOrig ]}]];
  Xit    = (EmpStatet Thetat + (1-EmpStatet)) etValsByAggEmpState[[AggState[[1]],EmpStatet+1]];
  yRatt  = (-\[Delta]+FP[KRat[[1]]]) kRatt + (wFunc[KRat[[1]]]/LLevelByAggState[[AggState[[1]]]]) Xit;
  mRatt  = kRatt + yRatt;
  cRatt  = Table[KSIndcFunc[mRatt[[i]],AggState[[1]],EmpStatet[[i]],KRat[[1]],PatientIndicatorList[[i]]],{i,1,NumPeopleToSim}];

  mRatMedian      = {Median[mRatt AdjustedLByAggState[[AggState[[1]]]]]};
  DummRatBelow20t = Map[If[# < 2 , 1, 0] &, mRatt AdjustedLByAggState[[AggState[[1]]]]];
  FracmRatBelow20  = {Total[DummRatBelow20t]/NumPeopleToSim};

  MRat       = {(mRatt.Pt)/Length[mRatt]};
  CRat       = {(cRatt.Pt)/Length[cRatt]};
  CLev       = {CRat[[1]] AdjustedLByAggState[[AggState[[1]]]]}; (* Aggregate consumption level *)

(*
  Print["period"];
  Print[1];
  Print["kRattMean"];
  Print[Total[kRatt]/Length[kRatt]];
  Print["PtMean"];
  Print[Total[Pt]/Length[Pt]];
  Print["KRat"];
  Print[KRat[[1]]];
  Print["CRat"];
  Print[CRat[[1]]];
*)

  (* Calculate MPC *)
  If[Estimatet  > TimesToEstimateSmall+1 && TimesToEstimateSmall > 3, 
  MPCt   = (Table[KSIndcFunc[mRatt[[i]]+d,AggState[[1]],EmpStatet[[i]],KRat[[1]],PatientIndicatorList[[i]]],{i,1,NumPeopleToSim}] - cRatt)/d;

  OrderingyLev    = Ordering[yRatt Pt];
  MPC             = {Mean[MPCt]};
  MPCtOrdered     = MPCt[[OrderingyLev]];
  MPCTop1Percent  = {Mean[Take[MPCtOrdered,NumPeopleToSim (-0.01)]]};
  MPCTop10Percent = {Mean[Take[MPCtOrdered,NumPeopleToSim (-0.10)]]};
  MPCTop20Percent = {Mean[Take[MPCtOrdered,NumPeopleToSim (-0.20)]]};
  MPCTop40Percent = {Mean[Take[MPCtOrdered,NumPeopleToSim (-0.40)]]};
  MPCTop60Percent = {Mean[Take[MPCtOrdered,NumPeopleToSim (-0.60)]]};

  MPCBottom40Percent = {Mean[Take[MPCtOrdered,NumPeopleToSim (0.40)]]};
  MPCBottom20Percent = {Mean[Take[MPCtOrdered,NumPeopleToSim (0.20)]]};

  MPCBottom3Quart = {Mean[Take[MPCtOrdered,NumPeopleToSim (3/4)]]};
  MPCBottomHalf   = {Mean[Take[MPCtOrdered,NumPeopleToSim (1/2)]]};
  MPCBottomQuart  = {Mean[Take[MPCtOrdered,NumPeopleToSim (1/4)]]};
  NumOfEmployed   = Total[EmpStatet];
  MPCEmp          = {MPCt.EmpStatet/NumOfEmployed}; 
  MPCUnemp        = {MPCt.(1-EmpStatet)/(NumPeopleToSim-NumOfEmployed)};

  OrderingkRat    = Ordering[kRatt];
  MPCtOrderedByk  = MPCt[[OrderingkRat]];

  MPCTop1PercentByk  = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.01)]]};
  MPCTop10PercentByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.10)]]};
  MPCTop20PercentByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.20)]]};
  MPCTop40PercentByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.40)]]};
  MPCTop60PercentByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.60)]]};

  MPCBottom40PercentByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (0.40)]]};
  MPCBottom20PercentByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (0.20)]]};

  MPCBottom3QuartByk = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (3/4)]]};
  MPCBottomHalfByk   = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (1/2)]]};
  MPCBottomQuartByk  = {Mean[Take[MPCtOrderedByk,NumPeopleToSim (1/4)]]};

  ];

  sRatt           = mRatt- cRatt;
  sLevt           = sRatt Pt AdjustedLByAggState[[AggState[[1]]]]; 
  Clear[Xit, mRatt, cRatt, MPCt, MPCtOrdered];


  (* 2nd period and thereafter *)      
  Periodt = 2;

  TimeEmp2        = 0;
  TimeRenormalize = 0;
  TimecRatt       = 0; 
  TimeDist        = 0;

  Do[SimulateAnotherPeriodInd,{PeriodsToSimulate-1}];                          
  Clear[EmpStatet, sRatt];  


  KLev = KRat AdjustedLByAggState[[AggState]];

  (* Estimate and display agg process *)
  EstimateAR1;

  (* Calculate and display R^2 *)  
  CalculateRSquared;  

  (* Calculate and display agg statistics in JEDC project *)
  If[(Estimatet  > TimesToEstimateSmall+1 && GapCoeff <= MaxGapCoeff) 
    || TimesToEstimateSmall ==1 (* this is for SolveAndSimKS_experiments.m *)
    || (Estimatet == TimesToEstimateSmall + 2 && TimesToEstimateSmall <= 3), 
     CalcAggStatsKS];

  (* Calculate and display distribution of wealth (capital) *)
  If[  (ModelType == Point    && Estimatet > TimesToEstimateSmall+1) 
    || (ModelType == KSHetero && Estimatet > 1  (*  && Estimatet  > TimesToEstimateSmall+1 *) ) 
    || (ModelType == Dist     && Estimatet > 1  (*  && Estimatet  > TimesToEstimateSmall+1 *) ) 
    || (ModelType == KS       && Estimatet > TimesToEstimateSmall+1 && GapCoeff <= MaxGapCoeff),
     CalcDistStas];

  (* Calculate and display MPC *)
  If[Estimatet  > TimesToEstimateSmall+1 && GapCoeff <= MaxGapCoeff && TimesToEstimateSmall > 3, CalcMPC];
   (* The intention of TimesToEstimateSmall > 3 is NOT to show MPC when estimating parameters using a smaller simulation. *)          

  If[TimesToEstimateSmall > 3 || Estimatet  >= TimesToEstimateSmall, 
  Print[" Estimates of agg process, by good state and bad state: ", Flatten[{kAR1ByAggState[[1]],kAR1ByAggState[[3]]}]]
  ]; (* End if *)    

  If[TimesToEstimateSmall > 3 || Estimatet  >= TimesToEstimateSmall, 
     Print[" R^2 if good, R^2 if bad: ", {RSquaredg,RSquaredb}]]; 

  EndSimulation   = SessionTime[]; 
  If[(ModelType == KSHetero || ModelType == Dist) && TimesToEstimateSmall > 3, 
     Print[" Time spent to simulate (minutes): ", (EndSimulation - StartSimulation)/60]]; 


]; (* End SimulateKSInd *) 




(* "SimulateAnotherPeriodInd" simulates the model one more period *)
SimulateAnotherPeriodInd := Block[{},

  If[(ModelType == KSHetero || ModelType == Dist) && Estimatet  > TimesToEstimateSmall+1 && TimesToEstimateSmall > 3,
   If[Mod[Periodt, 500] == 0, Print[" Simulating period ", Periodt]]
  ];

  EmpStatetm1   = EmpStatet;
  Gt            = GrowthByAggState[[AggState[[Periodt]]]];

  (* Construct Deatht, Psit, Thetat when model is KS or KSHetero *)
  If[ModelType == KS || ModelType == KSHetero (* If model is KS *), 
     Deatht = Table[0,{NumPeopleToSim}]; (* no death *)

     ]; (* End If KS *)

  (* Construct Deatht, Psit, Thetat, if model is Point or Dist. "Ordering" (which gives a list of order) is necessary to avoid a case where only households with very high (low) sLev receive specific shocks. *)

  If[ModelType == Point (* If model is Point *),
     sLevtOrdering   = Ordering[sLevt] (* Calculate a list of order *)
     ]; (* End If Point *)

  If[ModelType == Dist (* If model is Dist *),     
     sLevtOrdering = 
     Flatten[Table[
       Ordering[
         Take[sLevt, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) (i - 1) + NumPeopleToSim/NumOfApproxPoints}]] + (NumPeopleToSim/NumOfApproxPoints) (i - 1), {i, 1, NumOfApproxPoints}]] (* Calculate a list of order. The list is ordered by \[Beta] *)
     ]; (* End If *)

If[ModelType == Point || ModelType == Dist, 

     (* Avoid a case where only households with very high (low) sLev die *)
     PickOnePerSubPop        = Table[Random[Integer, {1, 1/ProbOfDeath}] + 1/ProbOfDeath(i - 1), {i, NumPeopleToSim ProbOfDeath}];
     PosOfKilled             = sLevtOrdering[[PickOnePerSubPop]];
     Deatht                  = Table[0, {NumPeopleToSim}];
     Deatht[[PosOfKilled]]   = 1;

     (* Avoid a case where only households with very high (low) sLev receive high (low) perm / tran inc shocks *)
     PsitDrawList        = Flatten[Table[RandomPermutation[PsiVec], {Round[NumPeopleToSim/Length[PsiVec]]}]];
     Psit[[sLevtOrdering]] = PsitDrawList;

     ThetaDrawList       = Flatten[Table[RandomPermutation[ThetaVecOrig], {Round[NumPeopleToSim/Length[ThetaVecOrig]]}]];
     Thetat[[sLevtOrdering]] = ThetaDrawList;
 
     Clear[sLevtOrdering, PsitDrawList (* ,ThetaDrawList *)];
   ]; (* End If *)

  (* Construct EmpStatet if model is KS KSHetero or Point. 
  Following code does not generate deviations of # of the unemployed from the true values. The number of households (NumPeopleToSim) needs to be a multiple of 3,000 due to several tiny values in the transition matrix (EmpStateTransitionMatrix). *)
  If[ModelType == KS || ModelType == KSHetero ||ModelType == Point,
     NumOfEmployedtm1  = Total[EmpStatetm1];                (* # of employed in prev period *)  
     NumOfUmeployedtm1 = NumPeopleToSim - NumOfEmployedtm1; (* # of unemployed in prev period *)
     NumOfUnempFromUnemp = Round[NumOfUmeployedtm1 EmpStateTransitionMatrix[[AggState[[Periodt]], 1, 1]]]; (* # of unemployed in this period and prev period *)
     NumOfUnempFromEmp   = Round[NumOfEmployedtm1 EmpStateTransitionMatrix[[AggState[[Periodt]], 2, 1]]];  (* # of unemployed in this period but employed in prev period *)
     EmpStateDrawList    = Join[RandomPermutation[Join[Table[0, {NumOfUnempFromUnemp}], Table[1, {NumOfUmeployedtm1 - NumOfUnempFromUnemp}]]],
                                RandomPermutation[Join[Table[0, {NumOfUnempFromEmp}], Table[1, {NumOfEmployedtm1 - NumOfUnempFromEmp}]]]
                                ]; (* End of Join *)
     EmpStatetm1Ordering              = Ordering[EmpStatetm1]; (* List of order *)
     EmpStatet[[EmpStatetm1Ordering]] = EmpStateDrawList;      (* Reorder, using the list of order *)
     Clear[EmpStatetm1, EmpStateDrawList, EmpStatetm1Ordering];
     ]; (* End If *)

  (* Construct EmpStatet if model is Dist. *)
  If[ModelType == Dist,

     NumOfEmployedtm1      = Total[EmpStatetm1]; 
     NumOfUmeployedtm1     = NumPeopleToSim - NumOfEmployedtm1; 

     TimeEmp2S = SessionTime[];
(*
     RandomNumEmployed     = RandomPermutation[Table[(i - 1 + Random[])/NumOfEmployedtm1, {i, NumOfEmployedtm1}]];  (* Generate list of random # for the employed *)
     RandomNumUnemployed   = RandomPermutation[Table[(i - 1 + Random[])/NumOfUmeployedtm1, {i, NumOfUmeployedtm1}]]; (* Generate list of random # for the unemployed *)

     CounterEmployed     = 0;
     CounterUnemployed   = 0;
     EmpStatet = Table[If[EmpStatetm1[[i]]==1 (* employed *),
                    CounterEmployed=CounterEmployed+1; 
                    FirstElementGreaterThan[CumEmpStateTransitionMatrix[[AggState[[Periodt]],EmpStatetm1[[i]]+1]],RandomNumEmployed[[CounterEmployed]]] - 1,
                    CounterUnemployed=CounterUnemployed+1;
                    FirstElementGreaterThan[CumEmpStateTransitionMatrix[[AggState[[Periodt]],EmpStatetm1[[i]]+1]],RandomNumUnemployed[[CounterUnemployed]]] - 1
],
                    {i,1,NumPeopleToSim}]; (* Construct EmpStatet (list of emp states) using random # *)
*)

     RandomNumEmployed     = Table[(i - 1 + Random[])/NumOfEmployedtm1,  {i, NumOfEmployedtm1}];  (* Generate list of random # for the employed *)
     RandomNumUnemployed   = Table[(i - 1 + Random[])/NumOfUmeployedtm1, {i, NumOfUmeployedtm1}]; (* Generate list of random # for the unemployed *)

     NumOfUnemployedFrEmployed = FirstElementGreaterThan[RandomNumEmployed, CumEmpStateTransitionMatrix[[AggState[[Periodt]], 1 + 1]][[1]]] - 1;
     NumOfUnemployedFrUnemployed = FirstElementGreaterThan[RandomNumUnemployed, CumEmpStateTransitionMatrix[[AggState[[Periodt]], 0 + 1]][[1]]] - 1;

     EmpStatetm1Ordering = Ordering[EmpStatetm1];

     UnempPosEmployed   = Take[RandomPermutation[Take[EmpStatetm1Ordering, {-NumOfEmployedtm1, -1}]], {1, NumOfUnemployedFrEmployed}];
     UnempPosUnemployed = Take[RandomPermutation[Take[EmpStatetm1Ordering, {1, NumOfUmeployedtm1}]], {1, NumOfUnemployedFrUnemployed}];

     UnempPos              = Flatten[{UnempPosEmployed, UnempPosUnemployed}];
     EmpStatet             = Table[1, {NumPeopleToSim}];
     EmpStatet[[UnempPos]] = 0; (* Repalce with 0 if unemployed in this period *)

     TimeEmp2 = (SessionTime[]-TimeEmp2S) + TimeEmp2; 

(*
Print["# of unemployed: ", NumOfUnemployedFrEmployed + NumOfUnemployedFrUnemployed];
*)

     ]; (* End If *)

  Livet  = 1-Deatht;  

  (* Renormalize shocks. 
  In the population, death and unemployment are independent of permanent income, so permanent income for all four subgroups (dying or not, unemployed or not) should be 1.
  For a finite sample, this will not be exactly true.  Unless the simulated population is enormous, the aggregate will occasionally be noticeably disturbed by the death of a particularly wealthy individual.
  The following code fixes this problem by renormalizing the shocks to each subgroup (dying, living and unemployed, and living and employed) so that the group mean level of P is one. This would have no effect in an infinite sample, but substantially reduces the sample size necessary for the law of large numbers to smooth out the aggregate fluctuations that would otherwise result from the deaths of the wealthiest individuals. (Below, transitory income shoks are also normalized.) *)     
  If[ModelType == Point  || ModelType == Dist (* If model is Point or Dist *),

TimeRenormalizeS = SessionTime[];
   Ptm1   = Pt; 
   Pt     = Ptm1 Psit; (* At this point, do not calc correct Pt for deads *)

   EmpLiv       =    EmpStatet  Livet;
   UnempLiv     = (1-EmpStatet) Livet;

   NumEmpLiv    = Total[EmpLiv];
   NumUnempLiv  = Total[UnempLiv];
   NumDie       = Total[Deatht]; 

   PSumEmpLiv       = Pt.EmpLiv;
   PSumUnempLiv     = Pt.UnempLiv;
   ThetaSumEmpLiv   = Thetat.EmpLiv;
   ThetaSumUnempLiv = Thetat.UnempLiv;
   ThetaSumDie      = Thetat.Deatht;

   Pt           = Pt ( EmpLiv/(PSumEmpLiv/NumEmpLiv) + UnempLiv/(PSumUnempLiv/NumUnempLiv) ) + Deatht; (* Pt is 1, if dead *)
   Thetat       = Thetat ( EmpLiv/(ThetaSumEmpLiv/NumEmpLiv) + UnempLiv/(ThetaSumUnempLiv/NumUnempLiv) + Deatht/(ThetaSumDie/NumDie) );
   Psit         = Pt/Ptm1; (* I do not adjust Psit for deads, since they do not affect the calculation below. Psit = Psit Livet + Deatht; is correct Psit *) 
   Clear[EmpLiv, UnempLiv, Ptm1];
TimeRenormalize = (SessionTime[]-TimeRenormalizeS) + TimeRenormalize; 
  
  ]; (* End If *)

  (* Adjust kRatt so that mean of kLevt is equal to its expected value *)
  kLevtMeanPredicted   = Mean[sLevt];
  kLevtMean            = Mean[(sLevt Livet/(1-ProbOfDeath))];
  AdjustmentFactor     = kLevtMean/kLevtMeanPredicted;
  kRatt            = (sRatt/(Gt Psit (1-ProbOfDeath))) Livet/AdjustmentFactor; (* If dead, replaced by an unrelated newborn and kRatt = 0. *)
  Clear[Livet];

  AppendTo[KRat, (kRatt.Pt)/Length[kRatt]];

(*
If[Mod[Periodt, 100] == 1, 
  Print["period"];
  Print[Periodt];
  Print["kRattMean"];
  Print[Total[kRatt]/Length[kRatt]];
  Print["PtMean"];
  Print[Total[Pt]/Length[Pt]];
  Print["KRat"];
  Print[KRat[[Periodt]]]];
*)

  (* Distribution of wealth (capital) *)
  TimeDistS = SessionTime[]; 

  kLevtsorted        = Sort[kRatt Pt AdjustedLByAggState[[AggState[[Periodt]]]]];
  kLevtsortedSum     = Total[kLevtsorted];
  kLevtsortedMean    = kLevtsortedSum/NumPeopleToSim;
  DumBetween05And15t = Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];

  AppendTo[GiniCoeff, (2/(NumPeopleToSim^2 kLevtsortedMean)) (Table[i,{i,1,NumPeopleToSim}].(kLevtsorted-kLevtsortedMean))];
  kLevtsorted      = Reverse[kLevtsorted];
  AppendTo[kLevTop1Percent , Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.01]}]]/kLevtsortedSum];
  AppendTo[kLevTop5Percent , Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.05]}]]/kLevtsortedSum];
  AppendTo[kLevTop10Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.10]}]]/kLevtsortedSum];
  AppendTo[kLevTop20Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.20]}]]/kLevtsortedSum];
  AppendTo[kLevTop25Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.25]}]]/kLevtsortedSum];
  AppendTo[kLevTop40Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.40]}]]/kLevtsortedSum];
  AppendTo[kLevTop50Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.50]}]]/kLevtsortedSum];
  AppendTo[kLevTop60Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.60]}]]/kLevtsortedSum];
  AppendTo[kLevTop80Percent, Total[Take[kLevtsorted, {1, Round[NumPeopleToSim 0.80]}]]/kLevtsortedSum];
  AppendTo[FracBetween05And15, Total[DumBetween05And15t]/NumPeopleToSim];
  Clear[DumBetween05And15t];


  TimeDist = (SessionTime[]-TimeDistS) + TimeDist;

  (* Calculate cRatt *)
  RE    = (1-\[Delta]+FP[KRat[[Periodt]]]); 
  w     = wFunc[KRat[[Periodt]]]; (* This is not exactly wageRate (= w AdjustedLByAggState / LLevelByAggState) *)
  Xit   = (EmpStatet Thetat + (1-EmpStatet)) etValsByAggEmpState[[AggState[[Periodt]],EmpStatet+1]]; 
  yRatt = (RE-1) kRatt + (w/LLevelByAggState[[AggState[[Periodt]]]]) Xit;
  mRatt = kRatt + yRatt;

  Clear[(* Psit,*) Deatht (*,Thetat*)];

  If[ModelType == KS || ModelType == Point, (* If model is KS or Point *)
     EmpStatetOrdering = Ordering[EmpStatet]; 

     (* Variables are ordered by emp state. This helps to evaluate cRatt (below) using list mRatt (avoiding one by one evaluation). *)  
     EmpStatet = EmpStatet[[EmpStatetOrdering]];
     Pt        = Pt[[EmpStatetOrdering]]; 
     mRatt     = mRatt[[EmpStatetOrdering]];
     kRatt     = kRatt[[EmpStatetOrdering]];

     cRatt     = Join[cInterpFuncList[[AggState[[Periodt]],1]][Take[mRatt,Round[uList[[AggState[[Periodt]]]] NumPeopleToSim]], KRat[[Periodt]]], 
                      cInterpFuncList[[AggState[[Periodt]],2]][Take[mRatt,-Round[(1-uList[[AggState[[Periodt]]]]) NumPeopleToSim]], KRat[[Periodt]]]]; (* Use cInterpFuncList (not KSIndcFunc[]) to speed up. To use cInterpFuncList, Ordering is necessary. *)

     (* Calculate MPC *)
     If[Estimatet  > TimesToEstimateSmall+1 && TimesToEstimateSmall > 3, 
     MPCt      = (Join[cInterpFuncList[[AggState[[Periodt]],1]][Take[mRatt+d,Round[uList[[AggState[[Periodt]]]] NumPeopleToSim]], KRat[[Periodt]]], 
                       cInterpFuncList[[AggState[[Periodt]],2]][Take[mRatt+d,-Round[(1-uList[[AggState[[Periodt]]]]) NumPeopleToSim]], KRat[[Periodt]]]] 
                  - cRatt)/d;
     ]; (* End If *)

     ]; (* End If *)


  (* Update PatientIndicatorList for KSHetero *)   
  If[ModelType == KSHetero, 
  PatientIndicatorListOrdering = Ordering[PatientIndicatorList];
  DrawAt1 = 
    RandomPermutation[
     Flatten[{Table[2 , {p12 0.1 NumPeopleToSim}], 
       Table[1 , {(1 - p12) 0.1 NumPeopleToSim}]}]];
  DrawAt2 = 
    RandomPermutation[Flatten[{Table[1 , {p21 0.8 NumPeopleToSim}],
       Table[2 , {(1 - p21 - p23) 0.8 NumPeopleToSim}],
       Table[3 , {p23 0.8 NumPeopleToSim}]}]];
  DrawAt3 = 
    RandomPermutation[
     Flatten[{Table[2 , {p32 0.1 NumPeopleToSim}], 
       Table[3 , {(1 - p32) 0.1 NumPeopleToSim}]}]];
  DrawList = Flatten[{DrawAt1, DrawAt2, DrawAt3}];
  PatientIndicatorList[[PatientIndicatorListOrdering]] = DrawList;
       ]; (* End If *)

  If[ModelType == KSHetero || ModelType == Dist, 

     TimecRattS = SessionTime[];

     cRatt = Table[KSIndcFunc[mRatt[[i]],AggState[[Periodt]],EmpStatet[[i]],KRat[[Periodt]],PatientIndicatorList[[i]]],{i,1,NumPeopleToSim}]; (* Unlike KS or Point case, cRatt is evaluated one by one. In principle, it is possible evaluate cRatt (below) using list mRatt (as done in KS or Point case), but that substantially complicates the codes. *)

     TimecRatt = (SessionTime[] - TimecRattS) + TimecRatt;

     (* Calculate MPC *)
     If[Estimatet  > TimesToEstimateSmall+1 && TimesToEstimateSmall > 3, 
     MPCt  = (Table[KSIndcFunc[mRatt[[i]]+d,AggState[[Periodt]],EmpStatet[[i]],KRat[[Periodt]],PatientIndicatorList[[i]]],{i,1,NumPeopleToSim}]-cRatt)/d;
     ]; (* End If *)

     ]; (* End If *)
                           
  AppendTo[MRat,    (mRatt.Pt)/Length[mRatt]];
  AppendTo[mRatMedian,    Median[mRatt AdjustedLByAggState[[AggState[[Periodt]]]]]];
  DummRatBelow20t = Map[If[# < 2, 1, 0] &,  mRatt AdjustedLByAggState[[AggState[[Periodt]]]]];
  AppendTo[FracmRatBelow20, Total[DummRatBelow20t]/NumPeopleToSim]; 

  AppendTo[CRat, (cRatt.Pt)/Length[cRatt]];

  (* MPC *)
  If[Estimatet  > TimesToEstimateSmall+1 && TimesToEstimateSmall > 3, 
  OrderingyLev    = Ordering[yRatt Pt]; (* Order of yLev, for later use *)
  AppendTo[MPC,     Mean[MPCt]];
  MPCtOrdered     = MPCt[[OrderingyLev]]; (* OrderingyLev is calculated above *)

  AppendTo[MPCTop1Percent,  Mean[Take[MPCtOrdered,NumPeopleToSim (-0.01)]]];
  AppendTo[MPCTop10Percent, Mean[Take[MPCtOrdered,NumPeopleToSim (-0.10)]]];
  AppendTo[MPCTop20Percent, Mean[Take[MPCtOrdered,NumPeopleToSim (-0.20)]]];
  AppendTo[MPCTop40Percent, Mean[Take[MPCtOrdered,NumPeopleToSim (-0.40)]]];
  AppendTo[MPCTop60Percent, Mean[Take[MPCtOrdered,NumPeopleToSim (-0.60)]]];

  AppendTo[MPCBottom40Percent, Mean[Take[MPCtOrdered,NumPeopleToSim (0.40)]]];
  AppendTo[MPCBottom20Percent, Mean[Take[MPCtOrdered,NumPeopleToSim (0.20)]]];

  AppendTo[MPCBottom3Quart, Mean[Take[MPCtOrdered,NumPeopleToSim (3/4)]]];
  AppendTo[MPCBottomHalf,   Mean[Take[MPCtOrdered,NumPeopleToSim (1/2)]]];
  AppendTo[MPCBottomQuart,  Mean[Take[MPCtOrdered,NumPeopleToSim (1/4)]]];

  NumOfEmployed   = Total[EmpStatet];
  AppendTo[MPCEmp,   MPCt.EmpStatet/NumOfEmployed];
  AppendTo[MPCUnemp, MPCt.(1-EmpStatet)/(NumPeopleToSim-NumOfEmployed)];

  OrderingkRat    = Ordering[kRatt];
  MPCtOrderedByk  = MPCt[[OrderingkRat]];

  AppendTo[MPCTop1PercentByk,  Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.01)]]];
  AppendTo[MPCTop10PercentByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.10)]]];
  AppendTo[MPCTop20PercentByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.20)]]];
  AppendTo[MPCTop40PercentByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.40)]]];
  AppendTo[MPCTop60PercentByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (-0.60)]]];

  AppendTo[MPCBottom40PercentByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (0.40)]]];
  AppendTo[MPCBottom20PercentByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (0.20)]]];

  AppendTo[MPCBottom3QuartByk, Mean[Take[MPCtOrderedByk,NumPeopleToSim (3/4)]]];
  AppendTo[MPCBottomHalfByk,   Mean[Take[MPCtOrderedByk,NumPeopleToSim (1/2)]]];
  AppendTo[MPCBottomQuartByk,  Mean[Take[MPCtOrderedByk,NumPeopleToSim (1/4)]]];

  ]; (* End If *)


  If[Periodt < PeriodsToSimulate, 
     Clear[kRatt]
     ];  

  sRatt = mRatt- cRatt; (* End of period assets *)
  sLevt = sRatt Pt AdjustedLByAggState[[AggState[[Periodt]]]];

  (* export mRatt *)
  If[Periodt == PeriodsToSimulate, 
     Export["mRatt.txt", mRatt, "Table"]
     ];

  (* export PatientIndicatorList if model is hetero *)
  If[Periodt == PeriodsToSimulate  (* if in the last period *), 
    If[ModelType == KSHetero  (* if hetero model  *),  
       Export["PatientIndicatorListKSHetero.txt", PatientIndicatorList, "Table"]; 
       ] 
     ]; (* End if Periodt == PeriodsToSimulate *)

  (* run CalcDistributionsByType (calculates various distribuitons by (impatience) type) *)
  If[Periodt == PeriodsToSimulate  (* if in the last period *), 
    If[ModelType == Dist && NumOfApproxPoints == 7 (* if dist model. run  CalcDistributionsByType if model is dist *),  
       CalcDistributionsByType; 
       ] (* End If ModelType == Dist && NumOfApproxPoints == 7 *)
     ]; (* End if Periodt == PeriodsToSimulate *)


  Clear[Xit, mRatt, cRatt, MPCtOrdered ];

Periodt = Periodt+1]; (* End SimulateAnotherPeriodInd *)



(* "CalcDistributionsByType" calculates various distribuitons by (impatience) type, in order to address ref comment from Quantitative Economics. *) 
CalcDistributionsByType := Block[{},
 
       DumMostImpatientList = Map[If[# == 7, 1, 0] &, PatientIndicatorList]; (* 7 is most impatient *)
       Dum2ndImpatientList  = Map[If[# == 6, 1, 0] &, PatientIndicatorList];
       Dum3rdImpatientList  = Map[If[# == 5, 1, 0] &, PatientIndicatorList];
       Dum4thImpatientList  = Map[If[# == 4, 1, 0] &, PatientIndicatorList];
       Dum5thImpatientList  = Map[If[# == 3, 1, 0] &, PatientIndicatorList];
       Dum6thImpatientList  = Map[If[# == 2, 1, 0] &, PatientIndicatorList];
       Dum7thImpatientList  = Map[If[# == 1, 1, 0] &, PatientIndicatorList]; (* 1 is most patient *)

       (* using consumption ratio to income *) 
       cRatBot20PctThreshold = Sort[cRatt][[0.2 Length[cRatt]]];
(*
       Print["consumption income ratio bottom 20 pct threshold"];
       Print[cRatBot20PctThreshold/w]; 
*)
       DumcRattBot20PctList = Map[If[# <= cRatBot20PctThreshold, 1, 0] &, cRatt]; (* dum if cRat is in the bottom 20%*)
     
       (* share of most impatient in the bottom 20% of the consumption (ratio) distribution *)
       ShareMostImpatientIncRatBot20Pct = Round[Total[DumcRattBot20PctList DumMostImpatientList]/Total[DumcRattBot20PctList]*100];
       Share2ndImpatientIncRatBot20Pct =  Round[Total[DumcRattBot20PctList Dum2ndImpatientList]/Total[DumcRattBot20PctList]*100];  
       Share3rdImpatientIncRatBot20Pct = Round[Total[DumcRattBot20PctList Dum3rdImpatientList]/Total[DumcRattBot20PctList]*100];
       Share4thImpatientIncRatBot20Pct = Round[Total[DumcRattBot20PctList Dum4thImpatientList]/Total[DumcRattBot20PctList]*100];
       Share5thImpatientIncRatBot20Pct = Round[Total[DumcRattBot20PctList Dum5thImpatientList]/Total[DumcRattBot20PctList]*100];
       Share6thImpatientIncRatBot20Pct = Round[Total[DumcRattBot20PctList Dum6thImpatientList]/Total[DumcRattBot20PctList]*100];
       Share7thImpatientIncRatBot20Pct = Round[Total[DumcRattBot20PctList Dum7thImpatientList]/Total[DumcRattBot20PctList]*100];
  
       (* fraction of most impatient whose consumption ratio (to income) is in the bottom 20% of the distribution *)
       FracMostImpatientcRatInBot20Pct = Round[Total[DumcRattBot20PctList DumMostImpatientList]/Total[DumMostImpatientList]*100];
       Frac2ndImpatientcRatInBot20Pct =  Round[Total[DumcRattBot20PctList Dum2ndImpatientList]/Total[Dum2ndImpatientList]*100];
       Frac3rdImpatientcRatInBot20Pct =  Round[Total[DumcRattBot20PctList Dum3rdImpatientList]/Total[Dum3rdImpatientList]*100] ;
       Frac4thImpatientcRatInBot20Pct =  Round[Total[DumcRattBot20PctList Dum4thImpatientList]/Total[Dum4thImpatientList]*100] ;
       Frac5thImpatientcRatInBot20Pct =  Round[Total[DumcRattBot20PctList Dum5thImpatientList]/Total[Dum5thImpatientList]*100] ;
       Frac6thImpatientcRatInBot20Pct =  Round[Total[DumcRattBot20PctList Dum6thImpatientList]/Total[Dum6thImpatientList]*100] ;
       Frac7thImpatientcRatInBot20Pct =  Round[Total[DumcRattBot20PctList Dum7thImpatientList]/Total[Dum7thImpatientList]*100] ;

       (* average cRatt *)
       AveragecRattMostImpatient = cRatt.DumMostImpatientList/Total[DumMostImpatientList]/w; 
       AveragecRatt2ndImpatient  = cRatt.Dum2ndImpatientList/Total[Dum2ndImpatientList]/w; 
       AveragecRatt3rdImpatient  = cRatt.Dum3rdImpatientList/Total[Dum3rdImpatientList]/w; 
       AveragecRatt4thImpatient  = cRatt.Dum4thImpatientList/Total[Dum4thImpatientList]/w; 
       AveragecRatt5thImpatient  = cRatt.Dum5thImpatientList/Total[Dum5thImpatientList]/w; 
       AveragecRatt6thImpatient  = cRatt.Dum6thImpatientList/Total[Dum6thImpatientList]/w; 
       AveragecRatt7thImpatient  = cRatt.Dum7thImpatientList/Total[Dum7thImpatientList]/w; 

       (* average kRatt *)
       AveragekRattMostImpatient = kRatt.DumMostImpatientList/Total[DumMostImpatientList]/w; 
       AveragekRatt2ndImpatient  = kRatt.Dum2ndImpatientList/Total[Dum2ndImpatientList]/w; 
       AveragekRatt3rdImpatient  = kRatt.Dum3rdImpatientList/Total[Dum3rdImpatientList]/w; 
       AveragekRatt4thImpatient  = kRatt.Dum4thImpatientList/Total[Dum4thImpatientList]/w; 
       AveragekRatt5thImpatient  = kRatt.Dum5thImpatientList/Total[Dum5thImpatientList]/w; 
       AveragekRatt6thImpatient  = kRatt.Dum6thImpatientList/Total[Dum6thImpatientList]/w; 
       AveragekRatt7thImpatient  = kRatt.Dum7thImpatientList/Total[Dum7thImpatientList]/w; 

       (* using consumption level *)
       cLevt=cRatt Pt AdjustedLByAggState[[AggState[[Periodt]]]]; 
       cLevBot20PctThreshold = Sort[cLevt][[0.2 Length[cLevt]]];
(*
       Print["consumption bottom 20 pct threshold"];
       Print[cLevBot20PctThreshold];  
*)
       DumcLevtBot20PctList = Map[If[# <= cLevBot20PctThreshold, 1, 0] &, cLevt]; (* dum if cLev is in the bottom 20%*)

 
       (* share of most impatient in the bottom 20% of the consumption distribution *)
       ShareMostImpatientIncLevBot20Pct = Round[Total[DumcLevtBot20PctList DumMostImpatientList]/Total[DumcLevtBot20PctList]*100];  
       Share2ndImpatientIncLevBot20Pct =  Round[Total[DumcLevtBot20PctList Dum2ndImpatientList]/Total[DumcLevtBot20PctList]*100];  
       Share3rdImpatientIncLevBot20Pct = Round[Total[DumcLevtBot20PctList Dum3rdImpatientList]/Total[DumcLevtBot20PctList]*100];
       Share4thImpatientIncLevBot20Pct = Round[Total[DumcLevtBot20PctList Dum4thImpatientList]/Total[DumcLevtBot20PctList]*100];
       Share5thImpatientIncLevBot20Pct = Round[Total[DumcLevtBot20PctList Dum5thImpatientList]/Total[DumcLevtBot20PctList]*100];
       Share6thImpatientIncLevBot20Pct = Round[Total[DumcLevtBot20PctList Dum6thImpatientList]/Total[DumcLevtBot20PctList]*100];
       Share7thImpatientIncLevBot20Pct = Round[Total[DumcLevtBot20PctList Dum7thImpatientList]/Total[DumcLevtBot20PctList]*100];
  
       (* fraction of most impatient whose consumption level is in the bottom 20% of the distribution *)
       FracMostImpatientcLevInBot20Pct = Round[Total[DumcLevtBot20PctList DumMostImpatientList]/Total[DumMostImpatientList]*100];
       Frac2ndImpatientcLevInBot20Pct =  Round[Total[DumcLevtBot20PctList Dum2ndImpatientList]/Total[Dum2ndImpatientList]*100];
       Frac3rdImpatientcLevInBot20Pct =  Round[Total[DumcLevtBot20PctList Dum3rdImpatientList]/Total[Dum3rdImpatientList]*100] ;
       Frac4thImpatientcLevInBot20Pct =  Round[Total[DumcLevtBot20PctList Dum4thImpatientList]/Total[Dum4thImpatientList]*100] ;
       Frac5thImpatientcLevInBot20Pct =  Round[Total[DumcLevtBot20PctList Dum5thImpatientList]/Total[Dum5thImpatientList]*100] ;
       Frac6thImpatientcLevInBot20Pct =  Round[Total[DumcLevtBot20PctList Dum6thImpatientList]/Total[Dum6thImpatientList]*100] ;
       Frac7thImpatientcLevInBot20Pct =  Round[Total[DumcLevtBot20PctList Dum7thImpatientList]/Total[Dum7thImpatientList]*100] ;


       (* export data for analysis *)
       Export["PatientIndicatorList.txt", PatientIndicatorList, "Table"]; 
       Export["cRattNormalizedByw.txt", cRatt/w, "Table"];
       Export["kRattNormalizedByw.txt", kRatt/w, "Table"];
       Export["mRattNormalizedByw.txt", mRatt/w, "Table"];
       Export["cLevt.txt", cLevt, "Table"];

       Clear[cLevt]
  
];  (* End Block CalcDistributionsByType *)
 

(* "CalcAggStatsKS" calculates and display (agg) statistics *)
CalcAggStatsKS := Block[{},

   (* Gen agg (level) vars *)
   MLev = MRat AdjustedLByAggState[[AggState]];
   YLev = MLev - (1-\[Delta]) KLev;
   CLev = CRat AdjustedLByAggState[[AggState]];
   ILev = YLev - CLev;

   (* Take variables for later use *)
   RUsed        = Take[FP[KRat], -PeriodsToUse];
   KLevUsedt    = Take[KLev,     -PeriodsToUse];
   YLevUsed     = Take[YLev,     -PeriodsToUse];

   CLevUsed     = Take[CLev,     -PeriodsToUse];
   ILevUsed     = Take[ILev , -PeriodsToUse];

   dlCLevUsed   =  Drop[Log[Take[CLev , -PeriodsToUse]], 1] - Drop[Log[Take[CLev , -PeriodsToUse]], -1];
   dlYLevUsed   =  Drop[Log[Take[YLev , -PeriodsToUse]], 1] - Drop[Log[Take[YLev , -PeriodsToUse]], -1];
   d4lCLevUsed   =  Drop[Log[Take[CLev , -PeriodsToUse]], {1,4}] - Drop[Log[Take[CLev , -PeriodsToUse]], {-4,-1}];
   d4lYLevUsed   =  Drop[Log[Take[YLev , -PeriodsToUse]], {1,4}] - Drop[Log[Take[YLev , -PeriodsToUse]], {-4,-1}];
   d8lCLevUsed   =  Drop[Log[Take[CLev , -PeriodsToUse]], {1,8}] - Drop[Log[Take[CLev , -PeriodsToUse]], {-8,-1}];
   d8lYLevUsed   =  Drop[Log[Take[YLev , -PeriodsToUse]], {1,8}] - Drop[Log[Take[YLev , -PeriodsToUse]], {-8,-1}];

   (* Calculate stats *)
   (* Calculate and show variances of income shocks implied by KS *)
   If[(ModelType == KS || ModelType == Point) && Estimatet > 1 && Rep == False,

     w            = wFunc[KRat] AdjustedLByAggState[[AggState]]/LLevelByAggState[[AggState]]; 
     

     IntervalUsedToCalcVar = 5; (* Interval to calculate lny(t)-lny(y-d) *)

     (* Below is used if a set of obs is dropped if the min inc is less than 20 percent of the average during the 7-year period *)

     EmpStateList = {1};
     For[periodt = 2, periodt <= Length[AggState], 
       AppendTo[EmpStateList, 
        FirstElementGreaterThan[
          CumEmpStateTransitionMatrix[[AggState[[periodt]], 
            EmpStateList[[periodt - 1]] + 1]], Random[]] - 1];
       periodt++];

     PList = Table[1, {Length[AggState]}];
     If[ModelType == KS ,  ThetaList = Table[1, {Length[AggState]}]]; 
     If[ModelType == Point, 
        PsiList     = RandomPermutation[Flatten[Table[PsiVec, {Length[AggState]/Length[PsiVec]}]]];
        ThetaList = RandomPermutation[Flatten[Table[ThetaVecOrig, {Length[AggState]/Length[ThetaVecOrig ]}]]];
        For[periodt = 2, periodt <= Length[AggState], 
            PList[[periodt]] = PList[[periodt-1]] PsiList[[periodt]]; 
            periodt++]
        ]; 

     WageList = Take[PList (EmpStateList ThetaList + (1-EmpStateList)) w Table[etValsByAggEmpState[[AggState[[i]] ,EmpStateList[[i]]+1]], {i,1, Length[AggState]}], -PeriodsToUse];
     WageList = Table[Total[Take[WageList, {(i - 1)*4 + 1, (i - 1)*4 + 4}]]/4, {i, Length[WageList]/4}]; (* convert to annual income *)
     WageListMat = WageList;

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
     Diffn = Drop[Flatten[Diffn], 1];      (* Remove the first element *)
     Diffnm1 = Drop[Flatten[Diffnm1], 1];  (* Remove the first element *)



     For[j=1, j<=1000-1, (* Repeat the sim 1000 times *)

     EmpStateList = {1};
     For[periodt = 2, periodt <= Length[AggState], 
       AppendTo[EmpStateList, 
        FirstElementGreaterThan[
          CumEmpStateTransitionMatrix[[AggState[[periodt]], 
            EmpStateList[[periodt - 1]] + 1]], Random[]] - 1];
       periodt++];

     PList = Table[1, {Length[AggState]}];
     If[ModelType == KS ,  ThetaList = Table[1, {Length[AggState]}]]; 
     If[ModelType == Point, 
        PsiList     = RandomPermutation[Flatten[Table[PsiVec, {Length[AggState]/Length[PsiVec]}]]];
        ThetaList = RandomPermutation[Flatten[Table[ThetaVecOrig, {Length[AggState]/Length[ThetaVecOrig ]}]]];
        For[periodt = 2, periodt <= Length[AggState], 
            PList[[periodt]] = PList[[periodt-1]] PsiList[[periodt]]; 
            periodt++]
        ]; 

     WageList = Take[PList (EmpStateList ThetaList + (1-EmpStateList)) w Table[etValsByAggEmpState[[AggState[[i]] ,EmpStateList[[i]]+1]], {i,1, Length[AggState]}], -PeriodsToUse];
     WageList = Table[Total[Take[WageList, {(i - 1)*4 + 1, (i - 1)*4 + 4}]]/4, {i, Length[WageList]/4}]; (* convert to annual income *)
     WageListMat = {WageListMat , WageList}; 

     DiffnTemp   = {0};
     Diffnm1Temp = {0};
     For[i = 1, i <= Length[WageList] - 7 + 1, (* 7 means that 7 periods is taken as in Carroll and Samwick (1997) *)
      WageListTemp     = Take[WageList, {i, i + 6}];
      WageListTempMean = Mean[WageListTemp];
      If[Min[WageListTemp] > 0.2 WageListTempMean, 

       (*if yes *)
       AppendTo[DiffnTemp, 
        Table[Log[WageListTemp[[j + IntervalUsedToCalcVar ]]] - 
          Log[WageListTemp[[j]]]
         , {j, 1, 7 - IntervalUsedToCalcVar}]];
       AppendTo[Diffnm1Temp, 
        Table[Log[WageListTemp[[j + IntervalUsedToCalcVar - 1]]] - 
          Log[WageListTemp[[j]]]
         , {j, 1, 7 - (IntervalUsedToCalcVar - 1)}]];
  
       ];
 
      i++
      ];
     DiffnTemp   = Drop[Flatten[DiffnTemp], 1];    (* Remove the first element *)
     Diffnm1Temp = Drop[Flatten[Diffnm1Temp], 1];  (* Remove the first element *)
     Diffn       = Flatten[AppendTo[Diffn, DiffnTemp]];
     Diffnm1     = Flatten[AppendTo[Diffnm1, Diffnm1Temp]];

         j++];

     VARn        = Variance[Diffn]; 
     VARnm1      = Variance[Diffnm1]; 
     VarPermSolution = VARn- VARnm1;
     If[VarPermSolution< 0, VarPerm=0, VarPerm=VarPermSolution]; (* If VarPerm solved is a tiny negative number, replace it with zero. *)

     VarTran = (VARn - IntervalUsedToCalcVar*VarPerm)/2; 

     If[ModelType == KS, 
        WageListKS = Flatten[WageListMat];  
        Print[" Variances of perm shocks and trans shocks implied by KS (dropping samples if annual income is below 20 percent of the 7-year average): ", {VarPerm, VarTran}]
        ];
     If[ModelType == Point, 
        Print[" Variances of perm shocks and trans shocks implied by the Point model (dropping samples if annual income is below 20 percent of the 7-year average): ", {VarPerm, VarTran}]
        ];

     ]; (* End If *)

   (* Calculate and show variances of income shocks implied by Castaneda *)
   If[ModelType == KS && Estimatet > 1 && Rep == False,
     <<EstimateIncVarsCastaneda.m; 

     ]; (* End if *)

    (* Agg statistics *)
    sigmaLogY        = StandardDeviation[Log[YLevUsed]];
    sigmaLogC        = StandardDeviation[Log[CLevUsed]];
    sigmaCYRatio     = sigmaLogC/sigmaLogY;
    sigmaLogI        = StandardDeviation[Log[ILevUsed]];
    sigmaIYRatio     = sigmaLogI/sigmaLogY;

    corrYtYtm1       = Corr[Drop[YLevUsed, 1],Drop[YLevUsed, -1]];
    corrCY           = Corr[YLevUsed,CLevUsed];
    corrCtYtm1       = Corr[Drop[CLevUsed, 1],Drop[YLevUsed, -1]];
    corrCtCtm1       = Corr[Drop[CLevUsed, 1],Drop[CLevUsed, -1]];
    corrIY           = Corr[YLevUsed,ILevUsed];
    corrItYtm1       = Corr[Drop[ILevUsed, 1],Drop[YLevUsed, -1]];
    corrItItm1       = Corr[Drop[ILevUsed, 1],Drop[ILevUsed, -1]];

    corrdlCtdlCtm1   = Corr[Drop[dlCLevUsed, 1],Drop[dlCLevUsed, -1]];
    corrdlCtdlYt     = Corr[dlCLevUsed, dlYLevUsed];
    corrdlCtdlYtm1   = Corr[Drop[dlCLevUsed, 1],Drop[dlYLevUsed, -1]];
    corrdlCtdlYtm2   = Corr[Drop[dlCLevUsed, {1,2}],Drop[dlYLevUsed, {-2,-1}]];
    corrdlCtRt       = Corr[dlCLevUsed, Drop[RUsed, 1]];
    corrdlCtRtm1     = Corr[dlCLevUsed, Drop[RUsed, -1]];
    corrd4lCtd4lYt   = Corr[d4lCLevUsed , d4lYLevUsed ];
    corrd8lCtd8lYt   = Corr[d8lCLevUsed , d8lYLevUsed ];

    lYLevUsed        = Log[YLevUsed]; (* take log *)
    corrlYtlYtm1     = Corr[Drop[lYLevUsed, 1],Drop[lYLevUsed, -1]];
    corrdlYtdlYtm1   = Corr[Drop[dlYLevUsed, 1],Drop[dlYLevUsed, -1]];

    KYRatio          = Mean[KLevUsedt/YLevUsed];
    KLevMean         = Mean[KLevUsedt]; 

    AggStatsWithAggShock ={
          corrdlCtdlCtm1   ,
          corrdlCtdlYt     ,
          corrdlCtdlYtm1   ,
          corrdlCtdlYtm2   ,
          corrdlCtRt       ,
          corrdlCtRtm1     ,
          corrd4lCtd4lYt   ,
          corrd8lCtd8lYt,   
          KYRatio          ,  
          corrlYtlYtm1     ,
          corrdlYtdlYtm1 }; 

   Clear[(* KRat, *) MRat,CRat,MLev,(* YLev,*) CLev,CLevSim,CLevExp,lCLevUsed,ILev];

   (* Show agg statistics *)

   If[Rep  == True || TimesToEstimateSmall > 3,  
   Print[" sigmaLogY,sigmaLogC,sigmaCYRatio,sigmaLogI,sigmaIYRatio,corr(Y(t),Y(t-1)),corr(C(t),Y(t)),corr(C(t),Y(t-1)),corr(C(t),C(t-1)),corr(I(t),Y(t)),corr(I(t),Y(t-1)),corr(I(t),I(t-1)), KYRatio: "];
  
   Print[{
          sigmaLogY, 
          sigmaLogC, 
          sigmaCYRatio, 
          sigmaLogI, 
          sigmaIYRatio, 

          corrYtYtm1, 
          corrCY,  
          corrCtYtm1, 
          corrCtCtm1, 
          corrIY, 
          corrItYtm1, 
          corrItItm1,

          (* corrdCtdCtm1, *)

          KYRatio
          }];

   Print[" corr(dlC(t),dlC(t-1)), corr(dlC(t),dlY(t)), corr(dlC(t),dlY(t-1)), corr(dlC(t),dlY(t-2)), corr(dlC(t),r(t)), corr(dlC(t),r(t-1)), corr(d4lC(t),d4lY(t)), corr(d8lC(t),d8lY(t)), corr(lY(t),lY(t-1)),  corr(dlY(t),dlY(t-1)): "];

   Print[{
          corrdlCtdlCtm1   ,
          corrdlCtdlYt     ,
          corrdlCtdlYtm1   ,
          corrdlCtdlYtm2   ,
          corrdlCtRt       ,
          corrdlCtRtm1     ,
          corrd4lCtd4lYt   ,
          corrd8lCtd8lYt   ,
          corrlYtlYtm1     ,
          corrdlYtdlYtm1   
          }]
   ]; (* End if *)

   If[TimesToEstimateSmall<=3,  
   Print[" Mean of K (level), KYRatio: "];
   Print[{KLevMean, KYRatio}]
   ]; (* End if *)


]; (* End CalcAggStatsKS *)


(* "CalcMPC" calculates and displays MPC *)
CalcMPC := Block[{},
  MPCUsed             = Take[MPC,             -PeriodsToUse];

  MPCTop1PercentUsed     = Take[MPCTop1Percent,  -PeriodsToUse];
  MPCTop10PercentUsed    = Take[MPCTop10Percent, -PeriodsToUse];
  MPCTop20PercentUsed    = Take[MPCTop20Percent, -PeriodsToUse];
  MPCTop40PercentUsed    = Take[MPCTop40Percent, -PeriodsToUse];
  MPCTop60PercentUsed    = Take[MPCTop60Percent, -PeriodsToUse];
  MPCBottom40PercentUsed = Take[MPCBottom40Percent, -PeriodsToUse];
  MPCBottom20PercentUsed = Take[MPCBottom20Percent, -PeriodsToUse];
  MPCBottom3QuartUsed    = Take[MPCBottom3Quart, -PeriodsToUse];
  MPCBottomHalfUsed      = Take[MPCBottomHalf,   -PeriodsToUse];
  MPCBottomQuartUsed     = Take[MPCBottomQuart,  -PeriodsToUse];

  MPCEmpUsed             = Take[MPCEmp,          -PeriodsToUse];
  MPCUnempUsed           = Take[MPCUnemp,        -PeriodsToUse];

  MPCTop1PercentBykUsed     = Take[MPCTop1PercentByk,  -PeriodsToUse];
  MPCTop10PercentBykUsed    = Take[MPCTop10PercentByk, -PeriodsToUse];
  MPCTop20PercentBykUsed    = Take[MPCTop20PercentByk, -PeriodsToUse];
  MPCTop40PercentBykUsed    = Take[MPCTop40PercentByk, -PeriodsToUse];
  MPCTop60PercentBykUsed    = Take[MPCTop60PercentByk, -PeriodsToUse];
  MPCBottom40PercentBykUsed = Take[MPCBottom40PercentByk, -PeriodsToUse];
  MPCBottom20PercentBykUsed = Take[MPCBottom20PercentByk, -PeriodsToUse];
  MPCBottom3QuartBykUsed    = Take[MPCBottom3QuartByk, -PeriodsToUse];
  MPCBottomHalfBykUsed      = Take[MPCBottomHalfByk,   -PeriodsToUse];
  MPCBottomQuartBykUsed     = Take[MPCBottomQuartByk,  -PeriodsToUse];


  MeanMPCAnnual                = 1-(1-Mean[MPCUsed])^4;            (* MPC annual terms *)

  MeanMPCTop1PercentAnnual     = 1-(1-Mean[MPCTop1PercentUsed])^4;
  MeanMPCTop10PercentAnnual    = 1-(1-Mean[MPCTop10PercentUsed])^4;
  MeanMPCTop20PercentAnnual    = 1-(1-Mean[MPCTop20PercentUsed])^4;
  MeanMPCTop40PercentAnnual    = 1-(1-Mean[MPCTop40PercentUsed])^4;
  MeanMPCTop60PercentAnnual    = 1-(1-Mean[MPCTop60PercentUsed])^4;
  MeanMPCBottom40PercentAnnual = 1-(1-Mean[MPCBottom40PercentUsed])^4;
  MeanMPCBottom20PercentAnnual = 1-(1-Mean[MPCBottom20PercentUsed])^4;
  MeanMPCBottom3QuartAnnual    = 1-(1-Mean[MPCBottom3QuartUsed])^4;
  MeanMPCBottomHalfAnnual      = 1-(1-Mean[MPCBottomHalfUsed])^4;
  MeanMPCBottomQuartAnnual     = 1-(1-Mean[MPCBottomQuartUsed])^4;
  MeanMPCEmpAnnual             = 1-(1-Mean[MPCEmpUsed])^4;
  MeanMPCUnempAnnual           = 1-(1-Mean[MPCUnempUsed])^4;

  MeanMPCTop1PercentBykAnnual     = 1-(1-Mean[MPCTop1PercentBykUsed])^4;
  MeanMPCTop10PercentBykAnnual    = 1-(1-Mean[MPCTop10PercentBykUsed])^4;
  MeanMPCTop20PercentBykAnnual    = 1-(1-Mean[MPCTop20PercentBykUsed])^4;
  MeanMPCTop40PercentBykAnnual    = 1-(1-Mean[MPCTop40PercentBykUsed])^4;
  MeanMPCTop60PercentBykAnnual    = 1-(1-Mean[MPCTop60PercentBykUsed])^4;
  MeanMPCBottom40PercentBykAnnual = 1-(1-Mean[MPCBottom40PercentBykUsed])^4;
  MeanMPCBottom20PercentBykAnnual = 1-(1-Mean[MPCBottom20PercentBykUsed])^4;
  MeanMPCBottom3QuartBykAnnual    = 1-(1-Mean[MPCBottom3QuartBykUsed])^4;
  MeanMPCBottomHalfBykAnnual      = 1-(1-Mean[MPCBottomHalfBykUsed])^4;
  MeanMPCBottomQuartBykAnnual     = 1-(1-Mean[MPCBottomQuartBykUsed])^4;

  MPCListWithAggShock = {
        MeanMPCAnnual,
        MeanMPCTop1PercentBykAnnual,
        MeanMPCTop10PercentBykAnnual,
        MeanMPCTop20PercentBykAnnual,
        MeanMPCTop40PercentBykAnnual,
        MeanMPCTop60PercentBykAnnual,
        MeanMPCBottomHalfBykAnnual,
        MeanMPCTop1PercentAnnual,
        MeanMPCTop10PercentAnnual,
        MeanMPCTop20PercentAnnual,
        MeanMPCTop40PercentAnnual,
        MeanMPCTop60PercentAnnual,
        MeanMPCBottomHalfAnnual,
        MeanMPCEmpAnnual,
        MeanMPCUnempAnnual,
        MeanMPCBottom20PercentBykAnnual,
        MeanMPCBottom20PercentAnnual
        };

  Print[" MPC mean:" , MeanMPCAnnual];

  Print[" MPC by income top 1%, 10%, 20%, 40%, 60%; bottom 40%, 20%, 3/4, 1/2, 1/4: "];
  Print[{MeanMPCTop1PercentAnnual,
         MeanMPCTop10PercentAnnual,
         MeanMPCTop20PercentAnnual,
         MeanMPCTop40PercentAnnual,
         MeanMPCTop60PercentAnnual,
         MeanMPCBottom40PercentAnnual,
         MeanMPCBottom20PercentAnnual,
         MeanMPCBottom3QuartAnnual,  
         MeanMPCBottomHalfAnnual, 
         MeanMPCBottomQuartAnnual}];

  Print[" MPC by wealth perm inc ratio top 1%, 10%, 20%, 40%, 60%; bottom 40%, 20%, 3/4, 1/2, 1/4: "];
  Print[{MeanMPCTop1PercentBykAnnual,
         MeanMPCTop10PercentBykAnnual,
         MeanMPCTop20PercentBykAnnual,
         MeanMPCTop40PercentBykAnnual,
         MeanMPCTop60PercentBykAnnual,
         MeanMPCBottom40PercentBykAnnual,
         MeanMPCBottom20PercentBykAnnual,
         MeanMPCBottom3QuartBykAnnual,  
         MeanMPCBottomHalfBykAnnual, 
         MeanMPCBottomQuartBykAnnual}];

  Print[" MPC employed, unemployed: ", {MeanMPCEmpAnnual, MeanMPCUnempAnnual}];

  (* calc MPCs by state *)
  AggStateUsed      = Take[AggState, -PeriodsToUse];

  AggStateDumgg = Map[If[# ==1, 1, 0] &, AggStateUsed]; (* The dummy is 1 if Currently Good, Came from Good *)
  AggStateDumgb = Map[If[# ==2, 1, 0] &, AggStateUsed]; (* The dummy is 1 if Currently Bad,  Came from Good *)
  AggStateDumbb = Map[If[# ==3, 1, 0] &, AggStateUsed]; (* The dummy is 1 if Currently Bad,  Came from Bad *)
  AggStateDumbg = Map[If[# ==4, 1, 0] &, AggStateUsed]; (* The dummy is 1 if Currently Good, Came from Bad *)

  AggStateDumExpansion    = AggStateDumgg + AggStateDumbg; (* current state is good *)
  AggStateDumRecession    = AggStateDumgb + AggStateDumbb; (* current state is bad *) 
  AggStateDumEntRecession = AggStateDumgb; (* entering recession *) 
  AggStateDumEntExpansion = AggStateDumbg; (* entering expansion *) 

   (* Recession *)
   MeanMPCAnnualRecession                = 1-(1-MPCUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;            (* MPC annual terms *)

   MeanMPCTop1PercentAnnualRecession     = 1-(1-MPCTop1PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop10PercentAnnualRecession    = 1-(1-MPCTop10PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop20PercentAnnualRecession    = 1-(1-MPCTop20PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop40PercentAnnualRecession    = 1-(1-MPCTop40PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop60PercentAnnualRecession    = 1-(1-MPCTop60PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottom40PercentAnnualRecession = 1-(1-MPCBottom40PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottom20PercentAnnualRecession = 1-(1-MPCBottom20PercentUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottom3QuartAnnualRecession    = 1-(1-MPCBottom3QuartUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottomHalfAnnualRecession      = 1-(1-MPCBottomHalfUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottomQuartAnnualRecession     = 1-(1-MPCBottomQuartUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCEmpAnnualRecession             = 1-(1-MPCEmpUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCUnempAnnualRecession           = 1-(1-MPCUnempUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;

   MeanMPCTop1PercentBykAnnualRecession     = 1-(1-MPCTop1PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop10PercentBykAnnualRecession    = 1-(1-MPCTop10PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop20PercentBykAnnualRecession    = 1-(1-MPCTop20PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop40PercentBykAnnualRecession    = 1-(1-MPCTop40PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCTop60PercentBykAnnualRecession    = 1-(1-MPCTop60PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottom40PercentBykAnnualRecession = 1-(1-MPCBottom40PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottom20PercentBykAnnualRecession = 1-(1-MPCBottom20PercentBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottom3QuartBykAnnualRecession    = 1-(1-MPCBottom3QuartBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottomHalfBykAnnualRecession      = 1-(1-MPCBottomHalfBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;
   MeanMPCBottomQuartBykAnnualRecession     = 1-(1-MPCBottomQuartBykUsed.AggStateDumRecession/Total[AggStateDumRecession])^4;

   MPCListRecessionWithAggShock = {
        MeanMPCAnnualRecession,
        MeanMPCTop1PercentBykAnnualRecession,
        MeanMPCTop10PercentBykAnnualRecession,
        MeanMPCTop20PercentBykAnnualRecession,
        MeanMPCTop40PercentBykAnnualRecession,
        MeanMPCTop60PercentBykAnnualRecession,
        MeanMPCBottomHalfBykAnnualRecession,
        MeanMPCTop1PercentAnnualRecession,
        MeanMPCTop10PercentAnnualRecession,
        MeanMPCTop20PercentAnnualRecession,
        MeanMPCTop40PercentAnnualRecession,
        MeanMPCTop60PercentAnnualRecession,
        MeanMPCBottomHalfAnnualRecession,
        MeanMPCEmpAnnualRecession,
        MeanMPCUnempAnnualRecession,
        MeanMPCBottom20PercentBykAnnualRecession,
        MeanMPCBottom20PercentAnnualRecession
        }; (* construct list *)


   (* Expansion *)
   MeanMPCAnnualExpansion                = 1-(1-MPCUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;            (* MPC annual terms *)

   MeanMPCTop1PercentAnnualExpansion     = 1-(1-MPCTop1PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop10PercentAnnualExpansion    = 1-(1-MPCTop10PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop20PercentAnnualExpansion    = 1-(1-MPCTop20PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop40PercentAnnualExpansion    = 1-(1-MPCTop40PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop60PercentAnnualExpansion    = 1-(1-MPCTop60PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottom40PercentAnnualExpansion = 1-(1-MPCBottom40PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottom20PercentAnnualExpansion = 1-(1-MPCBottom20PercentUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottom3QuartAnnualExpansion    = 1-(1-MPCBottom3QuartUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottomHalfAnnualExpansion      = 1-(1-MPCBottomHalfUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottomQuartAnnualExpansion     = 1-(1-MPCBottomQuartUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCEmpAnnualExpansion             = 1-(1-MPCEmpUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCUnempAnnualExpansion           = 1-(1-MPCUnempUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;

   MeanMPCTop1PercentBykAnnualExpansion     = 1-(1-MPCTop1PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop10PercentBykAnnualExpansion    = 1-(1-MPCTop10PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop20PercentBykAnnualExpansion    = 1-(1-MPCTop20PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop40PercentBykAnnualExpansion    = 1-(1-MPCTop40PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCTop60PercentBykAnnualExpansion    = 1-(1-MPCTop60PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottom40PercentBykAnnualExpansion = 1-(1-MPCBottom40PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottom20PercentBykAnnualExpansion = 1-(1-MPCBottom20PercentBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottom3QuartBykAnnualExpansion    = 1-(1-MPCBottom3QuartBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottomHalfBykAnnualExpansion      = 1-(1-MPCBottomHalfBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;
   MeanMPCBottomQuartBykAnnualExpansion     = 1-(1-MPCBottomQuartBykUsed.AggStateDumExpansion/Total[AggStateDumExpansion])^4;


   MPCListExpansionWithAggShock = {
        MeanMPCAnnualExpansion,
        MeanMPCTop1PercentBykAnnualExpansion,
        MeanMPCTop10PercentBykAnnualExpansion,
        MeanMPCTop20PercentBykAnnualExpansion,
        MeanMPCTop40PercentBykAnnualExpansion,
        MeanMPCTop60PercentBykAnnualExpansion,
        MeanMPCBottomHalfBykAnnualExpansion,
        MeanMPCTop1PercentAnnualExpansion,
        MeanMPCTop10PercentAnnualExpansion,
        MeanMPCTop20PercentAnnualExpansion,
        MeanMPCTop40PercentAnnualExpansion,
        MeanMPCTop60PercentAnnualExpansion,
        MeanMPCBottomHalfAnnualExpansion,
        MeanMPCEmpAnnualExpansion,
        MeanMPCUnempAnnualExpansion,
        MeanMPCBottom20PercentBykAnnualExpansion,
        MeanMPCBottom20PercentAnnualExpansion
        }; (* construct list *)


   (* Entering recession *)
   MeanMPCAnnualEntRecession                = 1-(1-MPCUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;            (* MPC annual terms *)

   MeanMPCTop1PercentAnnualEntRecession     = 1-(1-MPCTop1PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop10PercentAnnualEntRecession    = 1-(1-MPCTop10PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop20PercentAnnualEntRecession    = 1-(1-MPCTop20PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop40PercentAnnualEntRecession    = 1-(1-MPCTop40PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop60PercentAnnualEntRecession    = 1-(1-MPCTop60PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottom40PercentAnnualEntRecession = 1-(1-MPCBottom40PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottom20PercentAnnualEntRecession = 1-(1-MPCBottom20PercentUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottom3QuartAnnualEntRecession    = 1-(1-MPCBottom3QuartUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottomHalfAnnualEntRecession      = 1-(1-MPCBottomHalfUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottomQuartAnnualEntRecession     = 1-(1-MPCBottomQuartUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCEmpAnnualEntRecession             = 1-(1-MPCEmpUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCUnempAnnualEntRecession           = 1-(1-MPCUnempUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;

   MeanMPCTop1PercentBykAnnualEntRecession     = 1-(1-MPCTop1PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop10PercentBykAnnualEntRecession    = 1-(1-MPCTop10PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop20PercentBykAnnualEntRecession    = 1-(1-MPCTop20PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop40PercentBykAnnualEntRecession    = 1-(1-MPCTop40PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCTop60PercentBykAnnualEntRecession    = 1-(1-MPCTop60PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottom40PercentBykAnnualEntRecession = 1-(1-MPCBottom40PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottom20PercentBykAnnualEntRecession = 1-(1-MPCBottom20PercentBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottom3QuartBykAnnualEntRecession    = 1-(1-MPCBottom3QuartBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottomHalfBykAnnualEntRecession      = 1-(1-MPCBottomHalfBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;
   MeanMPCBottomQuartBykAnnualEntRecession     = 1-(1-MPCBottomQuartBykUsed.AggStateDumEntRecession/Total[AggStateDumEntRecession])^4;

    MPCListEntRecessionWithAggShock = {
        MeanMPCAnnualEntRecession,
        MeanMPCTop1PercentBykAnnualEntRecession,
        MeanMPCTop10PercentBykAnnualEntRecession,
        MeanMPCTop20PercentBykAnnualEntRecession,
        MeanMPCTop40PercentBykAnnualEntRecession,
        MeanMPCTop60PercentBykAnnualEntRecession,
        MeanMPCBottomHalfBykAnnualEntRecession,
        MeanMPCTop1PercentAnnualEntRecession,
        MeanMPCTop10PercentAnnualEntRecession,
        MeanMPCTop20PercentAnnualEntRecession,
        MeanMPCTop40PercentAnnualEntRecession,
        MeanMPCTop60PercentAnnualEntRecession,
        MeanMPCBottomHalfAnnualEntRecession,
        MeanMPCEmpAnnualEntRecession,
        MeanMPCUnempAnnualEntRecession,
        MeanMPCBottom20PercentBykAnnualEntRecession,
        MeanMPCBottom20PercentAnnualEntRecession
        }; (* construct list *)


   (* Entering expansion *)
   MeanMPCAnnualEntExpansion                = 1-(1-MPCUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;            (* MPC annual terms *)

   MeanMPCTop1PercentAnnualEntExpansion     = 1-(1-MPCTop1PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop10PercentAnnualEntExpansion    = 1-(1-MPCTop10PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop20PercentAnnualEntExpansion    = 1-(1-MPCTop20PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop40PercentAnnualEntExpansion    = 1-(1-MPCTop40PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop60PercentAnnualEntExpansion    = 1-(1-MPCTop60PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottom40PercentAnnualEntExpansion = 1-(1-MPCBottom40PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottom20PercentAnnualEntExpansion = 1-(1-MPCBottom20PercentUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottom3QuartAnnualEntExpansion    = 1-(1-MPCBottom3QuartUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottomHalfAnnualEntExpansion      = 1-(1-MPCBottomHalfUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottomQuartAnnualEntExpansion     = 1-(1-MPCBottomQuartUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCEmpAnnualEntExpansion             = 1-(1-MPCEmpUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCUnempAnnualEntExpansion           = 1-(1-MPCUnempUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;

   MeanMPCTop1PercentBykAnnualEntExpansion     = 1-(1-MPCTop1PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop10PercentBykAnnualEntExpansion    = 1-(1-MPCTop10PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop20PercentBykAnnualEntExpansion    = 1-(1-MPCTop20PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop40PercentBykAnnualEntExpansion    = 1-(1-MPCTop40PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCTop60PercentBykAnnualEntExpansion    = 1-(1-MPCTop60PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottom40PercentBykAnnualEntExpansion = 1-(1-MPCBottom40PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottom20PercentBykAnnualEntExpansion = 1-(1-MPCBottom20PercentBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottom3QuartBykAnnualEntExpansion    = 1-(1-MPCBottom3QuartBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottomHalfBykAnnualEntExpansion      = 1-(1-MPCBottomHalfBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;
   MeanMPCBottomQuartBykAnnualEntExpansion     = 1-(1-MPCBottomQuartBykUsed.AggStateDumEntExpansion/Total[AggStateDumEntExpansion])^4;

   MPCListEntExpansionWithAggShock = {
        MeanMPCAnnualEntExpansion,
        MeanMPCTop1PercentBykAnnualEntExpansion,
        MeanMPCTop10PercentBykAnnualEntExpansion,
        MeanMPCTop20PercentBykAnnualEntExpansion,
        MeanMPCTop40PercentBykAnnualEntExpansion,
        MeanMPCTop60PercentBykAnnualEntExpansion,
        MeanMPCBottomHalfBykAnnualEntExpansion,
        MeanMPCTop1PercentAnnualEntExpansion,
        MeanMPCTop10PercentAnnualEntExpansion,
        MeanMPCTop20PercentAnnualEntExpansion,
        MeanMPCTop40PercentAnnualEntExpansion,
        MeanMPCTop60PercentAnnualEntExpansion,
        MeanMPCBottomHalfAnnualEntExpansion,
        MeanMPCEmpAnnualEntExpansion,
        MeanMPCUnempAnnualEntExpansion,
        MeanMPCBottom20PercentBykAnnualEntExpansion,
        MeanMPCBottom20PercentAnnualEntExpansion
        }; (* construct list *)


];  (* End CalcMPC *) 
 
(* "CalcDistStas" calculates and displays distribution of wealth (capital) *)
CalcDistStas        := Block[{},
   
  kLevTop1PercentMean    = 100 Mean[Take[kLevTop1Percent , -PeriodsToUse]];
  kLevTop5PercentMean    = 100 Mean[Take[kLevTop5Percent , -PeriodsToUse]];
  kLevTop10PercentMean   = 100 Mean[Take[kLevTop10Percent, -PeriodsToUse]];
  kLevTop20PercentMean   = 100 Mean[Take[kLevTop20Percent, -PeriodsToUse]];
  kLevTop25PercentMean   = 100 Mean[Take[kLevTop25Percent, -PeriodsToUse]];
  kLevTop40PercentMean   = 100 Mean[Take[kLevTop40Percent, -PeriodsToUse]];
  kLevTop50PercentMean   = 100 Mean[Take[kLevTop50Percent, -PeriodsToUse]];
  kLevTop60PercentMean   = 100 Mean[Take[kLevTop60Percent, -PeriodsToUse]];
  kLevTop80PercentMean   = 100 Mean[Take[kLevTop80Percent, -PeriodsToUse]];

  GiniCoeffMean          = Mean[Take[GiniCoeff , -PeriodsToUse]];
  FracBetween05And15Mean = 100 Mean[Take[FracBetween05And15, -PeriodsToUse]]; (* show in percent *)

    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStats[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStats[[2]])^2
                + (kLevTop60PercentMean-WealthDistStats[[3]])^2
                + (kLevTop80PercentMean-WealthDistStats[[4]])^2;

  If[MatchFinAssets == Yes, (* If matching financial assets *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStatsFin[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStatsFin[[2]])^2
                + (kLevTop60PercentMean-WealthDistStatsFin[[3]])^2
                + (kLevTop80PercentMean-WealthDistStatsFin[[4]])^2
     ]; (* Data are from SCF2004 *)

  If[MatchLiqFinPlsRetAssets == Yes, (* If matching liquid financial assets plus retirement assets *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStatsLiqFinPlsRet[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStatsLiqFinPlsRet[[2]])^2
                + (kLevTop60PercentMean-WealthDistStatsLiqFinPlsRet[[3]])^2
                + (kLevTop80PercentMean-WealthDistStatsLiqFinPlsRet[[4]])^2
     ]; (* Data are from SCF2004 *)

  If[MatchLiqFinAssets == Yes, (* If matching liquid financial assets *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStatsLiqFin[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStatsLiqFin[[2]])^2
                + (kLevTop60PercentMean-WealthDistStatsLiqFin[[3]])^2
                + (kLevTop80PercentMean-WealthDistStatsLiqFin[[4]])^2

     ]; (* Data are from SCF2004 *)

  mRatMedianMean      = Mean[Take[mRatMedian, -PeriodsToUse]];
  FracmRatBelow20Mean = 100 Mean[Take[FracmRatBelow20, -PeriodsToUse]]; (* fraction of mRat below 2.0 (in percent) *)

  Print[" Distribution of wealth (k) 1%, 5%, 10%, 20%, 25%, 40%, 50%, 60%, 80%, Gini coeff, Frac between 0.5 and 1.5 * mean k (%), Frac mRat below 2 (%), Median mRat, Sum of Dev Squared: "];
  Print[N[{kLevTop1PercentMean, kLevTop5PercentMean, kLevTop10PercentMean, kLevTop20PercentMean, kLevTop25PercentMean, kLevTop40PercentMean, kLevTop50PercentMean, kLevTop60PercentMean, kLevTop80PercentMean, GiniCoeffMean, FracBetween05And15Mean, FracmRatBelow20Mean, mRatMedianMean, SumOfDevSq}]];

]; (* End Block *) 

(* "EstimateAR1" estimates agg process (AR1 process) *)
EstimateAR1 := Block[{},
  
  AggStateUsed      = Take[AggState, -PeriodsToUse];
  KLevUsedt         = Take[KLev   , -PeriodsToUse];
  KLevUsedtm1       = Take[KLev   , {Length[KLev]-PeriodsToUse,Length[KLev]-1}];

  AggStateDumg             = Map[If[# <=2, 1, 0] &, AggStateUsed]; (* The dummy is 1 if the state was good in the previous period *)
  LogKLevtTimesAggStateg   = AggStateDumg Log[KLevUsedt];
  LogKLevtm1TimesAggStateg = AggStateDumg Log[KLevUsedtm1]; 
  KARg                     = MyReg[LogKLevtTimesAggStateg,Transpose[{AggStateDumg*Table[1,{Length[LogKLevtm1TimesAggStateg]}],LogKLevtm1TimesAggStateg}]];

  AggStateDumb             = Map[If[# >=3, 1, 0] &, AggStateUsed]; (* The dummy is 1 if the state was bad in the previous period *)
  LogKLevtTimesAggStateb   = AggStateDumb Log[KLevUsedt];
  LogKLevtm1TimesAggStateb = AggStateDumb Log[KLevUsedtm1]; 
  KARb                     = MyReg[LogKLevtTimesAggStateb,Transpose[{AggStateDumb*Table[1,{Length[LogKLevtm1TimesAggStateb]}],LogKLevtm1TimesAggStateb}]];  

  (* Update estimates of agg process *)
  If[Rep == False, 
     kAR1ByAggStatetm1     = kAR1ByAggState; 
     kAR1ByAggState        = WeightOnPrevEstimates kAR1ByAggStatetm1 + (1-WeightOnPrevEstimates) {KARg,KARg,KARb,KARb};  
     AppendTo[kAR1ByAggStateList,kAR1ByAggState]
  ]; 

  If[Rep == False,
     GapCoeff = Max[Abs[Flatten[kAR1ByAggState]/Flatten[kAR1ByAggStatetm1]-1]]; 
     ]; (* End If *)

  Clear[AggStateUsed, KLevUsedt, KLevUsedtm1];
               
  ]; (* End CalcDistStas *) 

(* "CalculateRSquared" calculates R^2 *)
CalculateRSquared  := Block[{},

  PredictedLogKLevtTimesAggStateg = kAR1ByAggState[[1,1]] AggStateDumg + kAR1ByAggState[[1,2]] LogKLevtm1TimesAggStateg;
  PredictedLogKLevtTimesAggStateb = kAR1ByAggState[[3,1]] AggStateDumb + kAR1ByAggState[[3,2]] LogKLevtm1TimesAggStateb;
  Errorg                          = LogKLevtTimesAggStateg - PredictedLogKLevtTimesAggStateg;
  Errorb                          = LogKLevtTimesAggStateb - PredictedLogKLevtTimesAggStateb;
  MeanLogKLevtTimesAggStateg      = Total[LogKLevtTimesAggStateg]/Total[AggStateDumg];
  MeanLogKLevtTimesAggStateb      = Total[LogKLevtTimesAggStateb]/Total[AggStateDumb];

  RSquaredg = 1 - (Errorg.Errorg)/((LogKLevtTimesAggStateg-AggStateDumg MeanLogKLevtTimesAggStateg).(LogKLevtTimesAggStateg-AggStateDumg MeanLogKLevtTimesAggStateg));
  RSquaredb = 1 - (Errorb.Errorb)/((LogKLevtTimesAggStateb-AggStateDumb MeanLogKLevtTimesAggStateb).(LogKLevtTimesAggStateb-AggStateDumb MeanLogKLevtTimesAggStateb));
  (* Print[" R^2 if good, R^2 if bad: ", {RSquaredg,RSquaredb}]; *)

  (* Clear vars *)
  Clear[AggStateDumg, LogKLevtTimesAggStateg, LogKLevtm1TimesAggStateg,
        AggStateDumb, LogKLevtTimesAggStateb, LogKLevtm1TimesAggStateb,
        PredictedLogKLevtTimesAggStateg, PredictedLogKLevtTimesAggStateb,
        Errorg, Errorb
        ];
]; (* End CalculateRSquared *) 

(* "SimulateKSIndIntGuess" runs simulation to get initial guess of paramter values *)
SimulateKSIndIntGuess := Block[{},

   (* Set up lists *)
   kRatt                = InitialCapital Table[1, {NumOfApproxPoints}];
   kRatList             = {kRatt};
   Psit                 = Table[1, {NumOfApproxPoints}];
   Pt                   = Psit;
   Thetat               = Table[1, {NumOfApproxPoints}];
   PatientIndicatorList = Table[i, {i, 1, NumOfApproxPoints}];
   EmpStatet            = Table[1, {NumOfApproxPoints}];
   
   (* First period *)
(*
   Print[" Simulating period 1"];
*)
   KRat = {(kRatt.Pt)/Length[kRatt]};

(*
  (* Distribution of wealth (capital) *)
  kLevt           = Flatten[Table[PtSSDist kRatt[[i]], {i, 1, Length[kRatt]}]];
  kLevtsorted     = Sort[kLevt];
  kLevtsortedSum  = Total[kLevtsorted];
  kLevtsortedMean = kLevtsortedSum/(NumPeopleToGenPtSSDist NumOfApproxPoints);
  DumBetween05And15t  =  Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];

  GiniCoeff     = {(2/((NumPeopleToGenPtSSDist NumOfApproxPoints)^2 kLevtsortedMean)) (Table[i,{i,1,(NumPeopleToGenPtSSDist NumOfApproxPoints)}].(kLevtsorted-kLevtsortedMean))};
  kLevtsorted        = Reverse[kLevtsorted];
  kLevTop1Percent    = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.01]}]]/kLevtsortedSum};
  kLevTop5Percent    = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.05]}]]/kLevtsortedSum};
  kLevTop10Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.10]}]]/kLevtsortedSum};
  kLevTop20Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.20]}]]/kLevtsortedSum};
  kLevTop25Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.25]}]]/kLevtsortedSum};
  kLevTop40Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.40]}]]/kLevtsortedSum};
  kLevTop50Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.50]}]]/kLevtsortedSum};
  kLevTop60Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.60]}]]/kLevtsortedSum};
  kLevTop80Percent   = {Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.80]}]]/kLevtsortedSum};
  FracBetween05And15 = {Total[DumBetween05And15t]/(NumPeopleToGenPtSSDist NumOfApproxPoints)};
*)
   
   (* Calculate cRatt *)
   Xit = (EmpStatet Thetat + (1 - EmpStatet)) etValsByAggEmpState[[AggState[[1]], EmpStatet + 1]];
   yRatt = (-\[Delta] + FP[KRat[[1]]]) kRatt + (wFunc[KRat[[1]]]/LLevelByAggState[[AggState[[1]]]]) Xit;
   mRatt = kRatt + yRatt;
   cRatt = 
    Table[KSIndcFunc[mRatt[[i]], AggState[[1]], EmpStatet[[i]], 
      KRat[[1]], PatientIndicatorList[[i]]], {i, 1, NumOfApproxPoints}];
   sRatt = mRatt - cRatt;
   
   (* 2nd period and thereafter *)
   For[Periodt = 2, 
    Periodt <= PeriodsToSimulate,
(*
    If[Mod[Periodt, 500] == 0, Print[" Simulating period ", Periodt]];
*)
    
    Gt = GrowthByAggState[[AggState[[Periodt]]]];
    EmpStatetm1 = EmpStatet;
    EmpStatet = 
     Table[FirstElementGreaterThan[
        CumEmpStateTransitionMatrix[[AggState[[Periodt]], 
         EmpStatetm1[[i]] + 1]], Random[]] - 1, {i, 1, NumOfApproxPoints}];    
    kRatt = sRatt/(Gt Psit); (* No death *)
    AppendTo[kRatList, kRatt];
    (*
    Print[kRatt[[1]]];
    *)
    AppendTo[KRat, (kRatt.Pt)/Length[kRatt]];

(*
    (* Distribution of wealth (capital) *)
    kLevt           = Flatten[Table[PtSSDist kRatt[[i]], {i, 1, Length[kRatt]}]];
    kLevtsorted     = Sort[kLevt];
    kLevtsortedSum  = Total[kLevtsorted];
    kLevtsortedMean = kLevtsortedSum/(NumPeopleToGenPtSSDist NumOfApproxPoints);
    DumBetween05And15t = Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];

    AppendTo[GiniCoeff, (2/((NumPeopleToGenPtSSDist NumOfApproxPoints)^2 kLevtsortedMean)) (Table[i,{i,1,(NumPeopleToGenPtSSDist NumOfApproxPoints)}].(kLevtsorted-kLevtsortedMean))];
    kLevtsorted      = Reverse[kLevtsorted];
    AppendTo[kLevTop1Percent , Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.01]}]]/kLevtsortedSum];
    AppendTo[kLevTop5Percent , Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.05]}]]/kLevtsortedSum];
    AppendTo[kLevTop10Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.10]}]]/kLevtsortedSum];
    AppendTo[kLevTop20Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.20]}]]/kLevtsortedSum];
    AppendTo[kLevTop25Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.25]}]]/kLevtsortedSum];
  AppendTo[kLevTop40Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.40]}]]/kLevtsortedSum];
    AppendTo[kLevTop50Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.50]}]]/kLevtsortedSum];
    AppendTo[kLevTop60Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.60]}]]/kLevtsortedSum];
    AppendTo[kLevTop80Percent, Total[Take[kLevtsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.80]}]]/kLevtsortedSum];
    AppendTo[FracBetween05And15, Total[DumBetween05And15t]/(NumPeopleToGenPtSSDist NumOfApproxPoints)];
    Clear[DumBetween05And15t];
*)
    
    (* Calculate cRatt *)
    RE = (1 - \[Delta] + FP[KRat[[Periodt]]]);
    w = wFunc[KRat[[Periodt]]];(* This is not exactly wageRate (=w AdjustedLByAggState/LLevelByAggState) *)
    Xit = (EmpStatet Thetat + (1 - EmpStatet)) etValsByAggEmpState[[AggState[[Periodt]], EmpStatet + 1]];
    yRatt = (RE - 1) kRatt + (w/LLevelByAggState[[AggState[[Periodt]]]]) Xit;
    mRatt = kRatt + yRatt;
    cRatt = 
     Table[KSIndcFunc[mRatt[[i]], AggState[[Periodt]], EmpStatet[[i]],
        KRat[[Periodt]], PatientIndicatorList[[i]]], {i, 1, NumOfApproxPoints}];
    sRatt = mRatt - cRatt;
    
    Periodt++;

    ]; (* End For *)
   
   KLev = KRat AdjustedLByAggState[[AggState]];
   
   (* Estimate and display agg process *)
   EstimateAR1;

   (* Calculate and display R^2 *)  
   CalculateRSquared;  

   (* Calculate and display KLev  *)
   KLev      = KRat AdjustedLByAggState[[AggState]];
   KLevUsedt = Take[KLev,     -PeriodsToUse];
   KLevMean  = Mean[KLevUsedt]; 
   Print[" Mean of K (level): "];
   Print[KLevMean]; 

(*
   (* Calculate and display distribution of wealth (capital) *)
   CalcDistStas;
*)



   MeankRatByType = Mean[Take[kRatList, {-Round[PeriodsToSimulate/3], -1}]]; 
(*
   Print[" Mean of kRat by type:"];
   Print[MeankRatByType];
*)

   MeankRat = Mean[MeankRatByType];
(*
   Print[" Mean of kRat:"];
   Print[MeankRat];
*)

   kLevLast       = Flatten[Table[PtSSDist MeankRatByType[[i]], {i, 1, Length[MeankRatByType]}]];
   kLevsorted     = Sort[kLevLast];
   kLevsortedSum  = Total[kLevsorted];
   kLevsortedMean = kLevsortedSum/(NumPeopleToGenPtSSDist NumOfApproxPoints);

   GiniCoeff = (2/((NumPeopleToGenPtSSDist NumOfApproxPoints)^2 kLevsortedMean)) (Table[
      i, {i, 1, (NumPeopleToGenPtSSDist NumOfApproxPoints)}].(kLevsorted - kLevsortedMean));
   kLevsorted = Reverse[kLevsorted];
   kLevTop1Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.01]}]]/
   kLevsortedSum;
   kLevTop5Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.05]}]]/
   kLevsortedSum;
   kLevTop10Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.10]}]]/
   kLevsortedSum;
   kLevTop20Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.20]}]]/
   kLevsortedSum;
   kLevTop25Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.25]}]]/
   kLevsortedSum;
   kLevTop40Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.40]}]]/
   kLevsortedSum;
   kLevTop50Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.50]}]]/
   kLevsortedSum;
   kLevTop60Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.60]}]]/
   kLevsortedSum;
   kLevTop80Percent = Total[Take[kLevsorted, {1, Round[(NumPeopleToGenPtSSDist NumOfApproxPoints) 0.80]}]]/
   kLevsortedSum;
(*
   Print[" Distribution of wealth (k) 1%, 5%, 10%, 20%, 25%, 40%, 50%, 60%, 80%, Gini coeff: "];
   Print[N[{
    100 kLevTop1Percent, 
    100 kLevTop5Percent, 
    100 kLevTop10Percent, 
    100 kLevTop20Percent, 
    100 kLevTop25Percent, 
    100 kLevTop40Percent, 
    100 kLevTop50Percent, 
    100 kLevTop60Percent, 
    100 kLevTop80Percent, 
    GiniCoeff}]];
*)


(*
   Print[" Estimates of agg process, by good state and bad state: ", Flatten[{kAR1ByAggState[[1]], kAR1ByAggState[[3]]}]];
*)

(*
   Print[" R^2 if good, R^2 if bad: ", {RSquaredg,RSquaredb}];
*)

   Clear[KRat, EmpStatet, kRatt, sRatt, mRatt];
   
   ]; 

(* "GenPtSSDist" generates the steady state distribution of Pt (permanent income) *)
GenPtSSDist := Block[{},

   TimeStartPtSSDist = SessionTime[]; 

   Pt              = Table[1,{NumPeopleToGenPtSSDist}]; 
   DeathtMini      = Table[0, {Round[1/ProbOfDeath]}];
   DeathtMini[[1]] = 1;

   For[Periodt = 2, 

    Periodt <= PeriodsToGenPtSSDist,

    Psit   = Flatten[Table[RandomPermutation[PsiVec],     {Round[NumPeopleToGenPtSSDist/Length[PsiVec]]}]];
    Deatht = Flatten[Table[RandomPermutation[DeathtMini], {Round[NumPeopleToGenPtSSDist/Length[DeathtMini]]}]];
    Livet  = 1-Deatht;

    Ptm1   = Pt; 
    Ptm1   = Sort[Ptm1];
    Pt     = Ptm1 Psit; 

    NumLiv  = Total[Livet];
    PSumLiv = Pt.Livet;
    Pt      = Pt Livet/(PSumLiv/NumLiv) + Deatht; 
    Psit    = Pt/Ptm1; 
  
    Periodt++;

    ]; (* End For *)  

   PtSSDist = Pt; (* Steady state dist of Pt *)
   Clear[Pt];

   Print["Generated steady state distribution of Pt"];

   Print[" Time spent to generate steady state distribution of Pt (minutes): ",(SessionTime[]- TimeStartPtSSDist)/60]; 
   
   ]; 
