SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* MPC table directory *)
*)
(* no need to do this under cstwMPC folder. commented this out 2016/10/15 *)

AggStatsDistSevenWithAggPermShocks = Import["AggStatsDistSevenWithAggPermShocks.txt","List"]; 
AggStatsDistSevenWithAggPermShocks = Round[100 AggStatsDistSevenWithAggPermShocks]/100//N;

AggStatsDistSevenWithAggPermShocksLiqFin = Import["AggStatsDistSevenWithAggPermShocksLiqFin.txt","List"]; 
AggStatsDistSevenWithAggPermShocksLiqFin = Round[100 AggStatsDistSevenWithAggPermShocksLiqFin]/100//N;

AggStatsDistSevenWithAggShock = Import["AggStatsDistSevenWithAggShock.txt","List"]; 
AggStatsDistSevenWithAggShock = Round[100 AggStatsDistSevenWithAggShock]/100//N;

toplines = "
\\begin{center}
\\begin{tabular}{ld{2}d{7}d{4}}
\\toprule
& \\multicolumn{2}{c}{\\text{Friedman/Buffer Stock}}
& \\multicolumn{1}{c}{\\text{KS}}        \\\\
& \\multicolumn{2}{c}{\\text{Aggregate}}
& \\multicolumn{1}{c}{\\text{Aggregate}} \\\\
& \\multicolumn{2}{c}{\\text{Process}}
& \\multicolumn{1}{c}{\\text{Process}}   \\\\ \\cline{2-3}
& \\multicolumn{1}{c}{\\text{Net}}& \\multicolumn{1}{c}{\\text{Liquid Financial}} & \\multicolumn{1}{c}{\\text{Net}}\\\\
& \\multicolumn{1}{c}{\\text{Worth}} & \\multicolumn{1}{c}{\\text{Assets}} & \\multicolumn{1}{c}{\\text{Worth}} \\\\ \\hline
"; 

bottomlines = "\\end{tabular} \\end{center}";

AggStatsPlausibleAggShocks = {toplines, 

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\CLev_{t-1})$ &",
AggStatsDistSevenWithAggPermShocks[[1]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[1]],  
"&",
AggStatsDistSevenWithAggShock[[1]],
"\\\\",

" $corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t})$ &",
AggStatsDistSevenWithAggPermShocks[[2]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[2]],  
"&",
AggStatsDistSevenWithAggShock[[2]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-1})$ &",
AggStatsDistSevenWithAggPermShocks[[3]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[3]],  
"&",
AggStatsDistSevenWithAggShock[[3]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-2})$ &",
AggStatsDistSevenWithAggPermShocks[[4]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[4]],  
"&",
AggStatsDistSevenWithAggShock[[4]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\rfree_{t} )$ &",
AggStatsDistSevenWithAggPermShocks[[5]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[5]],  
"&",
AggStatsDistSevenWithAggShock[[5]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\rfree_{t-1} )$ &",
AggStatsDistSevenWithAggPermShocks[[6]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[6]],  
"&",
AggStatsDistSevenWithAggShock[[6]],
"\\\\",

"$corr(\\Delta_{4} \\log \\CLev_{t},\\Delta_{4} \\log \\YLev_{t})$ &",
AggStatsDistSevenWithAggPermShocks[[7]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[7]],  
"&",
AggStatsDistSevenWithAggShock[[7]],
"\\\\",

"$corr(\\Delta_{8} \\log \\CLev_{t},\\Delta_{8} \\log \\YLev_{t})$ &", 
AggStatsDistSevenWithAggPermShocks[[8]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFin[[8]],  
"&",
AggStatsDistSevenWithAggShock[[8]],
"\\\\ \\bottomrule",


bottomlines};


SetDirectory[TableDir];
Export["AggStatsPlausibleAggShocks.tex", AggStatsPlausibleAggShocks, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["AggStatsPlausibleAggShocks.tex", AggStatsPlausibleAggShocks, "text"]; 
*)
(* no need to do this under cstwMPC folder. commented this out 2016/10/15 *)
