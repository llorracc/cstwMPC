SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* KS table directory *)
*)

MPCListPointWithAggShock  = Import["MPCListPointWithAggShock.txt","List"]; 
MPCListPointWithAggShock  = Round[100 MPCListPointWithAggShock]/100//N;
MPCListPointWithAggShockQ = 1 - (1-MPCListPointWithAggShock)^(1/4); 
MPCListPointWithAggShockTop50ByW   = Round[100 (1 - (1 - (2 MPCListPointWithAggShockQ[[1]] - MPCListPointWithAggShockQ[[7]]))^4)]/100 //N;
MPCListPointWithAggShockTop50ByInc   = Round[100 (1 - (1 - (2 MPCListPointWithAggShockQ[[1]] - MPCListPointWithAggShockQ[[13]]))^4)]/100 //N;


MPCListDistSevenWithAggShock = Import["MPCListDistSevenWithAggShock.txt","List"]; 
MPCListDistSevenWithAggShock = Round[100 MPCListDistSevenWithAggShock]/100//N;
MPCListDistSevenWithAggShockQ = 1 - (1-MPCListDistSevenWithAggShock)^(1/4); 
MPCListDistSevenWithAggShockTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockQ[[1]] - MPCListDistSevenWithAggShockQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggShockTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockQ[[1]] - MPCListDistSevenWithAggShockQ[[13]]))^4)]/100 //N;

MPCListDistSevenWithAggShockLiqFinPlsRet = Import["MPCListDistSevenWithAggShockLiqFinPlsRet.txt","List"]; 
MPCListDistSevenWithAggShockLiqFinPlsRet = Round[100 MPCListDistSevenWithAggShockLiqFinPlsRet]/100//N;
MPCListDistSevenWithAggShockLiqFinPlsRetQ = 1 - (1-MPCListDistSevenWithAggShockLiqFinPlsRet)^(1/4); 
MPCListDistSevenWithAggShockLiqFinPlsRetTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggShockLiqFinPlsRetQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggShockLiqFinPlsRetQ[[13]]))^4)]/100 //N;


MPCListKSWithAggShock = Import["MPCListKSWithAggShock.txt","List"]; 
MPCListKSWithAggShock = Round[100 MPCListKSWithAggShock]/100//N;
MPCListKSWithAggShockQ = 1 - (1-MPCListKSWithAggShock)^(1/4); 
MPCListKSWithAggShockTop50ByW   = Round[100 (1 - (1 - (2 MPCListKSWithAggShockQ[[1]] - MPCListKSWithAggShockQ[[7]]))^4)]/100 //N;
MPCListKSWithAggShockTop50ByInc   = Round[100 (1 - (1 - (2 MPCListKSWithAggShockQ[[1]] - MPCListKSWithAggShockQ[[13]]))^4)]/100 //N;


MPCListKSHeteroWithAggShock = Import["MPCListKSHeteroWithAggShock.txt","List"]; 
MPCListKSHeteroWithAggShock = Round[100 MPCListKSHeteroWithAggShock]/100//N;
MPCListKSHeteroWithAggShockQ = 1 - (1-MPCListKSHeteroWithAggShock)^(1/4); 
MPCListKSHeteroWithAggShockTop50ByW   = Round[100 (1 - (1 - (2 MPCListKSHeteroWithAggShockQ[[1]] - MPCListKSHeteroWithAggShockQ[[7]]))^4)]/100 //N;
MPCListKSHeteroWithAggShockTop50ByInc   = Round[100 (1 - (1 - (2 MPCListKSHeteroWithAggShockQ[[1]] - MPCListKSHeteroWithAggShockQ[[13]]))^4)]/100 //N;

(*
MPCListDistSevenAltParamsWithAggShock = Import["MPCListDistSevenAltParamsWithAggShock.txt","List"]; 
MPCListDistSevenAltParamsWithAggShock = Round[100 MPCListDistSevenAltParamsWithAggShock]/100//N;
*)

MPCListDistSevenWithAggPermShock = Import["MPCListDistSevenWithAggPermShocks.txt","List"]; 
MPCListDistSevenWithAggPermShock = Round[100 MPCListDistSevenWithAggPermShock]/100//N;
MPCListDistSevenWithAggPermShockQ = 1 - (1-MPCListDistSevenWithAggPermShock)^(1/4); 
MPCListDistSevenWithAggPermShockTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockQ[[1]] - MPCListDistSevenWithAggPermShockQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockQ[[1]] - MPCListDistSevenWithAggPermShockQ[[13]]))^4)]/100 //N;


MPCListDistSevenWithAggPermShockLiqFinPlsRet = Import["MPCListDistSevenWithAggPermShocksLiqFinPlsRet.txt","List"]; 
MPCListDistSevenWithAggPermShockLiqFinPlsRet = Round[100 MPCListDistSevenWithAggPermShockLiqFinPlsRet]/100//N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetQ = 1 - (1-MPCListDistSevenWithAggPermShockLiqFinPlsRet)^(1/4); 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc   = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[13]]))^4)]/100 //N;


toplines = "
\\begin{center}

\\begin{tabular}{ld{5}d{5}d{3}d{3}d{7}d{3}d{8}}

\\toprule

&   \\multicolumn{5}{c}{\\text{Krusell--Smith (KS)}}  &                    \\multicolumn{2}{c}{Friedman/Buffer Stock (FBS)}       \\\\
&   \\multicolumn{5}{c}{\\text{Aggregate Process}}  &     \\multicolumn{2}{c}{Aggregate Process}   \\\\
\\cmidrule(r){2-6} \\cmidrule(r){7-8}

Model  & \\multicolumn{1}{c}{\\text{KS-JEDC}} & \\multicolumn{1}{c}{\\text{KS-Hetero}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Point}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}}  & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} \\\\

 & \\multicolumn{1}{c}{\\text{Our Solution}}  & \\multicolumn{1}{c}{\\text{Our Solution}} & & &  &  & \\\\

Wealth Measure & & & \\multicolumn{1}{c}{Net } &   \\multicolumn{1}{c}{Net}         &    \\multicolumn{1}{c}{Liquid Financial}  &  \\multicolumn{1}{c}{Net} &  \\multicolumn{1}{c}{Liquid Financial} \\\\

& & & \\multicolumn{1}{c}{Worth } &   \\multicolumn{1}{c}{Worth}         &    \\multicolumn{1}{c}{and Retirement}  & \\multicolumn{1}{c}{Worth} &  \\multicolumn{1}{c}{and Retirement} \\\\

& & & \\multicolumn{1}{c}{} &   \\multicolumn{1}{c}{}         &    \\multicolumn{1}{c}{Assets}  &  \\multicolumn{1}{c}{} &  \\multicolumn{1}{c}{Assets} \\\\   \\midrule

"; 

bottomlines = "
\\multicolumn{1}{l}{Time preference parameters${}^\\ddagger$} &	& & 	 & 	  &	  &		   &	 \\\\

\\multicolumn{1}{l}{$\\grave{\\Discount}$} & & &



\\input ../Code/Mathematica/Results/Beta.tex &

\\input ../Code/Mathematica/Results/BetamiddleWithAggShocks.tex &

\\input ../Code/Mathematica/Results/BetamiddleWithAggShocksLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/Betamiddle.tex &

\\input ../Code/Mathematica/Results/BetamiddleLiqFinPlsRet.tex \\\\

\\multicolumn{1}{l}{$\\nabla$} & & &

       &

\\input ../Code/Mathematica/Results/NablaWithAggShocks.tex &

\\input ../Code/Mathematica/Results/NablaWithAggShocksLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/Nabla.tex &

\\input ../Code/Mathematica/Results/NablaLiqFinPlsRet.tex

\\\\ \\bottomrule

\\end{tabular}

\\end{center}				";

MPC = {toplines, 

"\\multicolumn{1}{l}{Overall average} &",   
MPCListKSWithAggShock[[1]],
"&", 
MPCListKSHeteroWithAggShock[[1]],
"&", 
MPCListPointWithAggShock[[1]],
"&", 
MPCListDistSevenWithAggShock[[1]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[1]],
"&", 
MPCListDistSevenWithAggPermShock[[1]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[1]],
"\\\\ \\hline",


"\\multicolumn{1}{l}{By wealth/permanent income ratio} & & & & & & & ",
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &",  
MPCListKSWithAggShock[[2]],
"&",  
MPCListKSHeteroWithAggShock[[2]],
"&", 
MPCListPointWithAggShock[[2]],
"&", 
MPCListDistSevenWithAggShock[[2]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[2]],
"&", 
MPCListDistSevenWithAggPermShock[[2]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[2]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListKSWithAggShock[[3]],
"&",   
MPCListKSHeteroWithAggShock[[3]],
"&", 
MPCListPointWithAggShock[[3]],
"&", 
MPCListDistSevenWithAggShock[[3]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[3]],
"&", 
MPCListDistSevenWithAggPermShock[[3]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[3]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &",  
MPCListKSWithAggShock[[4]],
"&",  
MPCListKSHeteroWithAggShock[[4]],
"&", 
MPCListPointWithAggShock[[4]],
"&", 
MPCListDistSevenWithAggShock[[4]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[4]],
"&", 

MPCListDistSevenWithAggPermShock[[4]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[4]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &",   
MPCListKSWithAggShock[[5]],
"&", 
MPCListKSHeteroWithAggShock[[5]],
"&", 
MPCListPointWithAggShock[[5]],
"&", 
MPCListDistSevenWithAggShock[[5]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[5]],
"&", 
MPCListDistSevenWithAggPermShock[[5]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[5]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 50\\%} &",  
MPCListKSWithAggShockTop50ByW,
"&",  
MPCListKSHeteroWithAggShockTop50ByW,
"&",  
MPCListPointWithAggShockTop50ByW,
"&", 
MPCListDistSevenWithAggShockTop50ByW,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop50ByW,
"&", 
MPCListDistSevenWithAggPermShockTop50ByW,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &",   
MPCListKSWithAggShock[[6]],
"&", 
MPCListKSHeteroWithAggShock[[6]],
"&", 
MPCListPointWithAggShock[[6]],
"&", 
MPCListDistSevenWithAggShock[[6]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[6]],
"&", 

MPCListDistSevenWithAggPermShock[[6]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[6]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 50\\%} &",  
MPCListKSWithAggShock[[7]],
"&", 
MPCListKSHeteroWithAggShock[[7]],
"&", 
MPCListPointWithAggShock[[7]],
"&", 
MPCListDistSevenWithAggShock[[7]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[7]],
"&", 
MPCListDistSevenWithAggPermShock[[7]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[7]],
"\\\\ ",

"\\multicolumn{1}{l}{By income} & & & & & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &", 
MPCListKSWithAggShock[[8]],
"&", 
MPCListKSHeteroWithAggShock[[8]],
"&", 
MPCListPointWithAggShock[[8]],
"&", 
MPCListDistSevenWithAggShock[[8]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[8]],
"&", 
MPCListDistSevenWithAggPermShock[[8]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[8]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListKSWithAggShock[[9]],
"&", 
MPCListKSHeteroWithAggShock[[9]],
"&", 
MPCListPointWithAggShock[[9]],
"&", 
MPCListDistSevenWithAggShock[[9]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[9]],
"&", 
MPCListDistSevenWithAggPermShock[[9]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[9]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &", 
MPCListKSWithAggShock[[10]],
"&", 
MPCListKSHeteroWithAggShock[[10]],
"&", 
MPCListPointWithAggShock[[10]],
"&", 
MPCListDistSevenWithAggShock[[10]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[10]],
"&", 
MPCListDistSevenWithAggPermShock[[10]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[10]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40\\%} &", 
MPCListKSWithAggShock[[11]],
"&", 
MPCListKSHeteroWithAggShock[[11]],
"&", 
MPCListPointWithAggShock[[11]],
"&", 
MPCListDistSevenWithAggShock[[11]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[11]],
"&", 
MPCListDistSevenWithAggPermShock[[11]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[11]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 50\\%} &",  
MPCListKSWithAggShockTop50ByInc,
"&",  
MPCListKSHeteroWithAggShockTop50ByInc,
"&",  
MPCListPointWithAggShockTop50ByInc,
"&", 
MPCListDistSevenWithAggShockTop50ByInc,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop50ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop50ByInc,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60\\%} &", 
MPCListKSWithAggShock[[12]],
"&", 
MPCListKSHeteroWithAggShock[[12]],
"&", 
MPCListPointWithAggShock[[12]],
"&", 
MPCListDistSevenWithAggShock[[12]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[12]],
"&", 
MPCListDistSevenWithAggPermShock[[12]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[12]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 50\\%} &", 
MPCListKSWithAggShock[[13]],
"&", 
MPCListKSHeteroWithAggShock[[13]],
"&", 
MPCListPointWithAggShock[[13]],
"&", 
MPCListDistSevenWithAggShock[[13]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[13]],
"&", 
MPCListDistSevenWithAggPermShock[[13]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[13]],
"\\\\ ",

"\\multicolumn{1}{l}{By employment status} & & & & & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Employed} &", 
MPCListKSWithAggShock[[14]],
"&", 
MPCListKSHeteroWithAggShock[[14]],
"&", 
MPCListPointWithAggShock[[14]],
"&", 
MPCListDistSevenWithAggShock[[14]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[14]],
"&", 
MPCListDistSevenWithAggPermShock[[14]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[14]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Unemployed}  &", 
MPCListKSWithAggShock[[15]],
"&", 
MPCListKSHeteroWithAggShock[[15]],
"&", 
MPCListPointWithAggShock[[15]],
"&", 
MPCListDistSevenWithAggShock[[15]],
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRet[[15]],
"&", 
MPCListDistSevenWithAggPermShock[[15]],
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRet[[15]],
"\\\\ \\midrule",

bottomlines};

SetDirectory[TableDir];
Export["MPCall.tex", MPC, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["MPCall.tex", MPC, "text"]; 
*)