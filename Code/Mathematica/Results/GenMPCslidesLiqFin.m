SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
KSTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstKS\Latest\Tables"; (* KS table directory *)

MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* KS table directory *)
*)


MPCListDistSevenWithAggShockLiqFin = Import["MPCListDistSevenWithAggShockLiqFin.txt","List"]; 
MPCListDistSevenWithAggShockLiqFin = Round[100 MPCListDistSevenWithAggShockLiqFin]/100//N;

MPCListDistSevenWithAggShock = Import["MPCListDistSevenWithAggShock.txt","List"]; 
MPCListDistSevenWithAggShock = Round[100 MPCListDistSevenWithAggShock]/100//N;


toplines = "
\\begin{center}
\\begin{tabular}{ccc}
\\toprule
& \\multicolumn{2}{c}{\\text{$\\Discount$-Dist}}  \\\\ \\cline{2-3}

  &  \\multicolumn{1}{c}{\\text{Net Worth}}  & \\multicolumn{1}{c}{\\text{Liq Fin Assets}} \\\\ \\midrule
"; 

bottomlines = "\\end{tabular} \\end{center}";

MPCslides = {toplines, 

"\\multicolumn{1}{l}{Overall average} &",   
MPCListDistSevenWithAggShock[[1]],
"&", 
MPCListDistSevenWithAggShockLiqFin[[1]],
"\\\\ \\hline",


"\\multicolumn{1}{l}{By wealth/permanent income ratio} & &  ",
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &",   
MPCListDistSevenWithAggShock[[2]],
"&", 
MPCListDistSevenWithAggShockLiqFin[[2]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &",   
MPCListDistSevenWithAggShock[[4]],
"&", 
MPCListDistSevenWithAggShockLiqFin[[4]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &",   
MPCListDistSevenWithAggShock[[5]],
"&", 
MPCListDistSevenWithAggShockLiqFin[[5]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &",   
MPCListDistSevenWithAggShock[[6]],
"&", 
MPCListDistSevenWithAggShockLiqFin[[6]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 1/2} &",  
MPCListDistSevenWithAggShock[[7]],
"&", 
MPCListDistSevenWithAggShockLiqFin[[7]],
"\\\\ \\bottomrule",


bottomlines};

SetDirectory[TableDir];
Export["MPCslidesLiqFin.tex", MPCslides, "text"]; 

(*
SetDirectory[KSTableDir];
Export["MPCslidesLiqFin.tex", MPCslides, "text"]; 
SetDirectory[MPCTableDir];
Export["MPCslidesLiqFin.tex", MPCslides, "text"]; 
*)

