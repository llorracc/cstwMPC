SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsEuropeDir, SetDirectory[ResultsEuropeDir]];
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)
MPCxcTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPCxc\Latest\Tables"; (* MPC Europe directory directory *)

(* Import data *)

(* AllBaseline *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksAllBaseline.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline]/100//N;


BetamiddleLiqFinPlsRetAllBaseline = Round[1000 Import["BetamiddleLiqFinPlsRetAllBaseline.txt","List"]]/1000//N;
NablaLiqFinPlsRetAllBaseline      = Round[1000 3.5 Import["diffLiqFinPlsRetAllBaseline.txt","List"]]/1000//N;

(* AT *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksAT.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockATQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockAT)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockATTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockATQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockATQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockATTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockATQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockATQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockAT]/100//N;

BetamiddleLiqFinPlsRetAT = Round[1000 Import["BetamiddleLiqFinPlsRetAT.txt","List"]]/1000//N;
NablaLiqFinPlsRetAT      = Round[1000 3.5 Import["diffLiqFinPlsRetAT.txt","List"]]/1000//N;

(* BE *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksBE.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockBEQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockBE)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockBETop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockBEQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockBEQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockBETop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockBEQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockBEQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockBE]/100//N;

BetamiddleLiqFinPlsRetBE = Round[1000 Import["BetamiddleLiqFinPlsRetBE.txt","List"]]/1000//N;
NablaLiqFinPlsRetBE      = Round[1000 3.5 Import["diffLiqFinPlsRetBE.txt","List"]]/1000//N;

(* CY *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksCY.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockCYQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockCY)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockCYTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockCYQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockCYQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockCYTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockCYQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockCYQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockCY]/100//N;

BetamiddleLiqFinPlsRetCY = Round[1000 Import["BetamiddleLiqFinPlsRetCY.txt","List"]]/1000//N;
NablaLiqFinPlsRetCY      = Round[1000 3.5 Import["diffLiqFinPlsRetCY.txt","List"]]/1000//N;

(* DE *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksDE.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockDEQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockDE)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockDETop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockDEQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockDEQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockDETop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockDEQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockDEQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockDE]/100//N;

BetamiddleLiqFinPlsRetDE = Round[1000 Import["BetamiddleLiqFinPlsRetDE.txt","List"]]/1000//N;
NablaLiqFinPlsRetDE      = Round[1000 3.5 Import["diffLiqFinPlsRetDE.txt","List"]]/1000//N;

(* ES *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockES = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksES.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockESQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockES)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockESTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockESQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockESQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockESTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockESQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockESQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockES = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockES]/100//N;

BetamiddleLiqFinPlsRetES = Round[1000 Import["BetamiddleLiqFinPlsRetES.txt","List"]]/1000//N;
NablaLiqFinPlsRetES      = Round[1000 3.5 Import["diffLiqFinPlsRetES.txt","List"]]/1000//N;

(* FI *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksFI.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockFIQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockFI)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockFITop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockFIQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockFIQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockFITop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockFIQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockFIQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockFI]/100//N;

BetamiddleLiqFinPlsRetFI = Round[1000 Import["BetamiddleLiqFinPlsRetFI.txt","List"]]/1000//N;
NablaLiqFinPlsRetFI      = Round[1000 3.5 Import["diffLiqFinPlsRetFI.txt","List"]]/1000//N;

(* FR *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksFR.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockFRQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockFR)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockFRTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockFRQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockFRQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockFRTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockFRQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockFRQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockFR]/100//N;

BetamiddleLiqFinPlsRetFR = Round[1000 Import["BetamiddleLiqFinPlsRetFR.txt","List"]]/1000//N;
NablaLiqFinPlsRetFR      = Round[1000 3.5 Import["diffLiqFinPlsRetFR.txt","List"]]/1000//N;

(* GR *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksGR.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockGRQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockGR)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockGRTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockGRQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockGRQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockGRTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockGRQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockGRQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockGR]/100//N;

BetamiddleLiqFinPlsRetGR = Round[1000 Import["BetamiddleLiqFinPlsRetGR.txt","List"]]/1000//N;
NablaLiqFinPlsRetGR      = Round[1000 3.5 Import["diffLiqFinPlsRetGR.txt","List"]]/1000//N;

(* IT *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksIT.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockITQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockIT)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockITTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockITQ[[1]] -
MPCListDistSevenLiqFinPlsRetWithAggPermShockITQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockITTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockITQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockITQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockIT]/100//N;

BetamiddleLiqFinPlsRetIT = Round[1000 Import["BetamiddleLiqFinPlsRetIT.txt","List"]]/1000//N;
NablaLiqFinPlsRetIT      = Round[1000 3.5 Import["diffLiqFinPlsRetIT.txt","List"]]/1000//N;

(* LU *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksLU.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockLUQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockLU)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockLUTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockLUQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockLUQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockLUTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockLUQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockLUQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockLU]/100//N;

BetamiddleLiqFinPlsRetLU = Round[1000 Import["BetamiddleLiqFinPlsRetLU.txt","List"]]/1000//N;
NablaLiqFinPlsRetLU      = Round[1000 3.5 Import["diffLiqFinPlsRetLU.txt","List"]]/1000//N;

(* MT *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksMT.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockMTQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockMT)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockMTTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockMTQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockMTQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockMTTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockMTQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockMTQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockMT]/100//N;

BetamiddleLiqFinPlsRetMT = Round[1000 Import["BetamiddleLiqFinPlsRetMT.txt","List"]]/1000//N;
NablaLiqFinPlsRetMT      = Round[1000 3.5 Import["diffLiqFinPlsRetMT.txt","List"]]/1000//N;

(* NL *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksNL.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockNLQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockNL)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockNLTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockNLQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockNLQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockNLTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockNLQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockNLQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockNL]/100//N;

BetamiddleLiqFinPlsRetNL = Round[1000 Import["BetamiddleLiqFinPlsRetNL.txt","List"]]/1000//N;
NablaLiqFinPlsRetNL      = Round[1000 3.5 Import["diffLiqFinPlsRetNL.txt","List"]]/1000//N;

(* PT *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksPT.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockPTQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockPT)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockPTTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockPTQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockPTQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockPTTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockPTQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockPTQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockPT]/100//N;

BetamiddleLiqFinPlsRetPT = Round[1000 Import["BetamiddleLiqFinPlsRetPT.txt","List"]]/1000//N;
NablaLiqFinPlsRetPT      = Round[1000 3.5 Import["diffLiqFinPlsRetPT.txt","List"]]/1000//N;

(* SI *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksSI.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockSIQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockSI)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockSITop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockSIQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockSIQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockSITop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockSIQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockSIQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockSI]/100//N;

BetamiddleLiqFinPlsRetSI = Round[1000 Import["BetamiddleLiqFinPlsRetSI.txt","List"]]/1000//N;
NablaLiqFinPlsRetSI      = Round[1000 3.5 Import["diffLiqFinPlsRetSI.txt","List"]]/1000//N;

(* SK *)
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK = Import["MPCListDistSevenLiqFinPlsRetWithAggPermShocksSK.txt","List"];
MPCListDistSevenLiqFinPlsRetWithAggPermShockSKQ = 1 - (1-MPCListDistSevenLiqFinPlsRetWithAggPermShockSK)^(1/4);
MPCListDistSevenLiqFinPlsRetWithAggPermShockSKTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockSKQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockSKQ[[7]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockSKTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenLiqFinPlsRetWithAggPermShockSKQ[[1]] -

MPCListDistSevenLiqFinPlsRetWithAggPermShockSKQ[[13]]))^4)]/100 //N;
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK = Round[100 MPCListDistSevenLiqFinPlsRetWithAggPermShockSK]/100//N;

BetamiddleLiqFinPlsRetSK = Round[1000 Import["BetamiddleLiqFinPlsRetSK.txt","List"]]/1000//N;
NablaLiqFinPlsRetSK      = Round[1000 3.5 Import["diffLiqFinPlsRetSK.txt","List"]]/1000//N;



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
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[1]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[1]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[1]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[1]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[1]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[1]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[1]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[1]],
 " \\\\ ",
"\\multicolumn{10}{l}{By wealth-to-permanent income ratio} &",
"\\\\",

"& $\\text{Top 1\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[2]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[2]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[2]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[2]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[2]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[2]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[2]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[2]],
"\\\\",

"& $\\text{Top 10\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[3]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[3]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[3]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[3]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[3]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[3]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[3]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[3]],
"\\\\",

"& $\\text{Top 20\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[4]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[4]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[4]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[4]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[4]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[4]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[4]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[4]],
"\\\\",

"& $\\text{Top 40\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[5]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[5]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[5]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[5]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[5]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[5]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[5]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[5]],
"\\\\",

"& $\\text{Top 50\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineTop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockATTop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBETop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCYTop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDETop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockESTop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFITop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFRTop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGRTop50ByW,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockITTop50ByW,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLUTop50ByW,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMTTop50ByW,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNLTop50ByW,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPTTop50ByW,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSITop50ByW,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSKTop50ByW,
"\\\\",

"& $\\text{Top 60\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[6]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[6]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[6]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[6]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[6]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[6]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[6]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[6]],
"\\\\",

"& $\\text{Bottm 50\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[7]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[7]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[7]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[7]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[7]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[7]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[7]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[7]],
"\\\\",

"\\multicolumn{10}{l}{$\\text{By income}$}  \\\\",

"& $\\text{Top 1\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[8]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[8]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[8]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[8]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[8]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[8]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[8]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[8]],
"\\\\",

"& $\\text{Top 10\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[9]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[9]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[9]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[9]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[9]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[9]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[9]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[9]],
"\\\\",

"& $\\text{Top 20\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[10]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[10]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[10]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[10]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[10]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[10]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[10]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[10]],
"\\\\",

"& $\\text{Top 40\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[11]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[11]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[11]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[11]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[11]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[11]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[11]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[11]],
"\\\\",



"& $\\text{Top 50\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaselineTop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockATTop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBETop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCYTop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDETop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockESTop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFITop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFRTop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGRTop50ByInc,
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockITTop50ByInc,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLUTop50ByInc,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMTTop50ByInc,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNLTop50ByInc,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPTTop50ByInc,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSITop50ByInc,
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSKTop50ByInc,
"\\\\",

"& $\\text{Top 60\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[12]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[12]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[12]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[12]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[12]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[12]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[12]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[12]],
"\\\\",

"& $\\text{Bottm 50\\%}$ &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[13]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[13]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[13]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[13]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[13]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[13]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[13]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[13]],
"\\\\",

"\\multicolumn{10}{l}{$\\text{By employment status}$}   \\\\",

"& Employed &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[14]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[14]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[14]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[14]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[14]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[14]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[14]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[14]],
"\\\\",

"& Unempl &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAllBaseline[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockAT[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockBE[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockCY[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockDE[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockES[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFI[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockFR[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockGR[[15]],
"&",
MPCListDistSevenLiqFinPlsRetWithAggPermShockIT[[15]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockLU[[15]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockMT[[15]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockNL[[15]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockPT[[15]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSI[[15]],
"  &",
MPCListDistSevenLiqFinPlsRetWithAggPermShockSK[[15]],
"\\\\",

"\\midrule",

"\\multicolumn{10}{l}{Time preference parameters${}^\\ddagger$}   \\\\",

"\\multicolumn{2}{l}{$\\grave{\\Discount}$} ",

"&",
BetamiddleLiqFinPlsRetAllBaseline[[1]],
"&",
BetamiddleLiqFinPlsRetAT[[1]],
"&",
BetamiddleLiqFinPlsRetBE[[1]],
"&",
BetamiddleLiqFinPlsRetCY[[1]],
"&",
BetamiddleLiqFinPlsRetDE[[1]],
"&",
BetamiddleLiqFinPlsRetES[[1]],
"&",
BetamiddleLiqFinPlsRetFI[[1]],
"&",
BetamiddleLiqFinPlsRetFR[[1]],
"&",
BetamiddleLiqFinPlsRetGR[[1]],
"&",
BetamiddleLiqFinPlsRetIT[[1]],
"&",
BetamiddleLiqFinPlsRetLU[[1]],
"&",
BetamiddleLiqFinPlsRetMT[[1]],
"&",
BetamiddleLiqFinPlsRetNL[[1]],
"&",
BetamiddleLiqFinPlsRetPT[[1]],
"&",
BetamiddleLiqFinPlsRetSI[[1]],
"&",
BetamiddleLiqFinPlsRetSK[[1]],
"  \\\\",

"\\multicolumn{2}{l}{$\\nabla$} ",

"&",
NablaLiqFinPlsRetAllBaseline[[1]],
"&",
NablaLiqFinPlsRetAT[[1]],
"&",
NablaLiqFinPlsRetBE[[1]],
"&",
NablaLiqFinPlsRetCY[[1]],
"&",
NablaLiqFinPlsRetDE[[1]],
"&",
NablaLiqFinPlsRetES[[1]],
"&",
NablaLiqFinPlsRetFI[[1]],
"&",
NablaLiqFinPlsRetFR[[1]],
"&",
NablaLiqFinPlsRetGR[[1]],
"&",
NablaLiqFinPlsRetIT[[1]],
"&",
NablaLiqFinPlsRetLU[[1]],
"&",
NablaLiqFinPlsRetMT[[1]],
"&",
NablaLiqFinPlsRetNL[[1]],
"&",
NablaLiqFinPlsRetPT[[1]],
"&",
NablaLiqFinPlsRetSI[[1]],
"&",
NablaLiqFinPlsRetSK[[1]],
"  \\\\",


bottomlines};

SetDirectory[TableDir];
Export["MPCallLiqFinPlsRetxc.tex", MPC, "text"];

SetDirectory[MPCxcTableDir];
Export["MPCallLiqFinPlsRetxc.tex", MPC, "text"];

