(* MakeGrids.m *)
(* This file constructs the grid of possible values of \[Alpha] as a triple exponential *)

lll\[Alpha]Vec = Table[\[Alpha]Loop, 
                       {\[Alpha]Loop, 
                        Log[1 + Log[1 + Log[1 + \[Alpha]Min]]], 
                        Log[1 + Log[1 + Log[1 + \[Alpha]Max]]], 
                        (Log[1 + Log[1 + Log[1 + \[Alpha]Max]]] - Log[1 + Log[1 + Log[1 + \[Alpha]Min]]])/(n - 1)}];

\[Alpha]Vec    = Exp[Exp[Exp[lll\[Alpha]Vec] - 1] - 1] - 1 // N;

\[Alpha]Vec    = \[Alpha]VecBaseline = Append[\[Alpha]Vec, \[Alpha]Huge];

