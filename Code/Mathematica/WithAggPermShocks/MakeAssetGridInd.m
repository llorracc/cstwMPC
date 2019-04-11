(* MakeAssetGridInd.m *)
(* This file constructs the grid of possible values of saving (sRatVec) and possible values of aggregate K KRatVec (ratio), which are used in model with idiosyncratic shocks. *)

(* Construct sRatVec as a triple exponential *)
lsRatVec   = Table[sLoop, 
                {sLoop, 
                 Log[1 + Log[1 + Log[1 + sMin]]], 
                 Log[1 + Log[1 + Log[1 + sMax]]], 
                 (Log[1 + Log[1 + Log[1 + sMax]]] - Log[1 + Log[1 + Log[1 + sMin]]])/(nInd - 1)}];
sRatVec    = Exp[Exp[Exp[lsRatVec] - 1] - 1] - 1 // N;
sRatVec    = Append[sRatVec, sHuge]; (* Add sHuge in sRatVec *)


(* KRatVec *)
KRatVec =      Sort[ {(* 0.01, *) 
                      (* 0.1 kSS, *)
                       0.3 kSS,                
                       0.6  kSS,                 
                       0.8  kSS,
                       0.9  kSS,
                       0.98 kSS,
                       1.0  kSS,
                       1.02 kSS,
                       1.1  kSS,                 
                       1.2  kSS,
                       1.6  kSS 
                       (*, 2.0 kSS *)}];
