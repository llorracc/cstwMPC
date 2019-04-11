(* FindBetaDistNine.m *)

(* Find \[Beta]middle which matches distribution of wealth levels, using Dist model with time pref factors approximated by nine points *)
     
SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Estimate \[Beta]middle using \[Beta]-Dist model with time pref factors approximated by nine points"];

(* Messege off *)
Off[General::"spell1"]; 
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];
Off[NIntegrate::"ncvb"];
Off[FindMinimum::"lstol"];

TimeS = SessionTime[];  

Model  = Nine;   (* Indicates that the model is Dist with time pref factors approximated by nine points *)
Perm   = Yes;    (* Perm shock is on *)
KS     = No;     (* Income process is NOT KS *)


(* Set parameter values and set up routines *)
Initial\[Beta]middle           = 0.9860;           (* Initial guess of \[Beta]middle *) 
Initialdiff                    = 0.0012;           (* Initial value of diff (difference between approximated points of time pref factor) *)
diff                           = Initialdiff; 
NumOfPeriodsToSimulateInitial  = 1000;             (* Number of periods to simulate *)
PeriodsToUseInitial            = NumOfPeriodsToSimulateInitial (1/5); 
NumOfPeriodsToSimulateSearch   = 1100;             (* Number of periods to simulate *)
PeriodsToUseSearch             = NumOfPeriodsToSimulateSearch (10/11); 
(*  
NumOfPeople                    = 9000;             (* Number of people to simulate *)
*)
NumOfPeople                    = 7200;             (* Number of people to simulate *)

InitialSaving                  = kSS lbar L / wSS; (* Level of initial saving *) 
<<Params.m;
<<SetupSolve.m;
<<SimFuncs.m;                                      (* Load "Simulate" *) 

(* Obtain (common) initial distribution of Pt and kRatt for later simulations *)
Print["================================================="];
Print["Obtain (common) initial distribution of Pt and kRatt for later simulations "];

 (* Construct lists *)
 NumOfPeriodsToSimulate = NumOfPeriodsToSimulateInitial;
 PeriodsToUse           = PeriodsToUseInitial;
 ConstructShockDrawLists;  (* Construct shock draw lists *)   
 ConstructShockLists;      (* Construct shock lists *)

 (* Search for good guess of \[Beta]middle *)
 Print[" Searching for good guess of \[Beta]middle using Reiter's method... "]; 
 Print[" Diff between approximated points of \[Beta]:  ", diff];

 <<FindIntBetaDistNine_Reiter.m;

 (* Evaluate, and obtain (common) initial distribution of Pt and kRatt *)
 TimeSEvaludate  = SessionTime[]; 
 Print[" Evaluate with good guess of \[Beta]middle =  ",Initial\[Beta]middle];
 CalcStats       = No; (* Do not calc various statistics *)
 PtInitialList          = Table[1,{NumOfPeople}];
 kRattInitialList          = InitialSaving Table[1,{NumOfPeople}];
 GapKSqHet[Initial\[Beta]middle];
(*
 Print[" Gap agg K squared:  ",  GapKSqHet[Initial\[Beta]middle]];
*)
 Print[" Time to evaluate (seconds):  ", SessionTime[]-TimeSEvaludate];

 (* Initial dist of Pt and kRatt for later use *)
 PtInitialList          = Pt;
 kRattInitialList          = kRatt; 
 Print[" Obtained (common) initial distribution of Pt and kRatt"];


(* Find solution. The method is essentially the grid search. *)
Print["================================================="];
Print["Start searching for \[Beta]middle using the simulation method "]; 
NumOfPeriodsToSimulate = NumOfPeriodsToSimulateSearch;
PeriodsToUse           = PeriodsToUseSearch;
ConstructShockDrawLists;  (* Construct shock draw lists *)   
ConstructShockLists;      (* Construct shock lists *)


 (* Evaluate at diff (difference between approximated points of time pref factor) = Initialdiff-0.0001, Initialdiff, and Initialdiff+0.0001. *)
 StatsMat = Table[

  (* Search for \[Beta]middle which matches agg K (same as mathcing agg KY raito), given diff *)
  diff = Initialdiff + 0.0001 j;

  Print["==========================="];
  TimeSSearchBeta1 = SessionTime[]; 
  Print["Diff between approximated points of \[Beta]:  ", diff];
  CalcStats = No;(* Do not calc various statistics when searching *)
  Print[" Searching for initial guess of \[Beta]middle using Reiter's method... "];
  <<FindIntBetaDistNine_Reiter.m;
  Print[" Searching for \[Beta]middle... "];
  Find\[Beta]middleSolution; 
  Print[" Solution of \[Beta]middle: ", \[Beta]middleSolution]; (* \[Beta]middle which matches agg K given diff *)
  Print[" Time spent to find \[Beta]middle (minutes):  ", (SessionTime[]-TimeSSearchBeta1)/60];
  
  (* Report statistics *)
  CalcStats = Yes;
  GapKSqHet[\[Beta]middleSolution];
  
  (* Collect results *)
  {diff, 
   \[Beta]middleSolution, 
   KLevMean, 
   (KLevMean/lbar/L)^(1 - CapShare), 
   SdtK/KSS 100, 
   kLevTop1PercentMean, 
   kLevTop10PercentMean, 
   kLevTop20PercentMean, 
   kLevTop25PercentMean, 
   kLevTop40PercentMean, 
   kLevTop50PercentMean, 
   kLevTop60PercentMean, 
   (100 - kLevTop80PercentMean), 
   kLevTop20PercentMean, 
   AggMPCMeanAnnual, 
   SumOfDevSq (* Deviation of wealth distribution from the US data *)}
  , {j, -1, 1}];

While[StatsMat[[-1, -1]] < StatsMat[[-2, -1]] (* Increase diff until dev (of wealth distribution from the US data) starts to increase *),
  diff = StatsMat[[-1, 1]]  + 0.0001; 

  Print["==========================="];
  TimeSSearchBeta1 = SessionTime[]; 
  Print["Diff between approximated points of \[Beta]:  ", diff];
  CalcStats = No;(* Do not calc various statistics when searching *)
  Print[" Searching for initial guess of \[Beta]middle using Reiter's method... "];
  <<FindIntBetaDistNine_Reiter.m;
  Print[" Searching for \[Beta]middle... "];
  Find\[Beta]middleSolution; 
  Print[" Solution of \[Beta]middle: ", \[Beta]middleSolution]; (* \[Beta]middle which matches agg K given diff *)
  Print[" Time spent to find \[Beta]middle (minutes):  ", (SessionTime[]-TimeSSearchBeta1)/60];
  
  (* Report statistics *)
  CalcStats = Yes;
  GapKSqHet[\[Beta]middleSolution];
  
  (* Append results *)
  StatsMat = Append[StatsMat, 
  {diff, 
   \[Beta]middleSolution, 
   KLevMean, 
   (KLevMean/lbar/L)^(1 - CapShare), 
   SdtK/KSS 100, 
   kLevTop1PercentMean, 
   kLevTop10PercentMean, 
   kLevTop20PercentMean, 
   kLevTop25PercentMean, 
   kLevTop40PercentMean, 
   kLevTop50PercentMean, 
   kLevTop60PercentMean, 
   (100 - kLevTop80PercentMean), 
   kLevTop20PercentMean, 
   AggMPCMeanAnnual, 
   SumOfDevSq}
   ]
 ];

While[StatsMat[[1, -1]] < StatsMat[[2, -1]] (* Decrease diff until dev (of wealth distribution from the US data) starts to increase *),
  diff = StatsMat[[1, 1]]  - 0.0001; 

  Print["==========================="];
  TimeSSearchBeta1 = SessionTime[]; 
  Print["Diff between approximated points of \[Beta]:  ", diff];
  CalcStats = No;(* Do not calc various statistics when searching *)
  Print[" Searching for initial guess of \[Beta]middle using Reiter's method... "];
  <<FindIntBetaDistNine_Reiter.m;
  Print[" Searching for \[Beta]middle... "];
  Find\[Beta]middleSolution; 
  Print[" Solution of \[Beta]middle: ", \[Beta]middleSolution]; (* \[Beta]middle which matches agg K given diff *)
  Print[" Time spent to find \[Beta]middle (minutes):  ", (SessionTime[]-TimeSSearchBeta1)/60];
  
  (* Report statistics *)
  CalcStats = Yes;
  GapKSqHet[\[Beta]middleSolution];
  
  (* Prepend results *)
  StatsMat = Prepend[StatsMat, 
  {diff, 
   \[Beta]middleSolution, 
   KLevMean, 
   (KLevMean/lbar/L)^(1 - CapShare), 
   SdtK/KSS 100, 
   kLevTop1PercentMean, 
   kLevTop10PercentMean,
   kLevTop20PercentMean,  
   kLevTop25PercentMean, 
   kLevTop40PercentMean, 
   kLevTop50PercentMean, 
   kLevTop60PercentMean, 
   (100 - kLevTop80PercentMean), 
   kLevTop20PercentMean, 
   AggMPCMeanAnnual, 
   SumOfDevSq}
   ]
 ];

Print["==========================="]; 
(*
Print[" Stats mat: "]; (* Matrix of statistics calculated above *)
Print[StatsMat];
*)

(* Find position where deviation (of wealth distribution from the US data) is minimized *)
SumOfDevSqList = Transpose[StatsMat][[-1]];
PosMin         = Ordering[SumOfDevSqList][[1]]; (* Position which gives min *)

(* Solution *)
diff                  = StatsMat[[PosMin,1]]; (* Solution of diff *)
\[Beta]middleSolution = StatsMat[[PosMin,2]]; (* Solution of \[Beta]middle *)
CalcStats = Yes;
GapKSqHet[\[Beta]middleSolution];

Export[ParentDirectory[] <> "/WithAggShocks/diffNine.txt", diff, "Table"];
Export[ParentDirectory[] <> "/WithAggShocks/BetamiddleNine.txt", \[Beta]middleSolution, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/diffNine.txt", diff, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/BetamiddleNine.txt", \[Beta]middleSolution, "Table"];
Export[ParentDirectory[] <> "/Results/BetamiddleNine.tex", Round[10000 \[Beta]middleSolution]/10000//N, "Table"];
Export[ParentDirectory[] <> "/Results/NablaNine.tex",      Round[10000 3.5 diff]/10000//N, "Table"];

Print["Solution: "]; 
Print[" Difference beteen approximated points of \[Beta], \[Beta]middle, \[Beta]low, and \[Beta]high: ", 
      {diff, \[Beta]middleSolution, \[Beta]middleSolution - 3.5 diff, \[Beta]middleSolution + 3.5 diff}];
Print[" Difference between approximated points of \[Beta], \[Beta]middle, Agg K (Mean of k (level)), K/Y ratio, Average deviation of K (%), Distribution of capital (k) 1%, 10%, 20%, 25%, 40%, 50%, 60%, 1st quintile, 5th quintile, Agg Annual MPC, Sum of Dev Squared:"];
Print[StatsMat[[PosMin]]];


(* Display time spent *)  
Print[" Time spent to run \[Beta]-Dist model with nine types (minutes):  ", (SessionTime[]-TimeS)/60];