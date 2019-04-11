(* Params.m *)

(* Set baseline values of model parameters *)
\[Rho]         = 1;                   (* Coefficient of Relative Risk Aversion *)
G              = 1;                   (* Gross income growth rate *)

(* alt params suggested by carroll *)
\[Sigma]Theta = (0.01*4)^0.5;         (* Standard deviation of lognormal distribution of transitory shocks *)
\[Sigma]Psi   = (0.01/(11/4))^0.5;    (* Standard deviation of lognormal distribution of permanent shocks *)

(*
\[Sigma]Theta = (0.01*4)^0.5;         (* Standard deviation of lognormal distribution of transitory shocks *)
\[Sigma]Psi   = (0.01/4)^0.5;         (* Standard deviation of lognormal distribution of permanent shocks *)
*)

NumOfThetaShockPoints = 5;            (* Number of points in the discrete approximation to lognormal distribution *)
NumOfPsiShockPoints = 5;              (* Number of points in the discrete approximation to lognormal distribution *)

lbar = 1/0.9;                         (* Time endowment *)
L              = 0.93; 
p              = 1-L;                 (* Probability of unemployment *)
UnempWage      = 0.15;                (* Wage when unemployed *)

CapShare       = 0.36;                (* Capital share *)  
\[Delta]       = 0.025;               (* Rate of depreciation *)
\[Beta]perf    = 0.99;                (* Discount factor in the perfect foresight model *)

If[MatchFinAssets == Yes, (* If matching financial assets *)
   FINYRatio      = 7.4;                 (* Aggregate financial assets/income ratio from SCF2004 *)
   \[Beta]perf    = FINYRatio/(CapShare+(1-\[Delta])FINYRatio)
   ]; 

If[MatchLiqFinPlsRetAssets == Yes, (* If matching financial assets plus retirement assets *)
   LiqFINPlsRetYRatio = 6.6;                 (* Aggregate liquid financial assets plus retirement assets/income ratio from SCF2004 *)
   \[Beta]perf        = LiqFINPlsRetYRatio/(CapShare+(1-\[Delta])LiqFINPlsRetYRatio);
   \[Sigma]Psi        = (0.01/4)^0.5         (* Standard deviation of lognormal distribution of permanent shocks *)
                                             (* need to use a lower \[Sigma]Psi to satisfy death-modified GIC *)
   ]; 

If[MatchLiqFinAssets == Yes, (* If matching financial assets *)
   LiqFINYRatio      = 3.9;                  (* Aggregate liquid financial assets/income ratio from SCF2004 *)
   \[Beta]perf       = LiqFINYRatio/(CapShare+(1-\[Delta])LiqFINYRatio); 
   \[Sigma]Psi       = (0.01/4)^0.5         (* Standard deviation of lognormal distribution of permanent shocks *)
                                            (* need to use a lower \[Sigma]Psi to satisfy death-modified GIC *)
   ]; 

(* wealth distributions stats. % of held by top 20, 40, 60, and 80% *)
WealthDistStats             = {82.9, 94.7, 99.0, 100.2}; (* net worth data from SCF2004 *)
WealthDistStatsFin          = {87.7, 97.1, 99.6, 100.0}; (* fin assets data from SCF2004 *)
WealthDistStatsLiqFinPlsRet = {88.3, 97.5, 99.6, 100.0}; (* liq fin pls ret assets data from SCF2004 *)
WealthDistStatsLiqFin       = {93.8, 98.6, 99.7, 100.0}; (* liq fin assets data from SCF2004 *)


kSS = ((1/\[Beta]perf - (1-\[Delta]))/CapShare)^(1/(CapShare-1));
                                      (* Steady state normalized level of capital *) 
KSS            = kSS lbar L;          (* SS of K (level) *)
KSS            = N[Round[10 KSS]/10]; (* Chop lower digits *)
(*
Print[" SS level of K:  ", KSS];
*)
RSS = 1+CapShare*kSS^(CapShare-1);    (* Steady state level of interest rate *)            
wSS = (1-CapShare) kSS^CapShare;      (* Steady state level of wage rate *) 
(*
ProbOfDeath    = 1/200;
*)
ProbOfDeath    = 1/160;
If[Perm == No (* If no perm shock *),
   ProbOfDeath    = 0;
   ];


Rhat           = (RSS-\[Delta])/(1-ProbOfDeath); (* Gross interest rate *)

\[Alpha]Min    = 0.00001;             (* Minimum point in \[Alpha]Vec (grid of possible saving) *)
\[Alpha]Max    = 20;                  (* Maximum point in \[Alpha]Vec *)
(*
\[Alpha]Max    = 4.;                  (* Maximum point in \[Alpha]Vec *)
*)
\[Alpha]Huge   = 9000.;               (* Value of \[Alpha] at which we connect to perfect foresight function *)
n              = 20;                  (* Number of points in \[Alpha]Vec *)

MaxGap         = 0.01/100;            (* Max gap allowed is 0.1 %. *)


<<ParamsEurope.m; (* params for cstMPC_Europe project *)