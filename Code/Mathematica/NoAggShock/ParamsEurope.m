(* ParamsEurope.m used in cstMPCxc project *)


(* if Country if all countries *)
If[Country == AllBaseline,  
Print["Country: All (baseline)"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats                 = {68.6, 88.9, 98.1, 100.4}; 
WealthDistStatsLiqFinPlsRet     = {77.3, 92.9, 98.3,  99.8} 

];

If[Country == AllLowPsi,  
Print["Country: All (low psi)"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.005/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats                 = {68.6, 88.9, 98.1, 100.4}; 
WealthDistStatsLiqFinPlsRet     = {77.3, 92.9, 98.3,  99.8} 

];

If[Country == AllHighTheta,  
Print["Country: All (high theta)"]; 

\[Sigma]Theta   = (0.05*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats                 = {68.6, 88.9, 98.1, 100.4}; 
WealthDistStatsLiqFinPlsRet     = {77.3, 92.9, 98.3,  99.8} 

];

If[Country == AllVeryHighTheta,  
Print["Country: All (very high theta)"]; 

\[Sigma]Theta   = (0.10*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats                 = {68.6, 88.9, 98.1, 100.4}; 
WealthDistStatsLiqFinPlsRet     = {77.3, 92.9, 98.3,  99.8} 

];



(* if Country if Austria *)
If[Country == AT,  
Print["Country: Austria"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats                 = { 77.3 , 93.6 , 99.4 , 100.6 }; 
WealthDistStatsLiqFinPlsRet     = { 75.3 , 91.0 , 97.4 , 99.7 }
(* Austria data from HFCS *)

];


(* if Country if Belgium *)
If[Country == BE,  
Print["Country: Belgium"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 61.2 , 83.6 , 95.9 , 99.9 };  WealthDistStatsLiqFinPlsRet = { 78.1 , 92.7 , 98.2 , 99.9 }
(* Belgium data from HFCS *)

];


(* if Country if Cyprus *)
If[Country == CY,  
Print["Country: Cyprus"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 71.9 , 87.4 , 95.5 , 99.6 };  
WealthDistStatsLiqFinPlsRet = { 76.0 , 91.2 , 97.8 , 99.9 }
(* Cyprus data from HFCS *)

];


(* if Country if Germany *)
If[Country == DE,  
Print["Country: Germany"]; 

\[Sigma]Theta   = (0.05*4)^0.5;              (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)
(* 20131104 KT updated *)

(*
\[Sigma]Theta   = (0.03*4)^0.5;              (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.006/4)^0.5;             (* lognormal distribution of permanent shocks. *)
*)

WealthDistStats             = { 79.2 , 94.2 , 99.3 , 100.5 };  
WealthDistStatsLiqFinPlsRet = { 71.3 , 90.1 , 97.8 , 99.8 }
(* Germany data from HFCS *)

];


(* if Country if Spain *)
If[Country == ES,  
Print["Country: Spain"]; 

If[MatchLiqFinPlsRetAssets  == Yes, 
diff = Initialdiff = 0.0055; (* overwrite Initialdiff *)
];

\[Sigma]Theta   = (0.05*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)
(* 20131104 KT updated *)

(*
\[Sigma]Theta   = (0.113*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)
*)

WealthDistStats             = { 59.5 , 80.2 , 93.1 , 99.7 };  
WealthDistStatsLiqFinPlsRet = { 83.3 , 94.8 , 98.7 , 99.9 }
(* Spain data from HFCS *)



];


(* if Country if Finland *)
If[Country == FI,  
Print["Country: Finland"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 68.0 , 90.7 , 100.1 , 101.7 };  
WealthDistStatsLiqFinPlsRet = { 80.0 , 92.8 , 97.9 , 99.7 }
(* Finland data from HFCS *)

];


(* if Country if France *)
If[Country == FR,  
Print["Country: France"]; 

\[Sigma]Theta   = (0.031*4)^0.5;            (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 67.7 , 89.2 , 98.5 , 100.2 };  
WealthDistStatsLiqFinPlsRet = { 79.4 , 93.0 , 98.1 , 99.7 }
 (* France data from HFCS *)

];


(* if Country if Greece *)
If[Country == GR,  
Print["Country: Greece"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 56.3 , 79.7 , 93.9 , 99.8 };  
WealthDistStatsLiqFinPlsRet = { 84.4 , 96.4 , 99.6 , 100.0 }
(* Germany data from HFCS *)

];


(* if Country if Italy *)
If[Country == IT,  
Print["Country: Italy"]; 

\[Sigma]Theta   = (0.075*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)
(* 20131104 KT updated *)

(*
\[Sigma]Theta   = (0.105*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.007/4)^0.5;             (* lognormal distribution of permanent shocks. *)
*)

WealthDistStats             = { 61.5 , 83.4 , 96.1 , 99.7 };  
WealthDistStatsLiqFinPlsRet = { 74.6 , 91.4 , 97.8 , 99.9 }
(* Italy data from HFCS *)

];


(* if Country if Luxembourg *)
If[Country == LU,  
Print["Country: Luxembourg"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 69.1 , 87.6 , 97.6 , 100.1 };  
WealthDistStatsLiqFinPlsRet = { 72.8 , 90.0 , 97.3 , 99.8 }
(* Luxembourg data from HFCS *)

];


(* if Country if Malta *)
If[Country == MT,  
Print["Country: Malta"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 63.6 , 80.7 , 92.0 , 98.6 };  
WealthDistStatsLiqFinPlsRet = { 60.0 , 83.8 , 95.0 , 99.4 }
  (* Malta data from HFCS *) 

];


(* if Country if Netherland *)
If[Country == NL,  
Print["Country: Netherland"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 62.9 , 89.5 , 101.8 , 104.9 };  
WealthDistStatsLiqFinPlsRet = { 60.3 , 85.3 , 96.4 , 99.6 }
  (* Netherland data from HFCS *)

];


(* if Country if Portugal *)
If[Country == PT,  
Print["Country: Portugal"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 65.0 , 84.9 , 95.8 , 100.0 };  
WealthDistStatsLiqFinPlsRet = { 82.6 , 94.9 , 98.8 , 99.8 }
(* Portugal data from HFCS *)

];


(* if Country if Slovenia *)
If[Country == SI,  
Print["Country: Slovenia"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 57.5 , 79.8 , 93.3 , 99.4 };  
WealthDistStatsLiqFinPlsRet = { 80.7 , 95.1 , 99.4 , 100.0 }
  (* Slovenia data from HFCS *)

];


(* if Country if Slovakia *)
If[Country == SK,  
Print["Country: Slovakia"]; 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)

WealthDistStats             = { 49.3 , 71.5 , 86.7 , 96.9 };  
WealthDistStatsLiqFinPlsRet = { 72.2 , 90.4 , 97.3 , 99.6 }
(* Slovakia data from HFCS *)

];


(*
Print["Empirical wealth (net worth) distribution stats: top 20%,  top 40%,  top 60%,  top 80%"];
Print[WealthDistStats];

Print["Empirical wealth (liq fin and retirement assets) distribution stats: top 20%,  top 40%,  top 60%,  top 80%"];
Print[WealthDistStatsLiqFinPlsRet];
*)

