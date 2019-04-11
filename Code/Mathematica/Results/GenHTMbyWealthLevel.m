SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* MPC table directory *)
*)

MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet = Import["MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet.txt","List"]; 
MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet = Round[10 MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet]/10//N;

toplines = "

\\begin{center}

\\begin{tabular}{ld{8}}
  \\toprule
  Wealth level   &  \\multicolumn{1}{c}{Share in HHs }\\\\ 
    &  \\multicolumn{1}{c}{with top 1/3 MPCs}\\\\ \\midrule
"; 

bottomlines = "

  \\bottomrule
\\end{tabular}

\\end{center}							
	";

MPC = {toplines, 

"  Top 1-20 \\% & ",
MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet[[1]],
"\\\\",

"  Top 21-40 \\% & ",
MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet[[2]],
"\\\\",

"  Top 41-60 \\% & ",
MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet[[3]],
"\\\\",

"  Top 61-80 \\% & ",
MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet[[4]],
"\\\\",

"  Top 81-100 \\% & ",
MeanShareInPctTopOneThirdMPCbykLevLiqFinPlsRet[[5]],
"\\\\ \\midrule",

"  Total      & 100.0 \\\\ ",

bottomlines};

SetDirectory[TableDir];
Export["HTMbyWealthLevel.tex", MPC, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["HTMbyWealthLevel.tex", MPC, "text"]; 
*)