SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* KS table directory *)
*)

MPCListDistSevenWithAggPermShockLiqFinPlsRet = Import["MPCListDistSevenWithAggPermShocksLiqFinPlsRet.txt","List"]; 
MPCListDistSevenWithAggPermShockLiqFinPlsRet = Round[100 MPCListDistSevenWithAggPermShockLiqFinPlsRet]/100//N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetQ = 1 - (1-MPCListDistSevenWithAggPermShockLiqFinPlsRet)^(1/4); 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[13]]))^4)]/100 //N;

MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge = Import["MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge.txt","List"]; 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge = Round[100 MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge]/100//N;
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAgeTop50ByW   = Round[100 (2 MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[1]] - MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[7]])]/100 //N;
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAgeTop50ByInc   = Round[100 (2 MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[1]] - MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[13]])]/100 //N;

toplines = "

\\begin{center}

\\begin{tabular}{ld{3}d{8}}

\\toprule



Aggregate Process &                      \\multicolumn{2}{c}{Friedman/Buffer Stock (FBS)}       \\\\

Model  &   \\multicolumn{2}{c}{\\text{$\\Discount$-Dist}} \\\\

Wealth Measure  & \\multicolumn{2}{c}{Liquid Financial}\\\\

& \\multicolumn{2}{c}{and Retirement Assets}\\\\

\\cmidrule(r){2-3}  

 & \\multicolumn{1}{c}{Baseline} & \\multicolumn{1}{c}{Death at age 100} \\\\ \\midrule

"; 

bottomlines = "


\\multicolumn{1}{l}{Time preference parameters${}^\\ddagger$}  & 	  &	  	 \\\\

\\multicolumn{1}{l}{$\\grave{\\Discount}$} &

\\input ../Code/Mathematica/Results/BetamiddleLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/BetamiddleLiqFinPlsRetDeathFrAge.tex \\\\

\\multicolumn{1}{l}{$\\nabla$} &

\\input ../Code/Mathematica/Results/NablaLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/NablaLiqFinPlsRetDeathFrAge.tex

\\\\ \\bottomrule

\\end{tabular}

\\end{center}								
	";

MPC = {toplines, 

"\\multicolumn{1}{l}{Overall average} &",   
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[1]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[1]],
"\\\\ \\hline",

"\\multicolumn{1}{l}{By wealth/permanent income ratio} & &  ",
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &",  
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[2]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[2]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[3]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[3]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &",  
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[4]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[4]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &",   
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[5]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[5]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 50\\%} &",  
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW,
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAgeTop50ByW,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &",   
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[6]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[6]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 50\\%} &",  
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[7]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[7]],
"\\\\ ",

"\\multicolumn{1}{l}{By income} & &  ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[8]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[8]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[9]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[9]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[10]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[10]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[11]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[11]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 50\\%} &",  
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc,
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAgeTop50ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[12]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[12]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 50\\%} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[13]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[13]],
"\\\\ ",

"\\multicolumn{1}{l}{By employment status} & &  ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Employed} &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[14]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[14]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Unemployed}  &", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[15]],
"&", 
MPCListDistSevenWithAggPermShocksLiqFinPlsRetDeathFrAge[[15]],
"\\\\ \\midrule",

bottomlines};

SetDirectory[TableDir];
Export["MPCallDeathFromAge.tex", MPC, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["MPCallDeathFromAge.tex", MPC, "text"];
*) 