(* EstimateAnnualVarUsingQtrlyVar.m *)
(* 
This file verifies footnote 2 in Economics Letter version of cstKS paper 
by running Monte Carlo simulations to show 
ratio of annual variance of perm shocks to quarterly variance is 11/4 (=2.75)
*)

(*
This file 

-- calculates variance of perm shocks in two ways:

 i) calc annual perm income using quarterly perm income, and 
    estimate the variance of annul perm shocks (annual variance) 

 ii) estimate the variance of four quarter perm shocks y(q4, year t) over y(q4, year t-1) (four quarter variance) 


-- reports 

 i)  ratio of annual variance to quarterly variance

 ii) ratio of four quarter variance to quarterly variance
*)


(* set up func *)
DiscreteApproxToMeanOneLogNormal[StdDev_, NumOfPoints_] := Block[{}, 
LevelAdjustingParameter = -(1/2) (StdDev)^2;

(* This parameter takes on the value necessary to make the mean in levels = 1 *)
  ListOfEdgePoints =Table[Quantile[LogNormalDistribution[LevelAdjustingParameter, StdDev],(i/NumOfPoints)], 
                         {i, NumOfPoints - 1}];
  ListOfEdgePoints = Flatten[{{0}, ListOfEdgePoints, {Infinity}}];
  ProbOfMeanPoints = Table[CDF[LogNormalDistribution[LevelAdjustingParameter, StdDev],ListOfEdgePoints[[i]]] 
                         - CDF[LogNormalDistribution[LevelAdjustingParameter,StdDev], ListOfEdgePoints[[i - 1]]],
                          {i, 2, Length[ListOfEdgePoints]}];
  ListOfMeanPoints = Table[NIntegrate[z PDF[LogNormalDistribution[LevelAdjustingParameter, StdDev], z],
                          {z, ListOfEdgePoints[[i - 1]], ListOfEdgePoints[[i]]}], 
                         {i, 2,Length[ListOfEdgePoints]}]/ProbOfMeanPoints;
  Return[{ListOfMeanPoints, ProbOfMeanPoints}]]; (* End of Block *)


(* set up params *)
\[Sigma]Psi         = (0.01/4)^0.5; (* Quarterly standard deviation of lognormal distribution of permanent shocks *)
NumOfPsiShockPoints = 1000;         (* Number of points in the discrete approximation to lognormal distribution *)
                                    (* Picked a large number to minimize error resulting from approximation *)
{PsiVec, PsiVecProb} =DiscreteApproxToMeanOneLogNormal[\[Sigma]Psi, NumOfPsiShockPoints]; 
 (* calc PsiVec (vector of perm shocks) *)


(* set up routine *)
EstimateVars := Block[{},

TimeS = SessionTime[]; 

(* set up lists *)
QtrPsiList=Table[PsiVec[[RandomInteger[{1,NumOfPsiShockPoints}]]],{NumOfPeriods}]; (* list of quaterly perm shocks *)
QtrPList=Table[1,{NumOfPeriods}]; (* list of quarterly perm inc *)

For[t=2, t<=NumOfPeriods,
QtrPList[[t]]=QtrPList[[t-1]] QtrPsiList[[t]]; 
t=t+1];


AnnualPList = Table[Mean[Take[QtrPList,{4*(i-1)+1,4*i}]],
                   {i,1,NumOfPeriods/4}]; (* list of annual perm income *)
LogAnnualPList=Log[AnnualPList];
dLogAnnualPList= Take[LogAnnualPList,{2,Length[LogAnnualPList]}]
                -Take[LogAnnualPList,{1,Length[LogAnnualPList]-1}];
AnnualVar = Variance[dLogAnnualPList]; (* variance of annul income *)

QtrVar=Variance[Log[PsiVec]]; (* varinace of quarterly income *)

Print["Ratio of annual variance of perm shocks to quarterly variance of perm shocks "];
Print[Round[100 AnnualVar/QtrVar]/100//N];

LogQtrPList=Log[QtrPList];
dFourQtrLogQtrPList =  Take[LogQtrPList,{5,Length[LogAnnualPList]}]
                     - Take[LogQtrPList,{1,Length[LogAnnualPList]-4}];
FourQtrVar=Variance[dFourQtrLogQtrPList]; 

Print["Ratio of four quarter variance of perm shocks to quarterly variance of perm shocks"];
Print[Round[100 FourQtrVar/QtrVar]/100//N]; 

Print[" Time spent (seconds):  ", (SessionTime[]-TimeS)]

]; (* End block *)




Print["============================================"];
NumOfPeriods = 100000; 
Print["Number of periods to simulate:"];
Print[NumOfPeriods];
EstimateVars; (* estimate vars *)



Print["============================================"];
NumOfPeriods = 5000000; 
Print["Number of periods to simulate:"];
Print[NumOfPeriods];
EstimateVars; (* estimate vars *)



