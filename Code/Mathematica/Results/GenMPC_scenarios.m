SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* MPC table directory *)
*)


MPCListDistSevenWithAggShock = Import["MPCListDistSevenWithAggShock.txt","List"]; 
MPCListDistSevenWithAggShockQ = 1 - (1-MPCListDistSevenWithAggShock)^(1/4); 
MPCListDistSevenWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockQ[[1]] - MPCListDistSevenWithAggShockQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockQ[[1]] - MPCListDistSevenWithAggShockQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListDistSevenWithAggShockQ[[5]] - 20 MPCListDistSevenWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListDistSevenWithAggShockQ[[6]] - 40 MPCListDistSevenWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListDistSevenWithAggShockQ[[1]] - 60 MPCListDistSevenWithAggShockQ[[6]] - 20 MPCListDistSevenWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListDistSevenWithAggShockQ[[11]] - 20 MPCListDistSevenWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListDistSevenWithAggShockQ[[12]] - 40 MPCListDistSevenWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListDistSevenWithAggShockQ[[1]] - 60 MPCListDistSevenWithAggShockQ[[12]] - 20 MPCListDistSevenWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShock = Round[100 MPCListDistSevenWithAggShock]/100//N;
MPCListDistSevenWithAggShockBottom20ByW = MPCListDistSevenWithAggShock[[16]];
MPCListDistSevenWithAggShockBottom20ByInc = MPCListDistSevenWithAggShock[[17]];


MPCListRecessionDistSevenWithAggShock = Import["MPCListRecessionDistSevenWithAggShock.txt","List"]; 
MPCListRecessionDistSevenWithAggShockQ = 1 - (1-MPCListRecessionDistSevenWithAggShock)^(1/4); 
MPCListRecessionDistSevenWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListRecessionDistSevenWithAggShockQ[[1]] - MPCListRecessionDistSevenWithAggShockQ[[7]]))^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListRecessionDistSevenWithAggShockQ[[1]] - MPCListRecessionDistSevenWithAggShockQ[[13]]))^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListRecessionDistSevenWithAggShockQ[[5]] - 20 MPCListRecessionDistSevenWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListRecessionDistSevenWithAggShockQ[[6]] - 40 MPCListRecessionDistSevenWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListRecessionDistSevenWithAggShockQ[[1]] - 60 MPCListRecessionDistSevenWithAggShockQ[[6]] - 20 MPCListRecessionDistSevenWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListRecessionDistSevenWithAggShockQ[[11]] - 20 MPCListRecessionDistSevenWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListRecessionDistSevenWithAggShockQ[[12]] - 40 MPCListRecessionDistSevenWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListRecessionDistSevenWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListRecessionDistSevenWithAggShockQ[[1]] - 60 MPCListRecessionDistSevenWithAggShockQ[[12]] - 20 MPCListRecessionDistSevenWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListRecessionDistSevenWithAggShock = Round[100 MPCListRecessionDistSevenWithAggShock]/100//N;
MPCListRecessionDistSevenWithAggShockBottom20ByW = MPCListRecessionDistSevenWithAggShock[[16]];
MPCListRecessionDistSevenWithAggShockBottom20ByInc = MPCListRecessionDistSevenWithAggShock[[17]];

MPCListExpansionDistSevenWithAggShock = Import["MPCListExpansionDistSevenWithAggShock.txt","List"]; 

MPCListExpansionDistSevenWithAggShockQ = 1 - (1-MPCListExpansionDistSevenWithAggShock)^(1/4); 
MPCListExpansionDistSevenWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListExpansionDistSevenWithAggShockQ[[1]] - MPCListExpansionDistSevenWithAggShockQ[[7]]))^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListExpansionDistSevenWithAggShockQ[[1]] - MPCListExpansionDistSevenWithAggShockQ[[13]]))^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListExpansionDistSevenWithAggShockQ[[5]] - 20 MPCListExpansionDistSevenWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListExpansionDistSevenWithAggShockQ[[6]] - 40 MPCListExpansionDistSevenWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListExpansionDistSevenWithAggShockQ[[1]] - 60 MPCListExpansionDistSevenWithAggShockQ[[6]] - 20 MPCListExpansionDistSevenWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListExpansionDistSevenWithAggShockQ[[11]] - 20 MPCListExpansionDistSevenWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListExpansionDistSevenWithAggShockQ[[12]] - 40 MPCListExpansionDistSevenWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListExpansionDistSevenWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListExpansionDistSevenWithAggShockQ[[1]] - 60 MPCListExpansionDistSevenWithAggShockQ[[12]] - 20 MPCListExpansionDistSevenWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListExpansionDistSevenWithAggShock = Round[100 MPCListExpansionDistSevenWithAggShock]/100//N;
MPCListExpansionDistSevenWithAggShockBottom20ByW = MPCListExpansionDistSevenWithAggShock[[16]];
MPCListExpansionDistSevenWithAggShockBottom20ByInc = MPCListExpansionDistSevenWithAggShock[[17]];

MPCListEntRecessionDistSevenWithAggShock = Import["MPCListEntRecessionDistSevenWithAggShock.txt","List"]; 
MPCListEntRecessionDistSevenWithAggShockQ = 1 - (1-MPCListEntRecessionDistSevenWithAggShock)^(1/4); 
MPCListEntRecessionDistSevenWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListEntRecessionDistSevenWithAggShockQ[[1]] - MPCListEntRecessionDistSevenWithAggShockQ[[7]]))^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListEntRecessionDistSevenWithAggShockQ[[1]] - MPCListEntRecessionDistSevenWithAggShockQ[[13]]))^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListEntRecessionDistSevenWithAggShockQ[[5]] - 20 MPCListEntRecessionDistSevenWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListEntRecessionDistSevenWithAggShockQ[[6]] - 40 MPCListEntRecessionDistSevenWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListEntRecessionDistSevenWithAggShockQ[[1]] - 60 MPCListEntRecessionDistSevenWithAggShockQ[[6]] - 20 MPCListEntRecessionDistSevenWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListEntRecessionDistSevenWithAggShockQ[[11]] - 20 MPCListEntRecessionDistSevenWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListEntRecessionDistSevenWithAggShockQ[[12]] - 40 MPCListEntRecessionDistSevenWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListEntRecessionDistSevenWithAggShockQ[[1]] - 60 MPCListEntRecessionDistSevenWithAggShockQ[[12]] - 20 MPCListEntRecessionDistSevenWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListEntRecessionDistSevenWithAggShock = Round[100 MPCListEntRecessionDistSevenWithAggShock]/100//N;
MPCListEntRecessionDistSevenWithAggShockBottom20ByW = MPCListEntRecessionDistSevenWithAggShock[[16]];
MPCListEntRecessionDistSevenWithAggShockBottom20ByInc = MPCListEntRecessionDistSevenWithAggShock[[17]];

MPCListEntExpansionDistSevenWithAggShock = Import["MPCListEntExpansionDistSevenWithAggShock.txt","List"]; 
MPCListEntExpansionDistSevenWithAggShockQ = 1 - (1-MPCListEntExpansionDistSevenWithAggShock)^(1/4); 
MPCListEntExpansionDistSevenWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListEntExpansionDistSevenWithAggShockQ[[1]] - MPCListEntExpansionDistSevenWithAggShockQ[[7]]))^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListEntExpansionDistSevenWithAggShockQ[[1]] - MPCListEntExpansionDistSevenWithAggShockQ[[13]]))^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListEntExpansionDistSevenWithAggShockQ[[5]] - 20 MPCListEntExpansionDistSevenWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListEntExpansionDistSevenWithAggShockQ[[6]] - 40 MPCListEntExpansionDistSevenWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListEntExpansionDistSevenWithAggShockQ[[1]] - 60 MPCListEntExpansionDistSevenWithAggShockQ[[6]] - 20 MPCListEntExpansionDistSevenWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListEntExpansionDistSevenWithAggShockQ[[11]] - 20 MPCListEntExpansionDistSevenWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListEntExpansionDistSevenWithAggShockQ[[12]] - 40 MPCListEntExpansionDistSevenWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListEntExpansionDistSevenWithAggShockQ[[1]] - 60 MPCListEntExpansionDistSevenWithAggShockQ[[12]] - 20 MPCListEntExpansionDistSevenWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListEntExpansionDistSevenWithAggShock = Round[100 MPCListEntExpansionDistSevenWithAggShock]/100//N;
MPCListEntExpansionDistSevenWithAggShockBottom20ByW = MPCListEntExpansionDistSevenWithAggShock[[16]];
MPCListEntExpansionDistSevenWithAggShockBottom20ByInc = MPCListEntExpansionDistSevenWithAggShock[[17]];


MPCListDistSevenWithAggPermShock = Import["MPCListDistSevenWithAggPermShocks.txt","List"]; 
MPCListDistSevenWithAggPermShockQ = 1 - (1-MPCListDistSevenWithAggPermShock)^(1/4); 
MPCListDistSevenWithAggPermShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockQ[[1]] - MPCListDistSevenWithAggPermShockQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockQ[[1]] - MPCListDistSevenWithAggPermShockQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop2040ByW  = Round[100 (1-(1-(40 MPCListDistSevenWithAggPermShockQ[[5]] - 20 MPCListDistSevenWithAggPermShockQ[[4]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop4060ByW  = Round[100 (1-(1-(60 MPCListDistSevenWithAggPermShockQ[[6]] - 40 MPCListDistSevenWithAggPermShockQ[[5]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop6080ByW  = Round[100 (1-(1-(100 MPCListDistSevenWithAggPermShockQ[[1]] - 60 MPCListDistSevenWithAggPermShockQ[[6]] - 20 MPCListDistSevenWithAggPermShockQ[[16]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListDistSevenWithAggPermShockQ[[11]] - 20 MPCListDistSevenWithAggPermShockQ[[10]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListDistSevenWithAggPermShockQ[[12]] - 40 MPCListDistSevenWithAggPermShockQ[[11]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListDistSevenWithAggPermShockQ[[1]] - 60 MPCListDistSevenWithAggPermShockQ[[12]] - 20 MPCListDistSevenWithAggPermShockQ[[17]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShock = Round[100 MPCListDistSevenWithAggPermShock]/100//N;
MPCListDistSevenWithAggPermShockBottom20ByW = MPCListDistSevenWithAggPermShock[[16]];
MPCListDistSevenWithAggPermShockBottom20ByInc = MPCListDistSevenWithAggPermShock[[17]];

MPCLargeBadPermListDistSevenWithAggPermShock = Import["MPCLargeBadPermListDistSevenWithAggPermShocks.txt","List"]; 

MPCLargeBadPermListDistSevenWithAggPermShockQ = 1 - (1-MPCLargeBadPermListDistSevenWithAggPermShock)^(1/4); 
MPCLargeBadPermListDistSevenWithAggPermShockTop50ByW    = Round[100 (1 - (1 - (2 MPCLargeBadPermListDistSevenWithAggPermShockQ[[1]] - MPCLargeBadPermListDistSevenWithAggPermShockQ[[7]]))^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCLargeBadPermListDistSevenWithAggPermShockQ[[1]] - MPCLargeBadPermListDistSevenWithAggPermShockQ[[13]]))^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop2040ByW  = Round[100 (1-(1-(40 MPCLargeBadPermListDistSevenWithAggPermShockQ[[5]] - 20 MPCLargeBadPermListDistSevenWithAggPermShockQ[[4]])/20)^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop4060ByW  = Round[100 (1-(1-(60 MPCLargeBadPermListDistSevenWithAggPermShockQ[[6]] - 40 MPCLargeBadPermListDistSevenWithAggPermShockQ[[5]])/20)^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop6080ByW  = Round[100 (1-(1-(100 MPCLargeBadPermListDistSevenWithAggPermShockQ[[1]] - 60 MPCLargeBadPermListDistSevenWithAggPermShockQ[[6]] - 20 MPCLargeBadPermListDistSevenWithAggPermShockQ[[16]])/20)^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop2040ByInc  = Round[100 (1-(1-(40 MPCLargeBadPermListDistSevenWithAggPermShockQ[[11]] - 20 MPCLargeBadPermListDistSevenWithAggPermShockQ[[10]])/20)^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop4060ByInc  = Round[100 (1-(1-(60 MPCLargeBadPermListDistSevenWithAggPermShockQ[[12]] - 40 MPCLargeBadPermListDistSevenWithAggPermShockQ[[11]])/20)^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShockTop6080ByInc  = Round[100 (1-(1-(100 MPCLargeBadPermListDistSevenWithAggPermShockQ[[1]] - 60 MPCLargeBadPermListDistSevenWithAggPermShockQ[[12]] - 20 MPCLargeBadPermListDistSevenWithAggPermShockQ[[17]])/20)^4)]/100 //N;
MPCLargeBadPermListDistSevenWithAggPermShock = Round[100 MPCLargeBadPermListDistSevenWithAggPermShock]/100//N;
MPCLargeBadPermListDistSevenWithAggPermShockBottom20ByW = MPCLargeBadPermListDistSevenWithAggPermShock[[16]];
MPCLargeBadPermListDistSevenWithAggPermShockBottom20ByInc = MPCLargeBadPermListDistSevenWithAggPermShock[[17]];

MPCLargeBadTranListDistSevenWithAggPermShock = Import["MPCLargeBadTranListDistSevenWithAggPermShocks.txt","List"]; 
MPCLargeBadTranListDistSevenWithAggPermShockQ = 1 - (1-MPCLargeBadTranListDistSevenWithAggPermShock)^(1/4); 
MPCLargeBadTranListDistSevenWithAggPermShockTop50ByW    = Round[100 (1 - (1 - (2 MPCLargeBadTranListDistSevenWithAggPermShockQ[[1]] - MPCLargeBadTranListDistSevenWithAggPermShockQ[[7]]))^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCLargeBadTranListDistSevenWithAggPermShockQ[[1]] - MPCLargeBadTranListDistSevenWithAggPermShockQ[[13]]))^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop2040ByW  = Round[100 (1-(1-(40 MPCLargeBadTranListDistSevenWithAggPermShockQ[[5]] - 20 MPCLargeBadTranListDistSevenWithAggPermShockQ[[4]])/20)^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop4060ByW  = Round[100 (1-(1-(60 MPCLargeBadTranListDistSevenWithAggPermShockQ[[6]] - 40 MPCLargeBadTranListDistSevenWithAggPermShockQ[[5]])/20)^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop6080ByW  = Round[100 (1-(1-(100 MPCLargeBadTranListDistSevenWithAggPermShockQ[[1]] - 60 MPCLargeBadTranListDistSevenWithAggPermShockQ[[6]] - 20 MPCLargeBadTranListDistSevenWithAggPermShockQ[[16]])/20)^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop2040ByInc  = Round[100 (1-(1-(40 MPCLargeBadTranListDistSevenWithAggPermShockQ[[11]] - 20 MPCLargeBadTranListDistSevenWithAggPermShockQ[[10]])/20)^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop4060ByInc  = Round[100 (1-(1-(60 MPCLargeBadTranListDistSevenWithAggPermShockQ[[12]] - 40 MPCLargeBadTranListDistSevenWithAggPermShockQ[[11]])/20)^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShockTop6080ByInc  = Round[100 (1-(1-(100 MPCLargeBadTranListDistSevenWithAggPermShockQ[[1]] - 60 MPCLargeBadTranListDistSevenWithAggPermShockQ[[12]] - 20 MPCLargeBadTranListDistSevenWithAggPermShockQ[[17]])/20)^4)]/100 //N;
MPCLargeBadTranListDistSevenWithAggPermShock = Round[100 MPCLargeBadTranListDistSevenWithAggPermShock]/100//N;
MPCLargeBadTranListDistSevenWithAggPermShockBottom20ByW = MPCLargeBadTranListDistSevenWithAggPermShock[[16]];
MPCLargeBadTranListDistSevenWithAggPermShockBottom20ByInc = MPCLargeBadTranListDistSevenWithAggPermShock[[17]];



toplines = "
\\begin{center}

\\begin{tabular}{ld{3}d{3}d{3}d{3}d{3}d{9}d{9}d{6}}

\\toprule
Model &   \\multicolumn{4}{c}{\\text{Krusell--Smith (KS): $\\Discount$-Dist}}  &  \\multicolumn{3}{c}{\\text{Friedman/Buffer Stock (FBS): $\\Discount$-Dist}}       \\\\
\\cmidrule(r){2-5} \\cmidrule(r){6-8}
Scenario & && & \\multicolumn{1}{c}{ Entering } && \\multicolumn{1}{c}{Large Bad Permanent} & \\multicolumn{1}{c}{Large Bad Transitory} \\\\
& \\multicolumn{1}{c}{ Baseline} & \\multicolumn{1}{c}{ Recession} & \\multicolumn{1}{c}{ Expansion} & \\multicolumn{1}{c}{ Recession} & \\multicolumn{1}{c}{ Baseline} & \\multicolumn{1}{c}{Aggregate Shock} & \\multicolumn{1}{c}{Aggregate Shock}
\\\\ \\midrule

"; 

bottomlines = "
\\end{tabular}

\\end{center}					";


MPC = {toplines, 

"\\multicolumn{1}{l}{Overall average} &",   
MPCListDistSevenWithAggShock[[1]],
"&", 
MPCListRecessionDistSevenWithAggShock[[1]],
"&", 
MPCListExpansionDistSevenWithAggShock[[1]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[1]],
"&", 
MPCListDistSevenWithAggPermShock[[1]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[1]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[1]],
"\\\\ \\hline",


"\\multicolumn{3}{l}{By wealth/permanent income ratio} & & & & & ",
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &",  
MPCListDistSevenWithAggShock[[2]],
"&", 
MPCListRecessionDistSevenWithAggShock[[2]],
"&", 
MPCListExpansionDistSevenWithAggShock[[2]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[2]],
"&", 
MPCListDistSevenWithAggPermShock[[2]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[2]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[2]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListDistSevenWithAggShock[[3]],
"&", 
MPCListRecessionDistSevenWithAggShock[[3]],
"&", 
MPCListExpansionDistSevenWithAggShock[[3]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[3]],
"&", 
MPCListDistSevenWithAggPermShock[[3]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[3]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[3]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &",  
MPCListDistSevenWithAggShock[[4]],
"&", 
MPCListRecessionDistSevenWithAggShock[[4]],
"&", 
MPCListExpansionDistSevenWithAggShock[[4]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[4]],
"&", 
MPCListDistSevenWithAggPermShock[[4]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[4]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[4]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20--40\\%} &",   
MPCListDistSevenWithAggShockTop2040ByW,
"&",  
MPCListRecessionDistSevenWithAggShockTop2040ByW,
"&", 
MPCListExpansionDistSevenWithAggShockTop2040ByW,
"&", 
MPCListEntRecessionDistSevenWithAggShockTop2040ByW,
"&", 
MPCListDistSevenWithAggPermShockTop2040ByW,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockTop2040ByW,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockTop2040ByW,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40--60\\%} &",  
MPCListDistSevenWithAggShockTop4060ByW,
"&",  
MPCListRecessionDistSevenWithAggShockTop4060ByW,
"&", 
MPCListExpansionDistSevenWithAggShockTop4060ByW,
"&", 
MPCListEntRecessionDistSevenWithAggShockTop4060ByW,
"&", 
MPCListDistSevenWithAggPermShockTop4060ByW,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockTop4060ByW,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockTop4060ByW,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60--80\\%} &",   
MPCListDistSevenWithAggShockTop6080ByW,
"&",  
MPCListRecessionDistSevenWithAggShockTop6080ByW,
"&", 
MPCListExpansionDistSevenWithAggShockTop6080ByW,
"&", 
MPCListEntRecessionDistSevenWithAggShockTop6080ByW,
"&", 
MPCListDistSevenWithAggPermShockTop6080ByW,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockTop6080ByW,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockTop6080ByW,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 20\\%} &",  
MPCListDistSevenWithAggShockBottom20ByW,
"&",  
MPCListRecessionDistSevenWithAggShockBottom20ByW,
"&", 
MPCListExpansionDistSevenWithAggShockBottom20ByW,
"&", 
MPCListEntRecessionDistSevenWithAggShockBottom20ByW,
"&", 
MPCListDistSevenWithAggPermShockBottom20ByW,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockBottom20ByW,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockBottom20ByW,
"\\\\ ",

"\\multicolumn{1}{l}{By income} & & & & & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 1\\%} &", 
MPCListDistSevenWithAggShock[[8]],
"&", 
MPCListRecessionDistSevenWithAggShock[[8]],
"&", 
MPCListExpansionDistSevenWithAggShock[[8]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[8]],
"&", 
MPCListDistSevenWithAggPermShock[[8]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[8]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[8]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 10\\%} &", 
MPCListDistSevenWithAggShock[[9]],
"&", 
MPCListRecessionDistSevenWithAggShock[[9]],
"&", 
MPCListExpansionDistSevenWithAggShock[[9]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[9]],
"&", 
MPCListDistSevenWithAggPermShock[[9]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[9]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[9]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20\\%} &", 
MPCListDistSevenWithAggShock[[10]],
"&", 
MPCListRecessionDistSevenWithAggShock[[10]],
"&", 
MPCListExpansionDistSevenWithAggShock[[10]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[10]],
"&", 
MPCListDistSevenWithAggPermShock[[10]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[10]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[10]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20--40\\%} &", 
MPCListDistSevenWithAggShockTop2040ByInc,
"&",  
MPCListRecessionDistSevenWithAggShockTop2040ByInc,
"&", 
MPCListExpansionDistSevenWithAggShockTop2040ByInc,
"&", 
MPCListEntRecessionDistSevenWithAggShockTop2040ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop2040ByInc,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockTop2040ByInc,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockTop2040ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40--60\\%} &",  
MPCListDistSevenWithAggShockTop4060ByInc,
"&",  
MPCListRecessionDistSevenWithAggShockTop4060ByInc,
"&", 
MPCListExpansionDistSevenWithAggShockTop4060ByInc,
"&", 
MPCListEntRecessionDistSevenWithAggShockTop4060ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop4060ByInc,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockTop4060ByInc,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockTop4060ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60--80\\%} &", 
MPCListDistSevenWithAggShockTop6080ByInc,
"&",  
MPCListRecessionDistSevenWithAggShockTop6080ByInc,
"&", 
MPCListExpansionDistSevenWithAggShockTop6080ByInc,
"&", 
MPCListEntRecessionDistSevenWithAggShockTop6080ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop6080ByInc,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockTop6080ByInc,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockTop6080ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 20\\%} &", 
MPCListDistSevenWithAggShockBottom20ByInc,
"&",  
MPCListRecessionDistSevenWithAggShockBottom20ByInc,
"&", 
MPCListExpansionDistSevenWithAggShockBottom20ByInc,
"&", 
MPCListEntRecessionDistSevenWithAggShockBottom20ByInc,
"&", 
MPCListDistSevenWithAggPermShockBottom20ByInc,
"&", 
MPCLargeBadPermListDistSevenWithAggPermShockBottom20ByInc,
"&", 
MPCLargeBadTranListDistSevenWithAggPermShockBottom20ByInc,
"\\\\ ",

"\\multicolumn{1}{l}{By employment status} & & & & & & & ", 
"\\\\ ",

"\\multicolumn{1}{l}{\\ Employed} &", 
MPCListDistSevenWithAggShock[[14]],
"&", 
MPCListRecessionDistSevenWithAggShock[[14]],
"&", 
MPCListExpansionDistSevenWithAggShock[[14]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[14]],
"&", 
MPCListDistSevenWithAggPermShock[[14]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[14]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[14]],
"\\\\ ",

"\\multicolumn{1}{l}{\\ Unemployed}  &", 
MPCListDistSevenWithAggShock[[15]],
"&", 
MPCListRecessionDistSevenWithAggShock[[15]],
"&", 
MPCListExpansionDistSevenWithAggShock[[15]],
"&", 
MPCListEntRecessionDistSevenWithAggShock[[15]],
"&", 
MPCListDistSevenWithAggPermShock[[15]],
"&", 
MPCLargeBadPermListDistSevenWithAggPermShock[[15]],
"&", 
MPCLargeBadTranListDistSevenWithAggPermShock[[15]],
"\\\\ \\bottomrule",

bottomlines};

SetDirectory[TableDir];
Export["MPC_scenarios.tex", MPC, "text"]; 


(*
SetDirectory[MPCTableDir];
Export["MPC_scenarios.tex", MPC, "text"]; 
*)