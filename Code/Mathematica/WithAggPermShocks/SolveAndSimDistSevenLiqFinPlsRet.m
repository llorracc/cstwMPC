(* SolveAndSimDistSevenLiqFinPlsRet.m *)
(* This file runs \[Beta]-Dist (uniformly distributed \[Beta]) model with time pref factors approximated by seven points. In the model, there are seven types of households. Using parameter values estimated by matching liquid FINANCIAL assets plus retirement assets. *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggPermShocksDir, SetDirectory[WithAggPermShocksDir]];

Print["============================================================="];
Print["Run \[Beta]-Dist model with time pref factors approximated by seven points"];
Print["Using parameter values estimated by matching liquid FINANCIAL assets plus retirement assets"];

MatchLiqFinPlsRetAssets    = Yes;       (* Mathcing liquid financial assets plus retirement assets, not net worth *)

Print["========================================="];
(* Solve and simulate rep agent model with aggregate shocks to obtain initial agg process *)
<<SolveAndSimRepAgent.m; 

TimeStart = SessionTime[]; 

Print["========================================="];
Print["Running \[Beta]-Dist model with time pref factors approximated by seven points... "];
ModelType         = Dist;   (* Indicate that the model is Dist *) 
NumOfApproxPoints = 7;      (* Time pref factors approximated by seven points *)
Rep               = False;
DeathFromAge      = False;  (* Death from age at 100 yrs is incorporated *)

(* Setup routines and set parameter values specific to this file *)
<<PrepareEverything.m;        (* Setup everything (routines etc.) *)
\[Beta]middle = Import["BetamiddleLiqFinPlsRet.txt","List"][[1]]; (* Mean of time pref factors *)
diff = Import["diffLiqFinPlsRet.txt","List"][[1]]; (* Diff between approximated points (of time pref factors) *)
TimesToEstimateSmall   = 5;         (* Number of times to estimate agg process with a smaller # of people *) 
NumPeopleToSim      = 5600;    (* Number of people to simulate *)
NumPeopleToSimLarge = NumPeopleToSim*10;   (* Number of people to simulate in large simulation(s) (needs to be a multiple of NumPeopleToSim). This param can be increased to further reduce sim error. *)


(* Construct converged consumption function and run simulation *)
cInterpFunc = {Interpolation[{{0, 0, 0}, {1000, 0, 1000}, {0, 1000, 0}, {1000, 1000, 1000}}]};

GapCoeff  = 1; (* Initial value of gap *)
Estimatet = 1;
While[GapCoeff > MaxGapCoeff || Estimatet <= TimesToEstimateSmall+2 (* Iterate while the max gap of the estiamted coeff is hither than 1%. Iterate at least TimesToEstimateSmall+2. *), 

    Print["Iteration ", Estimatet];   
       
    (* Construct consumption function *)
    StartConstructingFunc = SessionTime[]; 

    Print[" Solving ind consumption function(s)..."];

    (* 06/24/10 KT comment: the part below can be consolidated, using Table *)
    \[Beta] = (\[Beta]middle + 3 diff)  (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFunc = cInterpFunc1];
    ConstructIndcFunc;     
    cInterpFunc1 = cInterpFunc; 
    cInterpFuncList = {cInterpFunc1}; 

    \[Beta] = (\[Beta]middle + 2 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFunc = cInterpFunc2];
    ConstructIndcFunc;  
    cInterpFunc2 = cInterpFunc; 
    AppendTo[cInterpFuncList, cInterpFunc];

    \[Beta] = (\[Beta]middle +   diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFunc = cInterpFunc3];
    ConstructIndcFunc; 
    cInterpFunc3 = cInterpFunc; 
    AppendTo[cInterpFuncList, cInterpFunc];

    \[Beta] = \[Beta]middle (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFunc = cInterpFunc4];
    ConstructIndcFunc; 
    cInterpFunc4 = cInterpFunc; 
    AppendTo[cInterpFuncList, cInterpFunc];

    \[Beta] = (\[Beta]middle -  diff) (1-ProbOfDeath);   (* Effective time preference factor *) 
    If[Estimatet>1, cInterpFunc = cInterpFunc5];
    ConstructIndcFunc; 
    cInterpFunc5 = cInterpFunc; 
    AppendTo[cInterpFuncList, cInterpFunc];

    \[Beta] = (\[Beta]middle - 2 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFunc = cInterpFunc6];
    ConstructIndcFunc; 
    cInterpFunc6 = cInterpFunc; 
    AppendTo[cInterpFuncList, cInterpFunc];

    \[Beta] = (\[Beta]middle - 3 diff) (1-ProbOfDeath);   (* Effective time preference factor *)  
    If[Estimatet>1, cInterpFunc = cInterpFunc7];
    ConstructIndcFunc; 
    cInterpFunc7 = cInterpFunc; 
    AppendTo[cInterpFuncList, cInterpFunc];

    EndConstructingFunc   = SessionTime[]; 
    Print[" Time spent to solve consumption function(s) (minutes): ", (EndConstructingFunc - StartConstructingFunc)/60]; 

   (* Run simulation, show results, and estimate agg process *)
   SimulateInd; 
       
   Estimatet++;

   ]; (* End While *)

(* Export data on wealth distribution *)
kLevListDistSevenWithAggPermShock = {100, kLevTop80PercentMean, kLevTop60PercentMean, kLevTop50PercentMean, kLevTop40PercentMean, kLevTop25PercentMean, kLevTop20PercentMean, kLevTop10PercentMean, kLevTop5PercentMean, kLevTop1PercentMean, 0}; 
Export["kLevListDistSevenLiqFinPlsRet.txt", kLevListDistSevenWithAggPermShock, "Table"];
Export[ParentDirectory[] <> "/Results/kLevListDistSevenWithAggPermShockLiqFinPlsRet.txt", kLevListDistSevenWithAggPermShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCDistSevenBottomHalfWithAggPermShockLiqFinPlsRet.tex", Round[100 MeanMPCBottomHalfBykAnnual]/100//N, "Table"];

Export[ParentDirectory[] <> "/Results/AggStatsDistSevenWithAggPermShocksLiqFinPlsRet.txt", AggStatsWithAggShock, "Table"];
Export["MPCsLiqFinPlsRetList.txt", MPCt, "Table"];
Export[ParentDirectory[] <> "/Results/MPCListDistSevenWithAggPermShocksLiqFinPlsRet.txt", MPCListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCDistSevenWithAggPermShocksLiqFinPlsRet.tex", Round[100 MeanMPCAnnual]/100//N, "Table"];

Export[ParentDirectory[] <> "/Results/MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet.txt", Round[10 MeanShareInPctTopOneThirdMPCbykLev]/10//N, "Table"]; 
Export[ParentDirectory[] <> "/Results/MeanMPCTopOneThirdAnnualLiqFinPlsRet.tex", Round[100 MeanMPCTopOneThirdAnnual]/100//N, "Table"]; 

Export[ParentDirectory[] <> "/Results/MPCAltListDistSevenWithAggPermShocksLiqFinPlsRet.txt", MPCAltListWithAggShock, "Table"];
Export[ParentDirectory[] <> "/Results/MPCAltDistSevenWithAggPermShocksLiqFinPlsRet.tex", Round[100 MeanMPCAltAnnual]/100//N, "Table"]; 

Clear[MatchLiqFinPlsRetAssets]; (* Clear MatchLiqFinPlsRetAssets var *)

(* Display time spent *)  
TimeEnd = SessionTime[];  
Print[" Time spent to run \[Beta]-Dist model with time pref factors approximated by seven points (minutes): ",(TimeEnd - TimeStart)/60]; 