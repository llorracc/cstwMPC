SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]];


TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
KSTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstKS\Latest\Tables"; (* KS table directory *)

MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* MPC table directory *)

*)

MPCListPointWithAggShock = Import["MPCListPointWithAggShock.txt","List"]; 
MPCListPointWithAggShock = Round[100 MPCListPointWithAggShock]/100//N;

MPCListDistSevenWithAggShock = Import["MPCListDistSevenWithAggShock.txt","List"]; 
MPCListDistSevenWithAggShock = Round[100 MPCListDistSevenWithAggShock]/100//N;

MPCListDistSevenAltParamsWithAggShock = Import["MPCListDistSevenAltParamsWithAggShock.txt","List"]; 
MPCListDistSevenAltParamsWithAggShock = Round[100 MPCListDistSevenAltParamsWithAggShock]/100//N;

MPCListKSWithAggShock = Import["MPCListKSWithAggShock.txt","List"]; 
MPCListKSWithAggShock = Round[100 MPCListKSWithAggShock]/100//N;

toplines = "
\\begin{center}

\\begin{tabular}{cccc}

\\toprule & \\multicolumn{3}{c}{\\text{Micro Income Process}} \\\\ \\cmidrule(r){2-4}

& \\multicolumn{2}{c}{\\text{Friedman/Buffer Stock}} & \\multicolumn{1}{c}{\\text{KS-JEDC}} \\\\ \\cmidrule(r){2-3} \\cmidrule(l){4-4}


 & \\multicolumn{1}{c}{\\text{$\\Discount$-Point}} &  \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{Our solution}}  \\\\ \\midrule
"; 

bottomlines = "\\end{tabular} \\end{center}";

MPCslides = {toplines, 

"\\multicolumn{1}{l}{Overall average} &",   
MPCListPointWithAggShock[[1]],
"&", 
MPCListDistSevenWithAggShock[[1]],
"&", 
MPCListKSWithAggShock[[1]],
"\\\\ \\hline",


"\\multicolumn{1}{l}{By wealth/permanent income ratio} & & & ",
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &",   
MPCListPointWithAggShock[[2]],
"&", 
MPCListDistSevenWithAggShock[[2]],
"&", 
MPCListKSWithAggShock[[2]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &",   
MPCListPointWithAggShock[[4]],
"&", 
MPCListDistSevenWithAggShock[[4]],
"&", 
MPCListKSWithAggShock[[4]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &",   
MPCListPointWithAggShock[[5]],
"&", 
MPCListDistSevenWithAggShock[[5]],
"&", 
MPCListKSWithAggShock[[5]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &",   
MPCListPointWithAggShock[[6]],
"&", 
MPCListDistSevenWithAggShock[[6]],
"&", 
MPCListKSWithAggShock[[6]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 1/2} &",  
MPCListPointWithAggShock[[7]],
"&", 
MPCListDistSevenWithAggShock[[7]],
"&", 
MPCListKSWithAggShock[[7]],
"\\\\ ",

"\\multicolumn{1}{l}{By employment status} & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Employed} &", 
MPCListPointWithAggShock[[14]],
"&", 
MPCListDistSevenWithAggShock[[14]],
"&", 
MPCListKSWithAggShock[[14]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Unemployed}  &", 
MPCListPointWithAggShock[[15]],
"&", 
MPCListDistSevenWithAggShock[[15]],
"&", 
MPCListKSWithAggShock[[15]],
"\\\\ \\bottomrule",

bottomlines};

SetDirectory[TableDir];
Export["MPCslides.tex", MPCslides, "text"]; 

(*
SetDirectory[KSTableDir];
Export["MPCslides.tex", MPCslides, "text"]; 

SetDirectory[MPCTableDir];
Export["MPCslides.tex", MPCslides, "text"]; 
*)

