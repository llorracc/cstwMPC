SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsEuropeDir, SetDirectory[ResultsEuropeDir]];
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)
MPCxcTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPCxc\Latest\Tables"; (* MPC Europe directory directory *)

(* Import data *)

(* AllBaseline *)
MPCListDistSevenWithAggPermShockAllBaseline = Import["MPCListDistSevenWithAggPermShocksAllBaseline.txt","List"];
MPCListDistSevenWithAggPermShockAllBaselineQ = 1 - (1-MPCListDistSevenWithAggPermShockAllBaseline)^(1/4);
MPCListDistSevenWithAggPermShockAllBaselineTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllBaselineQ[[1]] -

MPCListDistSevenWithAggPermShockAllBaselineQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAllBaselineTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllBaselineQ[[1]] -

MPCListDistSevenWithAggPermShockAllBaselineQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAllBaseline = Round[100 MPCListDistSevenWithAggPermShockAllBaseline]/100//N;


BetamiddleAllBaseline = Round[1000 Import["BetamiddleAllBaseline.txt","List"]]/1000//N;
NablaAllBaseline      = Round[1000 3.5 Import["diffAllBaseline.txt","List"]]/1000//N;

(* AT *)
MPCListDistSevenWithAggPermShockAT = Import["MPCListDistSevenWithAggPermShocksAT.txt","List"];
MPCListDistSevenWithAggPermShockATQ = 1 - (1-MPCListDistSevenWithAggPermShockAT)^(1/4);
MPCListDistSevenWithAggPermShockATTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockATQ[[1]] -

MPCListDistSevenWithAggPermShockATQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockATTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockATQ[[1]] -

MPCListDistSevenWithAggPermShockATQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAT = Round[100 MPCListDistSevenWithAggPermShockAT]/100//N;

BetamiddleAT = Round[1000 Import["BetamiddleAT.txt","List"]]/1000//N;
NablaAT      = Round[1000 3.5 Import["diffAT.txt","List"]]/1000//N;

(* BE *)
MPCListDistSevenWithAggPermShockBE = Import["MPCListDistSevenWithAggPermShocksBE.txt","List"];
MPCListDistSevenWithAggPermShockBEQ = 1 - (1-MPCListDistSevenWithAggPermShockBE)^(1/4);
MPCListDistSevenWithAggPermShockBETop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockBEQ[[1]] -

MPCListDistSevenWithAggPermShockBEQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockBETop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockBEQ[[1]] -

MPCListDistSevenWithAggPermShockBEQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockBE = Round[100 MPCListDistSevenWithAggPermShockBE]/100//N;

BetamiddleBE = Round[1000 Import["BetamiddleBE.txt","List"]]/1000//N;
NablaBE      = Round[1000 3.5 Import["diffBE.txt","List"]]/1000//N;

(* CY *)
MPCListDistSevenWithAggPermShockCY = Import["MPCListDistSevenWithAggPermShocksCY.txt","List"];
MPCListDistSevenWithAggPermShockCYQ = 1 - (1-MPCListDistSevenWithAggPermShockCY)^(1/4);
MPCListDistSevenWithAggPermShockCYTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockCYQ[[1]] -

MPCListDistSevenWithAggPermShockCYQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockCYTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockCYQ[[1]] -

MPCListDistSevenWithAggPermShockCYQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockCY = Round[100 MPCListDistSevenWithAggPermShockCY]/100//N;

BetamiddleCY = Round[1000 Import["BetamiddleCY.txt","List"]]/1000//N;
NablaCY      = Round[1000 3.5 Import["diffCY.txt","List"]]/1000//N;

(* DE *)
MPCListDistSevenWithAggPermShockDE = Import["MPCListDistSevenWithAggPermShocksDE.txt","List"];
MPCListDistSevenWithAggPermShockDEQ = 1 - (1-MPCListDistSevenWithAggPermShockDE)^(1/4);
MPCListDistSevenWithAggPermShockDETop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockDEQ[[1]] -

MPCListDistSevenWithAggPermShockDEQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockDETop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockDEQ[[1]] -

MPCListDistSevenWithAggPermShockDEQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockDE = Round[100 MPCListDistSevenWithAggPermShockDE]/100//N;

BetamiddleDE = Round[1000 Import["BetamiddleDE.txt","List"]]/1000//N;
NablaDE      = Round[1000 3.5 Import["diffDE.txt","List"]]/1000//N;

(* ES *)
MPCListDistSevenWithAggPermShockES = Import["MPCListDistSevenWithAggPermShocksES.txt","List"];
MPCListDistSevenWithAggPermShockESQ = 1 - (1-MPCListDistSevenWithAggPermShockES)^(1/4);
MPCListDistSevenWithAggPermShockESTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockESQ[[1]] -

MPCListDistSevenWithAggPermShockESQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockESTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockESQ[[1]] -

MPCListDistSevenWithAggPermShockESQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockES = Round[100 MPCListDistSevenWithAggPermShockES]/100//N;

BetamiddleES = Round[1000 Import["BetamiddleES.txt","List"]]/1000//N;
NablaES      = Round[1000 3.5 Import["diffES.txt","List"]]/1000//N;

(* FI *)
MPCListDistSevenWithAggPermShockFI = Import["MPCListDistSevenWithAggPermShocksFI.txt","List"];
MPCListDistSevenWithAggPermShockFIQ = 1 - (1-MPCListDistSevenWithAggPermShockFI)^(1/4);
MPCListDistSevenWithAggPermShockFITop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFIQ[[1]] -

MPCListDistSevenWithAggPermShockFIQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockFITop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFIQ[[1]] -

MPCListDistSevenWithAggPermShockFIQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockFI = Round[100 MPCListDistSevenWithAggPermShockFI]/100//N;

BetamiddleFI = Round[1000 Import["BetamiddleFI.txt","List"]]/1000//N;
NablaFI      = Round[1000 3.5 Import["diffFI.txt","List"]]/1000//N;

(* FR *)
MPCListDistSevenWithAggPermShockFR = Import["MPCListDistSevenWithAggPermShocksFR.txt","List"];
MPCListDistSevenWithAggPermShockFRQ = 1 - (1-MPCListDistSevenWithAggPermShockFR)^(1/4);
MPCListDistSevenWithAggPermShockFRTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFRQ[[1]] -

MPCListDistSevenWithAggPermShockFRQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockFRTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFRQ[[1]] -

MPCListDistSevenWithAggPermShockFRQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockFR = Round[100 MPCListDistSevenWithAggPermShockFR]/100//N;

BetamiddleFR = Round[1000 Import["BetamiddleFR.txt","List"]]/1000//N;
NablaFR      = Round[1000 3.5 Import["diffFR.txt","List"]]/1000//N;

(* GR *)
MPCListDistSevenWithAggPermShockGR = Import["MPCListDistSevenWithAggPermShocksGR.txt","List"];
MPCListDistSevenWithAggPermShockGRQ = 1 - (1-MPCListDistSevenWithAggPermShockGR)^(1/4);
MPCListDistSevenWithAggPermShockGRTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockGRQ[[1]] -

MPCListDistSevenWithAggPermShockGRQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockGRTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockGRQ[[1]] -

MPCListDistSevenWithAggPermShockGRQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockGR = Round[100 MPCListDistSevenWithAggPermShockGR]/100//N;

BetamiddleGR = Round[1000 Import["BetamiddleGR.txt","List"]]/1000//N;
NablaGR      = Round[1000 3.5 Import["diffGR.txt","List"]]/1000//N;

(* IT *)
MPCListDistSevenWithAggPermShockIT = Import["MPCListDistSevenWithAggPermShocksIT.txt","List"];
MPCListDistSevenWithAggPermShockITQ = 1 - (1-MPCListDistSevenWithAggPermShockIT)^(1/4);
MPCListDistSevenWithAggPermShockITTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockITQ[[1]] -
MPCListDistSevenWithAggPermShockITQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockITTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockITQ[[1]] -

MPCListDistSevenWithAggPermShockITQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockIT = Round[100 MPCListDistSevenWithAggPermShockIT]/100//N;

BetamiddleIT = Round[1000 Import["BetamiddleIT.txt","List"]]/1000//N;
NablaIT      = Round[1000 3.5 Import["diffIT.txt","List"]]/1000//N;

(* LU *)
MPCListDistSevenWithAggPermShockLU = Import["MPCListDistSevenWithAggPermShocksLU.txt","List"];
MPCListDistSevenWithAggPermShockLUQ = 1 - (1-MPCListDistSevenWithAggPermShockLU)^(1/4);
MPCListDistSevenWithAggPermShockLUTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLUQ[[1]] -

MPCListDistSevenWithAggPermShockLUQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLUTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLUQ[[1]] -

MPCListDistSevenWithAggPermShockLUQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLU = Round[100 MPCListDistSevenWithAggPermShockLU]/100//N;

BetamiddleLU = Round[1000 Import["BetamiddleLU.txt","List"]]/1000//N;
NablaLU      = Round[1000 3.5 Import["diffLU.txt","List"]]/1000//N;

(* MT *)
MPCListDistSevenWithAggPermShockMT = Import["MPCListDistSevenWithAggPermShocksMT.txt","List"];
MPCListDistSevenWithAggPermShockMTQ = 1 - (1-MPCListDistSevenWithAggPermShockMT)^(1/4);
MPCListDistSevenWithAggPermShockMTTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockMTQ[[1]] -

MPCListDistSevenWithAggPermShockMTQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockMTTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockMTQ[[1]] -

MPCListDistSevenWithAggPermShockMTQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockMT = Round[100 MPCListDistSevenWithAggPermShockMT]/100//N;

BetamiddleMT = Round[1000 Import["BetamiddleMT.txt","List"]]/1000//N;
NablaMT      = Round[1000 3.5 Import["diffMT.txt","List"]]/1000//N;

(* NL *)
MPCListDistSevenWithAggPermShockNL = Import["MPCListDistSevenWithAggPermShocksNL.txt","List"];
MPCListDistSevenWithAggPermShockNLQ = 1 - (1-MPCListDistSevenWithAggPermShockNL)^(1/4);
MPCListDistSevenWithAggPermShockNLTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockNLQ[[1]] -

MPCListDistSevenWithAggPermShockNLQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockNLTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockNLQ[[1]] -

MPCListDistSevenWithAggPermShockNLQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockNL = Round[100 MPCListDistSevenWithAggPermShockNL]/100//N;

BetamiddleNL = Round[1000 Import["BetamiddleNL.txt","List"]]/1000//N;
NablaNL      = Round[1000 3.5 Import["diffNL.txt","List"]]/1000//N;

(* PT *)
MPCListDistSevenWithAggPermShockPT = Import["MPCListDistSevenWithAggPermShocksPT.txt","List"];
MPCListDistSevenWithAggPermShockPTQ = 1 - (1-MPCListDistSevenWithAggPermShockPT)^(1/4);
MPCListDistSevenWithAggPermShockPTTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockPTQ[[1]] -

MPCListDistSevenWithAggPermShockPTQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockPTTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockPTQ[[1]] -

MPCListDistSevenWithAggPermShockPTQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockPT = Round[100 MPCListDistSevenWithAggPermShockPT]/100//N;

BetamiddlePT = Round[1000 Import["BetamiddlePT.txt","List"]]/1000//N;
NablaPT      = Round[1000 3.5 Import["diffPT.txt","List"]]/1000//N;

(* SI *)
MPCListDistSevenWithAggPermShockSI = Import["MPCListDistSevenWithAggPermShocksSI.txt","List"];
MPCListDistSevenWithAggPermShockSIQ = 1 - (1-MPCListDistSevenWithAggPermShockSI)^(1/4);
MPCListDistSevenWithAggPermShockSITop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSIQ[[1]] -

MPCListDistSevenWithAggPermShockSIQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockSITop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSIQ[[1]] -

MPCListDistSevenWithAggPermShockSIQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockSI = Round[100 MPCListDistSevenWithAggPermShockSI]/100//N;

BetamiddleSI = Round[1000 Import["BetamiddleSI.txt","List"]]/1000//N;
NablaSI      = Round[1000 3.5 Import["diffSI.txt","List"]]/1000//N;

(* SK *)
MPCListDistSevenWithAggPermShockSK = Import["MPCListDistSevenWithAggPermShocksSK.txt","List"];
MPCListDistSevenWithAggPermShockSKQ = 1 - (1-MPCListDistSevenWithAggPermShockSK)^(1/4);
MPCListDistSevenWithAggPermShockSKTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSKQ[[1]] -

MPCListDistSevenWithAggPermShockSKQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockSKTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSKQ[[1]] -

MPCListDistSevenWithAggPermShockSKQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockSK = Round[100 MPCListDistSevenWithAggPermShockSK]/100//N;

BetamiddleSK = Round[1000 Import["BetamiddleSK.txt","List"]]/1000//N;
NablaSK      = Round[1000 3.5 Import["diffSK.txt","List"]]/1000//N;



toplines = "
\\begin{center}

\\begin{tabular}{llllllllllllllllll}
 \\toprule 
 &  & \\multicolumn{1}{r}{All} &  \\multicolumn{1}{r}{Austria} &  \\multicolumn{2}{r}{Cyprus} &  \\multicolumn{2}{r}{Spain} &  \\multicolumn{2}{r}{France} &  \\multicolumn{2}{r}{Italy} &  \\multicolumn{2}{r}{Malta} &  \\multicolumn{2}{r}{Portugal} &  \\multicolumn{2}{r}{Slovakia}\\\\
\\multicolumn{2}{l}{} &  \\multicolumn{1}{r}{Countries} &  \\multicolumn{2}{r}{Belgium} &  \\multicolumn{2}{r}{Germany}&  \\multicolumn{2}{r}{Finland} &  \\multicolumn{2}{r}{Greece} &  \\multicolumn{2}{r}{Luxmbrg} &  \\multicolumn{2}{r}{Nethrlds} &  \\multicolumn{2}{r}{Slovenia}\\\\
\\midrule

";

bottomlines = "
\\bottomrule
\\end{tabular}%

\\end{center}				";

MPC = {toplines,

"\\multicolumn{10}{l}{Overall} & \\\\ \\multicolumn{2}{l}{$\\text{Average}$} &",
MPCListDistSevenWithAggPermShockAllBaseline[[1]],
"&",
MPCListDistSevenWithAggPermShockAT[[1]],
"&",
MPCListDistSevenWithAggPermShockBE[[1]],
"&",
MPCListDistSevenWithAggPermShockCY[[1]],
"&",
MPCListDistSevenWithAggPermShockDE[[1]],
"&",
MPCListDistSevenWithAggPermShockES[[1]],
"&",
MPCListDistSevenWithAggPermShockFI[[1]],
"&",
MPCListDistSevenWithAggPermShockFR[[1]],
"&",
MPCListDistSevenWithAggPermShockGR[[1]],
"&",
MPCListDistSevenWithAggPermShockIT[[1]],
"  &",
MPCListDistSevenWithAggPermShockLU[[1]],
"  &",
MPCListDistSevenWithAggPermShockMT[[1]],
"  &",
MPCListDistSevenWithAggPermShockNL[[1]],
"  &",
MPCListDistSevenWithAggPermShockPT[[1]],
"  &",
MPCListDistSevenWithAggPermShockSI[[1]],
"  &",
MPCListDistSevenWithAggPermShockSK[[1]],
 " \\\\ ",
"\\multicolumn{10}{l}{By wealth-to-permanent income ratio} &",
"\\\\",

"& $\\text{Top 1\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[2]],
"&",
MPCListDistSevenWithAggPermShockAT[[2]],
"&",
MPCListDistSevenWithAggPermShockBE[[2]],
"&",
MPCListDistSevenWithAggPermShockCY[[2]],
"&",
MPCListDistSevenWithAggPermShockDE[[2]],
"&",
MPCListDistSevenWithAggPermShockES[[2]],
"&",
MPCListDistSevenWithAggPermShockFI[[2]],
"&",
MPCListDistSevenWithAggPermShockFR[[2]],
"&",
MPCListDistSevenWithAggPermShockGR[[2]],
"&",
MPCListDistSevenWithAggPermShockIT[[2]],
"  &",
MPCListDistSevenWithAggPermShockLU[[2]],
"  &",
MPCListDistSevenWithAggPermShockMT[[2]],
"  &",
MPCListDistSevenWithAggPermShockNL[[2]],
"  &",
MPCListDistSevenWithAggPermShockPT[[2]],
"  &",
MPCListDistSevenWithAggPermShockSI[[2]],
"  &",
MPCListDistSevenWithAggPermShockSK[[2]],
"\\\\",

"& $\\text{Top 10\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[3]],
"&",
MPCListDistSevenWithAggPermShockAT[[3]],
"&",
MPCListDistSevenWithAggPermShockBE[[3]],
"&",
MPCListDistSevenWithAggPermShockCY[[3]],
"&",
MPCListDistSevenWithAggPermShockDE[[3]],
"&",
MPCListDistSevenWithAggPermShockES[[3]],
"&",
MPCListDistSevenWithAggPermShockFI[[3]],
"&",
MPCListDistSevenWithAggPermShockFR[[3]],
"&",
MPCListDistSevenWithAggPermShockGR[[3]],
"&",
MPCListDistSevenWithAggPermShockIT[[3]],
"  &",
MPCListDistSevenWithAggPermShockLU[[3]],
"  &",
MPCListDistSevenWithAggPermShockMT[[3]],
"  &",
MPCListDistSevenWithAggPermShockNL[[3]],
"  &",
MPCListDistSevenWithAggPermShockPT[[3]],
"  &",
MPCListDistSevenWithAggPermShockSI[[3]],
"  &",
MPCListDistSevenWithAggPermShockSK[[3]],
"\\\\",

"& $\\text{Top 20\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[4]],
"&",
MPCListDistSevenWithAggPermShockAT[[4]],
"&",
MPCListDistSevenWithAggPermShockBE[[4]],
"&",
MPCListDistSevenWithAggPermShockCY[[4]],
"&",
MPCListDistSevenWithAggPermShockDE[[4]],
"&",
MPCListDistSevenWithAggPermShockES[[4]],
"&",
MPCListDistSevenWithAggPermShockFI[[4]],
"&",
MPCListDistSevenWithAggPermShockFR[[4]],
"&",
MPCListDistSevenWithAggPermShockGR[[4]],
"&",
MPCListDistSevenWithAggPermShockIT[[4]],
"  &",
MPCListDistSevenWithAggPermShockLU[[4]],
"  &",
MPCListDistSevenWithAggPermShockMT[[4]],
"  &",
MPCListDistSevenWithAggPermShockNL[[4]],
"  &",
MPCListDistSevenWithAggPermShockPT[[4]],
"  &",
MPCListDistSevenWithAggPermShockSI[[4]],
"  &",
MPCListDistSevenWithAggPermShockSK[[4]],
"\\\\",

"& $\\text{Top 40\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[5]],
"&",
MPCListDistSevenWithAggPermShockAT[[5]],
"&",
MPCListDistSevenWithAggPermShockBE[[5]],
"&",
MPCListDistSevenWithAggPermShockCY[[5]],
"&",
MPCListDistSevenWithAggPermShockDE[[5]],
"&",
MPCListDistSevenWithAggPermShockES[[5]],
"&",
MPCListDistSevenWithAggPermShockFI[[5]],
"&",
MPCListDistSevenWithAggPermShockFR[[5]],
"&",
MPCListDistSevenWithAggPermShockGR[[5]],
"&",
MPCListDistSevenWithAggPermShockIT[[5]],
"  &",
MPCListDistSevenWithAggPermShockLU[[5]],
"  &",
MPCListDistSevenWithAggPermShockMT[[5]],
"  &",
MPCListDistSevenWithAggPermShockNL[[5]],
"  &",
MPCListDistSevenWithAggPermShockPT[[5]],
"  &",
MPCListDistSevenWithAggPermShockSI[[5]],
"  &",
MPCListDistSevenWithAggPermShockSK[[5]],
"\\\\",

"& $\\text{Top 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaselineTop50ByW,
"&",
MPCListDistSevenWithAggPermShockATTop50ByW,
"&",
MPCListDistSevenWithAggPermShockBETop50ByW,
"&",
MPCListDistSevenWithAggPermShockCYTop50ByW,
"&",
MPCListDistSevenWithAggPermShockDETop50ByW,
"&",
MPCListDistSevenWithAggPermShockESTop50ByW,
"&",
MPCListDistSevenWithAggPermShockFITop50ByW,
"&",
MPCListDistSevenWithAggPermShockFRTop50ByW,
"&",
MPCListDistSevenWithAggPermShockGRTop50ByW,
"&",
MPCListDistSevenWithAggPermShockITTop50ByW,
"  &",
MPCListDistSevenWithAggPermShockLUTop50ByW,
"  &",
MPCListDistSevenWithAggPermShockMTTop50ByW,
"  &",
MPCListDistSevenWithAggPermShockNLTop50ByW,
"  &",
MPCListDistSevenWithAggPermShockPTTop50ByW,
"  &",
MPCListDistSevenWithAggPermShockSITop50ByW,
"  &",
MPCListDistSevenWithAggPermShockSKTop50ByW,
"\\\\",

"& $\\text{Top 60\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[6]],
"&",
MPCListDistSevenWithAggPermShockAT[[6]],
"&",
MPCListDistSevenWithAggPermShockBE[[6]],
"&",
MPCListDistSevenWithAggPermShockCY[[6]],
"&",
MPCListDistSevenWithAggPermShockDE[[6]],
"&",
MPCListDistSevenWithAggPermShockES[[6]],
"&",
MPCListDistSevenWithAggPermShockFI[[6]],
"&",
MPCListDistSevenWithAggPermShockFR[[6]],
"&",
MPCListDistSevenWithAggPermShockGR[[6]],
"&",
MPCListDistSevenWithAggPermShockIT[[6]],
"  &",
MPCListDistSevenWithAggPermShockLU[[6]],
"  &",
MPCListDistSevenWithAggPermShockMT[[6]],
"  &",
MPCListDistSevenWithAggPermShockNL[[6]],
"  &",
MPCListDistSevenWithAggPermShockPT[[6]],
"  &",
MPCListDistSevenWithAggPermShockSI[[6]],
"  &",
MPCListDistSevenWithAggPermShockSK[[6]],
"\\\\",

"& $\\text{Bottm 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[7]],
"&",
MPCListDistSevenWithAggPermShockAT[[7]],
"&",
MPCListDistSevenWithAggPermShockBE[[7]],
"&",
MPCListDistSevenWithAggPermShockCY[[7]],
"&",
MPCListDistSevenWithAggPermShockDE[[7]],
"&",
MPCListDistSevenWithAggPermShockES[[7]],
"&",
MPCListDistSevenWithAggPermShockFI[[7]],
"&",
MPCListDistSevenWithAggPermShockFR[[7]],
"&",
MPCListDistSevenWithAggPermShockGR[[7]],
"&",
MPCListDistSevenWithAggPermShockIT[[7]],
"  &",
MPCListDistSevenWithAggPermShockLU[[7]],
"  &",
MPCListDistSevenWithAggPermShockMT[[7]],
"  &",
MPCListDistSevenWithAggPermShockNL[[7]],
"  &",
MPCListDistSevenWithAggPermShockPT[[7]],
"  &",
MPCListDistSevenWithAggPermShockSI[[7]],
"  &",
MPCListDistSevenWithAggPermShockSK[[7]],
"\\\\",

"\\multicolumn{10}{l}{$\\text{By income}$}  \\\\",

"& $\\text{Top 1\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[8]],
"&",
MPCListDistSevenWithAggPermShockAT[[8]],
"&",
MPCListDistSevenWithAggPermShockBE[[8]],
"&",
MPCListDistSevenWithAggPermShockCY[[8]],
"&",
MPCListDistSevenWithAggPermShockDE[[8]],
"&",
MPCListDistSevenWithAggPermShockES[[8]],
"&",
MPCListDistSevenWithAggPermShockFI[[8]],
"&",
MPCListDistSevenWithAggPermShockFR[[8]],
"&",
MPCListDistSevenWithAggPermShockGR[[8]],
"&",
MPCListDistSevenWithAggPermShockIT[[8]],
"  &",
MPCListDistSevenWithAggPermShockLU[[8]],
"  &",
MPCListDistSevenWithAggPermShockMT[[8]],
"  &",
MPCListDistSevenWithAggPermShockNL[[8]],
"  &",
MPCListDistSevenWithAggPermShockPT[[8]],
"  &",
MPCListDistSevenWithAggPermShockSI[[8]],
"  &",
MPCListDistSevenWithAggPermShockSK[[8]],
"\\\\",

"& $\\text{Top 10\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[9]],
"&",
MPCListDistSevenWithAggPermShockAT[[9]],
"&",
MPCListDistSevenWithAggPermShockBE[[9]],
"&",
MPCListDistSevenWithAggPermShockCY[[9]],
"&",
MPCListDistSevenWithAggPermShockDE[[9]],
"&",
MPCListDistSevenWithAggPermShockES[[9]],
"&",
MPCListDistSevenWithAggPermShockFI[[9]],
"&",
MPCListDistSevenWithAggPermShockFR[[9]],
"&",
MPCListDistSevenWithAggPermShockGR[[9]],
"&",
MPCListDistSevenWithAggPermShockIT[[9]],
"  &",
MPCListDistSevenWithAggPermShockLU[[9]],
"  &",
MPCListDistSevenWithAggPermShockMT[[9]],
"  &",
MPCListDistSevenWithAggPermShockNL[[9]],
"  &",
MPCListDistSevenWithAggPermShockPT[[9]],
"  &",
MPCListDistSevenWithAggPermShockSI[[9]],
"  &",
MPCListDistSevenWithAggPermShockSK[[9]],
"\\\\",

"& $\\text{Top 20\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[10]],
"&",
MPCListDistSevenWithAggPermShockAT[[10]],
"&",
MPCListDistSevenWithAggPermShockBE[[10]],
"&",
MPCListDistSevenWithAggPermShockCY[[10]],
"&",
MPCListDistSevenWithAggPermShockDE[[10]],
"&",
MPCListDistSevenWithAggPermShockES[[10]],
"&",
MPCListDistSevenWithAggPermShockFI[[10]],
"&",
MPCListDistSevenWithAggPermShockFR[[10]],
"&",
MPCListDistSevenWithAggPermShockGR[[10]],
"&",
MPCListDistSevenWithAggPermShockIT[[10]],
"  &",
MPCListDistSevenWithAggPermShockLU[[10]],
"  &",
MPCListDistSevenWithAggPermShockMT[[10]],
"  &",
MPCListDistSevenWithAggPermShockNL[[10]],
"  &",
MPCListDistSevenWithAggPermShockPT[[10]],
"  &",
MPCListDistSevenWithAggPermShockSI[[10]],
"  &",
MPCListDistSevenWithAggPermShockSK[[10]],
"\\\\",

"& $\\text{Top 40\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[11]],
"&",
MPCListDistSevenWithAggPermShockAT[[11]],
"&",
MPCListDistSevenWithAggPermShockBE[[11]],
"&",
MPCListDistSevenWithAggPermShockCY[[11]],
"&",
MPCListDistSevenWithAggPermShockDE[[11]],
"&",
MPCListDistSevenWithAggPermShockES[[11]],
"&",
MPCListDistSevenWithAggPermShockFI[[11]],
"&",
MPCListDistSevenWithAggPermShockFR[[11]],
"&",
MPCListDistSevenWithAggPermShockGR[[11]],
"&",
MPCListDistSevenWithAggPermShockIT[[11]],
"  &",
MPCListDistSevenWithAggPermShockLU[[11]],
"  &",
MPCListDistSevenWithAggPermShockMT[[11]],
"  &",
MPCListDistSevenWithAggPermShockNL[[11]],
"  &",
MPCListDistSevenWithAggPermShockPT[[11]],
"  &",
MPCListDistSevenWithAggPermShockSI[[11]],
"  &",
MPCListDistSevenWithAggPermShockSK[[11]],
"\\\\",



"& $\\text{Top 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaselineTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockATTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockBETop50ByInc,
"&",
MPCListDistSevenWithAggPermShockCYTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockDETop50ByInc,
"&",
MPCListDistSevenWithAggPermShockESTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockFITop50ByInc,
"&",
MPCListDistSevenWithAggPermShockFRTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockGRTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockITTop50ByInc,
"  &",
MPCListDistSevenWithAggPermShockLUTop50ByInc,
"  &",
MPCListDistSevenWithAggPermShockMTTop50ByInc,
"  &",
MPCListDistSevenWithAggPermShockNLTop50ByInc,
"  &",
MPCListDistSevenWithAggPermShockPTTop50ByInc,
"  &",
MPCListDistSevenWithAggPermShockSITop50ByInc,
"  &",
MPCListDistSevenWithAggPermShockSKTop50ByInc,
"\\\\",

"& $\\text{Top 60\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[12]],
"&",
MPCListDistSevenWithAggPermShockAT[[12]],
"&",
MPCListDistSevenWithAggPermShockBE[[12]],
"&",
MPCListDistSevenWithAggPermShockCY[[12]],
"&",
MPCListDistSevenWithAggPermShockDE[[12]],
"&",
MPCListDistSevenWithAggPermShockES[[12]],
"&",
MPCListDistSevenWithAggPermShockFI[[12]],
"&",
MPCListDistSevenWithAggPermShockFR[[12]],
"&",
MPCListDistSevenWithAggPermShockGR[[12]],
"&",
MPCListDistSevenWithAggPermShockIT[[12]],
"  &",
MPCListDistSevenWithAggPermShockLU[[12]],
"  &",
MPCListDistSevenWithAggPermShockMT[[12]],
"  &",
MPCListDistSevenWithAggPermShockNL[[12]],
"  &",
MPCListDistSevenWithAggPermShockPT[[12]],
"  &",
MPCListDistSevenWithAggPermShockSI[[12]],
"  &",
MPCListDistSevenWithAggPermShockSK[[12]],
"\\\\",

"& $\\text{Bottm 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[13]],
"&",
MPCListDistSevenWithAggPermShockAT[[13]],
"&",
MPCListDistSevenWithAggPermShockBE[[13]],
"&",
MPCListDistSevenWithAggPermShockCY[[13]],
"&",
MPCListDistSevenWithAggPermShockDE[[13]],
"&",
MPCListDistSevenWithAggPermShockES[[13]],
"&",
MPCListDistSevenWithAggPermShockFI[[13]],
"&",
MPCListDistSevenWithAggPermShockFR[[13]],
"&",
MPCListDistSevenWithAggPermShockGR[[13]],
"&",
MPCListDistSevenWithAggPermShockIT[[13]],
"  &",
MPCListDistSevenWithAggPermShockLU[[13]],
"  &",
MPCListDistSevenWithAggPermShockMT[[13]],
"  &",
MPCListDistSevenWithAggPermShockNL[[13]],
"  &",
MPCListDistSevenWithAggPermShockPT[[13]],
"  &",
MPCListDistSevenWithAggPermShockSI[[13]],
"  &",
MPCListDistSevenWithAggPermShockSK[[13]],
"\\\\",

"\\multicolumn{10}{l}{$\\text{By employment status}$}   \\\\",

"& Employed &",
MPCListDistSevenWithAggPermShockAllBaseline[[14]],
"&",
MPCListDistSevenWithAggPermShockAT[[14]],
"&",
MPCListDistSevenWithAggPermShockBE[[14]],
"&",
MPCListDistSevenWithAggPermShockCY[[14]],
"&",
MPCListDistSevenWithAggPermShockDE[[14]],
"&",
MPCListDistSevenWithAggPermShockES[[14]],
"&",
MPCListDistSevenWithAggPermShockFI[[14]],
"&",
MPCListDistSevenWithAggPermShockFR[[14]],
"&",
MPCListDistSevenWithAggPermShockGR[[14]],
"&",
MPCListDistSevenWithAggPermShockIT[[14]],
"  &",
MPCListDistSevenWithAggPermShockLU[[14]],
"  &",
MPCListDistSevenWithAggPermShockMT[[14]],
"  &",
MPCListDistSevenWithAggPermShockNL[[14]],
"  &",
MPCListDistSevenWithAggPermShockPT[[14]],
"  &",
MPCListDistSevenWithAggPermShockSI[[14]],
"  &",
MPCListDistSevenWithAggPermShockSK[[14]],
"\\\\",

"& Unempl &",
MPCListDistSevenWithAggPermShockAllBaseline[[15]],
"&",
MPCListDistSevenWithAggPermShockAT[[15]],
"&",
MPCListDistSevenWithAggPermShockBE[[15]],
"&",
MPCListDistSevenWithAggPermShockCY[[15]],
"&",
MPCListDistSevenWithAggPermShockDE[[15]],
"&",
MPCListDistSevenWithAggPermShockES[[15]],
"&",
MPCListDistSevenWithAggPermShockFI[[15]],
"&",
MPCListDistSevenWithAggPermShockFR[[15]],
"&",
MPCListDistSevenWithAggPermShockGR[[15]],
"&",
MPCListDistSevenWithAggPermShockIT[[15]],
"  &",
MPCListDistSevenWithAggPermShockLU[[15]],
"  &",
MPCListDistSevenWithAggPermShockMT[[15]],
"  &",
MPCListDistSevenWithAggPermShockNL[[15]],
"  &",
MPCListDistSevenWithAggPermShockPT[[15]],
"  &",
MPCListDistSevenWithAggPermShockSI[[15]],
"  &",
MPCListDistSevenWithAggPermShockSK[[15]],
"\\\\",

"\\midrule",

"\\multicolumn{10}{l}{Time preference parameters${}^\\ddagger$}   \\\\",

"\\multicolumn{2}{l}{$\\grave{\\Discount}$} ",

"&",
BetamiddleAllBaseline[[1]],
"&",
BetamiddleAT[[1]],
"&",
BetamiddleBE[[1]],
"&",
BetamiddleCY[[1]],
"&",
BetamiddleDE[[1]],
"&",
BetamiddleES[[1]],
"&",
BetamiddleFI[[1]],
"&",
BetamiddleFR[[1]],
"&",
BetamiddleGR[[1]],
"&",
BetamiddleIT[[1]],
"&",
BetamiddleLU[[1]],
"&",
BetamiddleMT[[1]],
"&",
BetamiddleNL[[1]],
"&",
BetamiddlePT[[1]],
"&",
BetamiddleSI[[1]],
"&",
BetamiddleSK[[1]],
"  \\\\",

"\\multicolumn{2}{l}{$\\nabla$} ",

"&",
NablaAllBaseline[[1]],
"&",
NablaAT[[1]],
"&",
NablaBE[[1]],
"&",
NablaCY[[1]],
"&",
NablaDE[[1]],
"&",
NablaES[[1]],
"&",
NablaFI[[1]],
"&",
NablaFR[[1]],
"&",
NablaGR[[1]],
"&",
NablaIT[[1]],
"&",
NablaLU[[1]],
"&",
NablaMT[[1]],
"&",
NablaNL[[1]],
"&",
NablaPT[[1]],
"&",
NablaSI[[1]],
"&",
NablaSK[[1]],
"  \\\\",


bottomlines};

SetDirectory[TableDir];
Export["MPCallxc.tex", MPC, "text"];

SetDirectory[MPCxcTableDir];
Export["MPCallxc.tex", MPC, "text"];

