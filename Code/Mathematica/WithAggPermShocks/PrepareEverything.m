(* PrepareEverything.m *)
(* This file sets up params, common routines etc. *)

(* Messege off *)
Off[Syntax::"newl"];
Off[Set::"write"]
Off[Interpolation::"inhr"];
Off[InterpolatingFunction::"dmval"]
Off[Part::"pspec"];
Off[General::"spell1"]; 
Off[General::"obspkg"];
Off[General::"newpkg"];

<<Params.m;                 (* Set up params *)
<<SetupFuncs.m;             (* Set up basic funcs *)
<<SetupSolve.m;             (* Set up routines for solution (except for sim routines) *) 
<<MakeAssetGridRep.m;       (* Set up grids for solving rep func *)
<<MakeAssetGridInd.m;       (* Set up grids for solving ind funcs *)
<<MakeShocksDiscreteGrid.m; (* Set up shocks *) 
<<SimFuncs.m;               (* Set up sim funcs and routines *)


(* Use common RandomNum lists for agg shocks *)
<<SetupAggShockList.m;
\[CapitalPsi]RandomNum   = Take[\[CapitalPsi]RandomNumcstCode, PeriodsToSimulate];
\[CapitalTheta]RandomNum = Take[\[CapitalTheta]RandomNumcstCode, PeriodsToSimulate];