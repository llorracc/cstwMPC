(* FindBetaDistSevenAltParamsLiqFinPlsRet.m *)
(* With an ALTERNATIVE parameter of income shocks.  
\[Sigma]Theta         = (0.01*4)^0.5/2;  (* ALTERNATIVE Standard deviation of lognormal distribution of transitory shocks *)
*)

(* Find \[Beta]middle which matches distribution of Liquid FINANCIAL assets plus ret assets levels, using Dist model with time pref factors approximated by seven points *)

     
SetDirectory[NotebookDirectory[]];
If[Directory[] != NoAggShockDir, SetDirectory[NoAggShockDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "NoAggShock". *)
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Match liquid FINANCIAL assets plus retirement assets"];
Print["Estimate \[Beta]middle using \[Beta]-Dist model with time pref factors approximated by seven points "];

(* Messege off *)
Off[General::"spell1"]; 
Off[Permutations::"obslt"];
Off[General::"obspkg"];
Off[InterpolatingFunction::"dmval"];
Off[NIntegrate::"ncvb"];
Off[FindMinimum::"lstol"];
Off[General::"compat"];


TimeS = SessionTime[];  

Model              = Seven;  (* Indicates that the model is Dist with time pref factors approximated by seven points *)
Perm               = Yes;    (* Perm shock is on *)
KS                 = No;     (* Income process is NOT KS *)
MatchLiqFinPlsRetAssets  = Yes;    (* Mathcing liquid financial assets plus ret assets, not net worth *)


(* Set parameter values and set up routines *)
Initial\[Beta]middle           = 0.9660;           (* Initial guess of \[Beta]middle *) 
Initialdiff                    = 0.0035;           (* Initial value of diff (difference between approximated points of time pref factor) *)
diff                           = Initialdiff; 
NumOfPeriodsToSimulateInitial  = 1500;             (* Number of periods to simulate *)
PeriodsToUseInitial            = NumOfPeriodsToSimulateInitial (2/15); 
(*
NumOfPeriodsToSimulateInitial  = 1000;             (* Number of periods to simulate *)
PeriodsToUseInitial            = NumOfPeriodsToSimulateInitial (1/5); 
*)
NumOfPeriodsToSimulateSearch   = 1500;             (* Number of periods to simulate *)
PeriodsToUseSearch             = NumOfPeriodsToSimulateSearch (2/3); (* Not using the first 1/3. *)  
(*  
NumOfPeople                    = 7000;             (* Number of people to simulate *)
 (* 200 (inverse of death prob) * 5 * 7 (# of approximated points) *)
*)
NumOfPeople                    = 5600;             (* Number of people to simulate *)
 (* 160 (inverse of death prob) * 5 * 7 (# of approximated points) *)
InitialSaving                  = kSS lbar L / wSS; (* Level of initial saving *) 
<<Params.m;
 (* Set alternative param *)
 \[Sigma]Theta         = (0.01*4)^0.5/2;  (* ALTERNATIVE Standard deviation of lognormal distribution of transitory shocks *)
<<SetupSolve.m;
<<SimFuncs.m;                                     (* Load "Simulate" *) 

(* Obtain (common) initial distribution of Pt and kRatt for later simulations *)
Print["Obtain (common) initial distribution of Pt and kRatt for later simulations "];

 (* Construct lists *)
 NumOfPeriodsToSimulate = NumOfPeriodsToSimulateInitial;
 PeriodsToUse           = PeriodsToUseInitial;
 ConstructShockDrawLists;  (* Construct shock draw lists *)   
 ConstructShockLists;      (* Construct shock lists *)

 (* Search for good guess of \[Beta]middle *)
 Print[" Searching for good guess of \[Beta]middle using Reiter's method... "]; 
 Print[" Diff between approximated points of \[Beta]:  ", diff];

 <<FindIntBetaDistSeven_ReiterLiqFinPlsRet.m; (* (The Reiter's method is) used to get good guess. *)

(* 
(* Obtaining inital dist in this way does not work well in LiqFinPlsRet case because KLevMean is far off from KSS. Doing this in net worth and Fin cases does not create a problem KLevMean is close enough. *)
 (* Evaluate and obtain (common) initial distribution of Pt and kRatt *)
 TimeSEvaludate  = SessionTime[]; 
 Print[" Evaluate with good guess of \[Beta]middle =  ",Initial\[Beta]middle];
 CalcStats       = No; (* Do not calc various statistics *)
 PtInitialList          = Table[1,{NumOfPeople}];
 kRattInitialList       = InitialSaving Table[1,{NumOfPeople}];
 GapKSqHet[Initial\[Beta]middle]; 
(*
 Print[" Gap agg K squared:  ",  GapKSqHet[Initial\[Beta]middle]];
 Print[" Time to evaluate (seconds):  ", SessionTime[]-TimeSEvaludate];
*)
*)

 (* Find \[Beta]middle that matches KLevMean and obtain (common) initial distribution of Pt and kRatt *)
 TimeSEvaludate  = SessionTime[]; 
 Print[" Searching \[Beta]middle and obtaining (common) initial distribution of Pt and kRatt..."];
 CalcStats       = No; (* Do not calc various statistics *)
 PtInitialList          = Table[1,{NumOfPeople}];
 kRattInitialList       = InitialSaving Table[1,{NumOfPeople}];
 Find\[Beta]middleSolution; (* Find \[Beta]middle *)
 Print[" Time spent to search \[Beta]middle and obtain (common) initial distribution of Pt and kRatt (minutes):  ", (SessionTime[]-TimeSEvaludate)/60];

 (* Initial dist of Pt and kRatt for later use *)
 PtInitialList          = Pt;
 kRattInitialList       = kRatt;
 Print[" Obtained (common) initial distribution of Pt and kRatt. "]; 


(* Find solution. The method is essentially the grid search. *)
Print["Start searching for \[Beta]middle using the simulation method "]; 
NumOfPeriodsToSimulate = NumOfPeriodsToSimulateSearch;
PeriodsToUse           = PeriodsToUseSearch;
ConstructShockDrawLists;  (* Construct shock draw lists *)   
ConstructShockLists;      (* Construct shock lists *)


 (* Evaluate at diff (difference between approximated points of time pref factor) = Initialdiff-0.0001, Initialdiff, and Initialdiff+0.0001. *)
 StatsMat = Table[

  (* Search for \[Beta]middle which matches agg K (same as mathcing agg KY raito), given diff *)
  diff = Initialdiff + 0.0001 j;

  TimeSSearchBeta1 = SessionTime[]; 
  Print["Diff between approximated points of \[Beta]:  ", diff];
  CalcStats = No;(* Do not calc various statistics when searching *)
  Print[" Searching for initial guess of \[Beta]middle using Reiter's method... "];
  <<FindIntBetaDistSeven_ReiterLiqFinPlsRet.m; (* (The Reiter's method is) used to get good initial guess. *)
  Print[" Searching for \[Beta]middle... "];
  Find\[Beta]middleSolution; 
  Print[" Time spent to find \[Beta]middle (minutes):  ", (SessionTime[]-TimeSSearchBeta1)/60];
  Print[" Solution of \[Beta]middle: ", \[Beta]middleSolution]; (* \[Beta]middle which matches agg K given diff *)
  
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
   kLevTop80PercentMean, 
   kLevTop20PercentMean, 
   AggMPCMeanAnnual, 
   SumOfDevSq (* Deviation of wealth distribution from the US data *)}
  , {j, -1, 0}];

While[StatsMat[[-1, -1]] < StatsMat[[-2, -1]] (* Increase diff until dev (of wealth distribution from the US data) starts to increase *),
  diff = StatsMat[[-1, 1]]  + 0.0001; 

  TimeSSearchBeta1 = SessionTime[]; 
  Print["Diff between approximated points of \[Beta]:  ", diff];
  CalcStats = No;(* Do not calc various statistics when searching *)
  Print[" Searching for initial guess of \[Beta]middle using Reiter's method... "];
  <<FindIntBetaDistSeven_ReiterLiqFinPlsRet.m; (* (The Reiter's method is) used to get good initial guess. *)
  Print[" Searching for \[Beta]middle... "];
  Find\[Beta]middleSolution; 
  Print[" Time spent to find \[Beta]middle (minutes):  ", (SessionTime[]-TimeSSearchBeta1)/60];
  Print[" Solution of \[Beta]middle: ", \[Beta]middleSolution]; (* \[Beta]middle which matches agg K given diff *)
  
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

  TimeSSearchBeta1 = SessionTime[]; 
  Print["Diff between approximated points of \[Beta]:  ", diff];
  CalcStats = No;(* Do not calc various statistics when searching *)
  Print[" Searching for initial guess of \[Beta]middle using Reiter's method... "];
  <<FindIntBetaDistSeven_ReiterLiqFinPlsRet.m; (* (The Reiter's method is) used to get good initial guess. *)
  Print[" Searching for \[Beta]middle... "];
  Find\[Beta]middleSolution; 
  Print[" Time spent to find \[Beta]middle (minutes):  ", (SessionTime[]-TimeSSearchBeta1)/60];
  Print[" Solution of \[Beta]middle: ", \[Beta]middleSolution]; (* \[Beta]middle which matches agg K given diff *)
  
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
   kLevTop80PercentMean, 
   kLevTop20PercentMean, 
   AggMPCMeanAnnual, 
   SumOfDevSq}
   ]
 ];

(*
Print[" Stats mat: "]; (* Matrix of statistics calculated above *)
Print[StatsMat];
*)

(* Find position where deviation (of wealth distribution from the US data) is minimized *)
SumOfDevSqList = Transpose[StatsMat][[-1]];
PosMin         = Ordering[SumOfDevSqList][[1]]; (* Position which gives min *)

(* Solution *)
NumOfTimes       = 5; (* Num of times to increase the sim size to raise precision *)
PtInitialList = 
  Flatten[Table[
    Table[Take[
      Pt, {(i - 1)*(NumOfPeople/7) + 1, (i - 1)*(NumOfPeople/7) + 
        NumOfPeople/7}], {NumOfTimes}], {i, 1, 7}]];
kRattInitialList = 
  Flatten[Table[
    Table[Take[
      kRatt, {(i - 1)*(NumOfPeople/7) + 1, (i - 1)*(NumOfPeople/7) + 
        NumOfPeople/7}], {NumOfTimes}], {i, 1, 7}]];
(*
PtInitialList    = Flatten[Table[Pt, {NumOfTimes}]];
kRattInitialList = Flatten[Table[kRatt, {NumOfTimes}]];
*)
NumOfPeople      = NumOfTimes NumOfPeople; 
ConstructShockDrawLists;  (* Construct shock draw lists *)   
ConstructShockLists;      (* Construct shock lists *)


Print["Solution: "]; 
diff                  = StatsMat[[PosMin,1]]; (* Solution of diff *)
\[Beta]middleSolution = StatsMat[[PosMin,2]]; (* Solution of \[Beta]middle *)
CalcStats = Yes; (* Rerun with the solution *)
GapKSqHet[\[Beta]middleSolution];

kLevListDistSevenNoAggShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListDistSevenNoAggShockAltParamsLiqFinPlsRet.txt", kLevListDistSevenNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListDistSevenNoAggShockAltParamsLiqFinPlsRet.txt", kLevListDistSevenNoAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCDistSevenNoAggShockAltParamsLiqFinPlsRet.txt", AggMPCMeanAnnual, "Table"];
Export[ParentDirectory[] <> "/Results/KYDistSevenNoAggShockAltParamsLiqFinPlsRet.txt", (KLevMean/lbar/L)^(1 - CapShare), "Table"];

Export["diffAltParamsLiqFinPlsRet.txt", diff, "Table"];
Export["BetamiddleAltParamsLiqFinPlsRet.txt", \[Beta]middleSolution, "Table"];
Export[ParentDirectory[] <> "/WithAggShocks/diffAltParamsLiqFinPlsRet.txt", diff, "Table"];
Export[ParentDirectory[] <> "/WithAggShocks/BetamiddleAltParamsLiqFinPlsRet.txt", \[Beta]middleSolution, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/diffAltParamsLiqFinPlsRet.txt", diff, "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/BetamiddleAltParamsLiqFinPlsRet.txt", \[Beta]middleSolution, "Table"];

Export[ParentDirectory[] <> "/Results/BetamiddleAltParamsLiqFinPlsRet.tex", Round[10000 \[Beta]middleSolution]/10000//N, "Table"];
Export[ParentDirectory[] <> "/Results/NablaAltParamsLiqFinPlsRet.tex",      Round[10000 3.5 diff]/10000//N, "Table"];
Export[ParentDirectory[] <> "/Results/BetaLowAltParamsLiqFinPlsRet.tex", Round[10000 (\[Beta]middleSolution - 3.5 diff)]/10000 // N, "Table"];
Export[ParentDirectory[] <> "/Results/BetaHighAltParamsLiqFinPlsRet.tex",Round[10000 (\[Beta]middleSolution + 3.5 diff)]/10000 // N, "Table"];


Print[" Difference beteen approximated points of \[Beta] (\[EmptyDownTriangle]/3.5), \[Beta]middle (\[Beta]grave in the text), \[Beta]middle-\[EmptyDownTriangle],  \[Beta]middle+\[EmptyDownTriangle], Agg K (Mean of k (level)), K/Y ratio, Average deviation of K (%): ", 
 {diff, 
  \[Beta]middleSolution, 
  \[Beta]middleSolution - 3.5 diff, 
  \[Beta]middleSolution + 3.5 diff, 
  StatsMat[[PosMin,3]], 
  StatsMat[[PosMin,4]], 
  StatsMat[[PosMin,5]]}];

(*
Print[" Distribution of capital (k) 1%, 10%, 20%, 25%, 40%, 50%, 60%, 80%, 5th quintile, Agg Annual MPC, Sum of Dev Squared:"];
Print[Drop[StatsMat[[PosMin]] ,5]];
*)

Clear[MatchLiqFinPlsRetAssets]; (* Clear MatchLiqFinPlsRetAssets var *)


(* Display time spent *)  
Print[" Time spent to run \[Beta]-Dist model with seven types (minutes):  ", (SessionTime[]-TimeS)/60];

