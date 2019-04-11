(* PrepareEverything.m *)
(* This file sets up params, common routines etc. *)

(* Messege off *)
Off[Syntax::"newl"];
Off[Set::"write"]
Off[Interpolation::"inhr"];
Off[InterpolatingFunction::"dmval"];
Off[Part::"pspec"];
Off[Part::"pkspec1"];

Off[General::"spell1"]; 
Off[General::"obspkg"];
Off[General::"newpkg"];
Off[General::"compat"];

<<Params.m;                 (* Set up params *)
<<SetupFuncs.m;             (* Set up basic funcs *)
<<SetupSolve.m;             (* Set up routines for solution (except for sim routines) *) 
<<MakeAssetGridRep.m;       (* Set up grids for solving rep func *)
<<MakeAssetGridInd.m;       (* Set up grids for solving ind funcs *)
<<MakeShocksDiscreteGrid.m; (* Set up shocks *) 
<<SimFuncs.m;               (* Set up sim funcs and routines *)
<<SetupAggstatelist.m;      (* Load list of agg state list *)
AggState = Take[AggStatecstCode, PeriodsToSimulate];

