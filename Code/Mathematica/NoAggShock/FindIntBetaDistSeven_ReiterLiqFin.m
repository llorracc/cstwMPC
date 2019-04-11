(* FindIntBetaDistSeven_ReiterLiqFin.m *)

(* Find \[Beta]middle which produces perfect forsight agg K.
 Income process: perm and tran shock 
 Method: Reiter's (transition matrix) method. For details about the Reiter's method, see http://elaine.ihs.ac.at/~mreiter/hetjedc.pdf 

 Note that this file is used only to find good initial guess of \[Beta]middle. 
 *)

     
(* Messege off *)
Off[General::"spell1"]; 
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];

TimeSReiter = SessionTime[];  

Model       = Seven;  (* Indicates that the model is Dist with time pref factors approximated by seven points *)
Perm        = Yes;    (* Perm shock is on *)
KS          = No;     (* Income process is NOT KS *)
PermTranMat = No;     (* Matrix of transition caused by perm inc shock will be calculated *)


(* Set up routines and set parameter values *)   
<<SetupSolve.m;
nkgrid          = 400; (* Number of k grid *) 
kmaxLow         = 50/38 kSS;
kmin            = 0;
kgridLow        = Table[kmin + (i - 1) (kmaxLow - kmin)/(nkgrid - 1), {i, 1, nkgrid}];

kmaxMid         = 3 kmaxLow; 
kgridMid        = Table[kmin + (i - 1) (kmaxMid - kmin)/(nkgrid - 1), {i, 1, nkgrid}];

kmaxHigh        = 10 kmaxLow; (* Some experiments show that 500 is high enough *)
kgridHigh       = Table[kmin + (i - 1) (kmaxHigh - kmin)/(nkgrid - 1), {i, 1, nkgrid}];

(* Integrates cumlative distribution function (disty and distp). This part is from Reiter's codes. *) 
IDistgrid = Table[0, {Length[ThetaVecList]}];
For[i = 2, i <= Length[ThetaVecList], i++, 
    IDistgrid[[i]] = IDistgrid[[i - 1]] + NIntegrate[Disty[y], {y, ThetaVecList[[i - 1]], ThetaVecList[[i]]}]];

(* Evaluate gap at Initial\[Beta]middle *)
GapKSqHetMultiTran[Initial\[Beta]middle];

(* Solve for \[Beta]middle *)
\[Beta]middleSolution = beta /. Last[FindMinimum[GapKSqHetMultiTran[beta], 
  {beta, Initial\[Beta]middle, 

   0.905   (* Lower bound *),  
   0.915   (* Upper bound *)}, 

 WorkingPrecision -> 10 (* 10 may be enough?? *) 
 (*, Method -> "Gradient" *)]];
Print[" \[Beta]middle:  ", \[Beta]middleSolution];
(*
Print[" \[Beta]middle (4 digits below point):  ", N[\[Beta]middleSolution, 4]];
*)
GapKSqHetMultiTran[\[Beta]middleSolution];

Initial\[Beta]middle = \[Beta]middleSolution; 
 
(* Display time spent *)  
Print[" Time spent to get guess of \[Beta]middle (minutes):  ", (SessionTime[]-TimeSReiter)/60];


