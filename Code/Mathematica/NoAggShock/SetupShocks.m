(* SetupShocks.m *)
(* This file constructs: 
   (i)   discrete approximation to lognormal shocks
   (ii)  possible values of the shock to income 
   (iii) shock draw lists
   (iv)  shock lists 
*)

(* Load relevant packages from mathematica *)
(*
<< DiscreteMath`Permutations`
*)
<< Combinatorica`
(*
<< Statistics`DataManipulation`
<< Statistics`DescriptiveStatistics`
<< Statistics`ContinuousDistributions`
*)

ClearAll[DiscreteApproxToMeanOneLogNormal];

(* (i) "DiscreteApproxToMeanOneLogNormal" constructs discrete approximation to lognormal shocks *)
DiscreteApproxToMeanOneLogNormal[StdDev_, NumOfPoints_] := Block[{}, 
LevelAdjustingParameter = -(1/2) (StdDev)^2;
(* This parameter takes on the value necessary to make the mean in levels = 1 *)
  ListOfEdgePoints =Table[Quantile[LogNormalDistribution[LevelAdjustingParameter, StdDev],(i/NumOfPoints)], {i, NumOfPoints - 1}];
  ListOfEdgePoints = Flatten[{{0}, ListOfEdgePoints, {Infinity}}];
  ProbOfMeanPoints = Table[CDF[LogNormalDistribution[LevelAdjustingParameter, StdDev],ListOfEdgePoints[[i]]] - CDF[LogNormalDistribution[LevelAdjustingParameter,StdDev], ListOfEdgePoints[[i - 1]]], {i, 2, Length[ListOfEdgePoints]}];
  ListOfMeanPoints = Table[NIntegrate[z PDF[LogNormalDistribution[LevelAdjustingParameter, StdDev], z], {z, ListOfEdgePoints[[i - 1]], ListOfEdgePoints[[i]]}], {i, 2,Length[ListOfEdgePoints]}]/ProbOfMeanPoints;
  Return[{ListOfMeanPoints, ProbOfMeanPoints}]]; (* End of Block *)

(* (ii) Construct the possible values of the shock to income => used to construct interp c func *)  
{ThetaVec, ThetaVecProb} = DiscreteApproxToMeanOneLogNormal[\[Sigma]Theta, NumOfThetaShockPoints]; 

If[KS == Yes, (* If KS income process *)
   ThetaVec     = {1};
   ThetaVecProb = {1};
   ];

ThetaVec                = Prepend[(1-UnempWage p/(lbar L))lbar ThetaVec  , UnempWage];  
ThetaVecProb            = Prepend[ThetaVecProb (1 - p) , p];  

{PsiVec, PsiVecProb} = DiscreteApproxToMeanOneLogNormal[\[Sigma]Psi, NumOfPsiShockPoints]; 
If[Perm == No,
   PsiVec     = {1};
   PsiVecProb = {1};
   ];


(* Used for transition matrix method *)
ThetaVecCumProb = {0};
For[i=1, i<=Length[ThetaVecProb], i++,
    ThetaVecCumProb = Append[ThetaVecCumProb, ThetaVecCumProb[[i]] + ThetaVecProb[[i]]]; 
    ];
ThetaVecCumProbList = Sort[Flatten[{ThetaVecCumProb, ThetaVecCumProb}]];
ThetaVecList = Sort[Flatten[{0, ThetaVec-10^(-8) , ThetaVec, 100}]]; 

PsiVecCumProb = {0};
For[i=1, i<=Length[PsiVecProb], i++,
    PsiVecCumProb = Append[PsiVecCumProb, PsiVecCumProb[[i]] + PsiVecProb[[i]]]; 
    ];
PsiVecCumProbList = Sort[Flatten[{PsiVecCumProb, PsiVecCumProb}]];
PsiVecList = Sort[Flatten[{0, PsiVec-10^(-8) , PsiVec, 100}]]; 

(*
(* (iii) "ConstructShockDrawLists" constructs shock draw lists => used to construct shock lists *)  
ConstructShockDrawLists := Block[{}, 
   (* Tran shock draw list *)  
    NumOfUnempGuys   = Round[NumOfPeople p];
    {ThetaShockDraws, ThetaShockDensity} = DiscreteApproxToMeanOneLogNormal[\[Sigma]Theta,NumOfPeople - NumOfUnempGuys];  
    ThetaShockDraws   = (1-UnempWage p/(lbar L))lbar ThetaShockDraws;
    ThetaShockDraws   = Join[ThetaShockDraws, Table[UnempWage, {NumOfUnempGuys}]];  
    ThetaShockDensity = ThetaShockDensity (1 - p) ;  
    ThetaShockDensity = Join[ThetaShockDensity, Table[p/NumOfUnempGuys, {NumOfUnempGuys}]];

    ]; (* End of Block *)    
*)

(* "ConstructShockLists" constructs shock lists *)
ConstructShockLists := Block[{},
   DeathPosList = {Table[Round[(i - 1)/ProbOfDeath] + RandomInteger[{1, Round[1/ProbOfDeath]}], {i, 1, Round[NumOfPeople ProbOfDeath]}]};

   ThetaVecPos  = Join[Table[1, {Round[p NumOfPeople]}], 
                 Flatten[Table[Table[i, {i, 2, Length[ThetaVec]}], {Round[(1 - p) NumOfPeople]}]]];
   ThetaPosList = {ThetaVecPos[[RandomPermutation[NumOfPeople]]]};

   PsiVecPos  = Table[i, {i, 1, Length[PsiVec]}];
   PsiPosList = {Flatten[Table[RandomPermutation[PsiVecPos], {Round[NumOfPeople/Length[PsiVec]]}]]};

   For[t  = 2,
    t <= NumOfPeriodsToSimulate,

    DeathPosList    = Append[DeathPosList, Table[Round[(i - 1)/ProbOfDeath] + RandomInteger[{1, Round[1/ProbOfDeath]}], {i, 1, Round[NumOfPeople ProbOfDeath]}]];

    ThetaPosList  = Append[ThetaPosList, ThetaVecPos[[RandomPermutation[NumOfPeople]]]];
    PsiPosList  = Append[PsiPosList, Flatten[Table[RandomPermutation[PsiVecPos], {Round[NumOfPeople/Length[PsiVec]]}]]]; (* This list needs to be adjusted in simulation process *)

    t  = t + 1
    ]  (* End of t loop *)
   ] (* End of Block *) 