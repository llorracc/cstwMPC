
\[GothicV]P[at_] := \[Beta] Sum[


      \[CapitalPsi]Postp1   = \[CapitalPsi]PosLoop;
      \[CapitalTheta]Postp1 = \[CapitalTheta]PosLoop;
      \[CapitalPsi]tp1      = \[CapitalPsi]Vec[[\[CapitalPsi]Postp1]];
      \[CapitalTheta]tp1    = \[CapitalTheta]Vec[[\[CapitalTheta]Postp1]];
      \[CapitalLambda]tp1   = \[CapitalPsi]tp1;

      KRattp1             = at/\[CapitalLambda]tp1;
      ltp1                = \[CapitalTheta]tp1;
      MRattp1             = If[KRattp1== 0,0,KRattp1 (R[KRattp1/ltp1]-\[Delta]) + ltp1 W[KRattp1/ltp1]];
      \[CapitalPsi]VecProb[[\[CapitalPsi]Postp1]] \[CapitalTheta]VecProb[[\[CapitalTheta]Postp1]] (R[KRattp1/ltp1]-\[Delta]) uP[\[CapitalLambda]tp1 Last[cInterpFunc][MRattp1]]
  ,{\[CapitalPsi]PosLoop,Length[\[CapitalPsi]Vec]}
  ,{\[CapitalTheta]PosLoop,Length[\[CapitalTheta]Vec]}
]; (* End Sum *)



SolveAnotherPeriodRep:=Block[{},
  AppendTo[cInterpFunc,
    Interpolation[
      Union[
        Chop[
          Prepend[
            Table[
              SRattemp     = SRatVec[[SRatLoop]];
              \[Chi]       = nP[\[GothicV]P[SRattemp]];
              \[Mu]        = SRattemp+\[Chi];
              {\[Mu],\[Chi]}
            ,{SRatLoop,Length[SRatVec]}]
          ,{0.,0.}]  (* Prepending {0,0} handles potential liquidity constraint *)
        ]            (* Chop cuts off numerically insignificant digits *)
      ]              (* Union removes duplicate entries *)
    ,InterpolationOrder->1] (* Piecewise linear interpolation *)
  ];                 (* End of AppendTo *)
];                   (* End of SolveAnotherPeriodRep *)

(* "ConstructRepcFunc" constructs representative agent consumption function with aggregate shocks, using "SolveAnotherPeriodRep" defined above *)
ConstructRepcFunc := Block[{},

 (* Iterate until consumption func converges *)
 Iteration      = 0;
 CalculatedGap  = 1; (* Initial value of calulcated gap *)
 MRatGridTest   = mSS{0.9, 1, 1.1};

 While[CalculatedGap > MaxGap (* Iterate while calculated (max) gap is more than MaxGap *), 

       Iteration++;  
       (* Print[Iteration]; *)
       SolveAnotherPeriodRep; 
       CalculatedGap = Max[Abs[cInterpFunc[[-1]][MRatGridTest]/cInterpFunc[[-2]][MRatGridTest]-1]]; 

       ]; (* End While *)
      ]; (* End Block *)


\[GothicV]IndP[sRatt_, KRatt_] := \[Beta] Sum[


      \[CapitalPsi]Postp1   = \[CapitalPsi]PosLoop;
      \[CapitalTheta]Postp1 = \[CapitalTheta]PosLoop;

      \[CapitalPsi]tp1      = \[CapitalPsi]Vec[[\[CapitalPsi]Postp1]];
      \[CapitalTheta]tp1    = \[CapitalTheta]Vec[[\[CapitalTheta]Postp1]];
      ltp1                  = \[CapitalTheta]tp1;

      KRattp1               = Exp[LogKRatAR.{1,Log[KRatt]}];

      RE                    = (R[KRattp1/ltp1]-\[Delta]) /(1-ProbOfDeath);           (* Effective interest rate *)

      Sum[PsiVecPostp1   = PsiVecPosLoop;
          ThetaVecPostp1 = ThetaVecPosLoop;

          \[CapitalLambda]tp1 = \[CapitalPsi]tp1 PsiVec[[PsiVecPostp1]];
          kRattp1             = sRatt/\[CapitalLambda]tp1;                (* kRat(t+1) *)  
          mRattp1             = kRattp1 RE + ltp1 ThetaVec[[ThetaVecPostp1]] W[KRattp1/ltp1]; (* mRat(t+1) *)

          \[CapitalPsi]VecProb[[\[CapitalPsi]Postp1]] \[CapitalTheta]VecProb[[\[CapitalTheta]Postp1]] PsiVecProb[[PsiVecPostp1]] ThetaVecProb[[ThetaVecPostp1]] RE uP[\[CapitalLambda]tp1 Last[cInterpFunc][mRattp1, KRattp1]]

          ,{ThetaVecPosLoop,Length[ThetaVec]}
          ,{PsiVecPosLoop,Length[PsiVec]}
          ]  


  ,{\[CapitalPsi]PosLoop,Length[\[CapitalPsi]Vec]}
  ,{\[CapitalTheta]PosLoop,Length[\[CapitalTheta]Vec]}
]; (* End Sum *)

(* "SolveAnotherPeriodInd" is used in "ConstructIndcFunc". 
  Note that grid in cInterpData (data for interpolation) has to be "regular"; if not, two dimensional interpolation does not work. *)
SolveAnotherPeriodInd := Block[{},

 (* Data for interpolation given KRat = kSS *)
 KRat          = kSS;
 \[Chi]TempVec = nP[\[GothicV]IndP[sRatVec,KRat]];

 \[Mu]TempVec  = sRatVec + \[Chi]TempVec;
 TempData      = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3]; 


 cInterpData = Union[
                 Chop[
                   Prepend[TempData, {0.,KRat,0.}         
                ]                (* Prepending {0,KRat,0} handles potential liquidity constraint *)
             ]                   (* Chop cuts off numerically insignificant digits *)
           ];                    (* Union removes duplicate entries *)

 (* Construct \[Mu]Vec (\[Mu]: possible values of cash on hand) *)   
 \[Mu]Vec = Transpose[cInterpData][[1]];

 (* Data for interpolation given KRat = kSS[[1]] *)
 KRat = KRatVec[[1]];
 \[Chi]TempVec   = nP[\[GothicV]IndP[sRatVec,KRat]];
 \[Mu]TempVec    = sRatVec + \[Chi]TempVec;
 TempData        = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3];

 (* Construct interp consumption functiontion given KRat *)
 Temp = Interpolation[
                  Union[
                     Chop[
                    Prepend[TempData, {0.,KRat,0.}        
                ]                  (* Prepending {0,KRat,0} handles potential liquidity constraint *)
             ]                     (* Chop cuts off numerically insignificant digits *)
           ]                       (* Union removes duplicate entries *)
     ,InterpolationOrder->1];      (* Piecewise linear interpolation *)

 (* Construct data for interpolation, using function "Temp" defined above. *)
 cInterpData = Transpose[{\[Mu]Vec, KRat Table[1,{Length[\[Mu]Vec]}], Temp[\[Mu]Vec,KRat]}];
   (* This step is necessary to make grid regular *)  

 (* Data for interpolation. *) 
 For[i  = 2,
     i <= Length[KRatVec],
     KRat          = KRatVec[[i]];
     \[Chi]TempVec = nP[\[GothicV]IndP[sRatVec,KRat]];
     \[Mu]TempVec  = sRatVec + \[Chi]TempVec;
     TempData      = Partition[Flatten[Transpose[{\[Mu]TempVec, KRat Table[1,{Length[\[Mu]TempVec]}], \[Chi]TempVec}]],3];



    (* Construct interp consumption functiontion given KRat *)
     Temp = Interpolation[
                     Union[
                       Chop[
                    Prepend[TempData, {0.,KRat,0.}         
                ]                  (* Prepending {0,KRat,0} handles potential liquidity constraint *)
             ]                     (* Chop cuts off numerically insignificant digits *)
           ]                       (* Union removes duplicate entries *)
     ,InterpolationOrder->1];      (* Piecewise linear interpolation *)

    (* Construct data for interpolation, using function "Temp" defined above. *)
     cInterpDataTemp = Transpose[{\[Mu]Vec, KRat Table[1,{Length[\[Mu]Vec]}], Temp[\[Mu]Vec,KRat]}]; (* This step is necessary to make grid regular *)   

     cInterpData     = Join[cInterpData,cInterpDataTemp];  
     i  = i + 1
     ]; (* End loop *)

 (* Construct interp consumption function *)
 cInterpFunc= AppendTo[cInterpFunc, Interpolation[cInterpData,InterpolationOrder->1]];

]; (* End SolveAnotherPeriodInd *)

(* "ConstructIndcFunc" constructs agent consumption function with idiosyncratic shocks, using "SolveAnotherPeriodInd" defined above *)
ConstructIndcFunc := Block[{},

 (* Iterate until consumption func converges *)
 Iteration      = 0;
 CalculatedGap  = 1; (* Initial value of calulcated gap *)
 MRatGridTest   = mSS{0.9, 1, 1.1};

 While[CalculatedGap > MaxGap (* Iterate while calculated (max) gap is more than MaxGap *), 

       Iteration++;  
       (* Print[Iteration]; *) 
       SolveAnotherPeriodInd; 
       CalculatedGap = Max[Abs[cInterpFunc[[-1]][kSS, MRatGridTest]/cInterpFunc[[-2]][kSS, MRatGridTest]-1]]; 
       (* Print[CalculatedGap];  *)
       ]; (* End While *)
 
 (* Print[" # of times iterated: ", Iteration]; *)

      ]; (* End Block *)


