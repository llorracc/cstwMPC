(* MakeAssetGridRep.m *)
(* This file constructs the grid of possible values of saving (SRatVec) used in representative agent model with only aggregate shocks *)


(* Convert the evenly spaced log numbers to level form *)
lSRatVec   = Table[LoopOverSRatVec,{LoopOverSRatVec,Log[sMin],Log[sMax],Log[sMax/sMin]/(n-1)}];
SRatVec    = Exp[lSRatVec];

(* Construct evenly spaced level numbers *)
SRatVecLevel = Table[LoopOverSRatVec,{LoopOverSRatVec,sMin,sMax,(sMax-sMin)/(n-1)}];

(* Construct SRatVec *)
SRatVec      = (SRatVec + SRatVecLevel)/2;
SRatVec      = Union[SRatVec,Exp[lSRatVec],Flatten[{(kSS lbar/AdjustedLByAggState)/(1-\[Delta])}]];
SRatVec      = Sort[Union[Round[SRatVec*1000]/1000]] //N;
SRatVec      = Append[SRatVec, sHuge]; (* Append value of s at which we connect to perfect foresight function *)