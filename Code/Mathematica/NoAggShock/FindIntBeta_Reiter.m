(* FindIntBeta_Reiter.m *)

(* Find \[Beta] which produces perfect forsight agg K.
 Income process: perm and tran shock 
 Method: Reiter's (transition matrix) method. For details about the Reiter's method, see http://elaine.ihs.ac.at/~mreiter/hetjedc.pdf 

 Note that this file is used only to find good initial guess of \[Beta]. 
 *)

     
(* Messege off *)
Off[General::"spell1"]; 
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];

TimeSReiter = SessionTime[];  

Model       = Point; (* Indicates model with Point time pref factor *)
Perm        = Yes;    (* Perm shock is on *)
KS          = No;     (* Income process is NOT KS *)
PermTranMat = No;     (* Matrix of transition caused by perm inc shock will be calculated *)

(* Set up routines and set parameter values *)  
<<Params.m;
<<SetupSolve.m; 
Initial\[Beta] = 0.98879;
nkgrid         = 400; (* Number of k grid *) 
kmax           = 50;
kmin           = 0;
kgrid          = Table[kmin + (i - 1) (kmax - kmin)/(nkgrid - 1), {i, 1, nkgrid}];


(* Integrates cumlative distribution function (disty and distp). This part is from Reiter's codes. *) 
IDistgrid = Table[0, {Length[ThetaVecList]}];
For[i = 2, i <= Length[ThetaVecList], i++, 
    IDistgrid[[i]] = IDistgrid[[i - 1]] + NIntegrate[Disty[y], {y, ThetaVecList[[i - 1]], ThetaVecList[[i]]}]];

(* Evaluate gap at Initial\[Beta] *)
GapKSqTran[Initial\[Beta]];

(* Solve for \[Beta] *)
\[Beta]Solution = beta /. Last[FindMinimum[GapKSqTran[beta], 
  {beta, Initial\[Beta] (* Initial estimate *), 
(*   0.9885  (* Lower bound *), *)
   0.988  (* Lower bound *),
   0.991  (* Upper bound *)}, 
 WorkingPrecision -> 10 (* 10 may be enough?? *) 
 (*, Method -> "Gradient" *)]];
Print[" Initial guess of \[Beta]:  ", \[Beta]Solution];
(*
Print[" Initial guess of \[Beta] (4 digits below point):  ", N[\[Beta]Solution, 4]];
*)

 
(* Display time spent *)  
(*
Print[" Time spent to search for initial guess of \[Beta] (minutes):  ", (SessionTime[]-TimeSReiter)/60];
*)

