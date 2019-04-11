(* Params.m *)

(* Set of baseline parameter values to be used *)
PeriodsToSimulate = 1100;  (* Periods to simulate *)
PeriodsToUse      = Round[(10/11) PeriodsToSimulate]; (* Periods to use in estimation *)

\[Rho]    = 1;    (* Coeff of relative risk aversion *)   

\[Sigma]Theta         = (0.01*4)^0.5;  (* Standard deviation of lognormal distribution of transitory shocks *)
\[Sigma]Psi           = (0.01/(11/4))^0.5;  (* Standard deviation of lognormal distribution of permanent shocks *)
(*
\[Sigma]Psi           = (0.01/4)^0.5;  (* Standard deviation of lognormal distribution of permanent shocks *)
*)

NumOfThetaShockPoints = 5;     (* Num of tran shock points. Increasing this does not change results much. *)
NumOfPsiShockPoints   = 5;     (* Num of perm shock points. Increasing this does not change results much. *)
                
\[Alpha]  = 0.36; (* Share of income that goes to capital *)
\[Delta]  = 0.025;(* Rate of depreciation *)
\[Dalet]  = 1-\[Delta]; 
\[Beta]   = 0.99; (* Benchmark time preference factor. Point and Dist models use different params. *)

If[MatchFinAssets == Yes, (* If matching financial assets *)
   FINYRatio      = 7.4;                 (* Aggregate financial assets/income ratio from SCF2004 *)
   \[Beta]    = FINYRatio/(\[Alpha]+(1-\[Delta])FINYRatio)
   ]; 

If[MatchLiqFinPlsRetAssets == Yes, (* If matching financial assets plus retirement assets *)
   LiqFINPlsRetYRatio      = 6.6;                 (* Aggregate liquid financial assets plus retirement assets/income ratio from SCF2004 *)
   \[Beta]     = LiqFINPlsRetYRatio/(\[Alpha]+(1-\[Delta])LiqFINPlsRetYRatio);
   \[Sigma]Psi = (0.01/4)^0.5;                    (* Standard deviation of lognormal distribution of permanent shocks *)
                                                  (* need to use a lower \[Sigma]Psi to satisfy death-modified GIC *)
   ]; 

If[MatchLiqFinAssets == Yes, (* If matching financial assets *)
   LiqFINYRatio      = 3.9;                       (* Aggregate liquid financial assets/income ratio from SCF2004 *)
   \[Beta]     = LiqFINYRatio/(\[Alpha]+(1-\[Delta])LiqFINYRatio); 
   \[Sigma]Psi = (0.01/4)^0.5;                    (* Standard deviation of lognormal distribution of permanent shocks *)
                                                  (* need to use a lower \[Sigma]Psi to satisfy death-modified GIC *)
   ]; 

(* PF SS k *) kSS = ((1/\[Beta] - (1-\[Delta]))/\[Alpha])^(1/(\[Alpha]-1));

InitialCapital    = kSS;
mSS = (1-\[Delta]) kSS + kSS^\[Alpha];      (* Steady state normalized level of cash on hand *) 
(* PF SS a *) aSS = kSS;   
wSS = (1-\[Alpha]) kSS^\[Alpha];            (* Steady state level of wage rate *) 

ProbOfDeathPerYear = 1/40;                  (* Prob of death per year *)
(*                 
ProbOfDeathPerYear = 1/50;                  (* Prob of death per year *)
*)
ProbOfDeath        = ProbOfDeathPerYear/4;  (* Prob of death per period (quarter) *)  
If[Rep       == True, ProbOfDeath = 0];     (* If rep model, death is shut down *)

\[Beta]        = \[Beta] (1-ProbOfDeath);   (* Effective time preference factor *)  

sMin           = 0.01;      (* Minimum point in SRatVec (sRatVec) (grid of possible saving) *)
sMax           = 80;        (* Maximum point in SRatVec (sRatVec) *) 
sHuge          = 9000;      (* Value of s at which we connect to perfect foresight function *)
nInd           = 20;        (* Baseline number of points in sRatVec *)
n              = 20;        (* Number of points in SRatVec used in rep agent model with aggregate shocks *)

u                    = 0.07;                (* Unemployment rate *)
UnempWage            = 0.15;                (* Wage when unemployed *)

lbar                = 1/0.9;                                  (* Time endowment *)  

sigma\[CapitalTheta]Vec = 0.00001^0.5;      (* Standard deviation of quarterly tran agg pty shocks *)
sigma\[CapitalPsi]Vec   = 0.00004^0.5;      (* Standard deviation of quarterly perm agg pty shocks *)
NumOf\[CapitalTheta]ShockPoints = 3; 
NumOf\[CapitalPsi]ShockPoints   = 3;


(* Weight on prev estimates of agg process *)
If[ModelType == Point, WeightOnPrevEstimates = 3/4];
If[ModelType == Dist  , WeightOnPrevEstimates = 1/2];

(* Max gap allowed in estimating process *)
MaxGapCoeff = 0.015; (* 1.5% *)

(* Max gap allowed (solving consumptoin function is iterated, until calculated (max) gap is less than MaxGap *)
MaxGap         = 10^(-4); (* Max diff allowed is 0.01% *)
(*
MaxGap         = 10^(-3); (* Max diff allowed is 0.1% *)
*)

(* Small number used to calculate MPC *)
d = 0.001; 

(* 10% of quarterly wage income (param used in SimFuncs to calc alt MPC ) *)
StimulusSize = 0.1; 

(* Large bad aggregate shock *)
BottomProb=0.01;

LargeBad\[CapitalPsi]t   = InverseCDF[LogNormalDistribution[-(1/2) (sigma\[CapitalPsi]Vec)^2, sigma\[CapitalPsi]Vec],    BottomProb]; (* bottom 100 BottomProb % *)
LargeBad\[CapitalTheta]t = InverseCDF[LogNormalDistribution[-(1/2) (sigma\[CapitalTheta]Vec)^2, sigma\[CapitalTheta]Vec],BottomProb]; (* bottom 100 BottomProb % *)


<<ParamsEurope.m; (* import params for cstMPC Europe project *) 
