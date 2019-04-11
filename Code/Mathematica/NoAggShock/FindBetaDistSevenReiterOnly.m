(* FindBetaDistSevenReiterOnly.m *)

(* Find \[Beta]middle which matches wealth perm inc ratio, using Dist model with time pref factors approximated by seven points 
   Note that simulation is NOT used at all in this file. 
   The whole process is solved only by using the Reiter's (transition matrix) method, which can eliminate simulation error. For details about the Reiter's method, see http://elaine.ihs.ac.at/~mreiter/hetjedc.pdf 
*)

SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)

Print["============================================================="];
Print["Estimate \[Beta]middle using \[Beta]-Dist model without simulation"];

(* Messege off *)
Off[General::"spell1"];
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];
Off[NIntegrate::"ncvb"];
Off[FindMinimum::"lstol"];

TimeS = SessionTime[];

Model       = Seven;(* Indicates model with seven types *)
Perm        = Yes;  (* Perm shock is on *)
KS          = No;   (* Income process is NOT KS *)
PermTranMat = Yes;  (* Matrix of transition caused by perm inc shock will be calculated *)

(* Set parameter values and set up routines *)
Initial\[Beta]middle    = 0.9860; (* Initial guess of \[Beta]middle *)
Initialdiff             = 0.0008;
diff                    = Initialdiff;
inc                     = 0.0001;
NumOfPeriodsToSimulate  = 1500;             (* Number of periods to simulate *)
PeriodsToUse            = NumOfPeriodsToSimulate (2/3); (* Not using the first 1/3. *) 

NumOfPeople             = 33600;            (* Number of people to simulate *)
 (* NumOfPeople is a multiple of 1/death prob * 7 *)
(* 
NumOfPeople             = 35000;            (* Number of people to simulate *)
*)

InitialSaving           = kSS lbar L / wSS; (* Level of initial saving *) 

<<Params.m;
<<SetupSolve.m;
<<SimFuncs.m;                                     (* Load "Simulate" *) 

nkgrid     = 400; (* Number of k grid *)
kmaxLow    = 50;
kmin       = 0;
kgridLow   = Table[kmin + (i - 1) (kmaxLow - kmin)/(nkgrid - 1), {i, 1, nkgrid}];

kmaxMid    = 3 kmaxLow;
kgridMid   = Table[kmin + (i - 1) (kmaxMid - kmin)/(nkgrid - 1), {i, 1, nkgrid}];

kmaxHigh   = 10 kmaxLow;(* Some experiments show that 500 is high enough *)kgridHigh  = Table[kmin + (i - 1) (kmaxHigh - kmin)/(nkgrid - 1), {i, 1, nkgrid}];

(* Integrates cumlative distribution function (disty and distp) *)
IDistgrid = Table[0, {Length[ThetaVecList]}];
For[i = 2, i <= Length[ThetaVecList], i++, 
  IDistgrid[[i]] = IDistgrid[[i - 1]] + NIntegrate[Disty[y], {y, ThetaVecList[[i - 1]], ThetaVecList[[i]]}]];

IDistpgrid = Table[0, {Length[PsiVecList]}];
For[i = 2, i <= Length[PsiVecList], i++, 
  IDistpgrid[[i]] = IDistpgrid[[i - 1]] + NIntegrate[Distp[y], {y, PsiVecList[[i - 1]], PsiVecList[[i]]}]];


(* Find solution. The method is essentially the grid search. *)
diffList             = Table[inc j, {j, -1, 1}] + Initialdiff;
SumOfDevSqList       = Table[0, {Length[diffList]}];
\[Beta]middleSolutionList = Table[0, {Length[diffList]}];

(* Evaluate at Initialdiff-inc, Initialdiff, and Initialdiff+inc. *)
For[m = 1, m <= Length[diffList], m++,
  diff = diffList[[m]];
  Print["Diff between approximated points of \[Beta]:  ", diff];
  
  (* Search for \[Beta]middle which matches agg K (same as mathcing agg KY raito), given diff *)
  \[Beta]middleSolution = beta /. Last[FindMinimum[GapKSqHetMultiTran[beta],
      {beta, Initial\[Beta]middle,
       0.9845   (* Lower bound *),
       0.9890   (* Upper bound *)},
      WorkingPrecision -> 10 (* 10 may be enough?? *)
      (* ,Method->"Gradient" *)]];
  Print[" Solution of \[Beta]middle:  ", \[Beta]middleSolution];
(*
  Print[" Solution of \[Beta]middle (4 digits below point):  ", N[\[Beta]middleSolution, 4]];
*)
  GapKSqHetMultiTran[\[Beta]middleSolution];
  
  (* Calculate wealth distribution *)
  CalcDistDistSevenReiter;
  
  (* Store results *)
  SumOfDevSqList[[m]]       = SumOfDevSq (* Deviation of wealth perm income ratio *);
  \[Beta]middleSolutionList[[m]] = \[Beta]middleSolution
  ];(* End For *)

While[SumOfDevSqList[[-1]] < SumOfDevSqList[[-2]] (* Increase diff until deviation of wealth perm income ratio starts to increase *),
  diff = diffList[[-1]] + inc;
  Print["Diff between approximated points of \[Beta]:  ", diff];
  
  (* Solve for \[Beta]middle (middle point) *)
  \[Beta]middleSolution = beta /. Last[FindMinimum[GapKSqHetMultiTran[beta],
      {beta, Initial\[Beta]middle,
       0.9845   (* Lower bound *),
       0.9890   (* Upper bound *)},
      WorkingPrecision -> 10 (* 10 may be enough?? *)
      (* ,Method->"Gradient" *)]];
  Print[" Solution of \[Beta]middle:  ", \[Beta]middleSolution];
(*
  Print[" Solution of \[Beta]middle (4 digits below point):  ", N[\[Beta]middleSolution, 4]];
*)
  GapKSqHetMultiTran[\[Beta]middleSolution];
  
  (* Calculate wealth distribution *)
  CalcDistDistSevenReiter;
  
  (* Store results *)diffList = Append[diffList, diff];
  SumOfDevSqList = Append[SumOfDevSqList, SumOfDevSq]; (* Append deviation of wealth perm income ratio *)
  \[Beta]middleSolutionList = Append[\[Beta]middleSolutionList, \[Beta]middleSolution]
  ];(* End While *)

While[SumOfDevSqList[[1]] < SumOfDevSqList[[2]] (* Decrease diff until deviation of wealth perm income ratio starts to increase *),
  diff = diffList[[1]] - inc;
  Print["Diff between approximated points of \[Beta]:  ", diff];
  
  (* Solve for \[Beta]middle (middle point) *)
  \[Beta]middleSolution = beta /. Last[FindMinimum[GapKSqHetMultiTran[beta],
      {beta, Initial\[Beta]middle,
       0.9845   (* Lower bound *),
       0.9890   (* Upper bound *)},
      WorkingPrecision -> 10 (* 10 may be enough?? *)
      (* ,Method->"Gradient" *)]];
  Print[" Solution of \[Beta]middle:  ", \[Beta]middleSolution];
(*
  Print[" Solution of \[Beta]middle (4 digits below point):  ", N[\[Beta]middleSolution, 4]];
*)
  GapKSqHetMultiTran[\[Beta]middleSolution];
  
  (* Calculate wealth distribution *)
  CalcDistDistSevenReiter;
  
  (* Store results *)diffList = Prepend[diffList, diff]; (* Prepend deviation of wealth perm income ratio *)
  SumOfDevSqList = Prepend[SumOfDevSqList, SumOfDevSq];
  \[Beta]middleSolutionList = Prepend[\[Beta]middleSolutionList, \[Beta]middleSolution]
  ];(* End While *)

(* Report results *)
(*
Print[" SumOfDevSqList: ", SumOfDevSqList];
*)
MinPos = Ordering[SumOfDevSqList][[1]]; (* Find position which gives minimum deviation of wealth perm income ratio from the US data *)
diff   = diffList[[MinPos]];
\[Beta]middleSolution = \[Beta]middleSolutionList[[MinPos]];
Print["Solution: "]; 
Print[" Difference beteen approximated points of \[Beta], \[Beta]middle, \[Beta]middle-\[EmptyDownTriangle], and \[Beta]middle+\[EmptyDownTriangle]: ", 
      {diff, \[Beta]middleSolution, \[Beta]middleSolution - 3.5 diff, \[Beta]middleSolution + 3.5 diff}];

Export[ParentDirectory[] <> "/Results/BetaLowReiterOnly.tex", Round[10000 (\[Beta]middleSolution - 3.5 diff)]/10000 // N, "Table"];
Export[ParentDirectory[] <> "/Results/BetaHighReiterOnly.tex",Round[10000 (\[Beta]middleSolution + 3.5 diff)]/10000 // N, "Table"];

GapKSqHetMultiTran[\[Beta]middleSolution];
CalcDistDistSevenReiter;

WYRatioDistList = N[{0, 
  WYRatioTop80Percent,
  WYRatioTop60Percent,
  WYRatioTop50Percent,
  WYRatioTop40Percent,
  WYRatioTop30Percent,
  WYRatioTop20Percent,
  WYRatioTop15Percent,
  WYRatioTop10Percent,
  WYRatioTop7Percent,
  WYRatioTop5Percent,
  WYRatioTop3Percent,
  WYRatioTop1Percent}];
Export["WYRatioDistList.txt",WYRatioDistList,"Table"]; (* Save data for later use *)
Export[ParentDirectory[] <> "/Results/WYRatioDistList.txt", WYRatioDistList, "Table"];

(* Run simulation and report distribution statistics and average MPC *)
ConstructShockDrawLists;  (* Construct shock draw lists *)   
ConstructShockLists;      (* Construct shock lists *)

(* Obtain initial dist of Pt and kRatt for later use *)
CalcStats              = No; (* Do not calc various statistics *)
PtInitialList          = Table[1,{NumOfPeople}];
kRattInitialList       = InitialSaving Table[1,{NumOfPeople}];
GapKSqHet[\[Beta]middleSolution]; 
PtInitialList          = Pt;    (* Initial dist of Pt for later use *)
kRattInitialList       = kRatt; (* Initial dist of kRatt for later use *)

(* Calculate and report statistics *)
CalcStats = Yes;
GapKSqHet[\[Beta]middleSolution]; 

TimeE = SessionTime[];
Print[" Time spent to run \[Beta]-Dist model without simulation (minutes): ", (TimeE - TimeS)/60]