(* FindBeta.m *)

(* Find \[Beta] which produces perfect forsight agg K (and KY ratio), 
   using Reiter's method with tran shock only to obtain the initial guess.
 *)
     
SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)
(*
ClearAll["Global`*"];
*)


(* Messege off *)
Off[General::"spell1"]; 
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];
Off[NIntegrate::"ncvb"];
Off[FindMinimum::"lstol"];
Off[FindMinimum::"fmdig"];

Print["============================================================="];
Print["Estimate \[Beta] (using model with point (unique) \[Beta])"];

(* Obtain initial guess *)
Print["Searching for initial guess of \[Beta] using Reiter's method... "];
<<FindIntBeta_Reiter.m;

TimeS = SessionTime[];  

Print["Searching for \[Beta] using the simulation method... "];
Model        = Point; (* Indicates model with Point time pref factor *)
Perm         = Yes;   (* Perm shock is on *)
KS           = No;    (* No: Income process is NOT KS *)
DeathFromAge = No; 

(* Set parameter values and set up routines *)  
NumOfPeriodsToSimulate = 1000;             (* Number of periods to simulate *)
PeriodsToUse           = NumOfPeriodsToSimulate (2/5); 
NumOfPeople            = 4800;             (* Number of people to simulate *)
 (* NumOfPeople needs to be a multiple of 1/ProbOfDeath *)
(*
NumOfPeople            = 5000;             (* Number of people to simulate *)
*)
InitialSaving          = kSS lbar L / wSS; (* Level of initial saving *) 
Initial\[Beta]         = \[Beta]Solution;
<<Params.m;
<<SetupSolve.m;
<<SimFuncs.m;                              (* Load "Simulate" *) 

(* Construct lists *)
ConstructShockDrawLists;  (* Construct shock draw lists *)   
ConstructShockLists;      (* Construct shock lists *)

(* Evaluate with initial guess of \[Beta] *)
TimeSEvaludate = SessionTime[];
(* 
Print[" Evaluate with initial guess of \[Beta]=  ",Initial\[Beta]];
*)
CalcStats        = No; (* Do not calc various statistics *)
NumOfIterations  = 0;
PtInitialList    = Table[1,{NumOfPeople}];
kRattInitialList = InitialSaving Table[1,{NumOfPeople}];
GapKSq[Initial\[Beta]];
(*
Print[" Gap agg K squared:  ",  GapKSq[Initial\[Beta]]];
Print[" Time to evaluate (seconds):  ", SessionTime[]-TimeSEvaludate];
*)

(* Initial dist of Pt and kRatt for later use *)
PtInitialList          = Pt;
kRattInitialList       = kRatt; 

(* Find solution *)
Print[" Searching for \[Beta]... "];
ConstructShockDrawLists;  (* Construct shock draw lists *)   
ConstructShockLists;      (* Construct shock lists *)
CalcStats = No;           (* Do not calc various statistics when searching *)

\[Beta]Solution = beta /. Last[FindMinimum[GapKSq[beta], 
  {beta, Initial\[Beta] (* Initial estimate *), 
   Initial\[Beta] - 0.002 (* Lower bound *), 
   Initial\[Beta] + 0.002 (* Upper bound *)}, 
 Method           -> "PrincipalAxis",
 WorkingPrecision -> 12]];
Print[" Solution of \[Beta]:  ", \[Beta]Solution];
(*
Print[" Solution of \[Beta] (4 digits below point):  ", N[\[Beta]Solution, 4]]; 
*)
Export[ParentDirectory[] <> "/WithAggShocks/Beta.txt", \[Beta]Solution, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/Beta.txt", \[Beta]Solution, "Table"];
Export[ParentDirectory[] <> "/Results/Beta.tex", Round[10000 \[Beta]Solution]/10000//N, "Table"];

(* Report statistics *)
CalcStats = Yes;
GapKSq[\[Beta]Solution];
kLevListPointNoAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListPointNoAggShock.txt", kLevListPointNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListPointNoAggShock.txt", kLevListPointNoAggShock, "Table"];

Export[ParentDirectory[] <> "/Results/GiniCoeffWMeanPointNoAggShock.tex",       Round[100 GiniCoeffWMean]/100//N, "Table"];       (* gini coeff of wealth *)
Export[ParentDirectory[] <> "/Results/GiniCoeffWEndMeanPointNoAggShock.tex",    Round[100 GiniCoeffWEndMean]/100//N, "Table"];    (* gini coeff of wealth at end-period *)
Export[ParentDirectory[] <> "/Results/GiniCoeffPermIncMeanPointNoAggShock.tex", Round[100 GiniCoeffPermIncMean]/100//N, "Table"]; (* gini coeff of perm inc *)
Export[ParentDirectory[] <> "/Results/StdLogMeanPointNoAggShock.tex",           Round[100 StdLogMean]/100//N, "Table"];           (* std of wealth *)
Export[ParentDirectory[] <> "/Results/StdLogEndMeanPointNoAggShock.tex",        Round[100 StdLogEndMean]/100//N, "Table"];        (* std of wealth at end-period *)
Export[ParentDirectory[] <> "/Results/StdLogPermIncMeanPointNoAggShock.tex",    Round[100 StdLogPermIncMean]/100//N, "Table"];    (* std of perm inc *)

Export[ParentDirectory[] <> "/Results/MPCPointNoAggShock.txt", AggMPCMeanAnnual, "Table"];
Export[ParentDirectory[] <> "/Results/KYPointNoAggShock.txt", (KLevMean/lbar/L)^(1-CapShare), "Table"];

 
(* Display time spent *)  
Print[" Time spent to run model with point (unique) \[Beta] (minutes):  ", (SessionTime[]-TimeS)/60];

