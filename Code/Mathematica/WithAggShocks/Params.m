(* Params.m *)

(* Set of baseline parameter values to be used *)
PeriodsToSimulate = 1100; (* Number of periods to simulate *)
If[Rep  == True, PeriodsToSimulate = 4000]; 
PeriodsToUse      = Round[(10/11) PeriodsToSimulate]; (* Periods to use in estimation *)
\[Rho]    = 1;    (* Coeff of relative risk aversion *); 

\[Sigma]Theta         = (0.01*4)^0.5;      (* Standard deviation of lognormal distribution of transitory shocks *)
\[Sigma]Psi           = (0.01/(11/4))^0.5; (* Standard deviation of lognormal distribution of permanent shocks *)
(*
\[Sigma]Psi           = (0.01/4)^0.5;      (* Standard deviation of lognormal distribution of permanent shocks *)
*)

NumOfThetaShockPoints = 5;             (* Num of tran shock points. Increasing this does not change results much. *)
NumOfPsiShockPoints   = 5;             (* Num of perm shock points. Increasing this does not change results much. *)
                  
\[Alpha]  = 0.36; (* Share of income that goes to capital *)
\[Delta]  = 0.025;(* Rate of depreciation *)
\[Beta]   = 0.99; (* Benchmark time preference factor. \[Beta]-Point and \[Beta]-Dist models use different params. *)

If[MatchFinAssets == Yes, (* If matching financial assets *)
   FINYRatio      = 7.4;                 (* Aggregate financial assets/income ratio from SCF2004 *)
   \[Beta]    = FINYRatio/(\[Alpha]+(1-\[Delta])FINYRatio)
   ]; 

If[MatchLiqFinPlsRetAssets == Yes, (* If matching liquid financial assets plus retirement assets *)
   LiqFinPlsRetYRatio = 6.6;         (* Aggregate liquid financial assets plus retirement assets/income ratio from SCF2004 *)
   \[Beta]            = LiqFinPlsRetYRatio/(\[Alpha]+(1-\[Delta])LiqFinPlsRetYRatio);
   \[Sigma]Psi        = (0.01/4)^0.5 (* Standard deviation of lognormal distribution of permanent shocks *)
                                     (* need to use a lower \[Sigma]Psi to satisfy death-modified GIC *)
   ]; 

If[MatchLiqFinAssets == Yes, (* If matching liquid financial assets *)
   LiqFINYRatio       = 3.9;         (* Aggregate liquid financial assets/income ratio from SCF2004 *)
   \[Beta]            = LiqFINYRatio/(\[Alpha]+(1-\[Delta])LiqFINYRatio);
   \[Sigma]Psi        = (0.01/4)^0.5 (* Standard deviation of lognormal distribution of permanent shocks *)
                                     (* need to use a lower \[Sigma]Psi to satisfy death-modified GIC *)
   ]; 

(* wealth distributions stats. % of held by top 20, 40, 60, and 80% *)
WealthDistStats             = {82.9, 94.7, 99.0, 100.2}; (* net worth data from SCF2004 *)
WealthDistStatsFin          = {87.7, 97.1, 99.6, 100.0}; (* fin assets data from SCF2004 *)
WealthDistStatsLiqFinPlsRet = {88.3, 97.5, 99.6, 100.0}; (* liq fin pls ret assets data from SCF2004 *)
WealthDistStatsLiqFin       = {93.8, 98.6, 99.7, 100.0}; (* liq fin assets data from SCF2004 *)


kSS = ((1/\[Beta] - (1-\[Delta]))/\[Alpha])^(1/(\[Alpha]-1));
                                            (* Steady state normalized level of capital *)
mSS = (1-\[Delta]) kSS + kSS^\[Alpha];      (* Steady state normalized level of cash on hand *)     
cSS = kSS^\[Alpha] - \[Delta]*kSS;          (* Steady state normalized level of consumption *)    
RSS = 1+\[Alpha]*kSS^(\[Alpha]-1); (* Steady state level of interest rate *)            
wSS = (1-\[Alpha]) kSS^\[Alpha];            (* Steady state level of wage rate *) 
InitialCapital = kSS;                       (* Initial level of capital (k) in simulation *)


ProbOfDeathPerYear = 1/40;                  (* Prob of death per year *)
(*                 
ProbOfDeathPerYear = 1/50;                  (* Prob of death per year *)
*)
ProbOfDeath        = ProbOfDeathPerYear/4;  (* Prob of death per period (quarter) *)  
If[ModelType == KS || ModelType == KSHetero,   ProbOfDeath = 0];    
                                            (* If model is KS, death is shut down *)
If[Rep       == True, ProbOfDeath = 0];     (* If rep model, death is shut down *)
 
\[Beta]        = \[Beta] (1-ProbOfDeath);   (* Effective time preference factor *)   
RSS            = RSS/(1-ProbOfDeath);       (* Effective steady state level of R *)

\[Epsilon]     = 0.001;     (* Sufficiently small number used to generate PF c func *)
sMin           = 0.01;      (* Minimum point in SRatVec (sRatVec) (grid of possible saving) *)
sMax           = 80;        (* Maximum point in SRatVec (sRatVec) *) 
sHuge          = 9000;      (* Value of s at which we connect to perfect foresight function *)
nInd           = 20;        (* Point number of points in sRatVec *)
If[ModelType == KS || ModelType == KSHetero, nInd = 35]; 
n              = 15;        (* Number of points in SRatVec used in rep agent model with aggregate shocks = n*2+1 *)

NumOfAggStates = 4;         (* Number of aggregate states *)

(* Below, each 4 state is defined as follows:
    State 1 = Currently Good, Came from Good;  
    State 2 = Currently Bad, Came from Good; 
    State 3 = Currently Bad, Came from Bad; 
    State 4 = Currently Good, Came From Bad *)

pibb = 7/8 // N;   (* Probability of Bad coming from Bad *)
pigg = 7/8 // N;   (* Probability of Good coming from Good *)
pibg = (1 - pibb); (* Probability of Good coming from Bad *)
pigb = (1 - pigg); (* Probability of Bad coming from Good *)

AggStateTransitionMatrix    = {{pigg, pigb, 0.00, 0.00},
                               {0.00, 0.00, pibb, pibg},
                               {0.00, 0.00, pibb, pibg},
                               {pigg, pigb, 0.00, 0.00}}; (* Matrix of probs of aggregate state transition (e.g., [1,2] element is prob of transition from state 1 to state 2) *) 

CumAggStateTransitionMatrix = {{pigg, 1.00, 1.00, 1.00},
                               {0.00, 0.00, pibb, 1.00},
                               {0.00, 0.00, pibb, 1.00},
                               {pigg, 1.00, 1.00, 1.00}}; (* Matrix of cumulative probs of aggregate state transition *)

ub                   = 0.1;                                   (* Fraction of unemployed in bad times *)
ug                   = 0.04;                                  (* Fraction of unemployed in good times *)
uList                = {ug,ub,ub,ug};

ptyLevelByAggState  = {1.01,0.99,0.99,1.01}^(1/(1-\[Alpha])); (* Productivity level by aggregate state *)
lbar                = 1/0.9;                                  (* Time endowment *)  
KSS                 = kSS lbar ((1-ub) + (1-ug))/2;
LLevelByAggState    = {1-ug,1-ub,1-ub,1-ug} lbar;             (* L level (Lt) times lbar by aggregate state *)
AdjustedLByAggState = ptyLevelByAggState LLevelByAggState;    (* Adjusted labor stock (Pt) by aggregate state *)
MeanOfL             = Mean[LLevelByAggState];                 (* Mean of L Level *)
ptyGrowthByAggState = {1.00,(0.99/1.01),1.00,(1.01/0.99)}^(1/(1-\[Alpha])) //N; 
                                                              (* Productivity growth level by aggregate state *)
LGrowthByAggState   = {1.00,(1-ub)/(1-ug),1.00,(1-ug)/(1-ub)};(* L growth level by aggregate state *)  
GrowthByAggState    = ptyGrowthByAggState LGrowthByAggState;  (* Growth factor defined in paper (Gt) by aggregate state *)

(* Parameters and matrices used in model with idiosyncratic shocks *)
NumOfEmpStates        = 2;             (* Number of employment state *)  
UnempWage             = 0.15;          (* Wage when unemployed *)

(* Matrix of employment state transition probability 
    g: good times; 
    b: bad times;
    0: unemployed;
    1: employed    *)

(* Individual employment transition probs are from Krusell and Smith (1998). *)
pigg11 = 0.850694;
pigb11 = 0.115885;
pigg10 = 0.024306;
pigb10 = 0.009115;
pibg11 = 0.122917;
pibb11 = 0.836111;
pibg10 = 0.002083;
pibb10 = 0.038889;
pigg01 = 0.583333;
pigb01 = 0.031250;
pigg00 = 0.291667;
pigb00 = 0.093750;
pibg01 = 0.093750;
pibb01 = 0.35;
pibg00 = 0.03125;
pibb00 = 0.525000

(*
(* Case of no persistence with ind employment shocks. *)
pigg11 = pigg (1-ug);
pigb11 = pigb (1-ub);
pigg10 = pigg ug;
pigb10 = pigb ub;
pibg11 = pibg (1-ug);
pibb11 = pibb (1-ub);
pibg10 = pibg ug;
pibb10 = pibb ub;
pigg01 = pigg (1-ug);
pigb01 = pigb (1-ub);
pigg00 = pigg ug;
pigb00 = pigb ub;
pibg01 = pibg (1-ug);
pibb01 = pibb (1-ub);
pibg00 = pibg ug;
pibb00 = pibb ub;
*)

EmpStateTransitionMatrix    = {{{pigg00,pigg01},{pigg10,pigg11}}/pigg,
                               {{pigb00,pigb01},{pigb10,pigb11}}/pigb,
                               {{pibb00,pibb01},{pibb10,pibb11}}/pibb,
                               {{pibg00,pibg01},{pibg10,pibg11}}/pibg}; 

CumEmpStateTransitionMatrix = {{{pigg00/pigg,1},{pigg10/pigg,1}},
                               {{pigb00/pigb,1},{pigb10/pigb,1}},
                               {{pibb00/pibb,1},{pibb10/pibb,1}},
                               {{pibg00/pibg,1},{pibg10/pibg,1}}};

(* Matrix of et values *)
etValsByAggEmpState = {{UnempWage, (1-(ug UnempWage)/LLevelByAggState[[1]]) lbar},
                       {UnempWage, (1-(ub UnempWage)/LLevelByAggState[[2]]) lbar},
                       {UnempWage, (1-(ub UnempWage)/LLevelByAggState[[3]]) lbar},
                       {UnempWage, (1-(ug UnempWage)/LLevelByAggState[[4]]) lbar}};

(* Weight on prev estimates of agg process *)
If[ModelType == KS || ModelType == KSHetero,    WeightOnPrevEstimates = 1/2]; 
If[ModelType == Point, WeightOnPrevEstimates = 3/4];
If[ModelType == Dist,  WeightOnPrevEstimates = 1/2];
kAR1ByAggStateList    = kAR1ByAggState;               (* List of estimates of agg process *)

(* Patient / impatient indicators *)
PatientIndicator    = 1; (* Indicator for patient people is 1 *)
ImpatientIndicator  = 2; (* Indicator for impatient people is 2 *)

(* Baseline param value of fraction of impatinet *)
FracImpatient       = 2/3;

(* Max gap allowed in estimating process *)
MaxGapCoeff = 0.01; (* 1% *)

(* Max gap allowed (solving consumptoin function is iterated, until calculated (max) gap is less than MaxGap *)
MaxGap         = 10^(-4); (* Max diff allowed is 0.01% *)
(*
MaxGap         = 10^(-3); (* Max diff allowed is 0.1% *)
*)

(* Small number used to calculate MPC *)
d = 0.001; 




