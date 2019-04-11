(* SetupSolve.m *)  
(* This file defines functions used to construct interpolated consumption fn *)

<<SetupFuncs.m;
<<MakeGrids.m;
<<SetupShocks.m;

(* "SolveAnotherPeriod" constructs interpolated consumption fn for one period earlier and appends it to cInterpFunc *)
SolveAnotherPeriod[\[Beta]_] := Block[{},
  \[Chi]      = nP[\[GothicV]P[\[Alpha]Vec,\[Beta]]];
  \[Mu]       = \[Alpha]Vec + \[Chi];
  \[Chi]      = Prepend[\[Chi], 0];
  \[Mu]       = Prepend[\[Mu], 0];
  cInterpData = Transpose[{\[Mu],\[Chi]}];

  AppendTo[cInterpFunc,
    Interpolation[ (* Construct interpolated consumption fn by connecting the points (\[Mu],\[Chi]) *)
      Union[
        Chop[cInterpData
        ]                   (* Chop cuts off numerically insignificant digits *)
      ]                     (* Union removes duplicate entries *)
    ,InterpolationOrder->1] (* Piecewise linear interpolation *)
  ];                        (* End of AppendTo *)

];                          (* End of Block *)


ConstructcInterpFunc[\[Beta]_] := Block[{},

(*
 Print["Solving..."];
*)

 (* Iterate until consumption func converges *)
 Iteration      = 0;
 CalculatedGap  = 1; (* Initial value of calulcated gap *)
 cInterpFunc    = {Interpolation[{{0. , 0. }, {1000. , 1000. }}, InterpolationOrder \[Rule] 1]};  
 R              = Rhat/G;

 While[CalculatedGap > MaxGap (* Iterate while calculated (max) gap is more than MaxGap *), 
       Iteration++;  
(*
       Print[Iteration];
*)

       SolveAnotherPeriod[\[Beta]];

       CalculatedGap = Max[Abs[(cInterpFunc[[-1]][\[Alpha]Vec] - 
     cInterpFunc[[-2]][\[Alpha]Vec])/cInterpFunc[[-1]][\[Alpha]Vec]]];

       ]; (* End While *)

(*
  Print["# of iterations: "];
  Print[Iteration];
*)

]; (* End "ConstructcInterpFunc" *) 
