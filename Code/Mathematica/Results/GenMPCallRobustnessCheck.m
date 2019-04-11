SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* KS table directory *)
*)

MPCListDistSevenWithAggPermShock = Import["MPCListDistSevenWithAggPermShocks.txt","List"]; 
MPCListDistSevenWithAggPermShock = Round[100 MPCListDistSevenWithAggPermShock]/100//N;
MPCListDistSevenWithAggPermShockQ = 1 - (1-MPCListDistSevenWithAggPermShock)^(1/4); 
MPCListDistSevenWithAggPermShockTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockQ[[1]] - MPCListDistSevenWithAggPermShockQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockQ[[1]] - MPCListDistSevenWithAggPermShockQ[[13]]))^4)]/100 //N;

MPCAltListDistSevenWithAggPermShock = Import["MPCAltListDistSevenWithAggPermShocks.txt","List"]; 
MPCAltListDistSevenWithAggPermShock = Round[100 MPCAltListDistSevenWithAggPermShock]/100//N;
MPCAltListDistSevenWithAggPermShockTop50ByW   = Round[100 (2 MPCAltListDistSevenWithAggPermShock[[1]] - MPCAltListDistSevenWithAggPermShock[[7]])]/100 //N;
MPCAltListDistSevenWithAggPermShockTop50ByInc   = Round[100 (2 MPCAltListDistSevenWithAggPermShock[[1]] - MPCAltListDistSevenWithAggPermShock[[13]])]/100 //N;

MPCListDistSevenWithAggPermShockLiqFinPlsRet = Import["MPCListDistSevenWithAggPermShocksLiqFinPlsRet.txt","List"]; 
MPCListDistSevenWithAggPermShockLiqFinPlsRet = Round[100 MPCListDistSevenWithAggPermShockLiqFinPlsRet]/100//N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetQ = 1 - (1-MPCListDistSevenWithAggPermShockLiqFinPlsRet)^(1/4); 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[13]]))^4)]/100 //N;

MPCAltListDistSevenWithAggPermShockLiqFinPlsRet = Import["MPCAltListDistSevenWithAggPermShocksLiqFinPlsRet.txt","List"]; 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet = Round[100 MPCAltListDistSevenWithAggPermShockLiqFinPlsRet]/100//N;
MPCAltListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW   = Round[100 (2 MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[1]] - MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[7]])]/100 //N;
MPCAltListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc   = Round[100 (2 MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[1]] - MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[13]])]/100 //N;

toplines = "

\\begin{center}

\\begin{tabular}{ld{3}d{7}d{3}d{8}}

\\toprule

&                      \\multicolumn{4}{c}{Friedman/Buffer Stock (FBS)}       \\\\
&       \\multicolumn{4}{c}{Aggregate Process}   \\\\


Model  &   \\multicolumn{4}{c}{\\text{$\\Discount$-Dist}} \\\\
\\cmidrule(r){2-5} 

Wealth Measure  & \\multicolumn{2}{c}{Net} &  
\\multicolumn{2}{c}{Liquid Financial}\\\\

& \\multicolumn{2}{c}{Worth} &
\\multicolumn{2}{c}{and Retirement}\\\\

& \\multicolumn{2}{c}{} &
\\multicolumn{2}{c}{Assets}\\\\  

\\cmidrule(r){2-3}  \\cmidrule(r){4-5} 

Method of Calculating MPC & \\multicolumn{1}{c}{Theory$^{\\star}$}  & \\multicolumn{1}{c}{Simulation$^{*}$}  & \\multicolumn{1}{c}{Theory$^{\\star}$} & \\multicolumn{1}{c}{Simulation$^{*}$} \\\\ \\midrule

"; 

bottomlines = "

\\multicolumn{1}{l}{Time preference parameters${}^\\ddagger$}  & 	  &	  &		   &	 \\\\

\\multicolumn{1}{l}{$\\grave{\\Discount}$} & 

\\input ../Code/Mathematica/Results/Betamiddle.tex  &

\\input ../Code/Mathematica/Results/Betamiddle.tex &

\\input ../Code/Mathematica/Results/BetamiddleLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/BetamiddleLiqFinPlsRet.tex \\\\

\\multicolumn{1}{l}{$\\nabla$} & 

\\input ../Code/Mathematica/Results/Nabla.tex &

\\input ../Code/Mathematica/Results/Nabla.tex &

\\input ../Code/Mathematica/Results/NablaLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/NablaLiqFinPlsRet.tex

\\\\ \\bottomrule

\\end{tabular}

\\end{center}								";


MPC = {toplines, 

"\\multicolumn{1}{l}{Overall average} &",   
MPCListDistSevenWithAggPermShock[[1]],
"&", 
MPCAltListDistSevenWithAggPermShock[[1]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[1]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[1]],
"\\\\ \\hline",


"\\multicolumn{1}{l}{By wealth/permanent income ratio} & & & & ",
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &",  
MPCListDistSevenWithAggPermShock[[2]],
"&", 
MPCAltListDistSevenWithAggPermShock[[2]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[2]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[2]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListDistSevenWithAggPermShock[[3]],
"&", 
MPCAltListDistSevenWithAggPermShock[[3]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[3]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[3]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &",  
MPCListDistSevenWithAggPermShock[[4]],
"&", 
MPCAltListDistSevenWithAggPermShock[[4]],
"&", 

MPCListDistSevenWithAggPermShockLiqFinPlsRet[[4]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[4]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &",   
MPCListDistSevenWithAggPermShock[[5]],
"&", 
MPCAltListDistSevenWithAggPermShock[[5]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[5]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[5]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 50\\%} &",  
MPCListDistSevenWithAggPermShockTop50ByW,
"&", 
MPCAltListDistSevenWithAggPermShockTop50ByW,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW,
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &",   
MPCListDistSevenWithAggPermShock[[6]],
"&", 
MPCAltListDistSevenWithAggPermShock[[6]],
"&", 

MPCListDistSevenWithAggPermShockLiqFinPlsRet[[6]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[6]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 50\\%} &",  
MPCListDistSevenWithAggPermShock[[7]],
"&", 
MPCAltListDistSevenWithAggPermShock[[7]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[7]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[7]],
"\\\\ ",

"\\multicolumn{1}{l}{By income} & & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &", 
MPCListDistSevenWithAggPermShock[[8]],
"&", 
MPCAltListDistSevenWithAggPermShock[[8]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[8]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[8]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListDistSevenWithAggPermShock[[9]],
"&", 
MPCAltListDistSevenWithAggPermShock[[9]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[9]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[9]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &", 
MPCListDistSevenWithAggPermShock[[10]],
"&", 
MPCAltListDistSevenWithAggPermShock[[10]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[10]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[10]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &", 
MPCListDistSevenWithAggPermShock[[11]],
"&", 
MPCAltListDistSevenWithAggPermShock[[11]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[11]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[11]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 50\\%} &",  
MPCListDistSevenWithAggPermShockTop50ByInc,
"&", 
MPCAltListDistSevenWithAggPermShockTop50ByInc,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc,
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &", 
MPCListDistSevenWithAggPermShock[[12]],
"&", 
MPCAltListDistSevenWithAggPermShock[[12]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[12]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[12]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 50\\%} &", 
MPCListDistSevenWithAggPermShock[[13]],
"&", 
MPCAltListDistSevenWithAggPermShock[[13]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[13]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[13]],
"\\\\ ",

"\\multicolumn{1}{l}{By employment status} & & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Employed} &", 
MPCListDistSevenWithAggPermShock[[14]],
"&", 
MPCAltListDistSevenWithAggPermShock[[14]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[14]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[14]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Unemployed}  &", 
MPCListDistSevenWithAggPermShock[[15]],
"&", 
MPCAltListDistSevenWithAggPermShock[[15]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[15]],
"&", 
MPCAltListDistSevenWithAggPermShockLiqFinPlsRet[[15]],
"\\\\ \\midrule",

bottomlines};

SetDirectory[TableDir];
Export["MPCallRobustnessCheck.tex", MPC, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["MPCallRobustnessCheck.tex", MPC, "text"]; 
*)