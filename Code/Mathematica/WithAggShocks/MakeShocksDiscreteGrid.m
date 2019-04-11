(* MakeShocksDiscreteGrid.m *)

<< Combinatorica`
(*
<< Statistics`DataManipulation`
<< Statistics`DescriptiveStatistics`
<< Statistics`ContinuousDistributions`
*)

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
{ThetaVecOrig, ThetaVecProbOrig} = DiscreteApproxToMeanOneLogNormal[\[Sigma]Theta , NumOfThetaShockPoints];
{PsiVec, PsiVecProb}             = DiscreteApproxToMeanOneLogNormal[\[Sigma]Psi,   NumOfPsiShockPoints];

(* If model is KS, transitory shocks (Theta) and permanent shocks (Psi) are shut down *)
If[ModelType == KS || ModelType == KSHetero, 
   ThetaVecOrig     = 
   ThetaVecProbOrig = 
   PsiVec           = 
   PsiVecProb       = {1}];
