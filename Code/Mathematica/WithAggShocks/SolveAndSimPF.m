(* do_PF.m *)
(* This file solves PF representative agent and PF partial eq models *)

SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)
(*
ClearAll["Global`*"];
*)

Print["============================================================="];
Print["Run PF representative agent and PF partial eq models"];

TimeStart = SessionTime[]; 

Rep  = True;

(* Backwardshoot and construct representative agent PF consumption function *)
<<PrepareEverything.m;       (* Setup everything (routines etc.) *)
Backwardshoot;
Print[" PF Rep Agent KYRatio: ", kSS^(1 - \[Alpha])];

(* Partial equiriburm PF model *)
PEPFMPCQuarterly = 1 - (\[Beta] (RSS-\[Delta]))^(1/\[Rho])  (RSS-\[Delta])^(-1);
PEPFMPCAnnual    = 1 - (1 - PEPFMPCQuarterly)^4;
Print[" MPC of PF Partial Equilibrium: ", PEPFMPCAnnual]; 

Export[ParentDirectory[] <> "/Results/SteadyStateKYrat.tex",N[Round[10 kSS^(1 - \[Alpha])]/10] , "Table"];
Export["mRat.txt",N[Round[10 mSS/wSS]/10] , "Table"];
Export[ParentDirectory[] <> "/WithAggPermShocks/mRat.txt",N[Round[10 mSS/wSS]/10] , "Table"];



(* Display time spent *)  
TimeEnd = SessionTime[];  
(* 
Print[" Time spent (seconds) = "] 
Print[TimeEnd - TimeStart]
*)