SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

kLevListKSNoAggShock = Import["kLevListKSNoAggShock.txt","List"]; (* Raw time preference factor *) 
kLevListKSNoAggShock = Reverse[kLevListKSNoAggShock];
kLevListKSNoAggShock = Round[10 kLevListKSNoAggShock]/10;

kLevListPointNoAggShock = Import["kLevListPointNoAggShock.txt","List"]; (* Raw time preference factor *) 
kLevListPointNoAggShock = Reverse[kLevListPointNoAggShock];
kLevListPointNoAggShock = Round[10 kLevListPointNoAggShock]/10;

kLevListDistSevenNoAggShock = Import["kLevListDistSevenNoAggShock.txt","List"]; (* Raw time preference factor *) 
kLevListDistSevenNoAggShock = Reverse[kLevListDistSevenNoAggShock];
kLevListDistSevenNoAggShock = Round[10 kLevListDistSevenNoAggShock]/10;

MPCPointNoAggShock     = Import["MPCPointNoAggShock.txt","List"];
MPCPointNoAggShock     = Round[100 MPCPointNoAggShock[[1]]]/100//N;

MPCDistSevenNoAggShock = Import["MPCDistSevenNoAggShock.txt","List"];
MPCDistSevenNoAggShock = Round[100 MPCDistSevenNoAggShock[[1]]]/100//N;

MPCKSNoAggShock        = Import["MPCKSNoAggShock.txt","List"];
MPCKSNoAggShock        = Round[100 MPCKSNoAggShock[[1]]]/100//N;

KYPointNoAggShock     = Import["KYPointNoAggShock.txt","List"];
KYPointNoAggShock     = Round[10 KYPointNoAggShock[[1]]]/10//N;

KYDistSevenNoAggShock = Import["KYDistSevenNoAggShock.txt","List"];
KYDistSevenNoAggShock = Round[10 KYDistSevenNoAggShock[[1]]]/10//N;

KYKSNoAggShock        = Import["KYKSNoAggShock.txt","List"];
KYKSNoAggShock        = Round[10 KYKSNoAggShock[[1]]]/10//N;

toplines = "\\begin{center}

\\scalebox{0.9}[0.9]

\\begin{tabular}{lcccccc}

\\toprule

 & \\multicolumn{1}{c}{U.S.} &\\multicolumn{2}{c}{Impatience}  \\\\ \\cline{3-4} 

& \\multicolumn{1}{c}{Data} & Identical         & Heterogeneous  \\\\ \\midrule

"; 

bottomlines = "\\end{tabular} \\end{center}";

WDistFed = {toplines, 

"Top 1\\%  &",
"29.6",
"&",
kLevListPointNoAggShock[[2]]//N,
"&",
kLevListDistSevenNoAggShock[[2]]//N,
"\\\\",


"\\textbf{Top 20\\%}  &",
"79.5",
"&",
kLevListPointNoAggShock[[5]]//N,
"&",
kLevListDistSevenNoAggShock[[5]]//N,

"\\\\ ",

"\\textbf{Top 40\\%}  &",
"92.9",
"&",
kLevListPointNoAggShock[[7]]//N,
"&",
kLevListDistSevenNoAggShock[[7]]//N,
"\\\\",

"\\textbf{Top 60\\%}  &",
"98.7",
"&",
kLevListPointNoAggShock[[9]]//N,
"&",
kLevListDistSevenNoAggShock[[9]]//N,
"\\\\",

"\\textbf{Top 80\\%}  &",
"100.4",
"&",
kLevListPointNoAggShock[[10]]//N,
"&",
kLevListDistSevenNoAggShock[[10]]//N,
"\\\\ \\bottomrule",




bottomlines};

SetDirectory[TableDir];
Export["WDistFed.tex", WDistFed, "text"]; 
