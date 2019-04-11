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

(* "SimulateRep" runs simulation with representative agent model with aggregate shocks *) 
SimulateRep := Block[{},

(*
  \[CapitalPsi]RandomNum = RandomPermutation[Flatten[Table[Table[i, {i, 1, Length[\[CapitalPsi]Vec]}], {PeriodsToSimulate/Length[\[CapitalPsi]Vec]}]]];
  \[CapitalTheta]RandomNum = RandomPermutation[Flatten[Table[Table[i, {i, 1, Length[\[CapitalTheta]Vec]}], {PeriodsToSimulate/Length[\[CapitalTheta]Vec]}]]];
*)

  (* First period *)
  (* Using common RandomNum lists *)
  \[CapitalPsi]t    = \[CapitalPsi]Vec[[Ceiling[\[CapitalPsi]RandomNum[[1]] Length[\[CapitalPsi]Vec]]]];
  \[CapitalTheta]t  = \[CapitalTheta]Vec[[Ceiling[\[CapitalTheta]RandomNum[[1]] Length[\[CapitalTheta]Vec]]]];

  CapitalP          = {\[CapitalPsi]t}; (* List of aggregate P *)
  \[CapitalTheta]   = {\[CapitalTheta]t};

  KRat     = {InitialCapital};
  MRat     = {(R[KRat[[1]]/\[CapitalTheta]t]-\[Delta]) KRat[[1]] + \[CapitalTheta]t W[KRat[[1]]/\[CapitalTheta]t]};
  CRat     = {Last[cInterpFunc][MRat[[1]]]};
   
  (* 2nd period and thereafter *)
  Periodt = 2;
  Do[SimulateAnotherPeriodRep, {PeriodsToSimulate-1}];
(*
  Print[" Mean of KRat: ", Total[Take[KRat   , -PeriodsToUse]]/PeriodsToUse]; 
*)

  (* Estimate AR1 process *)
  EstimateAR1; 

  (* Calc R^2 *)
  CalculateRSquared; 

  (* Calculate and display agg statistics *)
  CalcAggStats;

]; (* SimulateRep *) 

(* "SimulateAnotherPeriodRep" simulates the rep model one more period *)
SimulateAnotherPeriodRep := Block[{},

  (* Using common RandomNum lists *)
  \[CapitalPsi]t    = \[CapitalPsi]Vec[[Ceiling[\[CapitalPsi]RandomNum[[Periodt]] Length[\[CapitalPsi]Vec]]]];
  \[CapitalTheta]t  = \[CapitalTheta]Vec[[Ceiling[\[CapitalTheta]RandomNum[[Periodt]] Length[\[CapitalTheta]Vec]]]];

  AppendTo[CapitalP, Last[CapitalP]\[CapitalPsi]t]; 
  AppendTo[\[CapitalTheta], \[CapitalTheta]t]; 

  AppendTo[KRat, (MRat[[Periodt-1]] - CRat[[Periodt-1]])/(\[CapitalPsi]t)];
  (* Print[KRat[[Periodt]] ]; *)
  AppendTo[MRat, (R[KRat[[Periodt]]/\[CapitalTheta]t]-\[Delta]) KRat[[Periodt]] + \[CapitalTheta]t W[KRat[[Periodt]]/\[CapitalTheta]t]];
  AppendTo[CRat, Last[cInterpFunc][MRat[[Periodt]]]];
(*
  If[Periodt>PeriodsToSimulate-11, Print[" Last period-", PeriodsToSimulate-Periodt, " KRat=", KRat[[Periodt]]]];
*)
  Periodt = Periodt+1
]; (* End SimulateAnotherPeriodRep *)


(* "SimulateInd" runs simulation of model with individuals and idiosyncratic shocks *) 
SimulateInd     := Block[{},
(*
  If[Print[" Simulating..."]];  
*)

  StartSimulation = SessionTime[]; 

  (* Set up lists *)   
  If[Estimatet==1 (* If in the first estimation (of agg process) *), 
     kRatt  = InitialCapital Table[1,{NumPeopleToSim}]; 
     Pt     = Table[1,{NumPeopleToSim}];
     Psit   = Table[1,{NumPeopleToSim}]; (* Psi shock (permanent shock). *) 

   (* for later use, get steady dist of Aget when death from age is on *)
    If[DeathFromAge == Yes, (* if death from age is on *)
        Aget = Table[0, {NumPeopleToSim}];
        Do[DeathPost =  Table[Round[(i - 1)/ProbOfDeath] + 
            RandomInteger[{1, Round[1/ProbOfDeath]}], {i, 1, 
            Round[NumPeopleToSim ProbOfDeath]}];
           Deatht    = Table[0, {NumPeopleToSim}];
           Deatht[[DeathPost]] = 1;
           DeathAget = Map[If[# == 400, 1, 0] &, Aget]; (* dummy of death from age. die if live for 100 years (400 quarters) *)
           Deatht = Deatht (1 - DeathAget) + DeathAget; (* incorporate death from age *)
           Aget   = Aget (1 - Deatht) + 1,              (* age at end period. 1 if dead *)
          {1000}] (* end Do *)
     ];(* end if *)

   ];(* end if Estimatet==1 *)


  (* Replicate lists (now the size of sim is larger) *)
  If[Estimatet == TimesToEstimateSmall+1 && ModelType == Point,
     NumPeopleToSimOrig    = NumPeopleToSim;
     NumPeopleToSim        = NumPeopleToSimLarge;
     (* PatientIndicatorList  = Table[PatientIndicator,{NumPeopleToSim}]; *)
     kRatt = Flatten[Table[kRatt, {NumPeopleToSim/NumPeopleToSimOrig}]]; (* Replicate kRatt *)
     Pt    = Flatten[Table[Pt,    {NumPeopleToSim/NumPeopleToSimOrig}]]; (* Replicate Pt *)
     Psit   = Table[1,{NumPeopleToSim}]; (* Psi shock (permanent shock). *) 

       If[DeathFromAge == Yes,
          Aget   = Flatten[Table[Aget, {NumPeopleToSim/NumPeopleToSimOrig}]];     (* Replicate Aget *)
          Deatht = Flatten[Table[Deatht, {NumPeopleToSim/NumPeopleToSimOrig}]];   (* Replicate Deatht *)

          DeathAget = Map[If[# == 400, 1, 0] &, Aget]; (* dummy of death from age.die if live for 100 years (400 quarters) *)
          Deatht = Deatht (1 - DeathAget) + DeathAget; (* incorporate death from age *)
          Aget   = Aget (1 - Deatht) + 1               (* age at end period. 1 if dead *), 
          ]; (* end if DeathFromAge *)

     ]; (* End If *)
 
  If[Estimatet == TimesToEstimateSmall+1 && ModelType == Dist,

     NumPeopleToSimOrig    = NumPeopleToSim;
     NumPeopleToSim        = NumPeopleToSimLarge;

     (* PatientIndicatorList = Flatten[Table[
       Table[i, {Round[NumPeopleToSim/NumOfApproxPoints]}], {i, 1,NumOfApproxPoints}]]; *)

     kRatt = Flatten[Table[
       Table[Take[kRatt, {Round[NumPeopleToSimOrig/NumOfApproxPoints] (i - 1) + 1, Round[NumPeopleToSimOrig/NumOfApproxPoints] i}], 
        {NumPeopleToSim/NumPeopleToSimOrig}], {i, 1, NumOfApproxPoints}]];

     Pt = Flatten[Table[
       Table[Take[Pt, {Round[NumPeopleToSimOrig/NumOfApproxPoints] (i - 1) + 1, Round[NumPeopleToSimOrig/NumOfApproxPoints] i}], 
        {NumPeopleToSim/NumPeopleToSimOrig}], {i, 1, NumOfApproxPoints}]];

     Psit   = Table[1,{NumPeopleToSim}]; (* Psi shock (permanent shock). *) 

       If[DeathFromAge == Yes,

          Aget = Flatten[Table[
             Table[Take[Aget, {Round[NumPeopleToSimOrig/NumOfApproxPoints] (i - 1) + 1, Round[NumPeopleToSimOrig/NumOfApproxPoints] i}], 
            {NumPeopleToSim/NumPeopleToSimOrig}], {i, 1, NumOfApproxPoints}]];

          Deatht = Flatten[Table[
             Table[Take[Deatht , {Round[NumPeopleToSimOrig/NumOfApproxPoints] (i - 1) + 1, Round[NumPeopleToSimOrig/NumOfApproxPoints] i}], {NumPeopleToSim/NumPeopleToSimOrig}], {i, 1, NumOfApproxPoints}]];

          DeathAget = Map[If[# == 400, 1, 0] &, Aget]; (* dummy of death from age. die if live for 100 years (400 quarters) *)
          Deatht = Deatht (1 - DeathAget) + DeathAget; (* incorporate death from age *)
          Aget   = Aget (1 - Deatht) + 1,              (* age at end period. 1 if dead *)
          ]; (* end if DeathFromAge *)

    ]; (* End If *)  

  (* First period *)
  If[ModelType == Dist && Estimatet  > TimesToEstimateSmall, Print[" Simulating period 1"]]; 
  KRat = {(kRatt.Pt)/Length[kRatt]/(lbar (1-u))};

  (* Distribution of wealth (capital) *)
  kLevtsorted     = Sort[kRatt Pt]; (* Sort by k level *)
  kLevtsortedSum  = Total[kLevtsorted];
  kLevtsortedMean = kLevtsortedSum/NumPeopleToSim;
  DumBetween05And15t  =  Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];

  GiniCoeff          = {(2/(NumPeopleToSim^2 kLevtsortedMean)) (Table[i,{i,1,NumPeopleToSim}].(kLevtsorted-kLevtsortedMean))};
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

  \[CapitalPsi]t    = \[CapitalPsi]Vec[[Ceiling[\[CapitalPsi]RandomNum[[1]] Length[\[CapitalPsi]Vec]]]];
  \[CapitalTheta]t  = \[CapitalTheta]Vec[[Ceiling[\[CapitalTheta]RandomNum[[1]] Length[\[CapitalTheta]Vec]]]];

  CapitalP          = {\[CapitalPsi]t}; (* List of aggregate P *)
  \[CapitalTheta]   = {\[CapitalTheta]t};

  (* Calculate cRatt *)
  EmpStatet = RandomPermutation[Join[Table[0, {Round[NumPeopleToSim u]}], 
   Table[1, {NumPeopleToSim - Round[NumPeopleToSim u]}]]]; (* 1 if employed, 0 if unemployed *)
  Thetat = Flatten[Table[RandomPermutation[ThetaVecOrig], {NumPeopleToSim/Length[ThetaVecOrig]}]];
  Xit    = EmpStatet Thetat (1 - UnempWage u/(lbar (1-u))) lbar + (1-EmpStatet) UnempWage;
(*
  Xit    = EmpStatet (Thetat - u UnempWage)/(1-u)+ (1-EmpStatet) UnempWage;
*)
  yRatt  = W[KRat[[1]]/\[CapitalTheta]t] \[CapitalTheta]t Xit;   
  mRatt  = (R[KRat[[1]]/\[CapitalTheta]t]-\[Delta]) kRatt + yRatt;

  If[ModelType == Point (* If model is Point *),
     cRatt  = Last[cInterpFunc][mRatt, KRat[[1]]]
     ]; (* End If Point *)

  If[ModelType == Dist (* If model is Dist *),
     cRatt = Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatt, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRat[[1]]], {i, 1, NumOfApproxPoints}]]
     ]; (* End If Dist *)
  
  MRat = {(mRatt.Pt)/Length[mRatt]}/(lbar (1-u));
  CRat = {(cRatt.Pt)/Length[cRatt]}/(lbar (1-u));

  (* Calculate MPC *)
  If[Estimatet > TimesToEstimateSmall+1, 

  If[ModelType == Point (* If model is Point *),
     MPCt = (Last[cInterpFunc][mRatt+d, KRat[[1]]]-cRatt)/d
     ]; (* End If Point *)

  If[ModelType == Dist (* If model is Dist *),
     MPCt = (Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatt+d, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRat[[1]]], {i, 1, NumOfApproxPoints}]]-cRatt)/d
     ]; (* End If Dist *)

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


  OrderingkLev                 = Ordering[kRatt Pt];(*Order of kLev*)
  MPCtOrderedBykLev            = MPCt[[OrderingkLev]];
  MPCTopOneThirdt              = Sort[MPCt][[Round[(-1/3) NumPeopleToSim]]]; 
  MPCTopOneThird               = {MPCTopOneThirdt}; 
  DumMPCTopOneThirdMPCbykLev = Map[If[# >= MPCTopOneThirdt, 1, 0] &, MPCtOrderedBykLev];

  (* ShareInPctTopOneThirdMPCbykLev80100 + ShareInPctTopOneThirdMPCbykLev6080 + ... + ShareInPctTopOneThirdMPCbykLev0020 = 100 *)
  ShareInPctTopOneThirdMPCbykLev80100 = {Total[Take[
       DumMPCTopOneThirdMPCbykLev, {1, Round[0.2 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100}; (* share among households with top 1/3 MPCs, in bottm 20 in wealth levels *)

  ShareInPctTopOneThirdMPCbykLev6080 = {Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.2 NumPeopleToSim] + 1, Round[0.4 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100};

  ShareInPctTopOneThirdMPCbykLev4060 = {Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.4 NumPeopleToSim] + 1, Round[0.6 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100};

  ShareInPctTopOneThirdMPCbykLev2040 = {Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.6 NumPeopleToSim] + 1, Round[0.8 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100};

  ShareInPctTopOneThirdMPCbykLev0020 = {Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.8 NumPeopleToSim] + 1, Round[NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100}; (* top 20 % in wealth levels *)
  

  (* MPC lists to run experiments with large perm shock and large tran shock *)
  MPCLargeBadPerm                = MPCLargeBadTran = MPC; 

  MPCLargeBadPermTop1Percent     = MPCLargeBadTranTop1Percent     = MPCTop1Percent; 
  MPCLargeBadPermTop10Percent    = MPCLargeBadTranTop10Percent    = MPCTop10Percent; 
  MPCLargeBadPermTop20Percent    = MPCLargeBadTranTop20Percent    = MPCTop20Percent; 
  MPCLargeBadPermTop40Percent    = MPCLargeBadTranTop40Percent    = MPCTop40Percent; 
  MPCLargeBadPermTop60Percent    = MPCLargeBadTranTop60Percent    = MPCTop60Percent; 
  MPCLargeBadPermBottom40Percent = MPCLargeBadTranBottom40Percent = MPCBottom40Percent; 
  MPCLargeBadPermBottom20Percent = MPCLargeBadTranBottom20Percent = MPCBottom20Percent; 
  MPCLargeBadPermBottom3Quart    = MPCLargeBadTranBottom3Quart    = MPCBottom3Quart; 
  MPCLargeBadPermBottomHalf      = MPCLargeBadTranBottomHalf      = MPCBottomHalf; 
  MPCLargeBadPermBottomQuart     = MPCLargeBadTranBottomQuart     = MPCBottomQuart; 
    
  MPCLargeBadPermEmp             = MPCLargeBadTranEmp   = MPCEmp; 
  MPCLargeBadPermUnemp           = MPCLargeBadTranUnemp = MPCUnemp; 
    
  MPCLargeBadPermTop1PercentByk     = MPCLargeBadTranTop1PercentByk     = MPCTop1PercentByk; 
  MPCLargeBadPermTop10PercentByk    = MPCLargeBadTranTop10PercentByk    = MPCTop10PercentByk; 
  MPCLargeBadPermTop20PercentByk    = MPCLargeBadTranTop20PercentByk    = MPCTop20PercentByk; 
  MPCLargeBadPermTop40PercentByk    = MPCLargeBadTranTop40PercentByk    = MPCTop40PercentByk; 
  MPCLargeBadPermTop60PercentByk    = MPCLargeBadTranTop60PercentByk    = MPCTop60PercentByk; 
  MPCLargeBadPermBottom40PercentByk = MPCLargeBadTranBottom40PercentByk = MPCBottom40PercentByk; 
  MPCLargeBadPermBottom20PercentByk = MPCLargeBadTranBottom20PercentByk = MPCBottom20PercentByk; 
  MPCLargeBadPermBottom3QuartByk    = MPCLargeBadTranBottom3QuartByk    = MPCBottom3QuartByk; 
  MPCLargeBadPermBottomHalfByk      = MPCLargeBadTranBottomHalfByk      = MPCBottomHalfByk; 
  MPCLargeBadPermBottomQuartByk     = MPCLargeBadTranBottomQuartByk     = MPCBottomQuartByk; 


  (* Alternative (simulation) MPCs *)
  If[ModelType == Dist (* If model is Dist *),
  AverageyRat  = Mean[yRatt];           (* average wage income *)
  AverageyLev  = (yRatt.Pt)/Length[yRatt]; (* Level of average wage income *)
  StimulusRatt = StimulusSize AverageyLev/Pt;

  (* calc c's over a year given stimulus *)  
  mAltRatt = mRatt + StimulusRatt;
  cAltRatt = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRatt, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatt; 

  mAltRattp1 = (R[KRat[[1]]] - \[Delta]) (mAltRatt - cAltRatt) + AverageyRat; (* assume no death *)
  Clear[mAltRatt, cAltRatt];
  cAltRattp1 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRattp1, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatCumt + cAltRattp1; 

  mAltRattp2 = (R[KRat[[1]]] - \[Delta]) (mAltRattp1 - cAltRattp1) + AverageyRat;
  Clear[mAltRattp1, cAltRattp1];
  cAltRattp2 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRattp2, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatCumt + cAltRattp2; 

  mAltRattp3 = (R[KRat[[1]]] - \[Delta]) (mAltRattp2 - cAltRattp2) + AverageyRat;
  Clear[mAltRattp2, cAltRattp2];
  cAltRattp3 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRattp3, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatCumt + cAltRattp3; 

  Clear[mAltRattp3, cAltRattp3];
  

  (* calc alt c's over a year  with no stimulus *)
  mRattp1 = (R[KRat[[1]]] - \[Delta]) (mRatt - cRatt) + AverageyRat;
  cRattp1 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mRattp1, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cRatCumt = cRatt + cRattp1; 

  mRattp2 = (R[KRat[[1]]] - \[Delta]) (mRattp1 - cRattp1) + AverageyRat;
  Clear[mRattp1, cRattp1];
  cRattp2 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mRattp2, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cRatCumt = cRatCumt + cRattp2; 

  mRattp3 = (R[KRat[[1]]] - \[Delta]) (mRattp2 - cRattp2) + AverageyRat;
  Clear[mRattp2, cRattp2];
  cRattp3 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mRattp3, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[1]]], {i, 1, NumOfApproxPoints}]];
  cRatCumt = cRatCumt + cRattp3; 

  Clear[mRattp3, cRattp3];
  
  (* Alternative (simulation) MPCs. calc how much you would spend MORE over a year, given stimulus  *)
  MPCAltt = (cAltRatCumt - cRatCumt)/StimulusRatt;

  Clear[cAltRatCumt, cRatCumt, StimulusRatt];

(*
  OrderingyLev    = Ordering[yRatt Pt];
*)
  MPCAlt             = {Mean[MPCAltt]};
  MPCAlttOrdered     = MPCAltt[[OrderingyLev]];
  MPCAltTop1Percent  = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.01)]]};
  MPCAltTop10Percent = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.10)]]};
  MPCAltTop20Percent = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.20)]]};
  MPCAltTop40Percent = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.40)]]};
  MPCAltTop60Percent = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.60)]]};

  MPCAltBottom40Percent = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (0.40)]]};
  MPCAltBottom20Percent = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (0.20)]]};

  MPCAltBottom3Quart = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (3/4)]]};
  MPCAltBottomHalf   = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (1/2)]]};
  MPCAltBottomQuart  = {Mean[Take[MPCAlttOrdered,NumPeopleToSim (1/4)]]};
  NumOfEmployed   = Total[EmpStatet];
  MPCAltEmp          = {MPCAltt.EmpStatet/NumOfEmployed}; 
  MPCAltUnemp        = {MPCAltt.(1-EmpStatet)/(NumPeopleToSim-NumOfEmployed)};

(*
  OrderingkRat    = Ordering[kRatt];
*)
  MPCAlttOrderedByk  = MPCAltt[[OrderingkRat]];

  MPCAltTop1PercentByk  = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.01)]]};
  MPCAltTop10PercentByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.10)]]};
  MPCAltTop20PercentByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.20)]]};
  MPCAltTop40PercentByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.40)]]};
  MPCAltTop60PercentByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.60)]]};

  MPCAltBottom40PercentByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (0.40)]]};
  MPCAltBottom20PercentByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (0.20)]]};

  MPCAltBottom3QuartByk = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (3/4)]]};
  MPCAltBottomHalfByk   = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (1/2)]]};
  MPCAltBottomQuartByk  = {Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (1/4)]]}
  
  
  ];(* End If Dist *)

  ];

  sRatt  = mRatt- cRatt;
  sLevt  = sRatt Pt ; (* for later use *)

  If[ModelType == Dist (* If model is Dist *),

   TotyRatt = mRatt - (1-\[Delta]) kRatt; (* total income including wage and capital income *)

   kLev25thPercentileFracOfAveIncome   = {kLevtsorted[[Round[NumPeopleToSim 0.75]]]/(4 (TotyRatt.Pt)/Length[TotyRatt])}; (* (4 (TotyRatt.Pt)/Length[TotyRatt]) = average ANNUAL income *)

   kLevMedianFracOfAveIncome           = {kLevtsorted[[Round[NumPeopleToSim 0.50]]]/(4 (TotyRatt.Pt)/Length[TotyRatt])};

   kLevMeanFracOfAveIncome             = {Mean[kLevtsorted]/(4 (TotyRatt.Pt)/Length[TotyRatt])};


   (* calc wealth (net worth) to annual total (wage and capital) income ratio by wealth ratio (kRatt/TotyRatt) *)
   OrderingkRat         = Ordering[kRatt/TotyRatt]; (* Order of kRatt/TotyRatt *)
   kRattsortedTemp      = kRatt[[OrderingkRat]];
   TotyRattsortedBykRat = TotyRatt[[OrderingkRat]];
   
   kTotyRatbykRat10thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.10]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]]) }; (* annual term *)
   kTotyRatbykRat15thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.15]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.15]]]) }; 
   kTotyRatbykRat20thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.20]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.20]]]) }; 
   kTotyRatbykRat25thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.25]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.25]]]) }; 
   kTotyRatbykRat30thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.30]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.30]]]) }; 
   kTotyRatbykRat40thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.40]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.40]]]) }; 
   kTotyRatbykRat60thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.60]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.60]]]) }; 
   kTotyRatbykRat80thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.80]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.80]]]) }; 
   kTotyRatbykRat90thPercentile   = {kRattsortedTemp[[Round[NumPeopleToSim 0.90]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.90]]]) }; 


   (* calc wealth (net worth) to annual total (wage and capital) income ratio by wealth level *)
   OrderingkLev      = Ordering[kRatt Pt]; (* Order of kLev *)
   kLevtsortedTemp   = Sort[kRatt Pt];
   TotyLevt             = TotyRatt Pt;
   TotyLevtsortedBykLev = TotyLevt[[OrderingkLev]];
   
   kTotyRat10thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.10]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.10]]]) }; (* annual term *)
   kTotyRat15thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.15]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.15]]]) }; 
   kTotyRat20thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.20]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.20]]]) }; 
   kTotyRat25thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.25]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.25]]]) }; 
   kTotyRat30thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.30]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.30]]]) }; 
   kTotyRat40thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.40]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.40]]]) }; 
   kTotyRat60thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.60]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.60]]]) }; 
   kTotyRat80thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.80]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.80]]]) }; 
   kTotyRat90thPercentile   = {kLevtsortedTemp[[Round[NumPeopleToSim 0.90]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.90]]]) }; 
  
    ]; (* End If Dist *)

  Clear[Xit, cRatt];

  (* 2nd period and thereafter *)      
  Periodt = 2;          
  Do[SimulateAnotherPeriodInd,{PeriodsToSimulate-1}];  
  (* Print[" Mean of KRat: ", Total[Take[KRat   , -PeriodsToUse]]/PeriodsToUse]; *)  
  Clear[sRatt];                  

  (* Estimate AR1 process *)
  EstimateAR1; 

  (* Calc R^2 *)
  CalculateRSquared; 

  (* Calculate and display agg statistics *)
  If[Estimatet  > TimesToEstimateSmall+1 && GapCoeff <= MaxGapCoeff, CalcAggStats];

  (* Calculate and display distribution of wealth (capital) *)
  If[Estimatet  > TimesToEstimateSmall+1, CalcDistStas];

  (* Calculate and display MPC *)
  If[Estimatet  > TimesToEstimateSmall+1 && GapCoeff <= MaxGapCoeff, CalcMPC];

  Print[" Estimates of agg process: ", LogKRatAR];
  Print[" R^2: ", N[Round[1000 RSquared]/1000]];

  EndSimulation   = SessionTime[]; 
  Print[" Time spent to simulate (minutes): ", (EndSimulation - StartSimulation)/60]; 

]; (* End SimulateInd *) 

(* "SimulateAnotherPeriodInd" simulates the model one more period *)
SimulateAnotherPeriodInd := Block[{},

  If[ModelType == Dist && Estimatet  > TimesToEstimateSmall,
   If[Mod[Periodt, 500] == 0, Print[" Simulating period ", Periodt]]
  ];

  \[CapitalPsi]t    = \[CapitalPsi]Vec[[Ceiling[\[CapitalPsi]RandomNum[[Periodt]] Length[\[CapitalPsi]Vec]]]];
  \[CapitalTheta]t  = \[CapitalTheta]Vec[[Ceiling[\[CapitalTheta]RandomNum[[Periodt]] Length[\[CapitalTheta]Vec]]]];

  AppendTo[CapitalP, Last[CapitalP]\[CapitalPsi]t]; 
  AppendTo[\[CapitalTheta], \[CapitalTheta]t]; 

  EmpStatet = RandomPermutation[Join[Table[0, {Round[NumPeopleToSim u]}], 
   Table[1, {NumPeopleToSim - Round[NumPeopleToSim u]}]]]; (* 1 if employed, 0 if unemployed *)

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

  (* Avoid a case where only households with very high (low) sLev die *)
  PickOnePerSubPop      = Table[Random[Integer, {1, 1/ProbOfDeath}] + 1/ProbOfDeath(i - 1), {i, NumPeopleToSim ProbOfDeath}];
  PosOfKilled           = sLevtOrdering[[PickOnePerSubPop]];
  Deatht                = Table[0, {NumPeopleToSim}];
  Deatht[[PosOfKilled]] = 1;

       If[DeathFromAge == Yes, 
          DeathAget = Map[If[# == 400, 1, 0] &, Aget];    (* dummy of death from age. die if live for 100 years (400 quarters) *)
          Deatht    = Deatht (1 - DeathAget) + DeathAget; (* incorporate death from age *)
          Aget = Aget (1 - Deatht) + 1                    (* age at end period. add age 1 if alive *)
          ]; (* end if DeathFromAge *)

  (* Avoid a case where only households with very high (low) sLev receive high (low) perm / tran inc shocks *)
  PsitDrawList            = Flatten[Table[RandomPermutation[PsiVec], {Round[NumPeopleToSim/Length[PsiVec]]}]];
  Psit[[sLevtOrdering]]   = PsitDrawList;
  ThetaDrawList           = Flatten[Table[RandomPermutation[ThetaVecOrig], {Round[NumPeopleToSim/Length[ThetaVecOrig]]}]];
  Thetat[[sLevtOrdering]] = ThetaDrawList;
 
  Clear[sLevtOrdering, PsitDrawList,ThetaDrawList];

  Livet  = 1-Deatht;  

  (* Renormalize shocks. 
  In the population, death and unemployment are independent of permanent income, so permanent income for all four subgroups (dying or not, unemployed or not) should be 1.
  For a finite sample, this will not be exactly true.  Unless the simulated population is enormous, the aggregate will occasionally be noticeably disturbed by the death of a particularly wealthy individual.
  The following code fixes this problem by renormalizing the shocks to each subgroup (dying, living and unemployed, and living and employed) so that the group mean level of P is one. This would have no effect in an infinite sample, but substantially reduces the sample size necessary for the law of large numbers to smooth out the aggregate fluctuations that would otherwise result from the deaths of the wealthiest individuals. (Below, transitory income shoks are also normalized.) *)  
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

  (* Adjust kRatt so that mean of kLevt is equal to its expected value *)
  kLevtMeanPredicted = Mean[sLevt];
  kLevtMean          = Mean[(sLevt Livet/(1-Total[Deatht]/Length[Deatht]))];
  AdjustmentFactor   = kLevtMean/kLevtMeanPredicted;
  kRatt      = (sRatt/(\[CapitalPsi]t Psit (1-Total[Deatht]/Length[Deatht]))) Livet/AdjustmentFactor; (* If dead, replaced by an unrelated newborn and kRatt = 0. *)

  AppendTo[KRat, (kRatt.Pt)/Length[kRatt]/(lbar (1-u))];

  (* Distribution of wealth (capital) *)
  kLevtsorted        = Sort[kRatt Pt];
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

  (* Calculate cRatt *)
  Xit    = EmpStatet Thetat (1 - UnempWage u/(lbar (1-u))) lbar + (1-EmpStatet) UnempWage;
(*
  Xit   = EmpStatet (Thetat  - u UnempWage)/(1-u)+ (1-EmpStatet) UnempWage;
*)
  yRatt = W[KRat[[Periodt]]/\[CapitalTheta]t] \[CapitalTheta]t Xit; 
  mRatt = (R[KRat[[Periodt]]/\[CapitalTheta]t]-\[Delta]) kRatt + yRatt;

  If[ModelType == Point (* If model is Point *),
     cRatt  = Last[cInterpFunc][mRatt, KRat[[Periodt]]]
     ]; (* End If Point *)

  If[ModelType == Dist (* If model is Dist *),
     cRatt = Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatt, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]]
     ]; (* End If Dist *)

  AppendTo[MRat,    (mRatt.Pt)/Length[mRatt]/(lbar (1-u))];
  AppendTo[CRat,    (cRatt.Pt)/Length[cRatt]/(lbar (1-u))];

  (* Calculate MPC *)

  If[Estimatet > TimesToEstimateSmall+1, 

  If[ModelType == Point (* If model is Point *),
     MPCt = (Last[cInterpFunc][mRatt+d, KRat[[Periodt]]]-cRatt)/d
     ]; (* End If Point *)

  If[ModelType == Dist (* If model is Dist *),
     MPCt = (Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatt+d, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]]-cRatt)/d
     ]; (* End If Dist *)

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


  OrderingkLev                 = Ordering[kRatt Pt];(*Order of kLev*)
  MPCtOrderedBykLev            = MPCt[[OrderingkLev]];
  MPCTopOneThirdt              = Sort[MPCt][[Round[(-1/3) NumPeopleToSim]]]; 
  AppendTo[MPCTopOneThird,  MPCTopOneThirdt];

  DumMPCTopOneThirdMPCbykLev = Map[If[# >= MPCTopOneThirdt, 1, 0] &, MPCtOrderedBykLev]; 

  (* ShareInPctTopOneThirdMPCbykLev80100 + ShareInPctTopOneThirdMPCbykLev6080 + ... + ShareInPctTopOneThirdMPCbykLev0020 = 100 *)
  AppendTo[ShareInPctTopOneThirdMPCbykLev80100,  Total[Take[
       DumMPCTopOneThirdMPCbykLev, {1, Round[0.2 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100]; (* bottom 20 in wealth levels *)
  AppendTo[ShareInPctTopOneThirdMPCbykLev6080,  Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.2 NumPeopleToSim] + 1, Round[0.4 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100]; 
  AppendTo[ShareInPctTopOneThirdMPCbykLev4060,  Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.4 NumPeopleToSim] + 1, Round[0.6 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100]; 
  AppendTo[ShareInPctTopOneThirdMPCbykLev2040,  Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.6 NumPeopleToSim] + 1, Round[0.8 NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100]; 
  AppendTo[ShareInPctTopOneThirdMPCbykLev0020,  Total[Take[
       DumMPCTopOneThirdMPCbykLev, {Round[0.8 NumPeopleToSim] + 1, Round[NumPeopleToSim]}]]/Total[DumMPCTopOneThirdMPCbykLev]*100]; (* top 20 % in wealth levels *) 


  (* calc MPCs when a large perm/tran shock is given *)
  If[ModelType == Dist (* If model is Dist *),

     (* calc MPCs when a large perm shock is given *)
     kRatLargeBadPermt = (sRatt/(LargeBad\[CapitalPsi]t Psit (1-Total[Deatht]/Length[Deatht]))) Livet/AdjustmentFactor; (* If dead, replaced by an unrelated newborn and kRatt = 0. *)
     KRatLargeBadPermt = (kRatLargeBadPermt.Pt)/Length[kRatLargeBadPermt]/(lbar (1-u)); 
     yRatLargeBadPermt = W[KRatLargeBadPermt/\[CapitalTheta]t] \[CapitalTheta]t Xit; 
     mRatLargeBadPermt = (R[KRat[[Periodt]]/\[CapitalTheta]t]-\[Delta]) kRatLargeBadPermt + yRatLargeBadPermt;
     cRatLargeBadPermt = Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatLargeBadPermt, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRatLargeBadPermt], {i, 1, NumOfApproxPoints}]]; 
     MPCLargeBadPermt = (Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatLargeBadPermt+d, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRatLargeBadPermt], {i, 1, NumOfApproxPoints}]]-cRatLargeBadPermt)/d; (* calc MPCs when a large permanent shock is given *)

(*
     Print["period"];
     Print[Periodt]; 
     Print[Mean[kRatLargeBadPermt]];
     Print[Mean[cRatLargeBadPermt]];
     Print[Mean[MPCLargeBadPermt]];
*)

     (* calc MPCs when a large transitory shock is given *)
     yRatLargeBadTrant = W[KRat[[Periodt]]/LargeBad\[CapitalTheta]t] LargeBad\[CapitalTheta]t Xit; 
     mRatLargeBadTrant = (R[KRat[[Periodt]]/LargeBad\[CapitalTheta]t]-\[Delta]) kRatt + yRatLargeBadTrant;
     cRatLargeBadTrant = Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatLargeBadTrant, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]]; 
     MPCLargeBadTrant = (Flatten[Table[cInterpFuncList[[i, -1]][Take[mRatLargeBadTrant+d, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 1, (NumPeopleToSim/NumOfApproxPoints) i}], KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]]-cRatLargeBadTrant)/d; (* calc MPCs when a large transitory shock is given *)


     (* (average) MPCs when a large perm shock is given *)
     AppendTo[MPCLargeBadPerm ,     Mean[MPCLargeBadPermt]];
     MPCLargeBadPermtOrdered     = MPCLargeBadPermt[[OrderingyLev]]; (* OrderingyLev is calculated above *)

     AppendTo[MPCLargeBadPermTop1Percent,  Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (-0.01)]]];
     AppendTo[MPCLargeBadPermTop10Percent, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (-0.10)]]];
     AppendTo[MPCLargeBadPermTop20Percent, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (-0.20)]]];
     AppendTo[MPCLargeBadPermTop40Percent, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (-0.40)]]];
     AppendTo[MPCLargeBadPermTop60Percent, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (-0.60)]]];

     AppendTo[MPCLargeBadPermBottom40Percent, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (0.40)]]];
     AppendTo[MPCLargeBadPermBottom20Percent, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (0.20)]]];

     AppendTo[MPCLargeBadPermBottom3Quart, Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (3/4)]]];
     AppendTo[MPCLargeBadPermBottomHalf,   Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (1/2)]]];
     AppendTo[MPCLargeBadPermBottomQuart,  Mean[Take[MPCLargeBadPermtOrdered,NumPeopleToSim (1/4)]]];

     AppendTo[MPCLargeBadPermEmp,   MPCLargeBadPermt.EmpStatet/NumOfEmployed];
     AppendTo[MPCLargeBadPermUnemp, MPCLargeBadPermt.(1-EmpStatet)/(NumPeopleToSim-NumOfEmployed)];

     MPCLargeBadPermtOrderedByk  = MPCLargeBadPermt[[OrderingkRat]];

     AppendTo[MPCLargeBadPermTop1PercentByk,  Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (-0.01)]]];
     AppendTo[MPCLargeBadPermTop10PercentByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (-0.10)]]];
     AppendTo[MPCLargeBadPermTop20PercentByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (-0.20)]]];
     AppendTo[MPCLargeBadPermTop40PercentByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (-0.40)]]];
     AppendTo[MPCLargeBadPermTop60PercentByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (-0.60)]]];

     AppendTo[MPCLargeBadPermBottom40PercentByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (0.40)]]];
     AppendTo[MPCLargeBadPermBottom20PercentByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (0.20)]]];

     AppendTo[MPCLargeBadPermBottom3QuartByk, Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (3/4)]]];
     AppendTo[MPCLargeBadPermBottomHalfByk,   Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (1/2)]]];
     AppendTo[MPCLargeBadPermBottomQuartByk,  Mean[Take[MPCLargeBadPermtOrderedByk,NumPeopleToSim (1/4)]]];


     (* (average) MPCs when a large tran shock is given *)
     AppendTo[MPCLargeBadTran ,     Mean[MPCLargeBadTrant]];
     MPCLargeBadTrantOrdered     = MPCLargeBadTrant[[OrderingyLev]]; (* OrderingyLev is calculated above *)

     AppendTo[MPCLargeBadTranTop1Percent,  Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (-0.01)]]];
     AppendTo[MPCLargeBadTranTop10Percent, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (-0.10)]]];
     AppendTo[MPCLargeBadTranTop20Percent, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (-0.20)]]];
     AppendTo[MPCLargeBadTranTop40Percent, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (-0.40)]]];
     AppendTo[MPCLargeBadTranTop60Percent, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (-0.60)]]];

     AppendTo[MPCLargeBadTranBottom40Percent, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (0.40)]]];
     AppendTo[MPCLargeBadTranBottom20Percent, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (0.20)]]];

     AppendTo[MPCLargeBadTranBottom3Quart, Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (3/4)]]];
     AppendTo[MPCLargeBadTranBottomHalf,   Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (1/2)]]];
     AppendTo[MPCLargeBadTranBottomQuart,  Mean[Take[MPCLargeBadTrantOrdered,NumPeopleToSim (1/4)]]];

     AppendTo[MPCLargeBadTranEmp,   MPCLargeBadTrant.EmpStatet/NumOfEmployed];
     AppendTo[MPCLargeBadTranUnemp, MPCLargeBadTrant.(1-EmpStatet)/(NumPeopleToSim-NumOfEmployed)];

     MPCLargeBadTrantOrderedByk  = MPCLargeBadTrant[[OrderingkRat]];

     AppendTo[MPCLargeBadTranTop1PercentByk,  Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (-0.01)]]];
     AppendTo[MPCLargeBadTranTop10PercentByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (-0.10)]]];
     AppendTo[MPCLargeBadTranTop20PercentByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (-0.20)]]];
     AppendTo[MPCLargeBadTranTop40PercentByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (-0.40)]]];
     AppendTo[MPCLargeBadTranTop60PercentByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (-0.60)]]];

     AppendTo[MPCLargeBadTranBottom40PercentByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (0.40)]]];
     AppendTo[MPCLargeBadTranBottom20PercentByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (0.20)]]];

     AppendTo[MPCLargeBadTranBottom3QuartByk, Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (3/4)]]];
     AppendTo[MPCLargeBadTranBottomHalfByk,   Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (1/2)]]];
     AppendTo[MPCLargeBadTranBottomQuartByk,  Mean[Take[MPCLargeBadTrantOrderedByk,NumPeopleToSim (1/4)]]];


     Clear[yRatLargeBadPermt, mRatLargeBadPermt, cRatLargeBadPermt, MPCLargeBadPermt];
     Clear[yRatLargeBadTrant, mRatLargeBadTrant, cRatLargeBadTrant, MPCLargeBadTrant];

     ]; (* End If Dist *)


  (* Alternative (simulation) MPCs *)
  If[ModelType == Dist (* If model is Dist *),
  AverageyRat  = Mean[yRatt];           (* average wage income *)
  AverageyLev  = (yRatt.Pt)/Length[yRatt]; (* Level of average wage income *)
  StimulusRatt = StimulusSize AverageyLev/Pt;

(*
  Print["period"];
  Print[Periodt]; 
*)

  (* calc c's over a year given stimulus *)  
  mAltRatt = mRatt + StimulusRatt;
  cAltRatt = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRatt, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatt; 

  mAltRattp1 = (R[KRat[[Periodt]]] - \[Delta]) (mAltRatt - cAltRatt) + AverageyRat; (* assume no death *)
  Clear[mAltRatt, cAltRatt];
  cAltRattp1 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRattp1, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatCumt + cAltRattp1; 

  mAltRattp2 = (R[KRat[[Periodt]]] - \[Delta]) (mAltRattp1 - cAltRattp1) + AverageyRat;
  Clear[mAltRattp1, cAltRattp1];
  cAltRattp2 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRattp2, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatCumt + cAltRattp2; 

  mAltRattp3 = (R[KRat[[Periodt]]] - \[Delta]) (mAltRattp2 - cAltRattp2) + AverageyRat;
  Clear[mAltRattp2, cAltRattp2];
  cAltRattp3 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mAltRattp3, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cAltRatCumt = cAltRatCumt + cAltRattp3; 

  Clear[mAltRattp3, cAltRattp3];
  

  (* calc alt c's over a year  with no stimulus *)
  mRattp1 = (R[KRat[[Periodt]]] - \[Delta]) (mRatt - cRatt) + AverageyRat;
  cRattp1 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mRattp1, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cRatCumt = cRatt + cRattp1; 

  mRattp2 = (R[KRat[[Periodt]]] - \[Delta]) (mRattp1 - cRattp1) + AverageyRat;
  Clear[mRattp1, cRattp1];
  cRattp2 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mRattp2, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cRatCumt = cRatCumt + cRattp2; 

  mRattp3 = (R[KRat[[Periodt]]] - \[Delta]) (mRattp2 - cRattp2) + AverageyRat;
  Clear[mRattp2, cRattp2];
  cRattp3 = 
   Flatten[Table[
     cInterpFuncList[[i, -1]][
      Take[mRattp3, {(NumPeopleToSim/NumOfApproxPoints) (i - 1) + 
         1, (NumPeopleToSim/NumOfApproxPoints) i}], 
      KRat[[Periodt]]], {i, 1, NumOfApproxPoints}]];
  cRatCumt = cRatCumt + cRattp3; 

  Clear[mRattp3, cRattp3];
  
  (* Alternative (simulation) MPCs. calc how much you would spend MORE over a year, given stimulus  *)
  MPCAltt = (cAltRatCumt - cRatCumt)/StimulusRatt;

  Clear[cAltRatCumt, cRatCumt, StimulusRatt];

(*
  OrderingyLev    = Ordering[yRatt Pt]; (* Order of yLev, for later use *)
*)
  AppendTo[MPCAlt,     Mean[MPCAltt]];
  MPCAlttOrdered     = MPCAltt[[OrderingyLev]]; (* OrderingyLev is calculated above *)

  AppendTo[MPCAltTop1Percent,  Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.01)]]];
  AppendTo[MPCAltTop10Percent, Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.10)]]];
  AppendTo[MPCAltTop20Percent, Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.20)]]];
  AppendTo[MPCAltTop40Percent, Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.40)]]];
  AppendTo[MPCAltTop60Percent, Mean[Take[MPCAlttOrdered,NumPeopleToSim (-0.60)]]];

  AppendTo[MPCAltBottom40Percent, Mean[Take[MPCAlttOrdered,NumPeopleToSim (0.40)]]];
  AppendTo[MPCAltBottom20Percent, Mean[Take[MPCAlttOrdered,NumPeopleToSim (0.20)]]];

  AppendTo[MPCAltBottom3Quart, Mean[Take[MPCAlttOrdered,NumPeopleToSim (3/4)]]];
  AppendTo[MPCAltBottomHalf,   Mean[Take[MPCAlttOrdered,NumPeopleToSim (1/2)]]];
  AppendTo[MPCAltBottomQuart,  Mean[Take[MPCAlttOrdered,NumPeopleToSim (1/4)]]];

  NumOfEmployed   = Total[EmpStatet];
  AppendTo[MPCAltEmp,   MPCAltt.EmpStatet/NumOfEmployed];
  AppendTo[MPCAltUnemp, MPCAltt.(1-EmpStatet)/(NumPeopleToSim-NumOfEmployed)];

(*
  OrderingkRat    = Ordering[kRatt];
*)
  MPCAlttOrderedByk  = MPCAltt[[OrderingkRat]];

  AppendTo[MPCAltTop1PercentByk,  Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.01)]]];
  AppendTo[MPCAltTop10PercentByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.10)]]];
  AppendTo[MPCAltTop20PercentByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.20)]]];
  AppendTo[MPCAltTop40PercentByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.40)]]];
  AppendTo[MPCAltTop60PercentByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (-0.60)]]];

  AppendTo[MPCAltBottom40PercentByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (0.40)]]];
  AppendTo[MPCAltBottom20PercentByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (0.20)]]];

  AppendTo[MPCAltBottom3QuartByk, Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (3/4)]]];
  AppendTo[MPCAltBottomHalfByk,   Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (1/2)]]];
  AppendTo[MPCAltBottomQuartByk,  Mean[Take[MPCAlttOrderedByk,NumPeopleToSim (1/4)]]]
  
  
  ]; (* End If Dist *)

  
  ]; (* End If *)

  sRatt = mRatt- cRatt; (* End of period assets *)
  sLevt = sRatt Pt ;

  If[ModelType == Dist (* If model is Dist *),

     TotyRatt = mRatt - (1-\[Delta]) kRatt; (* total income including wage and capital income *)

     AppendTo[kLev25thPercentileFracOfAveIncome, kLevtsorted[[Round[NumPeopleToSim 0.75]]]/(4 (TotyRatt.Pt)/Length[TotyRatt])];
     AppendTo[kLevMedianFracOfAveIncome,         kLevtsorted[[Round[NumPeopleToSim 0.50]]]/(4 (TotyRatt.Pt)/Length[TotyRatt])];
     AppendTo[kLevMeanFracOfAveIncome,         Mean[kLevtsorted]/(4 (TotyRatt.Pt)/Length[TotyRatt])];

 
     (* calc wealth (net worth) to annual total (wage and capital) income ratio by wealth ratio (kRatt/TotyRatt) *)
     OrderingkRat         = Ordering[kRatt/TotyRatt]; (* Order of kRatt/TotyRatt *)
     kRattsortedTemp      = kRatt[[OrderingkRat]];
     TotyRattsortedBykRat = TotyRatt[[OrderingkRat]];

     AppendTo[kTotyRatbykRat10thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.10]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])]; (* annual term *)
     AppendTo[kTotyRatbykRat15thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.15]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat20thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.20]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat25thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.25]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat30thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.30]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat40thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.40]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat60thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.60]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat80thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.80]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];
     AppendTo[kTotyRatbykRat90thPercentile, kRattsortedTemp[[Round[NumPeopleToSim 0.90]]]/(4 TotyRattsortedBykRat[[Round[NumPeopleToSim 0.10]]])];

     (* calc wealth (net worth) to annual total (wage and capital) income ratio by wealth level *)
     OrderingkLev      = Ordering[kRatt Pt]; (* Order of kLev *)
     kLevtsortedTemp   = Sort[kRatt Pt];
     TotyLevt             = TotyRatt Pt;
     TotyLevtsortedBykLev = TotyLevt[[OrderingkLev]];
   
     AppendTo[kTotyRat10thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.10]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.10]]])]; (* annual term *)
     AppendTo[kTotyRat15thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.15]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.15]]])];
     AppendTo[kTotyRat20thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.20]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.20]]])];
     AppendTo[kTotyRat25thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.25]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.25]]])];
     AppendTo[kTotyRat30thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.30]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.30]]])];
     AppendTo[kTotyRat40thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.40]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.40]]])];
     AppendTo[kTotyRat60thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.60]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.60]]])];
     AppendTo[kTotyRat80thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.80]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.80]]])];
     AppendTo[kTotyRat90thPercentile, kLevtsortedTemp[[Round[NumPeopleToSim 0.90]]]/(4 TotyLevtsortedBykLev[[Round[NumPeopleToSim 0.90]]])];
 
     ]; (* End If Dist *)

  Clear[Livet];
  Clear[Xit, mRatt, cRatt];

Periodt = Periodt+1]; (* End SimulateAnotherPeriodInd *)


 
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
  FracBetween05And15Mean = 100 Mean[Take[FracBetween05And15, -PeriodsToUse]];
  Print[" Distribution of wealth (k) 1%, 5%, 10%, 20%, 25%, 40%, 50%, 60%, 80%, Gini coeff, Frac between 0.5 and 1.5 * mean k (%): "];
  Print[N[{kLevTop1PercentMean, kLevTop5PercentMean, kLevTop10PercentMean, kLevTop20PercentMean, kLevTop25PercentMean, kLevTop40PercentMean, kLevTop50PercentMean, kLevTop60PercentMean, kLevTop80PercentMean, GiniCoeffMean, FracBetween05And15Mean}]];

  If[ModelType == Dist (* If model is Dist *),

     kLev25thPercentileFracOfAveIncomeMean = Mean[Take[kLev25thPercentileFracOfAveIncome, -PeriodsToUse]];
     kLevMedianFracOfAveIncomeMean         = Mean[Take[kLevMedianFracOfAveIncome, -PeriodsToUse]];
     kLevMeanFracOfAveIncomeMean           = Mean[Take[kLevMeanFracOfAveIncome, -PeriodsToUse]];

     Print[" median wealth (net worth), wealth at 25th percentile, average wealth as fraction of average ANNUAL income: "];
     Print[N[{kLevMedianFracOfAveIncomeMean, 
              kLev25thPercentileFracOfAveIncomeMean, 
              kLevMeanFracOfAveIncomeMean}]];


     kTotyRatbykRat10thPercentileMean = Mean[Take[kTotyRatbykRat10thPercentile, -PeriodsToUse]];
     kTotyRatbykRat15thPercentileMean = Mean[Take[kTotyRatbykRat15thPercentile, -PeriodsToUse]];
     kTotyRatbykRat20thPercentileMean = Mean[Take[kTotyRatbykRat20thPercentile, -PeriodsToUse]];
     kTotyRatbykRat25thPercentileMean = Mean[Take[kTotyRatbykRat25thPercentile, -PeriodsToUse]];
     kTotyRatbykRat30thPercentileMean = Mean[Take[kTotyRatbykRat30thPercentile, -PeriodsToUse]];
     kTotyRatbykRat40thPercentileMean = Mean[Take[kTotyRatbykRat40thPercentile, -PeriodsToUse]];
     kTotyRatbykRat60thPercentileMean = Mean[Take[kTotyRatbykRat60thPercentile, -PeriodsToUse]];
     kTotyRatbykRat80thPercentileMean = Mean[Take[kTotyRatbykRat80thPercentile, -PeriodsToUse]];
     kTotyRatbykRat90thPercentileMean = Mean[Take[kTotyRatbykRat90thPercentile, -PeriodsToUse]];

     Print[" wealth (net worth) to ANNUAL total income ratio by wealth ratio, p10, p15, p20, p25, p30, p40, p60, p80, p90: "];
     Print[N[{kTotyRatbykRat10thPercentileMean,
              kTotyRatbykRat15thPercentileMean,
              kTotyRatbykRat20thPercentileMean,
              kTotyRatbykRat25thPercentileMean,
              kTotyRatbykRat30thPercentileMean,
              kTotyRatbykRat40thPercentileMean,
              kTotyRatbykRat60thPercentileMean,
              kTotyRatbykRat80thPercentileMean,
              kTotyRatbykRat90thPercentileMean    }]];


     kTotyRat10thPercentileMean = Mean[Take[kTotyRat10thPercentile, -PeriodsToUse]];
     kTotyRat15thPercentileMean = Mean[Take[kTotyRat15thPercentile, -PeriodsToUse]];
     kTotyRat20thPercentileMean = Mean[Take[kTotyRat20thPercentile, -PeriodsToUse]];
     kTotyRat25thPercentileMean = Mean[Take[kTotyRat25thPercentile, -PeriodsToUse]];
     kTotyRat30thPercentileMean = Mean[Take[kTotyRat30thPercentile, -PeriodsToUse]];
     kTotyRat40thPercentileMean = Mean[Take[kTotyRat40thPercentile, -PeriodsToUse]];
     kTotyRat60thPercentileMean = Mean[Take[kTotyRat60thPercentile, -PeriodsToUse]];
     kTotyRat80thPercentileMean = Mean[Take[kTotyRat80thPercentile, -PeriodsToUse]];
     kTotyRat90thPercentileMean = Mean[Take[kTotyRat90thPercentile, -PeriodsToUse]];

     Print[" wealth (net worth) to ANNUAL total income ratio by wealth level, p10, p15, p20, p25, p30, p40, p60, p80, p90: "];
     Print[N[{kTotyRat10thPercentileMean,
              kTotyRat15thPercentileMean,
              kTotyRat20thPercentileMean,
              kTotyRat25thPercentileMean,
              kTotyRat30thPercentileMean,
              kTotyRat40thPercentileMean,
              kTotyRat60thPercentileMean,
              kTotyRat80thPercentileMean,
              kTotyRat90thPercentileMean    }]];


     ]; (* End If Dist *)

]; (* End Block *) 


(* "CalcAggStats" calculates and display agg statistics *)
CalcAggStats := Block[{},

  (* Gen agg (level) vars *)
  MLev = MRat CapitalP;
  KLev = KRat CapitalP;
  YLev = MLev - (1-\[Delta]) KLev;
  CLev = CRat CapitalP;
  ILev = YLev - CLev;

   (* Take variables for later use *)
   RUsed        = Take[FP[KRat/\[CapitalTheta]], -PeriodsToUse];
   KLevUsedt    = Take[KLev,     -PeriodsToUse];
   YLevUsed     = Take[YLev,     -PeriodsToUse];
   lYLevUsed    = Log[YLevUsed]; (* take log *)
   CLevUsed     = Take[CLev,     -PeriodsToUse];
   ILevUsed     = Take[ILev ,    -PeriodsToUse];

   dlCLevUsed   =  Drop[Log[Take[CLev , -PeriodsToUse]], 1] - Drop[Log[Take[CLev , -PeriodsToUse]], -1];
   dlYLevUsed   =  Drop[Log[Take[YLev , -PeriodsToUse]], 1] - Drop[Log[Take[YLev , -PeriodsToUse]], -1];
   d4lCLevUsed   =  Drop[Log[Take[CLev , -PeriodsToUse]], {1,4}] - Drop[Log[Take[CLev , -PeriodsToUse]], {-4,-1}];
   d4lYLevUsed   =  Drop[Log[Take[YLev , -PeriodsToUse]], {1,4}] - Drop[Log[Take[YLev , -PeriodsToUse]], {-4,-1}];
   d8lCLevUsed   =  Drop[Log[Take[CLev , -PeriodsToUse]], {1,8}] - Drop[Log[Take[CLev , -PeriodsToUse]], {-8,-1}];
   d8lYLevUsed   =  Drop[Log[Take[YLev , -PeriodsToUse]], {1,8}] - Drop[Log[Take[YLev , -PeriodsToUse]], {-8,-1}];

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

   corrlYtlYtm1     = Corr[Drop[lYLevUsed, 1],Drop[lYLevUsed, -1]];
   corrdlYtdlYtm1   = Corr[Drop[dlYLevUsed, 1],Drop[dlYLevUsed, -1]];

   KYRatio          = Mean[KLevUsedt/YLevUsed]; 

   AggStatsWithAggShock ={
          corrdlCtdlCtm1   ,
          corrdlCtdlYt     ,
          corrdlCtdlYtm1   ,
          corrdlCtdlYtm2   ,
          corrdlCtRt       ,
          corrdlCtRtm1     ,
          corrd4lCtd4lYt   ,
          corrd8lCtd8lYt   ,   
          KYRatio          ,  
          corrlYtlYtm1     ,
          corrdlYtdlYtm1 }; 

   Clear[(* KRat, *) MRat,CRat,MLev,(* YLev,*) CLev,CLevSim,CLevExp,lCLevUsed,ILev];

   (* Show agg statistics *)
   Print[" sigmaLogY,sigmaLogC,sigmaCYRatio,sigmaLogI,sigmaIYRatio,corr(Y(t),Y(t-1)),corr(C(t),Y(t)),corr(C(t),Y(t-1)),corr(C(t),C(t-1)),corr(I(t),Y(t)),corr(I(t),Y(t-1)),corr(I(t),I(t-1)), KYRatio, : "];
   
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

   Print[" corr(dlC(t),dlC(t-1)), corr(dlC(t),dlY(t)), corr(dlC(t),dlY(t-1)), corr(dlC(t),dlY(t-2)), corr(dlC(t),r(t)), corr(dlC(t),r(t-1)), corr(d4lC(t),d4lY(t)), corr(d8lC(t),d8lY(t)), corr(lY(t),lY(t-1)), corr(dlY(t),dlY(t-1)): "];

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
          }];

]; (* End CalcAggStats *)

(* "CalcMPC" calculates and displays MPC *)
CalcMPC := Block[{},

  MeanMPCAnnual                = 1-(1-Mean[Take[MPC,             -PeriodsToUse]])^4;  (* MPC annual terms *)
  MeanMPCTop1PercentAnnual     = 1-(1-Mean[Take[MPCTop1Percent,  -PeriodsToUse]])^4;
  MeanMPCTop10PercentAnnual    = 1-(1-Mean[Take[MPCTop10Percent, -PeriodsToUse]])^4;
  MeanMPCTop20PercentAnnual    = 1-(1-Mean[Take[MPCTop20Percent, -PeriodsToUse]])^4;
  MeanMPCTop40PercentAnnual    = 1-(1-Mean[Take[MPCTop40Percent, -PeriodsToUse]])^4;
  MeanMPCTop60PercentAnnual    = 1-(1-Mean[Take[MPCTop60Percent, -PeriodsToUse]])^4;
  MeanMPCBottom40PercentAnnual = 1-(1-Mean[Take[MPCBottom40Percent, -PeriodsToUse]])^4;
  MeanMPCBottom20PercentAnnual = 1-(1-Mean[Take[MPCBottom20Percent, -PeriodsToUse]])^4;
  MeanMPCBottom3QuartAnnual    = 1-(1-Mean[Take[MPCBottom3Quart, -PeriodsToUse]])^4;
  MeanMPCBottomHalfAnnual      = 1-(1-Mean[Take[MPCBottomHalf,   -PeriodsToUse]])^4;
  MeanMPCBottomQuartAnnual     = 1-(1-Mean[Take[MPCBottomQuart,  -PeriodsToUse]])^4;
  MeanMPCEmpAnnual             = 1-(1-Mean[Take[MPCEmp,          -PeriodsToUse]])^4;
  MeanMPCUnempAnnual           = 1-(1-Mean[Take[MPCUnemp,        -PeriodsToUse]])^4;

  MeanMPCTop1PercentBykAnnual     = 1-(1-Mean[Take[MPCTop1PercentByk,  -PeriodsToUse]])^4;
  MeanMPCTop10PercentBykAnnual    = 1-(1-Mean[Take[MPCTop10PercentByk, -PeriodsToUse]])^4;
  MeanMPCTop20PercentBykAnnual    = 1-(1-Mean[Take[MPCTop20PercentByk, -PeriodsToUse]])^4;
  MeanMPCTop40PercentBykAnnual    = 1-(1-Mean[Take[MPCTop40PercentByk, -PeriodsToUse]])^4;
  MeanMPCTop60PercentBykAnnual    = 1-(1-Mean[Take[MPCTop60PercentByk, -PeriodsToUse]])^4;
  MeanMPCBottom40PercentBykAnnual = 1-(1-Mean[Take[MPCBottom40PercentByk, -PeriodsToUse]])^4;
  MeanMPCBottom20PercentBykAnnual = 1-(1-Mean[Take[MPCBottom20PercentByk, -PeriodsToUse]])^4;
  MeanMPCBottom3QuartBykAnnual    = 1-(1-Mean[Take[MPCBottom3QuartByk, -PeriodsToUse]])^4;
  MeanMPCBottomHalfBykAnnual      = 1-(1-Mean[Take[MPCBottomHalfByk,   -PeriodsToUse]])^4;
  MeanMPCBottomQuartBykAnnual     = 1-(1-Mean[Take[MPCBottomQuartByk,  -PeriodsToUse]])^4;

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


  (* calc MPC lists when a large perm/tran shock is given *)
  If[ModelType == Dist (* If model is Dist *),

  MeanMPCLargeBadPermAnnual                = 1-(1-Mean[Take[MPCLargeBadPerm,             -PeriodsToUse]])^4;  (* MPCLargeBadPerm annual terms *)
  MeanMPCLargeBadPermTop1PercentAnnual     = 1-(1-Mean[Take[MPCLargeBadPermTop1Percent,  -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop10PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop10Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop20PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop20Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop40PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop40Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop60PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop60Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottom40PercentAnnual = 1-(1-Mean[Take[MPCLargeBadPermBottom40Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottom20PercentAnnual = 1-(1-Mean[Take[MPCLargeBadPermBottom20Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottom3QuartAnnual    = 1-(1-Mean[Take[MPCLargeBadPermBottom3Quart, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottomHalfAnnual      = 1-(1-Mean[Take[MPCLargeBadPermBottomHalf,   -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottomQuartAnnual     = 1-(1-Mean[Take[MPCLargeBadPermBottomQuart,  -PeriodsToUse]])^4;
  MeanMPCLargeBadPermEmpAnnual             = 1-(1-Mean[Take[MPCLargeBadPermEmp,          -PeriodsToUse]])^4;
  MeanMPCLargeBadPermUnempAnnual           = 1-(1-Mean[Take[MPCLargeBadPermUnemp,        -PeriodsToUse]])^4;

  MeanMPCLargeBadPermTop1PercentBykAnnual     = 1-(1-Mean[Take[MPCLargeBadPermTop1PercentByk,  -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop10PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop10PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop20PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop20PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop40PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop40PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermTop60PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadPermTop60PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottom40PercentBykAnnual = 1-(1-Mean[Take[MPCLargeBadPermBottom40PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottom20PercentBykAnnual = 1-(1-Mean[Take[MPCLargeBadPermBottom20PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottom3QuartBykAnnual    = 1-(1-Mean[Take[MPCLargeBadPermBottom3QuartByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottomHalfBykAnnual      = 1-(1-Mean[Take[MPCLargeBadPermBottomHalfByk,   -PeriodsToUse]])^4;
  MeanMPCLargeBadPermBottomQuartBykAnnual     = 1-(1-Mean[Take[MPCLargeBadPermBottomQuartByk,  -PeriodsToUse]])^4;

  MPCLargeBadPermListWithAggShock = {
        MeanMPCLargeBadPermAnnual,
        MeanMPCLargeBadPermTop1PercentBykAnnual,
        MeanMPCLargeBadPermTop10PercentBykAnnual,
        MeanMPCLargeBadPermTop20PercentBykAnnual,
        MeanMPCLargeBadPermTop40PercentBykAnnual,
        MeanMPCLargeBadPermTop60PercentBykAnnual,
        MeanMPCLargeBadPermBottomHalfBykAnnual,
        MeanMPCLargeBadPermTop1PercentAnnual,
        MeanMPCLargeBadPermTop10PercentAnnual,
        MeanMPCLargeBadPermTop20PercentAnnual,
        MeanMPCLargeBadPermTop40PercentAnnual,
        MeanMPCLargeBadPermTop60PercentAnnual,
        MeanMPCLargeBadPermBottomHalfAnnual,
        MeanMPCLargeBadPermEmpAnnual,
        MeanMPCLargeBadPermUnempAnnual,
        MeanMPCLargeBadPermBottom20PercentBykAnnual,
        MeanMPCLargeBadPermBottom20PercentAnnual
        };


  MeanMPCLargeBadTranAnnual                = 1-(1-Mean[Take[MPCLargeBadTran,             -PeriodsToUse]])^4;  (* MPCLargeBadTran annual terms *)
  MeanMPCLargeBadTranTop1PercentAnnual     = 1-(1-Mean[Take[MPCLargeBadTranTop1Percent,  -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop10PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop10Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop20PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop20Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop40PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop40Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop60PercentAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop60Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottom40PercentAnnual = 1-(1-Mean[Take[MPCLargeBadTranBottom40Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottom20PercentAnnual = 1-(1-Mean[Take[MPCLargeBadTranBottom20Percent, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottom3QuartAnnual    = 1-(1-Mean[Take[MPCLargeBadTranBottom3Quart, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottomHalfAnnual      = 1-(1-Mean[Take[MPCLargeBadTranBottomHalf,   -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottomQuartAnnual     = 1-(1-Mean[Take[MPCLargeBadTranBottomQuart,  -PeriodsToUse]])^4;
  MeanMPCLargeBadTranEmpAnnual             = 1-(1-Mean[Take[MPCLargeBadTranEmp,          -PeriodsToUse]])^4;
  MeanMPCLargeBadTranUnempAnnual           = 1-(1-Mean[Take[MPCLargeBadTranUnemp,        -PeriodsToUse]])^4;

  MeanMPCLargeBadTranTop1PercentBykAnnual     = 1-(1-Mean[Take[MPCLargeBadTranTop1PercentByk,  -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop10PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop10PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop20PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop20PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop40PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop40PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranTop60PercentBykAnnual    = 1-(1-Mean[Take[MPCLargeBadTranTop60PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottom40PercentBykAnnual = 1-(1-Mean[Take[MPCLargeBadTranBottom40PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottom20PercentBykAnnual = 1-(1-Mean[Take[MPCLargeBadTranBottom20PercentByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottom3QuartBykAnnual    = 1-(1-Mean[Take[MPCLargeBadTranBottom3QuartByk, -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottomHalfBykAnnual      = 1-(1-Mean[Take[MPCLargeBadTranBottomHalfByk,   -PeriodsToUse]])^4;
  MeanMPCLargeBadTranBottomQuartBykAnnual     = 1-(1-Mean[Take[MPCLargeBadTranBottomQuartByk,  -PeriodsToUse]])^4;

  MPCLargeBadTranListWithAggShock = {
        MeanMPCLargeBadTranAnnual,
        MeanMPCLargeBadTranTop1PercentBykAnnual,
        MeanMPCLargeBadTranTop10PercentBykAnnual,
        MeanMPCLargeBadTranTop20PercentBykAnnual,
        MeanMPCLargeBadTranTop40PercentBykAnnual,
        MeanMPCLargeBadTranTop60PercentBykAnnual,
        MeanMPCLargeBadTranBottomHalfBykAnnual,
        MeanMPCLargeBadTranTop1PercentAnnual,
        MeanMPCLargeBadTranTop10PercentAnnual,
        MeanMPCLargeBadTranTop20PercentAnnual,
        MeanMPCLargeBadTranTop40PercentAnnual,
        MeanMPCLargeBadTranTop60PercentAnnual,
        MeanMPCLargeBadTranBottomHalfAnnual,
        MeanMPCLargeBadTranEmpAnnual,
        MeanMPCLargeBadTranUnempAnnual,
        MeanMPCLargeBadTranBottom20PercentBykAnnual,       
        MeanMPCLargeBadTranBottom20PercentAnnual
        };
  ]; (* end If Dist *)


  (* calc share among households with top 1/3 MPCs by wealth levels (by each quintile). total is 100% *)
  If[ModelType == Dist (* If model is Dist *),

     MeanMPCTopOneThirdAnnual     = 1-(1-Mean[Take[MPCTopOneThird,  -PeriodsToUse]])^4; (* annual MPC at top 1/3 (not average among top 1/3) *)

     MeanShareInPctTopOneThirdMPCbykLev80100 = Mean[Take[ShareInPctTopOneThirdMPCbykLev80100, -PeriodsToUse]]; (* bottom 20 in wealth levels *) 
     MeanShareInPctTopOneThirdMPCbykLev6080  = Mean[Take[ShareInPctTopOneThirdMPCbykLev6080,  -PeriodsToUse]]; 
     MeanShareInPctTopOneThirdMPCbykLev4060  = Mean[Take[ShareInPctTopOneThirdMPCbykLev4060,  -PeriodsToUse]]; 
     MeanShareInPctTopOneThirdMPCbykLev2040  = Mean[Take[ShareInPctTopOneThirdMPCbykLev2040,  -PeriodsToUse]]; 
     MeanShareInPctTopOneThirdMPCbykLev0020  = Mean[Take[ShareInPctTopOneThirdMPCbykLev0020,  -PeriodsToUse]]; (* top 20 in wealth levels *)

     MeanShareInPctTopOneThirdMPCbykLev = {
      N[MeanShareInPctTopOneThirdMPCbykLev0020],  (* top 20 in wealth levels *)
      N[MeanShareInPctTopOneThirdMPCbykLev2040], 
      N[MeanShareInPctTopOneThirdMPCbykLev4060], 
      N[MeanShareInPctTopOneThirdMPCbykLev6080], 
      N[MeanShareInPctTopOneThirdMPCbykLev80100]
        };

  Print[" Annual MPC at top 1/3:", MeanMPCTopOneThirdAnnual]; 
  Print[" Share (in %) among top 1/3 MPCs by wealth LEVELS -- top 20%, 20-40%, 40-60%, 60-80%, 80-100%, total:"]; 
  Print[{
      N[MeanShareInPctTopOneThirdMPCbykLev0020],  (* top 20 in wealth levels *)
      N[MeanShareInPctTopOneThirdMPCbykLev2040], 
      N[MeanShareInPctTopOneThirdMPCbykLev4060], 
      N[MeanShareInPctTopOneThirdMPCbykLev6080], 
      N[MeanShareInPctTopOneThirdMPCbykLev80100],
      100 
        }]; (* total is 100% *)

    ]; (* end if ModelType == Dist *)

  (* Alternative (simulation) MPC *)
  If[ModelType == Dist (* If model is Dist *),

  MeanMPCAltAnnual                = Mean[Take[MPCAlt,             -PeriodsToUse]];  
  MeanMPCAltTop1PercentAnnual     = Mean[Take[MPCAltTop1Percent,  -PeriodsToUse]];
  MeanMPCAltTop10PercentAnnual    = Mean[Take[MPCAltTop10Percent, -PeriodsToUse]];
  MeanMPCAltTop20PercentAnnual    = Mean[Take[MPCAltTop20Percent, -PeriodsToUse]];
  MeanMPCAltTop40PercentAnnual    = Mean[Take[MPCAltTop40Percent, -PeriodsToUse]];
  MeanMPCAltTop60PercentAnnual    = Mean[Take[MPCAltTop60Percent, -PeriodsToUse]];
  MeanMPCAltBottom40PercentAnnual = Mean[Take[MPCAltBottom40Percent, -PeriodsToUse]];
  MeanMPCAltBottom20PercentAnnual = Mean[Take[MPCAltBottom20Percent, -PeriodsToUse]];
  MeanMPCAltBottom3QuartAnnual    = Mean[Take[MPCAltBottom3Quart, -PeriodsToUse]];
  MeanMPCAltBottomHalfAnnual      = Mean[Take[MPCAltBottomHalf,   -PeriodsToUse]];
  MeanMPCAltBottomQuartAnnual     = Mean[Take[MPCAltBottomQuart,  -PeriodsToUse]];
  MeanMPCAltEmpAnnual             = Mean[Take[MPCAltEmp,          -PeriodsToUse]];
  MeanMPCAltUnempAnnual           = Mean[Take[MPCAltUnemp,        -PeriodsToUse]];

  MeanMPCAltTop1PercentBykAnnual     = Mean[Take[MPCAltTop1PercentByk,  -PeriodsToUse]];
  MeanMPCAltTop10PercentBykAnnual    = Mean[Take[MPCAltTop10PercentByk, -PeriodsToUse]];
  MeanMPCAltTop20PercentBykAnnual    = Mean[Take[MPCAltTop20PercentByk, -PeriodsToUse]];
  MeanMPCAltTop40PercentBykAnnual    = Mean[Take[MPCAltTop40PercentByk, -PeriodsToUse]];
  MeanMPCAltTop60PercentBykAnnual    = Mean[Take[MPCAltTop60PercentByk, -PeriodsToUse]];
  MeanMPCAltBottom40PercentBykAnnual = Mean[Take[MPCAltBottom40PercentByk, -PeriodsToUse]];
  MeanMPCAltBottom20PercentBykAnnual = Mean[Take[MPCAltBottom20PercentByk, -PeriodsToUse]];
  MeanMPCAltBottom3QuartBykAnnual    = Mean[Take[MPCAltBottom3QuartByk, -PeriodsToUse]];
  MeanMPCAltBottomHalfBykAnnual      = Mean[Take[MPCAltBottomHalfByk,   -PeriodsToUse]];
  MeanMPCAltBottomQuartBykAnnual     = Mean[Take[MPCAltBottomQuartByk,  -PeriodsToUse]];

  MPCAltListWithAggShock = {
        MeanMPCAltAnnual,
        MeanMPCAltTop1PercentBykAnnual,
        MeanMPCAltTop10PercentBykAnnual,
        MeanMPCAltTop20PercentBykAnnual,
        MeanMPCAltTop40PercentBykAnnual,
        MeanMPCAltTop60PercentBykAnnual,
        MeanMPCAltBottomHalfBykAnnual,
        MeanMPCAltTop1PercentAnnual,
        MeanMPCAltTop10PercentAnnual,
        MeanMPCAltTop20PercentAnnual,
        MeanMPCAltTop40PercentAnnual,
        MeanMPCAltTop60PercentAnnual,
        MeanMPCAltBottomHalfAnnual,
        MeanMPCAltEmpAnnual,
        MeanMPCAltUnempAnnual,
        MeanMPCAltBottom20PercentBykAnnual,
        MeanMPCAltBottom20PercentAnnual
        };

  Print[" Alternative (simulation) MPC mean:" , MeanMPCAltAnnual];

  Print[" Alternative (simulation) MPC by income top 1%, 10%, 20%, 40%, 60%; bottom 40%, 20%, 3/4, 1/2, 1/4: "];
  Print[{MeanMPCAltTop1PercentAnnual,
         MeanMPCAltTop10PercentAnnual,
         MeanMPCAltTop20PercentAnnual,
         MeanMPCAltTop40PercentAnnual,
         MeanMPCAltTop60PercentAnnual,
         MeanMPCAltBottom40PercentAnnual,
         MeanMPCAltBottom20PercentAnnual,
         MeanMPCAltBottom3QuartAnnual,  
         MeanMPCAltBottomHalfAnnual, 
         MeanMPCAltBottomQuartAnnual}];

  Print[" Alternative (simulation) MPC by wealth perm inc ratio top 1%, 10%, 20%, 40%, 60%; bottom 40%, 20%, 3/4, 1/2, 1/4: "];
  Print[{MeanMPCAltTop1PercentBykAnnual,
         MeanMPCAltTop10PercentBykAnnual,
         MeanMPCAltTop20PercentBykAnnual,
         MeanMPCAltTop40PercentBykAnnual,
         MeanMPCAltTop60PercentBykAnnual,
         MeanMPCAltBottom40PercentBykAnnual,
         MeanMPCAltBottom20PercentBykAnnual,
         MeanMPCAltBottom3QuartBykAnnual,  
         MeanMPCAltBottomHalfBykAnnual, 
         MeanMPCAltBottomQuartBykAnnual}];

  Print[" Alternative (simulation) MPC employed, unemployed: ", {MeanMPCAltEmpAnnual, MeanMPCAltUnempAnnual}];

  ]; (* end If Dist *)

];  (* End CalcMPC *) 

(* "EstimateAR1" estimates agg process (AR1 process). Note that in this model (with aggregate PERMANENT shocks), the AR1 process is estimated with KRat not KLev (such as in the KS model). *)
EstimateAR1 := Block[{},
  
  KRatUsedt         = Take[KRat   , -PeriodsToUse];
  KRatUsedtm1       = Take[KRat   , {Length[KRat]-PeriodsToUse,Length[KRat]-1}];

  LogKRatUsedt      = Log[KRatUsedt];
  LogKRatUsedtm1    = Log[KRatUsedtm1]; 

  If[Rep == False,
     LogKRatARtm1      = LogKRatAR; (* Rename previous estimates *)
     ]; (* End If *)  

  LogKRatAR     = MyReg[LogKRatUsedt,Transpose[{Table[1,{Length[LogKRatUsedtm1]}],LogKRatUsedtm1}]];

  If[Rep == False,
     LogKRatAR     = WeightOnPrevEstimates LogKRatARtm1 + (1-WeightOnPrevEstimates) LogKRatAR; 
     ]; (* End If *)  

(*
  Print[" Estimates of agg process: ", LogKRatAR];

  Print[" Estimates of agg process: ", N[Round[10000 LogKRatAR]/10000]];
*)

  If[Rep == False,
     GapCoeff = Max[Abs[LogKRatAR/LogKRatARtm1-1]]; 
     ]; (* End If *)

  Clear[KRatUsedt, KRatUsedtm1];               
  ]; (* End CalcDistStas *) 

(* "CalculateRSquared" calculates R^2 *)
CalculateRSquared  := Block[{},

  Error                 = LogKRatUsedt - (LogKRatAR[[1]] + LogKRatAR[[2]] LogKRatUsedtm1);
  MeanLogKRat           = Total[LogKRatUsedt]/Length[LogKRatUsedt];
  RSquared              = 1 - (Error.Error)/((LogKRatUsedt- MeanLogKRat).(LogKRatUsedt- MeanLogKRat));
  (* Print[" R^2: ", N[Round[1000 RSquared]/1000]]; *)

  (* Clear vars *)
  Clear[Error, LogKRatUsedt, LogKRatUsedtm1, MeanLogKRat];
]; (* End CalculateRSquared *) 
 