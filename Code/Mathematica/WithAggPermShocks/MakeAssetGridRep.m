(* MakeAssetGridRep.m *)
(* This file constructs the grid of possible values of saving (SRatVec) used in representative agent model with only aggregate shocks *)


SRatVec =       Table[Exp[SRatLoop]-1,{SRatLoop,0.0001,Log[3 aSS], Log[3 aSS]/(n-1)}];
