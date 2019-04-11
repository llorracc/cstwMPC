SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

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

toplines = " \\begin{center}
\\begin{tabular}{ld{3}d{6}d{6}d{6}d{5}}
\\toprule & \\multicolumn{5}{c}{Micro Income Process} \\\\ \\cline{2-6} 
& \\multicolumn{2}{c}{Friedman/Buffer Stock} & \\multicolumn{2}{c}{KS-JEDC} & \\multicolumn{1}{c}{None}        \\\\ \\cmidrule(r){2-3} \\cmidrule(r){4-5}
& \\multicolumn{1}{c}{\\text{$\\Discount$-Point}}   & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}}           & \\multicolumn{1}{c}{Our Solution} & \\multicolumn{1}{c}{Maliar et al.}  & \\multicolumn{1}{c}{Rep Agent} \\\\
&          &                        &              &  \\multicolumn{1}{c}{(2008)}        & \\multicolumn{1}{c}{Model}
\\\\ \\hline
"; 

bottomlines = "\\end{tabular} \\end{center}";

AggStatsKSShocks = {toplines, 

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\CLev_{t-1})$ &",
AggStatsPointWithAggShock[[1]],  
"&",
AggStatsDistSevenWithAggShock[[1]],
"&",
AggStatsKSWithAggShock[[1]],
"&",
0.28,
"&",
AggStatsRepWithAggShock[[1]],
"\\\\",

" $corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t})$ &",
AggStatsPointWithAggShock[[2]],  
"&",
AggStatsDistSevenWithAggShock[[2]],
"&",
AggStatsKSWithAggShock[[2]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[2]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-1})$ &",
AggStatsPointWithAggShock[[3]],  
"&",
AggStatsDistSevenWithAggShock[[3]],
"&",
AggStatsKSWithAggShock[[3]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[3]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-2})$ &",
AggStatsPointWithAggShock[[4]],  
"&",
AggStatsDistSevenWithAggShock[[4]],
"&",
AggStatsKSWithAggShock[[4]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[4]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\rfree_{t} )$ &",
AggStatsPointWithAggShock[[5]],  
"&",
AggStatsDistSevenWithAggShock[[5]],
"&",
AggStatsKSWithAggShock[[5]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[5]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\rfree_{t-1} )$ &",
AggStatsPointWithAggShock[[6]],  
"&",
AggStatsDistSevenWithAggShock[[6]],
"&",
AggStatsKSWithAggShock[[6]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[6]],
"\\\\",

"$corr(\\Delta_{4} \\log \\CLev_{t},\\Delta_{4} \\log \\YLev_{t})$ &",
AggStatsPointWithAggShock[[7]],  
"&",
AggStatsDistSevenWithAggShock[[7]],
"&",
AggStatsKSWithAggShock[[7]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[7]],
"\\\\",

"$corr(\\Delta_{8} \\log \\CLev_{t},\\Delta_{8} \\log \\YLev_{t})$ &", 
AggStatsPointWithAggShock[[8]],  
"&",
AggStatsDistSevenWithAggShock[[8]],
"&",
AggStatsKSWithAggShock[[8]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[8]],
"\\\\ \\bottomrule",

(*
"$\\KLev_{t}/\\YLev_{t}$  &",
AggStatsPointWithAggShock[[9]],  
"&",
AggStatsDistSevenWithAggShock[[9]],
"&",
AggStatsKSWithAggShock[[9]],
"&",
" ",
"&",
AggStatsRepWithAggShock[[9]],
"\\\\ \\bottomrule",
*)

bottomlines};

SetDirectory[TableDir];
Export["AggStatsKSShocks.tex", AggStatsKSShocks, "text"]; 
