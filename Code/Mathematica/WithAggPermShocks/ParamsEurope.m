(* ParamsEurope.m used in cstMPCxc project *)


(* if Country if all cocuntries  *)
If[Country == AllBaseline, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleAllBaseline.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffAllBaseline.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetAllBaseline.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetAllBaseline.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];

(* if Country if all cocuntries  *)
If[Country == AllLowPsi, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.005/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleAllLowPsi.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffAllLowPsi.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

(*
BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetAllLowPsi.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetAllLowPsi.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)
*)
];

(* if Country if all cocuntries  *)
If[Country == AllHighTheta, 

\[Sigma]Theta   = (0.05*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleAllHighTheta.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffAllHighTheta.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

(*
BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetAllHighTheta.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetAllHighTheta.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)
*)
];

(* if Country if all cocuntries  *)
If[Country == AllVeryHighTheta, 

\[Sigma]Theta   = (0.10*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleAllVeryHighTheta.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffAllVeryHighTheta.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

(*
BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetAllVeryHighTheta.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetAllVeryHighTheta.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)
*)
];


(* if Country if Austria *)
If[Country == AT, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleAT.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffAT.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetAT.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetAT.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Belgium *)
If[Country == BE, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleBE.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffBE.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetBE.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetBE.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Cyprus *)
If[Country == CY, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleCY.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffCY.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetCY.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetCY.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Germany *)
If[Country == DE, 

\[Sigma]Theta   = (0.05*4)^0.5;              (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)
(* 20131104 KT updated *)

(*
\[Sigma]Theta   = (0.03*4)^0.5;              (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.006/4)^0.5;             (* lognormal distribution of permanent shocks. *)
*)

\[Beta]middle = Import["BetamiddleDE.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffDE.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetDE.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetDE.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Spain *)
If[Country == ES, 

\[Sigma]Theta   = (0.05*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)
(* 20131104 KT updated *)

(*
\[Sigma]Theta   = (0.113*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)
*)

\[Beta]middle = Import["BetamiddleES.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffES.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetES.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetES.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Finland *)
If[Country == FI, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleFI.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffFI.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetFI.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetFI.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if France *)
If[Country == FR, 

\[Sigma]Theta   = (0.031*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleFR.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffFR.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetFR.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetFR.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Greece *)
If[Country == GR, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleGR.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffGR.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetGR.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetGR.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Italy *)
If[Country == IT, 

\[Sigma]Theta   = (0.075*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks. *)
(* 20131104 KT updated *)

(*
\[Sigma]Theta   = (0.105*4)^0.5;             (* lognormal distribution of transitory shocks. *)
\[Sigma]Psi     = (0.007/4)^0.5;             (* lognormal distribution of permanent shocks. *)
*)

\[Beta]middle = Import["BetamiddleIT.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffIT.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetIT.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetIT.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Luxembourg *)
If[Country == LU, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleLU.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffLU.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetLU.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetLU.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Malta *)
If[Country == MT, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleMT.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffMT.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetMT.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetMT.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Netherland *)
If[Country == NL, 
\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleNL.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffNL.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetNL.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetNL.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Portugal *)
If[Country == PT, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddlePT.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffPT.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetPT.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetPT.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Slovenia *)
If[Country == SI, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleSI.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffSI.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetSI.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetSI.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];



(* if Country if Slovakia *)

If[Country == SK, 

\[Sigma]Theta   = (0.01*4)^0.5;             (* lognormal distribution of transitory shocks.  *)
\[Sigma]Psi     = (0.01/4)^0.5;             (* lognormal distribution of permanent shocks.  *)

\[Beta]middle = Import["BetamiddleSK.txt","List"][[1]]; (* Mean of time pref factors *)
diff          = Import["diffSK.txt","List"][[1]];       (* Diff between approximated points (of time pref factors) *)

BetamiddleLiqFinPlsRet = Import["BetamiddleLiqFinPlsRetSK.txt","List"][[1]]; (* Mean of time pref factors *)
diffLiqFinPlsRet       = Import["diffLiqFinPlsRetSK.txt","List"][[1]]        (* Diff between approximated points (of time pref factors) *)

];







