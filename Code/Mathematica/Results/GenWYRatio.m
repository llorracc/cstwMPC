SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)


WYRatioDistList = Import["WYRatioDistList.txt","List"];  
WYRatioDistList = Reverse[WYRatioDistList];
WYRatioDistList = Round[10 WYRatioDistList]/10//N;

toplines = " \\begin{center}

\\begin{tabular}{c|d{1}d{1}d{1}d{1}d{1}d{1}}
\\hline
         & \\multicolumn{1}{l}\\text{$\\Discount$-Dist}  & \\multicolumn{1}{l}\\text{SCF1992} & \\multicolumn{1}{l}\\text{SCF1995} & \\multicolumn{1}{l}\\text{SCF1998} & \\multicolumn{1}{l}\\text{SCF2001} & \\multicolumn{1}{l}\\text{SCF2004} \\\\ \\hline
"; 

bottomlines = "\\end{tabular} \\end{center}";

WYRatio = {toplines, 

"Top 10\\% &", 
WYRatioDistList[[5]],  
"& 22.9    & 22.9    & 29.3    & 30.9    & 29.6 \\\\",

"Top 20\\% &", 
WYRatioDistList[[7]],    
"& 14.1    & 14.1    & 17.3    & 18.5    & 18.5 \\\\",

"Top 40\\% &", 
WYRatioDistList[[9]],     
"& 7.0     & 6.8     & 8.0     & 8.7     & 8.8 \\\\",

"Top 60\\% &", 
WYRatioDistList[[11]],     
"& 3.1     & 3.2     & 3.4     & 3.8     & 3.8 \\\\",

"Top 80\\% &", 
WYRatioDistList[[12]],     
"& 0.8     & 0.8     & 0.7     & 0.9     & 0.8 \\\\ \\hline",

bottomlines};

SetDirectory[TableDir];
Export["WYRatio.tex", WYRatio, "text"]; 
