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

\\begin{tabular}{ld{3}d{4}d{4}d{2}d{2}d{2}}
\\toprule
&  \\multicolumn{5}{c}{Micro Income Process} &  \\\\ \\cmidrule(r){2-6}
&  \\multicolumn{2}{c}{Friedman/Buffer Stock} & \\multicolumn{1}{c}{KS-JEDC} & \\multicolumn{2}{c}{KS-Orig$^{\\diamond}$} & \\\\ 
\\cmidrule(l){2-3} \\cmidrule(l){4-4} \\cmidrule(l){5-6}
&  \\multicolumn{1}{c}{Point} & \\multicolumn{1}{c}{Uniformly} & \\multicolumn{1}{c}{Our Solution} & & \\multicolumn{1}{c}{Hetero} & \\\\
&  \\multicolumn{1}{c}{Discount}                                & \\multicolumn{1}{c}{Distributed}  & &        & & \\\\
&  \\multicolumn{1}{c}{Factor$^{\\ddagger}$}                    & \\multicolumn{1}{c}{Discount}     & &        & & \\\\&                                                               & \\multicolumn{1}{c}{Factors$^{\\star}$} & &  & & \\multicolumn{1}{c}{U.S.} \\\\
&  \\multicolumn{1}{c}{\\text{($\\Discount$-Point)}}         & \\multicolumn{1}{c}{\\text{($\\Discount$-Dist)}}& & & & \\multicolumn{1}{c}{Data$^{*}$} \\\\ \\midrule

"; 

bottomlines = "\\end{tabular} \\end{center}";

WDist = {toplines, 

"Top 1\\%  &",
kLevListPointNoAggShock[[2]]//N,
"&",
kLevListDistSevenNoAggShock[[2]]//N,
"&",
kLevListKSNoAggShock[[2]]//N,
"&",
"3.0",
"&",
"24.0",
"&",
"29.6",
"\\\\",

"Top 10\\%  &",
kLevListPointNoAggShock[[4]]//N,
"&",
kLevListDistSevenNoAggShock[[4]]//N,
"&",
kLevListKSNoAggShock[[4]]//N,
"&",
"19.0",
"&",
"73.0",
"&",
"66.1",
"\\\\",

"\\textbf{Top 20\\%}  &",
kLevListPointNoAggShock[[5]]//N,
"&",
kLevListDistSevenNoAggShock[[5]]//N,
"&",
kLevListKSNoAggShock[[5]]//N,
"&",
"35.0",
"&",
"88.0",
"&",
"79.5",
"\\\\ ",

"\\textbf{Top 40\\%}  &",
kLevListPointNoAggShock[[7]]//N,
"&",
kLevListDistSevenNoAggShock[[7]]//N,
"&",
kLevListKSNoAggShock[[7]]//N,
"&",
" ",
"&",
" ",
"&",
"92.9",
"\\\\",

"\\textbf{Top 60\\%}  &",
kLevListPointNoAggShock[[9]]//N,
"&",
kLevListDistSevenNoAggShock[[9]]//N,
"&",
kLevListKSNoAggShock[[9]]//N,
"&",
" ",
"&",
" ",
"&",
"98.7",
"\\\\",

"\\textbf{Top 80\\%}  &",
kLevListPointNoAggShock[[10]]//N,
"&",
kLevListDistSevenNoAggShock[[10]]//N,
"&",
kLevListKSNoAggShock[[10]]//N,
"&",
" ",
"&",
" ",
"&",
"100.4",
"\\\\ \\toprule",

bottomlines};

SetDirectory[TableDir];
Export["WDist.tex", WDist, "text"]; 
