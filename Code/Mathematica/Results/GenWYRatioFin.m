SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)


WYRatioDistListFin = Import["WYRatioDistListFin.txt","List"];  
WYRatioDistListFin = Reverse[WYRatioDistListFin];
WYRatioDistListFin = Round[10 WYRatioDistListFin]/10//N;

toplines = " \\begin{center}

\\begin{tabular}{c|d{1}d{1}d{1}d{1}d{1}d{1}}
\\hline
         & \\multicolumn{1}{l}\\text{$\\Discount$-Dist}  & \\multicolumn{1}{l}\\text{SCF1992} & \\multicolumn{1}{l}\\text{SCF1995} & \\multicolumn{1}{l}\\text{SCF1998} & \\multicolumn{1}{l}\\text{SCF2001} & \\multicolumn{1}{l}\\text{SCF2004} \\\\ \\hline
"; 

bottomlines = "\\end{tabular} \\end{center}";

WYRatioFin = {toplines, 

"Top 10\\% &", 
WYRatioDistListFin[[5]],  
"& 8.2    & 9.3    & 13.0    & 13.8    & 11.5 \\\\",

"Top 20\\% &", 
WYRatioDistListFin[[7]],    
"& 4.6    & 4.9    & 6.9    & 7.5    & 6.0 \\\\",

"Top 40\\% &", 
WYRatioDistListFin[[9]],     
"& 1.7     & 1.7     & 2.7     & 2.9     & 2.2 \\\\",

"Top 60\\% &", 
WYRatioDistListFin[[11]],     
"& 0.6     & 0.6     & 0.8     & 0.9     & 0.6 \\\\",

"Top 80\\% &", 
WYRatioDistListFin[[12]],     
"& 0.1     & 0.1     & 0.1     & 0.2     & 0.1 \\\\ \\hline",

bottomlines};

SetDirectory[TableDir];
Export["WYRatioFin.tex", WYRatioFin, "text"]; 
