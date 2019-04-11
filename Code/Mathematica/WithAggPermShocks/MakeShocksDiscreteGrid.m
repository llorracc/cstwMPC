(* MakeShocksDiscreteGrid.m *)

<< Combinatorica`
(*
<< Statistics`DataManipulation`
<< Statistics`DescriptiveStatistics`
<< Statistics`ContinuousDistributions`
*)

(*  "DiscreteApproxToMeanOneLogNormal" constructs discrete approximation to lognormal shocks *)
DiscreteApproxToMeanOneLogNormal[StdDev_, NumOfPoints_] := Block[{}, 
LevelAdjustingParameter = -(1/2) (StdDev)^2;
(* This parameter takes on the value necessary to make the mean in levels = 1 *)
  ListOfEdgePoints =Table[Quantile[LogNormalDistribution[LevelAdjustingParameter, StdDev],(i/NumOfPoints)], {i, NumOfPoints - 1}];
  ListOfEdgePoints = Flatten[{{0}, ListOfEdgePoints, {Infinity}}];
  ProbOfMeanPoints = Table[CDF[LogNormalDistribution[LevelAdjustingParameter, StdDev],ListOfEdgePoints[[i]]] - CDF[LogNormalDistribution[LevelAdjustingParameter,StdDev], ListOfEdgePoints[[i - 1]]], {i, 2, Length[ListOfEdgePoints]}];
  ListOfMeanPoints = Table[NIntegrate[z PDF[LogNormalDistribution[LevelAdjustingParameter, StdDev], z], {z, ListOfEdgePoints[[i - 1]], ListOfEdgePoints[[i]]}], {i, 2,Length[ListOfEdgePoints]}]/ProbOfMeanPoints;
  Return[{ListOfMeanPoints, ProbOfMeanPoints}]]; (* End of Block *)

(* Agg shocks vectors *)  
{\[CapitalPsi]Vec, \[CapitalPsi]VecProb} = DiscreteApproxToMeanOneLogNormal[sigma\[CapitalPsi]Vec,   NumOf\[CapitalPsi]ShockPoints];
{\[CapitalTheta]Vec, \[CapitalTheta]VecProb} = DiscreteApproxToMeanOneLogNormal[sigma\[CapitalTheta]Vec,   NumOf\[CapitalTheta]ShockPoints];

(*
\[CapitalPsi]Vec     = {0.90,1.00,1.10};
\[CapitalPsi]VecProb = {0.25,0.50,0.25};

\[CapitalTheta]Vec     = {1.};
\[CapitalTheta]VecProb = {1.};
*)

(* Ind shocks vectors *)
{PsiVec,   PsiVecProb}   = DiscreteApproxToMeanOneLogNormal[\[Sigma]Psi,   NumOfPsiShockPoints];
{ThetaVecOrig, ThetaVecOrigProb} = DiscreteApproxToMeanOneLogNormal[\[Sigma]Theta, NumOfThetaShockPoints];

(*
{PsiVec,   PsiVecProb}   = {{1},{1}};
{ThetaVecOrig, ThetaVecOrigProb} = {{1},{1}}; 
*)

ThetaVec     = Flatten[{ThetaVecOrig (1 - UnempWage u/(lbar (1-u))) lbar, UnempWage}];
(*
ThetaVec     = Flatten[{(ThetaVecOrig- u UnempWage)/(1-u), UnempWage}]; 
*)

ThetaVecProb = Flatten[{ThetaVecOrigProb (1-u), u}];
