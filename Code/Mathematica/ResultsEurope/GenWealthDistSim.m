SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsEuropeDir, SetDirectory[ResultsEuropeDir]];
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)
MPCxcTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPCxc\Latest\Tables"; (* MPC Europe directory directory *)

(* Import data *)
kLevListDistSevenNoAggShockAllBaseline = Import["kLevListDistSevenNoAggShockAllBaseline.txt","List"];
kLevListDistSevenNoAggShockAllBaseline = Round[10 kLevListDistSevenNoAggShockAllBaseline]/10//N;

kLevListDistSevenNoAggShockAT = Import["kLevListDistSevenNoAggShockAT.txt","List"];
kLevListDistSevenNoAggShockAT = Round[10 kLevListDistSevenNoAggShockAT]/10//N;

kLevListDistSevenNoAggShockBE = Import["kLevListDistSevenNoAggShockBE.txt","List"];
kLevListDistSevenNoAggShockBE = Round[10 kLevListDistSevenNoAggShockBE]/10//N;

kLevListDistSevenNoAggShockCY = Import["kLevListDistSevenNoAggShockCY.txt","List"];
kLevListDistSevenNoAggShockCY = Round[10 kLevListDistSevenNoAggShockCY]/10//N;

kLevListDistSevenNoAggShockDE = Import["kLevListDistSevenNoAggShockDE.txt","List"];
kLevListDistSevenNoAggShockDE = Round[10 kLevListDistSevenNoAggShockDE]/10//N;

kLevListDistSevenNoAggShockES = Import["kLevListDistSevenNoAggShockES.txt","List"];
kLevListDistSevenNoAggShockES = Round[10 kLevListDistSevenNoAggShockES]/10//N;

kLevListDistSevenNoAggShockFI = Import["kLevListDistSevenNoAggShockFI.txt","List"];
kLevListDistSevenNoAggShockFI = Round[10 kLevListDistSevenNoAggShockFI]/10//N;

kLevListDistSevenNoAggShockFR = Import["kLevListDistSevenNoAggShockFR.txt","List"];
kLevListDistSevenNoAggShockFR = Round[10 kLevListDistSevenNoAggShockFR]/10//N;

kLevListDistSevenNoAggShockGR = Import["kLevListDistSevenNoAggShockGR.txt","List"];
kLevListDistSevenNoAggShockGR = Round[10 kLevListDistSevenNoAggShockGR]/10//N;

kLevListDistSevenNoAggShockIT = Import["kLevListDistSevenNoAggShockIT.txt","List"];
kLevListDistSevenNoAggShockIT = Round[10 kLevListDistSevenNoAggShockIT]/10//N;

kLevListDistSevenNoAggShockLU = Import["kLevListDistSevenNoAggShockLU.txt","List"];
kLevListDistSevenNoAggShockLU = Round[10 kLevListDistSevenNoAggShockLU]/10//N;

kLevListDistSevenNoAggShockMT = Import["kLevListDistSevenNoAggShockMT.txt","List"];
kLevListDistSevenNoAggShockMT = Round[10 kLevListDistSevenNoAggShockMT]/10//N;

kLevListDistSevenNoAggShockNL = Import["kLevListDistSevenNoAggShockNL.txt","List"];
kLevListDistSevenNoAggShockNL = Round[10 kLevListDistSevenNoAggShockNL]/10//N;

kLevListDistSevenNoAggShockPT = Import["kLevListDistSevenNoAggShockPT.txt","List"];
kLevListDistSevenNoAggShockPT = Round[10 kLevListDistSevenNoAggShockPT]/10//N;

kLevListDistSevenNoAggShockSI = Import["kLevListDistSevenNoAggShockSI.txt","List"];
kLevListDistSevenNoAggShockSI = Round[10 kLevListDistSevenNoAggShockSI]/10//N;

kLevListDistSevenNoAggShockSK = Import["kLevListDistSevenNoAggShockSK.txt","List"];
kLevListDistSevenNoAggShockSK = Round[10 kLevListDistSevenNoAggShockSK]/10//N;


kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline = Import["kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockAT = Import["kLevListDistSevenLiqFinPlsRetNoAggShockAT.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockAT = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockAT]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockBE = Import["kLevListDistSevenLiqFinPlsRetNoAggShockBE.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockBE = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockBE]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockCY = Import["kLevListDistSevenLiqFinPlsRetNoAggShockCY.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockCY = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockCY]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockDE = Import["kLevListDistSevenLiqFinPlsRetNoAggShockDE.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockDE = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockDE]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockES = Import["kLevListDistSevenLiqFinPlsRetNoAggShockES.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockES = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockES]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockFI = Import["kLevListDistSevenLiqFinPlsRetNoAggShockFI.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockFI = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockFI]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockFR = Import["kLevListDistSevenLiqFinPlsRetNoAggShockFR.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockFR = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockFR]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockGR = Import["kLevListDistSevenLiqFinPlsRetNoAggShockGR.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockGR = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockGR]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockIT = Import["kLevListDistSevenLiqFinPlsRetNoAggShockIT.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockIT = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockIT]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockLU = Import["kLevListDistSevenLiqFinPlsRetNoAggShockLU.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockLU = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockLU]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockMT = Import["kLevListDistSevenLiqFinPlsRetNoAggShockMT.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockMT = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockMT]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockNL = Import["kLevListDistSevenLiqFinPlsRetNoAggShockNL.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockNL = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockNL]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockPT = Import["kLevListDistSevenLiqFinPlsRetNoAggShockPT.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockPT = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockPT]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockSI = Import["kLevListDistSevenLiqFinPlsRetNoAggShockSI.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockSI = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockSI]/10//N;

kLevListDistSevenLiqFinPlsRetNoAggShockSK = Import["kLevListDistSevenLiqFinPlsRetNoAggShockSK.txt","List"];
kLevListDistSevenLiqFinPlsRetNoAggShockSK = Round[10 kLevListDistSevenLiqFinPlsRetNoAggShockSK]/10//N;



toplines = "
\\begin{center}

\\begin{tabular}{lrrrrrrrrrrrrrrrr}
 \\toprule
   & All & AT & BE & CY & DE & ES & FI & FR & GR & IT & LU & MT & NL & PT & SI & SK \\\\
 

\\midrule
\\multicolumn{17}{l}{Net Wealth} \\\\

";

bottomlines = "
\\bottomrule
\\end{tabular}
\\end{center}			";

WealthDistSim = {toplines,

"Top 1\\% &",
kLevListDistSevenNoAggShockAllBaseline[[10]],
"&",
kLevListDistSevenNoAggShockAT[[10]],
"&",
kLevListDistSevenNoAggShockBE[[10]],
"&",
kLevListDistSevenNoAggShockCY[[10]],
"&", 
kLevListDistSevenNoAggShockDE[[10]],
"&",
kLevListDistSevenNoAggShockES[[10]],
"&",  
kLevListDistSevenNoAggShockFI[[10]],
"&",
kLevListDistSevenNoAggShockFR[[10]],
"&", 
kLevListDistSevenNoAggShockGR[[10]],
"&",
kLevListDistSevenNoAggShockIT[[10]],
"&",
kLevListDistSevenNoAggShockLU[[10]],
"&", 
kLevListDistSevenNoAggShockMT[[10]],
"&",  
kLevListDistSevenNoAggShockNL[[10]],
"&", 
kLevListDistSevenNoAggShockPT[[10]],
"&",
kLevListDistSevenNoAggShockSI[[10]],
"&",  
kLevListDistSevenNoAggShockSK[[10]],

"\\\\",

"Top 10\\% &",
kLevListDistSevenNoAggShockAllBaseline[[8]],
"&",
kLevListDistSevenNoAggShockAT[[8]],
"&",
kLevListDistSevenNoAggShockBE[[8]],
"&",
kLevListDistSevenNoAggShockCY[[8]],
"&", 
kLevListDistSevenNoAggShockDE[[8]],
"&",
kLevListDistSevenNoAggShockES[[8]],
"&",  
kLevListDistSevenNoAggShockFI[[8]],
"&",
kLevListDistSevenNoAggShockFR[[8]],
"&", 
kLevListDistSevenNoAggShockGR[[8]],
"&",
kLevListDistSevenNoAggShockIT[[8]],
"&",
kLevListDistSevenNoAggShockLU[[8]],
"&", 
kLevListDistSevenNoAggShockMT[[8]],
"&",  
kLevListDistSevenNoAggShockNL[[8]],
"&", 
kLevListDistSevenNoAggShockPT[[8]],
"&",
kLevListDistSevenNoAggShockSI[[8]],
"&",  
kLevListDistSevenNoAggShockSK[[8]],

"\\\\",

"Top 20\\% &",
kLevListDistSevenNoAggShockAllBaseline[[7]],
"&",
kLevListDistSevenNoAggShockAT[[7]],
"&",
kLevListDistSevenNoAggShockBE[[7]],
"&",
kLevListDistSevenNoAggShockCY[[7]],
"&", 
kLevListDistSevenNoAggShockDE[[7]],
"&",
kLevListDistSevenNoAggShockES[[7]],
"&",  
kLevListDistSevenNoAggShockFI[[7]],
"&",
kLevListDistSevenNoAggShockFR[[7]],
"&", 
kLevListDistSevenNoAggShockGR[[7]],
"&",
kLevListDistSevenNoAggShockIT[[7]],
"&",
kLevListDistSevenNoAggShockLU[[7]],
"&", 
kLevListDistSevenNoAggShockMT[[7]],
"&",  
kLevListDistSevenNoAggShockNL[[7]],
"&", 
kLevListDistSevenNoAggShockPT[[7]],
"&",
kLevListDistSevenNoAggShockSI[[7]],
"&",  
kLevListDistSevenNoAggShockSK[[7]],

"\\\\",

"Top 40\\% &",
kLevListDistSevenNoAggShockAllBaseline[[5]],
"&",
kLevListDistSevenNoAggShockAT[[5]],
"&",
kLevListDistSevenNoAggShockBE[[5]],
"&",
kLevListDistSevenNoAggShockCY[[5]],
"&", 
kLevListDistSevenNoAggShockDE[[5]],
"&",
kLevListDistSevenNoAggShockES[[5]],
"&",  
kLevListDistSevenNoAggShockFI[[5]],
"&",
kLevListDistSevenNoAggShockFR[[5]],
"&", 
kLevListDistSevenNoAggShockGR[[5]],
"&",
kLevListDistSevenNoAggShockIT[[5]],
"&",
kLevListDistSevenNoAggShockLU[[5]],
"&", 
kLevListDistSevenNoAggShockMT[[5]],
"&",  
kLevListDistSevenNoAggShockNL[[5]],
"&", 
kLevListDistSevenNoAggShockPT[[5]],
"&",
kLevListDistSevenNoAggShockSI[[5]],
"&",  
kLevListDistSevenNoAggShockSK[[5]],

"\\\\",

"Top 60\\% &",
kLevListDistSevenNoAggShockAllBaseline[[3]],
"&",
kLevListDistSevenNoAggShockAT[[3]],
"&",
kLevListDistSevenNoAggShockBE[[3]],
"&",
kLevListDistSevenNoAggShockCY[[3]],
"&", 
kLevListDistSevenNoAggShockDE[[3]],
"&",
kLevListDistSevenNoAggShockES[[3]],
"&",  
kLevListDistSevenNoAggShockFI[[3]],
"&",
kLevListDistSevenNoAggShockFR[[3]],
"&", 
kLevListDistSevenNoAggShockGR[[3]],
"&",
kLevListDistSevenNoAggShockIT[[3]],
"&",
kLevListDistSevenNoAggShockLU[[3]],
"&", 
kLevListDistSevenNoAggShockMT[[3]],
"&",  
kLevListDistSevenNoAggShockNL[[3]],
"&", 
kLevListDistSevenNoAggShockPT[[3]],
"&",
kLevListDistSevenNoAggShockSI[[3]],
"&",  
kLevListDistSevenNoAggShockSK[[3]],

"\\\\",

"Top 80\\% &",
kLevListDistSevenNoAggShockAllBaseline[[2]],
"&",
kLevListDistSevenNoAggShockAT[[2]],
"&",
kLevListDistSevenNoAggShockBE[[2]],
"&",
kLevListDistSevenNoAggShockCY[[2]],
"&", 
kLevListDistSevenNoAggShockDE[[2]],
"&",
kLevListDistSevenNoAggShockES[[2]],
"&",  
kLevListDistSevenNoAggShockFI[[2]],
"&",
kLevListDistSevenNoAggShockFR[[2]],
"&", 
kLevListDistSevenNoAggShockGR[[2]],
"&",
kLevListDistSevenNoAggShockIT[[2]],
"&",
kLevListDistSevenNoAggShockLU[[2]],
"&", 
kLevListDistSevenNoAggShockMT[[2]],
"&",  
kLevListDistSevenNoAggShockNL[[2]],
"&", 
kLevListDistSevenNoAggShockPT[[2]],
"&",
kLevListDistSevenNoAggShockSI[[2]],
"&",  
kLevListDistSevenNoAggShockSK[[2]],

"\\\\",

"\\midrule
\\multicolumn{17}{l}{Liquid Financial and Retirement Assets} \\\\ ",

"Top 1\\% &",
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockAT[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockBE[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockCY[[10]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockDE[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockES[[10]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockFI[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockFR[[10]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockGR[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockIT[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockLU[[10]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockMT[[10]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockNL[[10]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockPT[[10]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockSI[[10]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockSK[[10]],

"\\\\",

"Top 10\\% &",
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockAT[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockBE[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockCY[[8]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockDE[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockES[[8]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockFI[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockFR[[8]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockGR[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockIT[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockLU[[8]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockMT[[8]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockNL[[8]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockPT[[8]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockSI[[8]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockSK[[8]],

"\\\\",

"Top 20\\% &",
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockAT[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockBE[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockCY[[7]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockDE[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockES[[7]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockFI[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockFR[[7]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockGR[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockIT[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockLU[[7]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockMT[[7]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockNL[[7]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockPT[[7]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockSI[[7]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockSK[[7]],

"\\\\",

"Top 40\\% &",
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockAT[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockBE[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockCY[[5]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockDE[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockES[[5]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockFI[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockFR[[5]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockGR[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockIT[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockLU[[5]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockMT[[5]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockNL[[5]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockPT[[5]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockSI[[5]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockSK[[5]],

"\\\\",

"Top 60\\% &",
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockAT[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockBE[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockCY[[3]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockDE[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockES[[3]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockFI[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockFR[[3]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockGR[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockIT[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockLU[[3]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockMT[[3]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockNL[[3]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockPT[[3]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockSI[[3]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockSK[[3]],

"\\\\",

"Top 80\\% &",
kLevListDistSevenLiqFinPlsRetNoAggShockAllBaseline[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockAT[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockBE[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockCY[[2]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockDE[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockES[[2]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockFI[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockFR[[2]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockGR[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockIT[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockLU[[2]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockMT[[2]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockNL[[2]],
"&", 
kLevListDistSevenLiqFinPlsRetNoAggShockPT[[2]],
"&",
kLevListDistSevenLiqFinPlsRetNoAggShockSI[[2]],
"&",  
kLevListDistSevenLiqFinPlsRetNoAggShockSK[[2]],

"\\\\",


bottomlines};

SetDirectory[TableDir];
Export["WealthDistSim.tex", WealthDistSim, "text"];

SetDirectory[MPCxcTableDir];
Export["WealthDistSim.tex", WealthDistSim, "text"];

