SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
KSTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstKS\Latest\Tables"; (* KS table directory *)
*)
(* no need to do this under cstwMPC folder. commented this out 2016/10/15 *)


EstimatesOfMGProcess = Import["EstimatesOfMGProcess.txt","List"];  


toplines = "  \\begin{center}

\\begin{tabular}{ld{4}d{3}d{3}d{3}}

\\toprule

&

\\multicolumn{1}{c}{\\text{$\\sigma _{\\pshk }^{2}$}} &

\\multicolumn{1}{c}{\\text{$\\sigma _{v}^{2}$}} &

\\multicolumn{1}{c}{\\text{$a_{1}$}} &

\\multicolumn{1}{c}{\\text{$m_{1}$}} \\\\ \\hline
"; 

bottomlines = "\\end{tabular} \\end{center}";

MGComparison = {toplines, 


"Our estimates &",
EstimatesOfMGProcess[[1]],
"&",
EstimatesOfMGProcess[[2]],
"&",
EstimatesOfMGProcess[[3]],
"&",
EstimatesOfMGProcess[[4]],
"\\\\",
"\\text{\\citet{mgCovariance}} & 0.00159 & 0.169 & 0.622 & -0.344 \\\\ \\bottomrule",

bottomlines};


SetDirectory[TableDir];
Export["MGComparison.tex", MGComparison, "text"]; 

(*
SetDirectory[KSTableDir];
Export["MGComparison.tex", MGComparison, "text"]; 
*)
(* no need to do this under cstwMPC folder. commented this out 2016/10/15 *)
