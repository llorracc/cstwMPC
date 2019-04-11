SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsEuropeDir, SetDirectory[ResultsEuropeDir]];
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)
MPCxcTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPCxc\Latest\Tables"; (* MPC Europe directory directory *)

(* Import data *)

(* AllBaseline *)
MPCListDistSevenWithAggPermShockAllBaseline = Import["MPCListDistSevenWithAggPermShocksAllBaseline.txt","List"];
MPCListDistSevenWithAggPermShockAllBaseline = Round[100 MPCListDistSevenWithAggPermShockAllBaseline]/100//N;
MPCListDistSevenWithAggPermShockAllBaselineQ = 1 - (1-MPCListDistSevenWithAggPermShockAllBaseline)^(1/4);
MPCListDistSevenWithAggPermShockAllBaselineTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllBaselineQ[[1]] -

MPCListDistSevenWithAggPermShockAllBaselineQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAllBaselineTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllBaselineQ[[1]] -

MPCListDistSevenWithAggPermShockAllBaselineQ[[13]]))^4)]/100 //N;

BetamiddleAllBaseline = Round[1000 Import["BetamiddleAllBaseline.txt","List"]]/1000//N;
NablaAllBaseline      = Round[1000 3.5 Import["diffAllBaseline.txt","List"]]/1000//N;

(* AllLowPsi *)
MPCListDistSevenWithAggPermShockAllLowPsi = Import["MPCListDistSevenWithAggPermShocksAllLowPsi.txt","List"];
MPCListDistSevenWithAggPermShockAllLowPsi = Round[100 MPCListDistSevenWithAggPermShockAllLowPsi]/100//N;
MPCListDistSevenWithAggPermShockAllLowPsiQ = 1 - (1-MPCListDistSevenWithAggPermShockAllLowPsi)^(1/4);
MPCListDistSevenWithAggPermShockAllLowPsiTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllLowPsiQ[[1]] -

MPCListDistSevenWithAggPermShockAllLowPsiQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAllLowPsiTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllLowPsiQ[[1]] -

MPCListDistSevenWithAggPermShockAllLowPsiQ[[13]]))^4)]/100 //N;

BetamiddleAllLowPsi = Round[1000 Import["BetamiddleAllLowPsi.txt","List"]]/1000//N;
NablaAllLowPsi      = Round[1000 3.5 Import["diffAllLowPsi.txt","List"]]/1000//N;

(* AllHighTheta *)
MPCListDistSevenWithAggPermShockAllHighTheta = Import["MPCListDistSevenWithAggPermShocksAllHighTheta.txt","List"];
MPCListDistSevenWithAggPermShockAllHighTheta = Round[100 MPCListDistSevenWithAggPermShockAllHighTheta]/100//N;
MPCListDistSevenWithAggPermShockAllHighThetaQ = 1 - (1-MPCListDistSevenWithAggPermShockAllHighTheta)^(1/4);
MPCListDistSevenWithAggPermShockAllHighThetaTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllHighThetaQ[[1]] -

MPCListDistSevenWithAggPermShockAllHighThetaQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAllHighThetaTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllHighThetaQ[[1]] -

MPCListDistSevenWithAggPermShockAllHighThetaQ[[13]]))^4)]/100 //N;

BetamiddleAllHighTheta = Round[1000 Import["BetamiddleAllHighTheta.txt","List"]]/1000//N;
NablaAllHighTheta      = Round[1000 3.5 Import["diffAllHighTheta.txt","List"]]/1000//N;

(* AllVeryHighTheta *)
MPCListDistSevenWithAggPermShockAllVeryHighTheta = Import["MPCListDistSevenWithAggPermShocksAllVeryHighTheta.txt","List"];
MPCListDistSevenWithAggPermShockAllVeryHighTheta = Round[100 MPCListDistSevenWithAggPermShockAllVeryHighTheta]/100//N;
MPCListDistSevenWithAggPermShockAllVeryHighThetaQ = 1 - (1-MPCListDistSevenWithAggPermShockAllVeryHighTheta)^(1/4);
MPCListDistSevenWithAggPermShockAllVeryHighThetaTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllVeryHighThetaQ[[1]] -

MPCListDistSevenWithAggPermShockAllVeryHighThetaQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockAllVeryHighThetaTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockAllVeryHighThetaQ[[1]] -

MPCListDistSevenWithAggPermShockAllVeryHighThetaQ[[13]]))^4)]/100 //N;

BetamiddleAllVeryHighTheta = Round[1000 Import["BetamiddleAllVeryHighTheta.txt","List"]]/1000//N;
NablaAllVeryHighTheta      = Round[1000 3.5 Import["diffAllVeryHighTheta.txt","List"]]/1000//N;

(* DE *)
MPCListDistSevenWithAggPermShockDE = Import["MPCListDistSevenWithAggPermShocksDE.txt","List"];
MPCListDistSevenWithAggPermShockDE = Round[100 MPCListDistSevenWithAggPermShockDE]/100//N;
MPCListDistSevenWithAggPermShockDEQ = 1 - (1-MPCListDistSevenWithAggPermShockDE)^(1/4);
MPCListDistSevenWithAggPermShockDETop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockDEQ[[1]] -

MPCListDistSevenWithAggPermShockDEQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockDETop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockDEQ[[1]] -

MPCListDistSevenWithAggPermShockDEQ[[13]]))^4)]/100 //N;

BetamiddleDE = Round[1000 Import["BetamiddleDE.txt","List"]]/1000//N;
NablaDE      = Round[1000 3.5 Import["diffDE.txt","List"]]/1000//N;

(* ES *)
MPCListDistSevenWithAggPermShockES = Import["MPCListDistSevenWithAggPermShocksES.txt","List"];
MPCListDistSevenWithAggPermShockES = Round[100 MPCListDistSevenWithAggPermShockES]/100//N;
MPCListDistSevenWithAggPermShockESQ = 1 - (1-MPCListDistSevenWithAggPermShockES)^(1/4);
MPCListDistSevenWithAggPermShockESTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockESQ[[1]] -

MPCListDistSevenWithAggPermShockESQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockESTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockESQ[[1]] -

MPCListDistSevenWithAggPermShockESQ[[13]]))^4)]/100 //N;

BetamiddleES = Round[1000 Import["BetamiddleES.txt","List"]]/1000//N;
NablaES      = Round[1000 3.5 Import["diffES.txt","List"]]/1000//N;

(* FI *)
MPCListDistSevenWithAggPermShockFI = Import["MPCListDistSevenWithAggPermShocksFI.txt","List"];
MPCListDistSevenWithAggPermShockFI = Round[100 MPCListDistSevenWithAggPermShockFI]/100//N;
MPCListDistSevenWithAggPermShockFIQ = 1 - (1-MPCListDistSevenWithAggPermShockFI)^(1/4);
MPCListDistSevenWithAggPermShockFITop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFIQ[[1]] -

MPCListDistSevenWithAggPermShockFIQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockFITop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFIQ[[1]] -

MPCListDistSevenWithAggPermShockFIQ[[13]]))^4)]/100 //N;

BetamiddleFI = Round[1000 Import["BetamiddleFI.txt","List"]]/1000//N;
NablaFI      = Round[1000 3.5 Import["diffFI.txt","List"]]/1000//N;

(* FR *)
MPCListDistSevenWithAggPermShockFR = Import["MPCListDistSevenWithAggPermShocksFR.txt","List"];
MPCListDistSevenWithAggPermShockFR = Round[100 MPCListDistSevenWithAggPermShockFR]/100//N;
MPCListDistSevenWithAggPermShockFRQ = 1 - (1-MPCListDistSevenWithAggPermShockFR)^(1/4);
MPCListDistSevenWithAggPermShockFRTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFRQ[[1]] -

MPCListDistSevenWithAggPermShockFRQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockFRTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockFRQ[[1]] -

MPCListDistSevenWithAggPermShockFRQ[[13]]))^4)]/100 //N;

BetamiddleFR = Round[1000 Import["BetamiddleFR.txt","List"]]/1000//N;
NablaFR      = Round[1000 3.5 Import["diffFR.txt","List"]]/1000//N;

(* GR *)
MPCListDistSevenWithAggPermShockGR = Import["MPCListDistSevenWithAggPermShocksGR.txt","List"];
MPCListDistSevenWithAggPermShockGR = Round[100 MPCListDistSevenWithAggPermShockGR]/100//N;
MPCListDistSevenWithAggPermShockGRQ = 1 - (1-MPCListDistSevenWithAggPermShockGR)^(1/4);
MPCListDistSevenWithAggPermShockGRTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockGRQ[[1]] -

MPCListDistSevenWithAggPermShockGRQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockGRTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockGRQ[[1]] -

MPCListDistSevenWithAggPermShockGRQ[[13]]))^4)]/100 //N;

BetamiddleGR = Round[1000 Import["BetamiddleGR.txt","List"]]/1000//N;
NablaGR      = Round[1000 3.5 Import["diffGR.txt","List"]]/1000//N;

(* IT *)
MPCListDistSevenWithAggPermShockIT = Import["MPCListDistSevenWithAggPermShocksIT.txt","List"];
MPCListDistSevenWithAggPermShockIT = Round[100 MPCListDistSevenWithAggPermShockIT]/100//N;
MPCListDistSevenWithAggPermShockITQ = 1 - (1-MPCListDistSevenWithAggPermShockIT)^(1/4);
MPCListDistSevenWithAggPermShockITTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockITQ[[1]] -

MPCListDistSevenWithAggPermShockITQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockITTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockITQ[[1]] -

MPCListDistSevenWithAggPermShockITQ[[13]]))^4)]/100 //N;

BetamiddleIT = Round[1000 Import["BetamiddleIT.txt","List"]]/1000//N;
NablaIT      = Round[1000 3.5 Import["diffIT.txt","List"]]/1000//N;

(* LU *)
MPCListDistSevenWithAggPermShockLU = Import["MPCListDistSevenWithAggPermShocksLU.txt","List"];
MPCListDistSevenWithAggPermShockLU = Round[100 MPCListDistSevenWithAggPermShockLU]/100//N;
MPCListDistSevenWithAggPermShockLUQ = 1 - (1-MPCListDistSevenWithAggPermShockLU)^(1/4);
MPCListDistSevenWithAggPermShockLUTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLUQ[[1]] -

MPCListDistSevenWithAggPermShockLUQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLUTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLUQ[[1]] -

MPCListDistSevenWithAggPermShockLUQ[[13]]))^4)]/100 //N;

BetamiddleLU = Round[1000 Import["BetamiddleLU.txt","List"]]/1000//N;
NablaLU      = Round[1000 3.5 Import["diffLU.txt","List"]]/1000//N;

(* MT *)
MPCListDistSevenWithAggPermShockMT = Import["MPCListDistSevenWithAggPermShocksMT.txt","List"];
MPCListDistSevenWithAggPermShockMT = Round[100 MPCListDistSevenWithAggPermShockMT]/100//N;
MPCListDistSevenWithAggPermShockMTQ = 1 - (1-MPCListDistSevenWithAggPermShockMT)^(1/4);
MPCListDistSevenWithAggPermShockMTTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockMTQ[[1]] -

MPCListDistSevenWithAggPermShockMTQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockMTTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockMTQ[[1]] -

MPCListDistSevenWithAggPermShockMTQ[[13]]))^4)]/100 //N;

BetamiddleMT = Round[1000 Import["BetamiddleMT.txt","List"]]/1000//N;
NablaMT      = Round[1000 3.5 Import["diffMT.txt","List"]]/1000//N;

(* NL *)
MPCListDistSevenWithAggPermShockNL = Import["MPCListDistSevenWithAggPermShocksNL.txt","List"];
MPCListDistSevenWithAggPermShockNL = Round[100 MPCListDistSevenWithAggPermShockNL]/100//N;
MPCListDistSevenWithAggPermShockNLQ = 1 - (1-MPCListDistSevenWithAggPermShockNL)^(1/4);
MPCListDistSevenWithAggPermShockNLTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockNLQ[[1]] -

MPCListDistSevenWithAggPermShockNLQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockNLTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockNLQ[[1]] -

MPCListDistSevenWithAggPermShockNLQ[[13]]))^4)]/100 //N;

BetamiddleNL = Round[1000 Import["BetamiddleNL.txt","List"]]/1000//N;
NablaNL      = Round[1000 3.5 Import["diffNL.txt","List"]]/1000//N;

(* PT *)
MPCListDistSevenWithAggPermShockPT = Import["MPCListDistSevenWithAggPermShocksPT.txt","List"];
MPCListDistSevenWithAggPermShockPT = Round[100 MPCListDistSevenWithAggPermShockPT]/100//N;
MPCListDistSevenWithAggPermShockPTQ = 1 - (1-MPCListDistSevenWithAggPermShockPT)^(1/4);
MPCListDistSevenWithAggPermShockPTTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockPTQ[[1]] -

MPCListDistSevenWithAggPermShockPTQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockPTTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockPTQ[[1]] -

MPCListDistSevenWithAggPermShockPTQ[[13]]))^4)]/100 //N;

BetamiddlePT = Round[1000 Import["BetamiddlePT.txt","List"]]/1000//N;
NablaPT      = Round[1000 3.5 Import["diffPT.txt","List"]]/1000//N;

(* SI *)
MPCListDistSevenWithAggPermShockSI = Import["MPCListDistSevenWithAggPermShocksSI.txt","List"];
MPCListDistSevenWithAggPermShockSI = Round[100 MPCListDistSevenWithAggPermShockSI]/100//N;
MPCListDistSevenWithAggPermShockSIQ = 1 - (1-MPCListDistSevenWithAggPermShockSI)^(1/4);
MPCListDistSevenWithAggPermShockSITop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSIQ[[1]] -

MPCListDistSevenWithAggPermShockSIQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockSITop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSIQ[[1]] -

MPCListDistSevenWithAggPermShockSIQ[[13]]))^4)]/100 //N;

BetamiddleSI = Round[1000 Import["BetamiddleSI.txt","List"]]/1000//N;
NablaSI      = Round[1000 3.5 Import["diffSI.txt","List"]]/1000//N;

(* SK *)
MPCListDistSevenWithAggPermShockSK = Import["MPCListDistSevenWithAggPermShocksSK.txt","List"];
MPCListDistSevenWithAggPermShockSK = Round[100 MPCListDistSevenWithAggPermShockSK]/100//N;
MPCListDistSevenWithAggPermShockSKQ = 1 - (1-MPCListDistSevenWithAggPermShockSK)^(1/4);
MPCListDistSevenWithAggPermShockSKTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSKQ[[1]] -

MPCListDistSevenWithAggPermShockSKQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockSKTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockSKQ[[1]] -

MPCListDistSevenWithAggPermShockSKQ[[13]]))^4)]/100 //N;

BetamiddleSK = Round[1000 Import["BetamiddleSK.txt","List"]]/1000//N;
NablaSK      = Round[1000 3.5 Import["diffSK.txt","List"]]/1000//N;



toplines = "
\\begin{center}\\tiny

\\begin{tabular}{lllll}
\\toprule
&  & Baseline  & High $\\sigma^2_\\theta$ &  Very High $\\sigma^2_\\theta$
\\\\
&  & $\\sigma^2_\\psi$, $\\sigma^2_\\theta=0.01$ & $\\sigma^2_\\theta=0.05$ & $\\sigma^2_\\theta=0.10$
\\\\ \\midrule

";

bottomlines = "
\\bottomrule
\\end{tabular}%

\\end{center}				";

MPC = {toplines,

"\\multicolumn{2}{l}{$\\text{Overall Average}$} &",
MPCListDistSevenWithAggPermShockAllBaseline[[1]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[1]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[1]],
 " \\\\ ",
"\\multicolumn{2}{l}{By wealth-to-permanent income ratio} & & & ",
"\\\\",

"& $\\text{Top 1\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[2]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[2]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[2]],
"\\\\",

"& $\\text{Top 10\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[3]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[3]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[3]],
"\\\\",

"& $\\text{Top 20\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[4]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[4]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[4]],
"\\\\",

"& $\\text{Top 40\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[5]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[5]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[5]],
"\\\\",

"& $\\text{Top 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaselineTop50ByW,
"&",
MPCListDistSevenWithAggPermShockAllHighThetaTop50ByW,
"&",
MPCListDistSevenWithAggPermShockAllVeryHighThetaTop50ByW,
"\\\\",

"& $\\text{Top 60\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[6]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[6]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[6]],
"\\\\",

"& $\\text{Bottom 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[7]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[7]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[7]],
"\\\\",

"\\multicolumn{4}{l}{$\\text{By income}$}  \\\\",

"& $\\text{Top 1\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[8]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[8]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[8]],
"\\\\",

"& $\\text{Top 10\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[9]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[9]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[9]],
"\\\\",

"& $\\text{Top 20\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[10]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[10]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[10]],
"\\\\",

"& $\\text{Top 40\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[11]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[11]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[11]],
"\\\\",



"& $\\text{Top 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaselineTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockAllHighThetaTop50ByInc,
"&",
MPCListDistSevenWithAggPermShockAllVeryHighThetaTop50ByInc,
"\\\\",

"& $\\text{Top 60\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[12]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[12]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[12]],
"\\\\",

"& $\\text{Bottom 50\\%}$ &",
MPCListDistSevenWithAggPermShockAllBaseline[[13]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[13]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[13]],
"\\\\",

"\\multicolumn{4}{l}{$\\text{By employment status}$}    \\\\",

"& Employed &",
MPCListDistSevenWithAggPermShockAllBaseline[[14]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[14]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[14]],
"\\\\",

"& Unemployed &",
MPCListDistSevenWithAggPermShockAllBaseline[[15]],
"&",
MPCListDistSevenWithAggPermShockAllHighTheta[[15]],
"&",
MPCListDistSevenWithAggPermShockAllVeryHighTheta[[15]],
"\\\\",

"\\hline",

"\\multicolumn{4}{l}{Time preference parameters${}^\\ddagger$}   \\\\",

"$\\grave{\\Discount}$&",

"&",
BetamiddleAllBaseline[[1]],
"&",
BetamiddleAllHighTheta[[1]],
"&",
BetamiddleAllVeryHighTheta[[1]],
"  \\\\",

"$\\nabla$            &",

"&",
NablaAllBaseline[[1]],
"&",
NablaAllHighTheta[[1]],
"&",
NablaAllVeryHighTheta[[1]],
"  \\\\",


bottomlines};

SetDirectory[TableDir];
Export["MPCAltParamsxc_slides.tex", MPC, "text"];

SetDirectory[MPCxcTableDir];
Export["MPCAltParamsxc_slides.tex", MPC, "text"];

