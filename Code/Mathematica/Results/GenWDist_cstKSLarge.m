SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir   = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
KSTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstKS\Latest\Tables"; (* KS table directory *)
*)

kLevListKSNoAggShock = Import["kLevListKSNoAggShock.txt","List"]; (* Raw time preference factor *) 
kLevListKSNoAggShock = Reverse[kLevListKSNoAggShock];
kLevListKSNoAggShock = Round[10 kLevListKSNoAggShock]/10;

kLevListPointNoAggShock = Import["kLevListPointNoAggShock.txt","List"]; (* Raw time preference factor *) 
kLevListPointNoAggShock = Reverse[kLevListPointNoAggShock];
kLevListPointNoAggShock = Round[10 kLevListPointNoAggShock]/10;



kLevListPointWithAggShock = Import["kLevListPointWithAggShock.txt","List"]; 
kLevListPointWithAggShock = Reverse[kLevListPointWithAggShock];
kLevListPointWithAggShock = Round[10 kLevListPointWithAggShock]/10;

kLevListDistSevenNoAggShock = Import["kLevListDistSevenNoAggShock.txt","List"]; 
kLevListDistSevenNoAggShock = Reverse[kLevListDistSevenNoAggShock];
kLevListDistSevenNoAggShock = Round[10 kLevListDistSevenNoAggShock]/10;

kLevListPointWithAggShock = Import["kLevListPointWithAggShock.txt","List"];
kLevListPointWithAggShock = Reverse[kLevListPointWithAggShock];
kLevListPointWithAggShock = Round[10 kLevListPointWithAggShock]/10;

kLevListPointWithAggShockHighTran = Import["kLevListPointWithAggShockHighTran.txt","List"];  
kLevListPointWithAggShockHighTran = Reverse[kLevListPointWithAggShockHighTran];
kLevListPointWithAggShockHighTran = Round[10 kLevListPointWithAggShockHighTran]/10;

kLevListPointWithAggShockHighPerm = Import["kLevListPointWithAggShockHighPerm.txt","List"];  
kLevListPointWithAggShockHighPerm = Reverse[kLevListPointWithAggShockHighPerm];
kLevListPointWithAggShockHighPerm = Round[10 kLevListPointWithAggShockHighPerm]/10;


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


toplines="\\begin{center}

\\scalebox{0.9}[0.9]

\\begin{tabular}{ld{4}d{4}d{4}d{4}d{4}d{3}}
\\toprule
 &  \\multicolumn{5}{c}{Income Process} &  \\\\ \\cmidrule(r){2-6}
&  \\multicolumn{1}{c}{KS-JEDC} &  \\multicolumn{4}{c}{Friedman/ Buffer Stock$^{\\ddagger}$}   & \\\\
  \\cmidrule(r){2-2} \\cmidrule(l){3-6}
&   \\multicolumn{1}{c}{Our Solution} & \\multicolumn{1}{c}{No Aggr Unc}  & \\multicolumn{3}{c}{KS Aggr Unc}    & \\\\
\\cmidrule(r){3-3} \\cmidrule(l){4-6}
Percentile of &  & \\multicolumn{1}{c}{$\\sigma^2_\\psi=0.01$} & \\multicolumn{1}{c}{$\\sigma^2_\\psi=0.01$}  & \\multicolumn{1}{c}{$\\sigma^2_\\psi=0.01$} & \\multicolumn{1}{c}{$\\sigma^2_\\psi=0.03$} &
\\\\
Net Worth &  & \\multicolumn{1}{c}{$\\sigma^2_\\theta=0.01$} & \\multicolumn{1}{c}{$\\sigma^2_\\theta=0.01$} & \\multicolumn{1}{c}{$\\sigma^2_\\theta=0.15$} & \\multicolumn{1}{c}{$\\sigma^2_\\theta=0.01$} & \\multicolumn{1}{c}{Data$^{*}$}
\\\\

\\midrule"; 


bottomlines = "\\end{tabular} \\end{center} ";

WDistcstKSLarge = {toplines, 

"Top 1\\%   ",  "&", 
kLevListKSNoAggShock[[2]]//N,
 "&", 
kLevListPointNoAggShock[[2]]//N, 
"&", 
kLevListPointWithAggShock[[2]]//N, 
"&", 
kLevListPointWithAggShockHighTran[[2]]//N, 
"&", 
kLevListPointWithAggShockHighPerm[[2]]//N, 
"&", 
"33.9",  "\\\\",

"Top 10\\%  ",  "&", 
kLevListKSNoAggShock[[4]]//N, 
"&", 
kLevListPointNoAggShock[[4]]//N, 
"&", 
kLevListPointWithAggShock[[4]]//N, 
"&", 
kLevListPointWithAggShockHighTran[[4]]//N, 
"&", 
kLevListPointWithAggShockHighPerm[[4]]//N, 
"&", 
"69.7",  "\\\\",

"{Top 20\\%}",  "&", 
kLevListKSNoAggShock[[5]]//N,
 "&", 
kLevListPointNoAggShock[[5]]//N,
"&", 
kLevListPointWithAggShock[[5]]//N, 
"&", 
kLevListPointWithAggShockHighTran[[5]]//N, 
"&", 
kLevListPointWithAggShockHighPerm[[5]]//N, 
"&", 
"82.9",  "\\\\",

"{Top 40\\%}",  "&", 
kLevListKSNoAggShock[[7]]//N,
 "&", 
kLevListPointNoAggShock[[7]]//N,
"&", 
kLevListPointWithAggShock[[7]]//N, 
"&", 
kLevListPointWithAggShockHighTran[[7]]//N, 
"&", 
kLevListPointWithAggShockHighPerm[[7]]//N, 
"&", 
"94.7",  "\\\\",

"{Top 60\\%}",  "&", 
kLevListKSNoAggShock[[9]]//N,
 "&", 
kLevListPointNoAggShock[[9]]//N,
"&", 
kLevListPointWithAggShock[[9]]//N, 
"&", 
kLevListPointWithAggShockHighTran[[9]]//N, 
"&",
kLevListPointWithAggShockHighPerm[[9]]//N, 
"&",
"99.0",  "\\\\",

"{Top 80\\%}",  "&", 
kLevListKSNoAggShock[[10]]//N,
 "&", 
kLevListPointNoAggShock[[10]]//N,
"&", 
kLevListPointWithAggShock[[10]]//N, 
"&", 
kLevListPointWithAggShockHighTran[[10]]//N, 
"&", 
kLevListPointWithAggShockHighPerm[[10]]//N, 
"&", 
"100.2", "\\\\ \\bottomrule",

bottomlines};

SetDirectory[TableDir];
Export["WDist_cstKSLarge.tex", WDistcstKSLarge , "text"]; 

(*
SetDirectory[KSTableDir];
Export["WDist_cstKSLarge.tex", WDistcstKSLarge , "text"]; 
*)


