SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
KSTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstKS\Latest\Tables"; (* KS table directory *)
*)

AggStatsPointWithAggShock = Import["AggStatsPointWithAggShock.txt","List"];  
AggStatsPointWithAggShock = Round[100 AggStatsPointWithAggShock]/100//N;
AggStatsPointWithAggShock[[-1]] = Round[10 AggStatsPointWithAggShock[[-1]]]/10//N;

AggStatsDistSevenWithAggShock = Import["AggStatsDistSevenWithAggShock.txt","List"];  
AggStatsDistSevenWithAggShock = Round[100 AggStatsDistSevenWithAggShock]/100//N;
AggStatsDistSevenWithAggShock[[-1]] = Round[10 AggStatsDistSevenWithAggShock[[-1]]]/10//N;

AggStatsKSWithAggShock = Import["AggStatsKSWithAggShock.txt","List"];  
AggStatsKSWithAggShock = Round[100 AggStatsKSWithAggShock]/100//N;
AggStatsKSWithAggShock[[-1]] = Round[10 AggStatsKSWithAggShock[[-1]]]/10//N;

AggStatsRepWithAggShock = Import["AggStatsRepWithAggShock.txt","List"];  
AggStatsRepWithAggShock = Round[100 AggStatsRepWithAggShock]/100//N;
AggStatsRepWithAggShock[[-1]] = Round[10 AggStatsRepWithAggShock[[-1]]]/10//N;

toplines = "  \\begin{center}

\\begin{tabular}{ld{6}d{6}d{8}d{5}}

\\toprule & \\multicolumn{3}{c}{Income Process} & \\\\ \\cline{2-4}

& \\multicolumn{1}{c}{KS Agg Unc}  & \\multicolumn{1}{c}{KS-JEDC} & \\multicolumn{1}{c}{Friedman/Buffer Stock}     &    \\\\  
& \\multicolumn{1}{c}{Only} & \\multicolumn{1}{c}{Our Solution}  & \\multicolumn{1}{c}{KS Agg Unc}   & \\multicolumn{1}{c}{U.S. Data}          \\\\

\\midrule


"; 

bottomlines = "\\end{tabular} \\end{center}";

AggStatscstKS = {toplines, 

"$\corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\CLev_{t-1})$ &",
AggStatsRepWithAggShock[[1]],
"&",
AggStatsKSWithAggShock[[1]],
"&",
AggStatsPointWithAggShock[[1]],
"&",
0.51,
"\\\\",

" $\corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t})$ &",
AggStatsRepWithAggShock[[2]],
"&",
AggStatsKSWithAggShock[[2]],
"&",
AggStatsPointWithAggShock[[2]],
"&",
0.50,
"\\\\",

"$\corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-1})$ &",
AggStatsRepWithAggShock[[3]],
"&",
AggStatsKSWithAggShock[[3]],
"&",
AggStatsPointWithAggShock[[3]],
"&",
0.31,
"\\\\",

"$\corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-2})$ &",
AggStatsRepWithAggShock[[4]],
"&",
AggStatsKSWithAggShock[[4]],
"&",
AggStatsPointWithAggShock[[4]],
"&",
0.17,
"\\\\",

"$\corr(\\Delta \\log \\CLev_{t},\\rfree_{t} )$ &",
AggStatsRepWithAggShock[[5]],
"&",
AggStatsKSWithAggShock[[5]],
"&",
AggStatsPointWithAggShock[[5]],
"&",
0.27,
"\\\\",


"$\corr(\\Delta \\log \\CLev_{t},\\rfree_{t-1} )$ &",
AggStatsRepWithAggShock[[6]],
"&",
AggStatsKSWithAggShock[[6]],
"&",
AggStatsPointWithAggShock[[6]],
"&",
0.20,
"\\\\",


"$\corr(\\Delta_{4} \\log \\CLev_{t},\\Delta_{4} \\log \\YLev_{t})$ &",
AggStatsRepWithAggShock[[7]],
"&",
AggStatsKSWithAggShock[[7]],
"&",
AggStatsPointWithAggShock[[7]],
"&",
0.76,
"\\\\",


"$\corr(\\Delta_{8} \\log \\CLev_{t},\\Delta_{8} \\log \\YLev_{t})$ &", 
AggStatsRepWithAggShock[[8]],
"&",
AggStatsKSWithAggShock[[8]],
"&",
AggStatsPointWithAggShock[[8]],
"&",
0.87,
"\\\\ \\bottomrule",



bottomlines};

SetDirectory[TableDir];
Export["AggStatscstKS.tex", AggStatscstKS, "text"]; 

(*
SetDirectory[KSTableDir];
Export["AggStatscstKS.tex", AggStatscstKS, "text"]; 
*)
