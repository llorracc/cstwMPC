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
kLev - level of individual capital
*)

(* "Simulate" runs simulation *)
Simulate     := Block[{},


   (* First period *)
   Deatht         = Table[0,{NumOfPeople}];
   Deatht[[DeathPosList[[1]]]] = 1; 

   (* for later use, get steady dist of Aget when death from age is on *)
   If[DeathFromAge == Yes, (* if death from age is on *)
    Aget = Table[0, {NumOfPeople}];
      Do[DeathPost = 
        Table[Round[(i - 1)/ProbOfDeath] + 
        RandomInteger[{1, Round[1/ProbOfDeath]}], {i, 1, 
        Round[NumOfPeople ProbOfDeath]}];
       Deatht    = Table[0, {NumOfPeople}];
       Deatht[[DeathPost]] = 1;
       DeathAget = Map[If[# == 400, 1, 0] &, Aget]; (* dummy of death from age.die if live for 100 years (400 quarters) *)
       Deatht = Deatht (1 - DeathAget) + DeathAget; (* incorporate death from age *)
       Aget   = Aget (1 - Deatht) + 1               (* age at end period. 1 if dead *), 
     {NumOfPeriodsToSimulateInitial}] (* end Do *)
    ];(* end if *)

   Thetat        = ThetaVec[[ThetaPosList[[1]]]];
   Psitt         = PsiVec[[PsiPosList[[1]]]];

   Pt            = PtInitialList;
   kRatt         = kRattInitialList;
   mRatt         = (RSS-\[Delta]) kRatt + Thetat;


   (* Calculate cRatt *)
   If[Model == Point (* If Point, *),
   cRatt = Last[cInterpFunc][mRatt]
   ]; (* End If *)

   If[Model == Seven (* If seven types *),
   cRatt = Join[Last[cInterpFunc1][Take[mRatt, {1,                          Round[NumOfPeople/7]}]],
             Last[cInterpFunc2][Take[mRatt, {Round[NumOfPeople/7]+1    , Round[NumOfPeople (2/7)]}]],
             Last[cInterpFunc3][Take[mRatt, {Round[NumOfPeople (2/7)]+1, Round[NumOfPeople (3/7)]}]],
             Last[cInterpFunc4][Take[mRatt, {Round[NumOfPeople (3/7)]+1, Round[NumOfPeople (4/7)]}]],
             Last[cInterpFunc5][Take[mRatt, {Round[NumOfPeople (4/7)]+1, Round[NumOfPeople (5/7)]}]],
             Last[cInterpFunc6][Take[mRatt, {Round[NumOfPeople (5/7)]+1, Round[NumOfPeople (6/7)]}]],
             Last[cInterpFunc7][Take[mRatt, {Round[NumOfPeople (6/7)]+1, Round[NumOfPeople ]}]]
             ];
   ]; (* End If *)

   If[Model == Nine (* If nine types *),
   cRatt = Join[Last[cInterpFunc1][Take[mRatt, {1,                          Round[NumOfPeople/9]}]],
             Last[cInterpFunc2][Take[mRatt, {Round[NumOfPeople/9]+1    , Round[NumOfPeople (2/9)]}]],
             Last[cInterpFunc3][Take[mRatt, {Round[NumOfPeople (2/9)]+1, Round[NumOfPeople (3/9)]}]],
             Last[cInterpFunc4][Take[mRatt, {Round[NumOfPeople (3/9)]+1, Round[NumOfPeople (4/9)]}]],
             Last[cInterpFunc5][Take[mRatt, {Round[NumOfPeople (4/9)]+1, Round[NumOfPeople (5/9)]}]],
             Last[cInterpFunc6][Take[mRatt, {Round[NumOfPeople (5/9)]+1, Round[NumOfPeople (6/9)]}]],
             Last[cInterpFunc7][Take[mRatt, {Round[NumOfPeople (6/9)]+1, Round[NumOfPeople (7/9)]}]],
             Last[cInterpFunc8][Take[mRatt, {Round[NumOfPeople (7/9)]+1, Round[NumOfPeople (8/9)]}]],
             Last[cInterpFunc9][Take[mRatt, {Round[NumOfPeople (8/9)]+1, Round[NumOfPeople ]}]]
             ];
   ]; (* End If *)


   aRatt    = mRatt - cRatt;
   aLevt    = aRatt Pt wSS;
   kLevt    = kRatt Pt wSS;
   KLevList = {Mean[kLevt]};

  (* Calculate distribution of wealth etc *)
  If[CalcStats == Yes, 

    kLevtsorted      = Sort[kLevt]; (* Sort by k level *)
    kLevtsortedSum   = Total[kLevtsorted];
    kLevtsortedMean  = kLevtsortedSum/NumOfPeople;
    DumBetween05And15t  =  Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];
    GiniCoeffW        = {(2/(NumOfPeople^2 kLevtsortedMean)) (Table[i,{i,1,NumOfPeople}].(kLevtsorted-kLevtsortedMean))};

    aLevtsorted      = Sort[aLevt]; (* Sort by a level *)
    aLevtsortedSum   = Total[aLevtsorted];
    aLevtsortedMean  = aLevtsortedSum/NumOfPeople;
    GiniCoeffWEnd    = {(2/(NumOfPeople^2 aLevtsortedMean)) (Table[i,{i,1,NumOfPeople}].(aLevtsorted-aLevtsortedMean))};

    StdLog           = {StandardDeviation[Log[kLevt]]}; 
    StdLogEnd        = {StandardDeviation[Log[aLevt]]}; 

    kLevtsorted      = Reverse[kLevtsorted];
    kLevTop1Percent  = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.01]}]]/kLevtsortedSum};
    kLevTop5Percent  = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.05]}]]/kLevtsortedSum};
    kLevTop10Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.10]}]]/kLevtsortedSum};
    kLevTop20Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.20]}]]/kLevtsortedSum};
    kLevTop25Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.25]}]]/kLevtsortedSum};
    kLevTop40Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.40]}]]/kLevtsortedSum};
    kLevTop50Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.50]}]]/kLevtsortedSum};
    kLevTop60Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.60]}]]/kLevtsortedSum};
    kLevTop80Percent = {Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.80]}]]/kLevtsortedSum};
    FracBetween05And15 = {Total[DumBetween05And15t]/NumPeopleToSim};

    (* gini coef of perm inc *)
    Ptsorted      = Sort[Pt]; (* Sort by k level *)
    PtsortedSum   = Total[Ptsorted];
    PtsortedMean  = PtsortedSum/NumOfPeople;

    GiniCoeffPermInc        = {(2/(NumOfPeople^2 PtsortedMean)) (Table[i,{i,1,NumOfPeople}].(Ptsorted-PtsortedMean))};
    StdLogPermInc           = {StandardDeviation[Log[Pt]]}; 

    (* Calculate MPC *)
    If[Model == Point,
    MPCt             = (Last[cInterpFunc][mRatt+0.01]-cRatt)/0.01;
    ]; (* End If *)

    If[Model == Seven (* If seven types *),
    MPCt = (Join[Last[cInterpFunc1][Take[mRatt, {1, Round[(1/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc2][Take[mRatt, {Round[(1/7) NumOfPeople]+1, Round[(2/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc3][Take[mRatt, {Round[(2/7) NumOfPeople]+1, Round[(3/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc4][Take[mRatt, {Round[(3/7) NumOfPeople]+1, Round[(4/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc5][Take[mRatt, {Round[(4/7) NumOfPeople]+1, Round[(5/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc6][Take[mRatt, {Round[(5/7) NumOfPeople]+1, Round[(6/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc7][Take[mRatt, {Round[(6/7) NumOfPeople]+1, Round[(7/7) NumOfPeople]}]+0.01]
             ]-cRatt)/0.01;
    ]; (* End If *)

    If[Model == Nine (* If nine types *),
    MPCt = (Join[Last[cInterpFunc1][Take[mRatt, {1, Round[(1/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc2][Take[mRatt, {Round[(1/9) NumOfPeople]+1, Round[(2/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc3][Take[mRatt, {Round[(2/9) NumOfPeople]+1, Round[(3/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc4][Take[mRatt, {Round[(3/9) NumOfPeople]+1, Round[(4/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc5][Take[mRatt, {Round[(4/9) NumOfPeople]+1, Round[(5/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc6][Take[mRatt, {Round[(5/9) NumOfPeople]+1, Round[(6/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc7][Take[mRatt, {Round[(6/9) NumOfPeople]+1, Round[(7/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc8][Take[mRatt, {Round[(7/9) NumOfPeople]+1, Round[(8/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc9][Take[mRatt, {Round[(8/9) NumOfPeople]+1, Round[NumOfPeople]}]+0.01]
             ]-cRatt)/0.01;
    ]; (* End If *)

    AggMPCList       = {Mean[MPCt]};

  ]; (* End If *)

   (* 2nd period and thereafter *)  
   For[t  = 2, 
       t <= NumOfPeriodsToSimulate,  
       Deatht      = Table[0,{NumOfPeople}];
       Deatht[[DeathPosList[[t]]]] = 1; 

       If[DeathFromAge == Yes, 
          DeathAget = Map[If[# == 400, 1, 0] &, Aget];    (* dummy of death from age. die if live for 100 years (400 quarters) *)
          Deatht    = Deatht (1 - DeathAget) + DeathAget; (* incorporate death from age *)
          Aget = Aget (1 - Deatht) + 1                    (* age at end period. add age 1 if alive *)
          ]; (* end if DeathFromAge *)

       Thetat      = ThetaVec[[ThetaPosList[[t]]]];
       Psitt       = PsiVec[[PsiPosList[[t]]]];

       If[Model == Point,
       aLevtOrdering = Ordering[aLevt];
       aRatt         = aRatt[[aLevtOrdering]];     
       Pt            = Pt[[aLevtOrdering]]; (* Sort by aLevt (prev period). One in each subgroup dies (size of the group: 1/ProbOfDeath) thanks to this ordering *)

         If[DeathFromAge == Yes, 
            Deatht = Deatht[[aLevtOrdering]];
            Aget   = Aget[[aLevtOrdering]]
            ]; (* end if DeathFromAge *)

       ]; (* End If Point *)


       (* Normalize Psitt so that mean of alives becomes 1 *)
       If[Model == Point (* If Point, *),
       PLivtTemp      = Pt Psitt;
       PsiIncSumLivt  = PLivtTemp.(1-Deatht);
       NumLivt        = NumOfPeople - Round[NumOfPeople Total[Deatht]/Length[Deatht]];
       Psitt       = (Psitt/(PsiIncSumLivt/NumLivt)) (1-Deatht) + Deatht; 
       ]; (* End If *)

       Pt             = Pt Psitt (1-Deatht) + Deatht; 

       kLevtMeanPredicted = Mean[aLevt];
       kLevtMean          = Mean[(aLevt (1-Deatht)/(1-Total[Deatht]/Length[Deatht]))];
       AdjustmentFactor   = kLevtMean/kLevtMeanPredicted; 

       kRatt             = (aRatt/(Psitt (1-Total[Deatht]/Length[Deatht]))) (1-Deatht)/AdjustmentFactor; (* adjust kRatt is equal to its predicted value *)
       mRatt             = (RSS-\[Delta]) kRatt + Thetat; 

       (* Calculate cRatt *)
       If[Model == Point (* If Point, *),
       cRatt = Last[cInterpFunc][mRatt]
       ]; (* End If *)

   If[Model == Seven (* If seven types *),
   cRatt = Join[Last[cInterpFunc1][Take[mRatt, {1,                          Round[NumOfPeople/7]}]],
             Last[cInterpFunc2][Take[mRatt, {Round[NumOfPeople/7]+1    , Round[NumOfPeople (2/7)]}]],
             Last[cInterpFunc3][Take[mRatt, {Round[NumOfPeople (2/7)]+1, Round[NumOfPeople (3/7)]}]],
             Last[cInterpFunc4][Take[mRatt, {Round[NumOfPeople (3/7)]+1, Round[NumOfPeople (4/7)]}]],
             Last[cInterpFunc5][Take[mRatt, {Round[NumOfPeople (4/7)]+1, Round[NumOfPeople (5/7)]}]],
             Last[cInterpFunc6][Take[mRatt, {Round[NumOfPeople (5/7)]+1, Round[NumOfPeople (6/7)]}]],
             Last[cInterpFunc7][Take[mRatt, {Round[NumOfPeople (6/7)]+1, Round[NumOfPeople ]}]]
             ];
   ]; (* End If *)

   If[Model == Nine (* If nine types *),
   cRatt = Join[Last[cInterpFunc1][Take[mRatt, {1,                          Round[NumOfPeople/9]}]],
             Last[cInterpFunc2][Take[mRatt, {Round[NumOfPeople/9]+1    , Round[NumOfPeople (2/9)]}]],
             Last[cInterpFunc3][Take[mRatt, {Round[NumOfPeople (2/9)]+1, Round[NumOfPeople (3/9)]}]],
             Last[cInterpFunc4][Take[mRatt, {Round[NumOfPeople (3/9)]+1, Round[NumOfPeople (4/9)]}]],
             Last[cInterpFunc5][Take[mRatt, {Round[NumOfPeople (4/9)]+1, Round[NumOfPeople (5/9)]}]],
             Last[cInterpFunc6][Take[mRatt, {Round[NumOfPeople (5/9)]+1, Round[NumOfPeople (6/9)]}]],
             Last[cInterpFunc7][Take[mRatt, {Round[NumOfPeople (6/9)]+1, Round[NumOfPeople (7/9)]}]],
             Last[cInterpFunc8][Take[mRatt, {Round[NumOfPeople (7/9)]+1, Round[NumOfPeople (8/9)]}]],
             Last[cInterpFunc9][Take[mRatt, {Round[NumOfPeople (8/9)]+1, Round[NumOfPeople ]}]]
             ];
   ]; (* End If *)

       aRatt      = mRatt-cRatt;
       aLevt      = aRatt Pt wSS;
       kLevt      = kRatt Pt wSS;
       KLevList   = Append[KLevList, Mean[kLevt]];

  (* Calculate distribution of wealth *)
  If[CalcStats == Yes, 
    kLevtsorted     = Sort[kLevt]; (* Sort by k level *)
    kLevtsortedSum  = Total[kLevtsorted];
    kLevtsortedMean = kLevtsortedSum/NumOfPeople;
    DumBetween05And15t = Map[If[# > 0.5 kLevtsortedMean && # < 1.5 kLevtsortedMean, 1, 0] &, kLevtsorted];
    AppendTo[GiniCoeffW, (2/(NumOfPeople^2 kLevtsortedMean)) (Table[i,{i,1,NumOfPeople}].(kLevtsorted-kLevtsortedMean))];

    aLevtsorted     = Sort[aLevt]; (* Sort by k level *)
    aLevtsortedSum  = Total[aLevtsorted];
    aLevtsortedMean = aLevtsortedSum/NumOfPeople;
    AppendTo[GiniCoeffWEnd, (2/(NumOfPeople^2 aLevtsortedMean)) (Table[i,{i,1,NumOfPeople}].(aLevtsorted-aLevtsortedMean))];

    AppendTo[StdLog,    StandardDeviation[Log[kLevt]]]; (* std of log wealth *)
    AppendTo[StdLogEnd, StandardDeviation[Log[aLevt]]]; (* std of log wealth at end period *)

    kLevtsorted      = Reverse[kLevtsorted];
    AppendTo[kLevTop1Percent , Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.01]}]]/kLevtsortedSum];
    AppendTo[kLevTop5Percent , Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.05]}]]/kLevtsortedSum];
    AppendTo[kLevTop10Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.10]}]]/kLevtsortedSum];
    AppendTo[kLevTop20Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.20]}]]/kLevtsortedSum];
    AppendTo[kLevTop25Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.25]}]]/kLevtsortedSum];
    AppendTo[kLevTop40Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.40]}]]/kLevtsortedSum];
    AppendTo[kLevTop50Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.50]}]]/kLevtsortedSum];
    AppendTo[kLevTop60Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.60]}]]/kLevtsortedSum];
    AppendTo[kLevTop80Percent, Total[Take[kLevtsorted, {1, Round[NumOfPeople 0.80]}]]/kLevtsortedSum];
    AppendTo[FracBetween05And15, Total[DumBetween05And15t]/NumPeopleToSim];

    (* gini coef of perm inc *)
    Ptsorted     = Sort[Pt]; (* Sort by k level *)
    PtsortedSum  = Total[Ptsorted];
    PtsortedMean = PtsortedSum/NumOfPeople;
    AppendTo[GiniCoeffPermInc, (2/(NumOfPeople^2 PtsortedMean)) (Table[i,{i,1,NumOfPeople}].(Ptsorted-PtsortedMean))];

    AppendTo[StdLogPermInc, StandardDeviation[Log[Pt]]]; (* std of log *)
 
    (* Calculate MPC *)
    If[Model == Point,
    MPCt         = (Last[cInterpFunc][mRatt+0.01]-cRatt)/0.01;
    ]; (* End If *)

    If[Model == Seven (* If seven types *),
    MPCt = (Join[Last[cInterpFunc1][Take[mRatt, {1, Round[(1/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc2][Take[mRatt, {Round[(1/7) NumOfPeople]+1, Round[(2/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc3][Take[mRatt, {Round[(2/7) NumOfPeople]+1, Round[(3/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc4][Take[mRatt, {Round[(3/7) NumOfPeople]+1, Round[(4/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc5][Take[mRatt, {Round[(4/7) NumOfPeople]+1, Round[(5/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc6][Take[mRatt, {Round[(5/7) NumOfPeople]+1, Round[(6/7) NumOfPeople]}]+0.01],
                 Last[cInterpFunc7][Take[mRatt, {Round[(6/7) NumOfPeople]+1, Round[NumOfPeople]}]+0.01]
             ]-cRatt)/0.01;
    ]; (* End If *)

    If[Model == Nine (* If nine types *),
    MPCt = (Join[Last[cInterpFunc1][Take[mRatt, {1, Round[(1/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc2][Take[mRatt, {Round[(1/9) NumOfPeople]+1, Round[(2/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc3][Take[mRatt, {Round[(2/9) NumOfPeople]+1, Round[(3/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc4][Take[mRatt, {Round[(3/9) NumOfPeople]+1, Round[(4/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc5][Take[mRatt, {Round[(4/9) NumOfPeople]+1, Round[(5/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc6][Take[mRatt, {Round[(5/9) NumOfPeople]+1, Round[(6/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc7][Take[mRatt, {Round[(6/9) NumOfPeople]+1, Round[(7/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc8][Take[mRatt, {Round[(7/9) NumOfPeople]+1, Round[(8/9) NumOfPeople]}]+0.01],
                 Last[cInterpFunc9][Take[mRatt, {Round[(8/9) NumOfPeople]+1, Round[NumOfPeople]}]+0.01]
             ]-cRatt)/0.01;
    ]; (* End If *)


    AggMPCList   = Append[AggMPCList, Mean[MPCt]];

  ]; (* End If *)

       t  = t + 1]; (* End of t loop *)

  KLevMean = Mean[Take[KLevList, -PeriodsToUse]];

(*
  Print["KLevMean"]; 
  Print[KLevMean]; 
  Print[KLevList];
*)

  If[CalcStats == Yes, 

(*
    Print[" Agg K (Mean of k (level)):   ", KLevMean];
*)
    SdtK = Mean[Take[(KLevList - KSS)^2, -PeriodsToUse]]^0.5;

    If[Model == Point (* If Point *),
    Print[" Solution of \[Beta], Agg K (Mean of k (level)), K/Y ratio, Average deviation of K (%):   ", {\[Beta]Solution, KLevMean, (KLevMean/lbar/L)^(1-CapShare), SdtK/KSS 100}];
    ]; (* End If *)

    kLevTop1PercentMean    = 100 Mean[Take[kLevTop1Percent , -PeriodsToUse]];
    kLevTop5PercentMean    = 100 Mean[Take[kLevTop5Percent , -PeriodsToUse]];
    kLevTop10PercentMean   = 100 Mean[Take[kLevTop10Percent, -PeriodsToUse]];
    kLevTop20PercentMean   = 100 Mean[Take[kLevTop20Percent, -PeriodsToUse]];
    kLevTop25PercentMean   = 100 Mean[Take[kLevTop25Percent, -PeriodsToUse]];
    kLevTop40PercentMean   = 100 Mean[Take[kLevTop40Percent, -PeriodsToUse]];
    kLevTop50PercentMean   = 100 Mean[Take[kLevTop50Percent, -PeriodsToUse]];
    kLevTop60PercentMean   = 100 Mean[Take[kLevTop60Percent, -PeriodsToUse]];
    kLevTop80PercentMean   = 100 Mean[Take[kLevTop80Percent, -PeriodsToUse]];
    FracBetween05And15Mean = 100 Mean[Take[FracBetween05And15, -PeriodsToUse]];
    GiniCoeffWMean         = Mean[Take[GiniCoeffW ,          -PeriodsToUse]];
    GiniCoeffWEndMean      = Mean[Take[GiniCoeffWEnd ,       -PeriodsToUse]];
    GiniCoeffPermIncMean   = Mean[Take[GiniCoeffPermInc ,    -PeriodsToUse]];
    StdLogMean             = Mean[Take[StdLog ,              -PeriodsToUse]];
    StdLogEndMean          = Mean[Take[StdLogEnd ,           -PeriodsToUse]];
    StdLogPermIncMean      = Mean[Take[StdLogPermInc ,       -PeriodsToUse]];
    AggMPCMean             = Mean[Take[AggMPCList ,          -PeriodsToUse]];
    AggMPCMeanAnnual       = 1-(1-AggMPCMean)^4;

If[Model == Point || Model == Seven || Model == Nine, (* Matching top 20%, 40%, 60%, and 80%. Data from SCF2004 *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStats[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStats[[2]])^2
                + (kLevTop60PercentMean-WealthDistStats[[3]])^2
                + (kLevTop80PercentMean-WealthDistStats[[4]])^2
]; 

If[MatchFinAssets == Yes, (* If matching financial assets *)
If[Model == Point || Model == Seven || Model == Nine, (* Matching top 20%, 40%, 60%, and 80%. Data from SCF2004 *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStatsFin[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStatsFin[[2]])^2
                + (kLevTop60PercentMean-WealthDistStatsFin[[3]])^2
                + (kLevTop80PercentMean-WealthDistStatsFin[[4]])^2
]; 
]; 


If[MatchLiqFinPlsRetAssets == Yes, (* If matching liquid financial assets plus retirement assets *)
If[Model == Point || Model == Seven || Model == Nine, (* Matching top 20%, 40%, 60%, and 80%. Data from SCF2004 *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStatsLiqFinPlsRet[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStatsLiqFinPlsRet[[2]])^2
                + (kLevTop60PercentMean-WealthDistStatsLiqFinPlsRet[[3]])^2
                + (kLevTop80PercentMean-WealthDistStatsLiqFinPlsRet[[4]])^2
]; 
]; 

If[MatchLiqFinAssets == Yes, (* If matching liquid financial assets *)
If[Model == Point || Model == Seven || Model == Nine, (* Matching top 20%, 40%, 60%, and 80%. Data from SCF2004 *)
    SumOfDevSq =  (kLevTop20PercentMean-WealthDistStatsLiqFin[[1]])^2 
                + (kLevTop40PercentMean-WealthDistStatsLiqFin[[2]])^2
                + (kLevTop60PercentMean-WealthDistStatsLiqFin[[3]])^2
                + (kLevTop80PercentMean-WealthDistStatsLiqFin[[4]])^2
]; 
]; 


    Print[" Distribution of wealth (k) 1%, 10%, 20%, 25%, 40%, 50%, 60%, 80%, 5th quintile, (* Frac between 0.5 and 1.5 * mean k (%), *) Gini coeff of wealth at beg-period, Gini coeff of wealth at end-period, Gini coeff of perm inc, std log wealth at beg-period, std log wealth at end-period, std log perm inc, Agg Annual MPC, Sum of Dev Squared:  "];
    Print[{
       kLevTop1PercentMean, 
       kLevTop10PercentMean, 
       kLevTop20PercentMean, 
       kLevTop25PercentMean,
       kLevTop40PercentMean,
       kLevTop50PercentMean,
       kLevTop60PercentMean,
       kLevTop80PercentMean, 
       kLevTop20PercentMean, 
(*
       FracBetween05And15Mean, 
*)
       GiniCoeffWMean,
       GiniCoeffWEndMean,
       GiniCoeffPermIncMean,

       StdLogMean,
       StdLogEndMean,
       StdLogPermIncMean,

       AggMPCMeanAnnual,
       SumOfDevSq
       }];

  ]; (* End If *)


]; (* End Block *)

