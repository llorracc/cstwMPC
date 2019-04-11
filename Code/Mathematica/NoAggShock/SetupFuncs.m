(* SetupFuncs.m *)

(* Function to give (KLevMean - KLevSS)^2 (used for the simulation method with unique beta) *)
GapKSq[\[Beta]_?NumberQ] := Block[{},

  (* Construct interp c func *)
  ConstructcInterpFunc[\[Beta]];

  (* Simulate *)  
  Simulate; 
(*
  Print[KLevMean];
*)       
  (KLevMean - KSS)^2 
   ];

(* Function to give (KLevMean - KLevSS)^2 (used for the simulation method with Dist betas) *)
GapKSqHet[\[Beta]_?NumberQ] := Block[{},

If[Model==Seven,
  ConstructcInterpFunc[\[Beta] + 3 diff];
  cInterpFunc1 = cInterpFunc;

  ConstructcInterpFunc[\[Beta] + 2 diff];
  cInterpFunc2  = cInterpFunc;

  ConstructcInterpFunc[\[Beta] +   diff];
  cInterpFunc3  = cInterpFunc;

  ConstructcInterpFunc[\[Beta]];
  cInterpFunc4  = cInterpFunc;

  ConstructcInterpFunc[\[Beta]-  diff];
  cInterpFunc5  = cInterpFunc;

  ConstructcInterpFunc[\[Beta]- 2 diff];
  cInterpFunc6  = cInterpFunc;

  ConstructcInterpFunc[\[Beta]- 3 diff];
  cInterpFunc7  = cInterpFunc;

];

If[Model==Nine,
  ConstructcInterpFunc[\[Beta] + 4 diff];
  cInterpFunc1 = cInterpFunc;

  ConstructcInterpFunc[\[Beta] + 3 diff];
  cInterpFunc2 = cInterpFunc;

  ConstructcInterpFunc[\[Beta] + 2 diff];
  cInterpFunc3  = cInterpFunc;

  ConstructcInterpFunc[\[Beta] +   diff];
  cInterpFunc4  = cInterpFunc;

  ConstructcInterpFunc[\[Beta]];
  cInterpFunc5  = cInterpFunc;

  ConstructcInterpFunc[\[Beta] -   diff];
  cInterpFunc6  = cInterpFunc;

  ConstructcInterpFunc[\[Beta] - 2 diff];
  cInterpFunc7  = cInterpFunc;

  ConstructcInterpFunc[\[Beta] - 3 diff];
  cInterpFunc8  = cInterpFunc;

  ConstructcInterpFunc[\[Beta] - 4 diff];
  cInterpFunc9  = cInterpFunc;

];

  (* Simulate *) 
  Simulate;                             
  (KLevMean - KSS)^2 
   ];


(* Find\[Beta]middleSolution gives \[Beta]middle which minimizes the deviation *)
Find\[Beta]middleSolution := Block[{},

 Inc     = 0.000005; (* (baseline) increment value in searching for beta *)
 Inctemp = Inc; 

 (* Evaluate deviation at Initial\[Beta]middle *) 
 temp\[Beta]middle = Initial\[Beta]middle;

(*
 Print[" Evaluating with \[Beta]middle=  ", temp\[Beta]middle];
*)
 DevsMat = {{temp\[Beta]middle, GapKSqHet[temp\[Beta]middle]}};

  If[Abs[KLevMean - KSS] > 0.20 , Inctemp =  3 Inc, Inctemp = Inc]; (* if KLevMean is away more than 0.20, increment is 3 times as large *)
  If[Abs[KLevMean - KSS] > 0.40,  Inctemp =  6 Inc];
  If[Abs[KLevMean - KSS] > 1.00,  Inctemp = 15 Inc];
  If[Abs[KLevMean - KSS] > 2.00,  Inctemp = 30 Inc];
  If[Abs[KLevMean - KSS] > 4.00,  Inctemp = 60 Inc];

 If[KLevMean > KSS, 
    
  (* then *)  
             temp\[Beta]middle = Initial\[Beta]middle - Inctemp;

(*
             Print[KLevMean - KSS];
             Print[" Evaluating with \[Beta]middle=  ", temp\[Beta]middle]; 
*)
 
             DevsMat = Prepend[DevsMat, {temp\[Beta]middle, GapKSqHet[temp\[Beta]middle]}],

  (* else *) 
             temp\[Beta]middle = Initial\[Beta]middle + Inctemp;

(*
             Print[KLevMean - KSS];
             Print[" Evaluating with \[Beta]middle=  ", temp\[Beta]middle]; 
*)

             DevsMat = Append[DevsMat, {temp\[Beta]middle, GapKSqHet[temp\[Beta]middle]}]

 ]; (* End If *)

 While[KSS - KLevMean > 0.1 (* Increase \[Beta]middle until KLevMean is within 0.1 from KSS *),

  If[Abs[KLevMean - KSS] > 0.20 , Inctemp =  3 Inc, Inctemp = Inc]; (* if KLevMean is away more than 0.20, increment is 3 times as large *)
  If[Abs[KLevMean - KSS] > 0.40,  Inctemp =  6 Inc];
  If[Abs[KLevMean - KSS] > 1.00,  Inctemp = 15 Inc];
  If[Abs[KLevMean - KSS] > 2.00,  Inctemp = 30 Inc];
  If[Abs[KLevMean - KSS] > 4.00,  Inctemp = 60 Inc];

  temp\[Beta]middle = DevsMat[[-1, 1]]  + Inctemp; 

(*
  Print[KLevMean - KSS];
  Print[" Evaluating with \[Beta]middle=  ", temp\[Beta]middle]; 
*)
  
  (* Append results *)
  DevsMat = Append[DevsMat, 
  {temp\[Beta]middle, GapKSqHet[temp\[Beta]middle]}
   ]
 ]; (* End While *)

 While[KLevMean - KSS > 0.1 (* Decrease \[Beta]middle until KLevMean is within 0.1 from KSS *),

  If[Abs[KLevMean - KSS] > 0.20 , Inctemp =  3 Inc, Inctemp = Inc]; (* if KLevMean is away more than 0.20, increment is 3 times as large *)
  If[Abs[KLevMean - KSS] > 0.40,  Inctemp =  6 Inc];
  If[Abs[KLevMean - KSS] > 1.00,  Inctemp = 15 Inc];
  If[Abs[KLevMean - KSS] > 2.00,  Inctemp = 30 Inc];
  If[Abs[KLevMean - KSS] > 4.00,  Inctemp = 60 Inc];

  temp\[Beta]middle = DevsMat[[1, 1]]  - Inctemp; 

(* 
  Print[KLevMean - KSS];
  Print[" Evaluating with \[Beta]middle=  ", temp\[Beta]middle]; 
*)
  
  (* Prepend results *)
  DevsMat = Prepend[DevsMat, 
  {temp\[Beta]middle, GapKSqHet[temp\[Beta]middle]}
   ]
 ]; (* End While *)

(*
 Print["Stats mat: "];
 Print[DevsMat];
*)

 DevSqList = Transpose[DevsMat][[-1]];
 PosMin    = Ordering[DevSqList][[1]]; (* Position which gives min *) 
 Beta1List = Transpose[DevsMat][[1]];
 \[Beta]middleSolution = Beta1List[[PosMin]];

]; (* End Find\[Beta]middleSolution *)

(*
Find\[Beta]middleSolution := Block[{},

  \[Beta]middleSolution = 
   beta1 /. 
    Last[FindMinimum[
      GapKSqHet[beta1], {beta1, Initial\[Beta]middle,

(*
       Initial\[Beta]middle-0.00006 (* Lower bound *), Initial\[Beta]middle+0.00006 (* Upper bound *)}, 
*)
       Initial\[Beta]middle-0.0001 (* Lower bound *), Initial\[Beta]middle+0.0001 (* Upper bound *)}, 
(*
       Initial\[Beta]middle-0.0002 (* Lower bound *), Initial\[Beta]middle+0.0002 (* Upper bound *)}, 
*)

      WorkingPrecision -> 10 (* 10 may be enough?? *)

   ]];
  ];
*)

(* Function to give (meanK - KLevSS)^2 in the transition matrix (Reiter's) method *)
GapKSqTran[\[Beta]_?NumberQ] := Block[{},

  (* Solve consumption function *)
  ConstructcInterpFunc[\[Beta]];

  (* Calc transition matrix PI and mean k (normalized capital at end period) *)
  CalcTran;           

  (meanK - KSS)^2

   ];

(* Function to give (meanK - KLevSS)^2 in the transition matrix (Reiter's) method. For model with two types (standard Dist model). *)
GapKSqHetTran[\[Beta]_?NumberQ] := Block[{},

  (* Solve consumption function with high \[Beta] and mean k (normalized capital at end period *)
  kgrid = kgridHigh; 
  ConstructcInterpFunc[\[Beta]];
  CalcTran;           
  meanKHigh = meanK;

  (* Solve consumption function with low \[Beta] and mean k (normalized capital at end period *)
  kgrid = kgridLow; 
  ConstructcInterpFunc[\[Beta]0];
  CalcTran;           
  meanKLow = meanK;

  (* Calc mean K of the whole sample *)
  meanK = FracOfPatients meanKHigh + (1-FracOfPatients) meanKLow;
  (meanK - KSS)^2

   ];

(* Function to give (meanK - KLevSS)^2 in the transition matrix (Reiter's) method. For model with three or seven types. *)
GapKSqHetMultiTran[\[Beta]_?NumberQ] := Block[{},

If[Model == Seven, 
  kgrid = kgridHigh; 
  ConstructcInterpFunc[\[Beta] + 3 diff];
  CalcTran;           
  meanK1    = meanK;
  Dist1     = Dist;
  kgridAdj1 = kgridAdj;

  kgrid = kgridHigh; 
  ConstructcInterpFunc[\[Beta] + 2 diff];
  CalcTran;           
  meanK2    = meanK;
  Dist2     = Dist;
  kgridAdj2 = kgridAdj;

  kgrid = kgridMid; 
  ConstructcInterpFunc[\[Beta] +  diff];
  CalcTran;           
  meanK3    = meanK;
  Dist3     = Dist;
  kgridAdj3 = kgridAdj;

  kgrid = kgridMid; 
  ConstructcInterpFunc[\[Beta]];
  CalcTran;           
  meanK4    = meanK;
  Dist4     = Dist;
  kgridAdj4 = kgridAdj;

  kgrid = kgridLow; 
  ConstructcInterpFunc[\[Beta] -  diff];
  CalcTran;           
  meanK5    = meanK;
  Dist5     = Dist;
  kgridAdj5 = kgridAdj;

  kgrid = kgridLow; 
  ConstructcInterpFunc[\[Beta] - 2 diff];
  CalcTran;           
  meanK6    = meanK;
  Dist6     = Dist;
  kgridAdj6 = kgridAdj;

  kgrid = kgridLow; 
  ConstructcInterpFunc[\[Beta] - 3 diff];
  CalcTran;           
  meanK7    = meanK;
  Dist7     = Dist;
  kgridAdj7 = kgridAdj;

  (* Calc mean K of the whole sample *)
  meanK = (meanK1 + meanK2 + meanK3 + meanK4 + meanK5 + meanK6 + meanK7)/7;

  ]; (* End If *)

If[Model == Nine, 
  kgrid = kgridHigh; 
  ConstructcInterpFunc[\[Beta] + 4 diff];
  CalcTran;           
  meanK1 = meanK;

  ConstructcInterpFunc[\[Beta] + 3 diff];
  CalcTran;           
  meanK2 = meanK;

  ConstructcInterpFunc[\[Beta] + 2 diff];
  CalcTran;           
  meanK3 = meanK;

  kgrid = kgridMid;
  ConstructcInterpFunc[\[Beta] +   diff];
  CalcTran;           
  meanK4 = meanK;

  ConstructcInterpFunc[\[Beta]];
  CalcTran;           
  meanK5 = meanK;

  ConstructcInterpFunc[\[Beta] -   diff];
  CalcTran;           
  meanK6 = meanK;

  kgrid = kgridLow; 
  ConstructcInterpFunc[\[Beta] - 2 diff];
  CalcTran;           
  meanK7 = meanK;

  ConstructcInterpFunc[\[Beta] - 3 diff];
  CalcTran;           
  meanK8 = meanK;
 
  ConstructcInterpFunc[\[Beta] - 4 diff];
  CalcTran;           
  meanK9 = meanK;

  (* Calc mean K of the whole sample *)
  meanK = (meanK1 + meanK2 + meanK3 + meanK4 + meanK5 + meanK6 + meanK7 + meanK8 + meanK9)/9;

  ]; (* End If *)

  (meanK - KSS)^2 (* This is essentially the same as calculating (meank - KSS/wSS)^2 *)

   ];

(* Function to calculate transition matrix PI and mean k (normalized capital at end period) *)
CalcTran := Block[{},

  TimeSCalcPI = SessionTime[]; 
  PI          = Table[0, {nkgrid}, {nkgrid}]; (* Empty transition matrix to be filled later *) 

  xgrid      = Interpolation[Transpose[{\[Mu] - \[Chi], \[Chi]}], InterpolationOrder -> 1][kgrid (1-ProbOfDeath)] + kgrid (1-ProbOfDeath);
  xgrid[[1]] = Interpolation[Transpose[{\[Mu] - \[Chi], \[Chi]}], InterpolationOrder -> 1][\[Alpha]Vec[[1]] (1-ProbOfDeath)] + \[Alpha]Vec[[1]] (1-ProbOfDeath);


  xx  = xgrid-((RSS-\[Delta])) kmin; 
  dd1 = Table[Disty[xx[[i]]], {i,1,Length[xx]}]; 

  idk = (1/((RSS-\[Delta]))) /Differences[kgrid];

   (* 1st row *)
   xx       = xgrid[[1]] - ((RSS-\[Delta])) kgrid;
   dd       = Idisty[xx];
   intF     = -Differences[dd] idk; 
   PI[[1]]  = Prepend[intF, dd1[[1]]];
   intFLast = intF; 

   (* 2nd row and thereafter *)
   For[j = 2, j <= nkgrid, j++,
       xx       = xgrid[[j]] - ((RSS-\[Delta])) kgrid; 
       dd       = Idisty[xx];
       intF     = -Differences[dd] idk;
       intF     = Table[Max[{intFLast[[i]], intF[[i]]}], {i, 1, Length[intF]}];
       PI[[j]]  = Prepend[intF-intFLast, (dd1[[j]]-dd1[[j-1]])];
       intFLast = intF; 
       ];
  (* Last element in each column needs to be 1-sum *) 
  PI = Transpose[PI];
  For[j = 1, j <= nkgrid, j++,
      PI[[j,-1]] = 1-Total[Take[PI[[j]], nkgrid-1]];
      ];
  PI = Transpose[PI];

  (* Incorporate death *)
  PI      = PI (1-ProbOfDeath);
  PI[[1]] = PI[[1]] + ProbOfDeath;


(* Note: PI above ignores transition caused by perm inc shock (between periods). To get true PI (transion mat for normalized k) with perm shock on, PI (above) needs to be multiplied from the left by mat which reflects the transition by perm inc shock (PIPerm, see below). But the true PI is not necessary, if this transition (Reiter's) method is used to get good initial guess of \[Beta] (PIPerm does not affect the guess of \[Beta] much). *)


If[PermTranMat == Yes,
(* Calc true PI (transion mat for normalized k) *)
  PIPerm = Table[0, {nkgrid}, {nkgrid}]; (* Empty transition matrix to be filled later *) 

  idk = 1/Differences[kgrid];

   (* 1st row *)
   PIPerm[[1,1]] = 1; (* If end of period capital is 0, it will remain zero at the beginning of next period *)
   intFLast = Delete[PIPerm[[1]],1];

   (* 2nd row and thereafter *)
   For[j = 2, j <= nkgrid, j++,
    
       dd       = Idistp[kgrid/kgrid[[j]]];
       intF     = 1-Differences[dd] idk kgrid[[j]];
       intF     = Table[Max[{intFLast[[i]], intF[[i]]}], {i, 1, Length[intF]}];
       PIPerm[[j]]  = Prepend[intF-intFLast, 0];
       intFLast = intF; 
       ];

  (* Last element in each column needs to be 1-sum *) 
  PIPerm = Transpose[PIPerm];
  For[j = 1, j <= nkgrid, j++,
      PIPerm[[j,-1]] = 1-Total[Take[PIPerm[[j]], nkgrid-1]];
      ];
  PIPerm = Transpose[PIPerm];
  PI = PIPerm. PI
]; (* End If *)

  (* Calc steady state distribution *) 
  PI   = PI - IdentityMatrix[nkgrid];
  x    = Flatten[NullSpace[PI]]; (* x is eigen vector with unit eigen value *)
  Dist = x/Total[x];
  Dist = Map[If[# < 0, 0, #] &, Dist];
  Dist = Dist/Total[Dist]; 
  (* Print[Dist]; *)

  (* Calc mean of k *)
  kgridAdj = Flatten[{kgrid[[1]], (Delete[kgrid, 1] + Delete[kgrid, -1])/2}];
  meank    = Dist.kgridAdj;
  meanK = meank wSS; 
   ];

(* Calculate wealth distribution in the Reiter's method. This routine is used only for the Dist model with seven types. *)
CalcDistDistSevenReiter := Block[{},
  
  kgridAdj = Flatten[{kgridAdj1,kgridAdj2,kgridAdj3,kgridAdj4,kgridAdj5,kgridAdj6,kgridAdj7}];
  Dist     = Flatten[{Dist1,Dist2,Dist3,Dist4,Dist5,Dist6,Dist7}]/7;

  kgridAdjOrdering = Ordering[kgridAdj];
  kgridAdj         = kgridAdj[[kgridAdjOrdering]];
  Dist             = Dist[[kgridAdjOrdering]];

  CumDist      = Table[0,{Length[Dist]}];
  CumDist[[1]] = Dist[[1]];
  For[i=2,i<=Length[CumDist],i++,
   CumDist[[i]] = CumDist[[i-1]]+Dist[[i]]
  ];

  (* Wealth perm inc ratio *)
  PosTop1            = Ordering[Abs[CumDist - 0.99]][[1]]; (* Top 1% *)
  WYRatioTop1Percent = kgridAdj[[PosTop1]];
  PosTop3            = Ordering[Abs[CumDist - 0.97]][[1]]; (* Top 3% *)
  WYRatioTop3Percent = kgridAdj[[PosTop3]];
  PosTop5            = Ordering[Abs[CumDist - 0.95]][[1]]; (* Top 5% *)
  WYRatioTop5Percent = kgridAdj[[PosTop5]];
  PosTop7            = Ordering[Abs[CumDist - 0.93]][[1]]; (* Top 7% *)
  WYRatioTop7Percent = kgridAdj[[PosTop7]];
  PosTop10            = Ordering[Abs[CumDist - 0.9]][[1]]; (* Top 10% *)
  WYRatioTop10Percent = kgridAdj[[PosTop10]];
  PosTop15            = Ordering[Abs[CumDist - 0.85]][[1]]; (* Top 15% *)
  WYRatioTop15Percent = kgridAdj[[PosTop15]];
  PosTop20            = Ordering[Abs[CumDist - 0.8]][[1]]; 
  WYRatioTop20Percent = kgridAdj[[PosTop20]];
  PosTop30            = Ordering[Abs[CumDist - 0.7]][[1]]; 
  WYRatioTop30Percent = kgridAdj[[PosTop30]];
  PosTop40            = Ordering[Abs[CumDist - 0.6]][[1]];
  WYRatioTop40Percent = kgridAdj[[PosTop40]];
  PosTop50            = Ordering[Abs[CumDist - 0.5]][[1]];
  WYRatioTop50Percent = kgridAdj[[PosTop50]];
  PosTop60            = Ordering[Abs[CumDist - 0.4]][[1]];
  WYRatioTop60Percent = kgridAdj[[PosTop60]];
  PosTop80            = Ordering[Abs[CumDist - 0.2]][[1]];
  WYRatioTop80Percent = kgridAdj[[PosTop80]];
  Print[" Wealth perm income ratio (k/p) mean, top 1%, 3%, 5%, 7%, 10%, 20%, 30%, 40%, 50%, 60%, 80%: ", 
   N[{kgridAdj.Dist, 
      WYRatioTop1Percent, 
      WYRatioTop3Percent,
      WYRatioTop5Percent, 
      WYRatioTop7Percent, 
      WYRatioTop10Percent, 
      WYRatioTop15Percent, 
      WYRatioTop20Percent, 
      WYRatioTop30Percent, 
      WYRatioTop40Percent, 
      WYRatioTop50Percent, 
      WYRatioTop60Percent, 
      WYRatioTop80Percent}]];
(*
  SumOfDevSq = (WYRatioTop20Percent-14.1)^2+(WYRatioTop40Percent-7.0)^2+(WYRatioTop60Percent-3.1)^2; (* Using SCF1992 data *)
*)

(*
  SumOfDevSq = (WYRatioTop20Percent-17.3)^2+(WYRatioTop40Percent-8.0)^2+(WYRatioTop60Percent-3.4)^2+(WYRatioTop80Percent-0.7)^2; (* Using SCF1998 data and matching 4 points *)
*)
  SumOfDevSq = (WYRatioTop20Percent-18.5)^2+(WYRatioTop40Percent-8.8)^2+(WYRatioTop60Percent-3.8)^2+(WYRatioTop80Percent-0.8)^2; (* Using SCF2004 data and matching 4 points *)


(*
If[MatchFinAssets == Yes, (* If matching financial assets *)
  SumOfDevSq = (WYRatioTop20Percent-6.9)^2+(WYRatioTop40Percent-2.7)^2+(WYRatioTop60Percent-0.8)^2+(WYRatioTop80Percent-0.1)^2; (* Using SCF1998 data and matching 4 points *)
]; 
*)

If[MatchFinAssets == Yes, (* If matching financial assets *)
  SumOfDevSq = (WYRatioTop20Percent-6.0)^2+(WYRatioTop40Percent-2.2)^2+(WYRatioTop60Percent-0.6)^2+(WYRatioTop80Percent-0.1)^2; (* Using SCF2004 data and matching 4 points *)
]; 




  Print[" Sum of dev^2: ", SumOfDevSq];

(*
  (* Cumulative distribution of wealth perm inc ratio *)
  MeankgridAdj     = kgridAdj.Dist;
  CumkgridAdj      = Table[0, {Length[kgridAdj]}];
  CumkgridAdj[[1]] = kgridAdj[[1]] Dist[[1]]/MeankgridAdj;
  For[i = 2, i <= Length[CumkgridAdj], i++, 
   CumkgridAdj[[i]] = CumkgridAdj[[i - 1]] + kgridAdj[[i]] Dist[[i]]/MeankgridAdj];

  WYRatioCumTop20Percent =  (1 - CumkgridAdj[[PosTop20]]);
  WYRatioCumTop40Percent =  (1 - CumkgridAdj[[PosTop40]]);
  WYRatioCumTop60Percent =  (1 - CumkgridAdj[[PosTop60]]);
  Print[" Cumulative distribution of wealth perm income ratio (k/p) top 20%, 40%, 60%: ", 
   N[{WYRatioCumTop20Percent, WYRatioCumTop40Percent,WYRatioCumTop60Percent}]]
*)

  ]; (* End Block *)

(* Function Disty:  a cumulative function of tran shock used in the transition matrix method *)
Disty[y_] := Interpolation[Transpose[{ThetaVecList, ThetaVecCumProbList}]
                            ,InterpolationOrder->1][y]; 

(* Function Distp:  a cumulative function of perm shock used in the transition matrix method *)
Distp[y_] := Interpolation[Transpose[{PsiVecList, PsiVecCumProbList}]
                            ,InterpolationOrder->1][y]; 

Idisty[y_] := Interpolation[Transpose[{ThetaVecList, IDistgrid}]
                            ,InterpolationOrder->1][y]; 

Idistp[y_] := Interpolation[Transpose[{PsiVecList, IDistpgrid}]
                            ,InterpolationOrder->1][y]; 


(* CRRA marginal utility function *)
uP[c_]        := c^-\[Rho];     

(* Inverse of the CRRA marginal *) 
nP[z_] := z^ - (1/\[Rho]);  


(* Define expected marginal value of saving fn \[GothicV]_t'(at) = \[Beta] R (1/n) \[Sum]u'(c_ {t + 1} (R at + Thetai) ) *)  
\[GothicV]P[at_, \[Beta]_] := (G^(1 - \[Rho])) \[Beta] (1-ProbOfDeath) Sum[(R (PsiVec[[PsiLoop]]^(-\[Rho]))) ThetaVecProb[[ThetaLoop]] PsiVecProb[[PsiLoop]] uP[Last[cInterpFunc][at (R/PsiVec[[PsiLoop]]) + ThetaVec[[ThetaLoop]]]], {ThetaLoop, 1, Length[ThetaVec]}, {PsiLoop, 1, Length[PsiVec]}];  
