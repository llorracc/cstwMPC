SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* MPC table directory *)
*)

AggStatsDistSevenWithAggPermShocks = Import["AggStatsDistSevenWithAggPermShocks.txt","List"]; 
AggStatsDistSevenWithAggPermShocks = Round[100 AggStatsDistSevenWithAggPermShocks]/100//N;

AggStatsDistSevenWithAggPermShocksLiqFinPlsRet = Import["AggStatsDistSevenWithAggPermShocksLiqFinPlsRet.txt","List"]; 
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet = Round[100 AggStatsDistSevenWithAggPermShocksLiqFinPlsRet]/100//N;

AggStatsDistSevenWithAggShock = Import["AggStatsDistSevenWithAggShock.txt","List"]; 
AggStatsDistSevenWithAggShock = Round[100 AggStatsDistSevenWithAggShock]/100//N;

toplines = "
\\begin{center}
\\begin{tabular}{ld{2}d{4}d{4}}
\\toprule
& \\multicolumn{2}{c}{\\text{FBS}}
& \\multicolumn{1}{c}{\\text{KS}}        \\\\
& \\multicolumn{2}{c}{\\text{Aggregate}}
& \\multicolumn{1}{c}{\\text{Aggregate}} \\\\
& \\multicolumn{2}{c}{\\text{Process}}
& \\multicolumn{1}{c}{\\text{Process}}   \\\\ \\cline{2-3}
& \\multicolumn{1}{c}{\\text{Net}}& \\multicolumn{1}{c}{\\text{Liquid}} & \\multicolumn{1}{c}{\\text{Net}}\\\\
& \\multicolumn{1}{c}{\\text{Worth}} & \\multicolumn{1}{c}{\\text{Assets}} & \\multicolumn{1}{c}{\\text{Worth}} \\\\ \\hline
"; 

bottomlines = "\\end{tabular} \\end{center}";

AggStatsPlausibleAggShocks = {toplines, 

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\CLev_{t-1})$ &",
AggStatsDistSevenWithAggPermShocks[[1]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[1]],  
"&",
AggStatsDistSevenWithAggShock[[1]],
"\\\\",

" $corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t})$ &",
AggStatsDistSevenWithAggPermShocks[[2]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[2]],  
"&",
AggStatsDistSevenWithAggShock[[2]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-1})$ &",
AggStatsDistSevenWithAggPermShocks[[3]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[3]],  
"&",
AggStatsDistSevenWithAggShock[[3]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\Delta \\log \\YLev_{t-2})$ &",
AggStatsDistSevenWithAggPermShocks[[4]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[4]],  
"&",
AggStatsDistSevenWithAggShock[[4]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\rfree_{t} )$ &",
AggStatsDistSevenWithAggPermShocks[[5]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[5]],  
"&",
AggStatsDistSevenWithAggShock[[5]],
"\\\\",

"$corr(\\Delta \\log \\CLev_{t},\\rfree_{t-1} )$ &",
AggStatsDistSevenWithAggPermShocks[[6]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[6]],  
"&",
AggStatsDistSevenWithAggShock[[6]],
"\\\\",

"$corr(\\Delta_{4} \\log \\CLev_{t},\\Delta_{4} \\log \\YLev_{t})$ &",
AggStatsDistSevenWithAggPermShocks[[7]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[7]],  
"&",
AggStatsDistSevenWithAggShock[[7]],
"\\\\",

"$corr(\\Delta_{8} \\log \\CLev_{t},\\Delta_{8} \\log \\YLev_{t})$ &", 
AggStatsDistSevenWithAggPermShocks[[8]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[8]],  
"&",
AggStatsDistSevenWithAggShock[[8]],
"\\\\",

"$corr(\\Delta \\log \\YLev_{t},\\Delta \\log \\YLev_{t-1})$ &",
AggStatsDistSevenWithAggPermShocks[[-1]],  
"&",
AggStatsDistSevenWithAggPermShocksLiqFinPlsRet[[-1]],  
"&",
AggStatsDistSevenWithAggShock[[-1]],
"\\\\ \\bottomrule",



bottomlines};


SetDirectory[TableDir];
Export["AggStatsPlausibleAggShocksRev.tex", AggStatsPlausibleAggShocks, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["AggStatsPlausibleAggShocksRev.tex", AggStatsPlausibleAggShocks, "text"]; 
*)
