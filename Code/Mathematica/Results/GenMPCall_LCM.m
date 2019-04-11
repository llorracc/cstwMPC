
SetDirectory[NotebookDirectory[]];
If[Directory[] != ResultsDir, SetDirectory[ResultsDir]]; 
TableDir = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/Tables" ; (* Directory where tex Tables are stored *)

(*
MPCTableDir = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]]] <> "\cstMPC\Latest\Tables"; (* KS table directory *)
*)



(* wealth distributions stats. % of held by top 20, 40, 60, and 80% *)
WealthDistStats             = {82.9, 94.7, 99.0, 100.2}; (* net worth data from SCF2004 *)
WealthDistStatsFin          = {87.7, 97.1, 99.6, 100.0}; (* fin assets data from SCF2004 *)
WealthDistStatsLiqFinPlsRet = {88.3, 97.5, 99.6, 100.0}; (* liq fin pls ret assets data from SCF2004 *)
WealthDistStatsLiqFin       = {93.8, 98.6, 99.7, 100.0}; (* liq fin assets data from SCF2004 *)


MPCListKSWithAggShock = Import["MPCListKSWithAggShock.txt","List"]; 

MPCListKSWithAggShockQ = 1 - (1-MPCListKSWithAggShock)^(1/4); 
MPCListKSWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListKSWithAggShockQ[[1]] - MPCListKSWithAggShockQ[[7]]))^4)]/100 //N;
MPCListKSWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListKSWithAggShockQ[[1]] - MPCListKSWithAggShockQ[[13]]))^4)]/100 //N;
MPCListKSWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListKSWithAggShockQ[[5]] - 20 MPCListKSWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListKSWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListKSWithAggShockQ[[6]] - 40 MPCListKSWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListKSWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListKSWithAggShockQ[[1]] - 60 MPCListKSWithAggShockQ[[6]] - 20 MPCListKSWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListKSWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListKSWithAggShockQ[[11]] - 20 MPCListKSWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListKSWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListKSWithAggShockQ[[12]] - 40 MPCListKSWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListKSWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListKSWithAggShockQ[[1]] - 60 MPCListKSWithAggShockQ[[12]] - 20 MPCListKSWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListKSWithAggShock = Round[100 MPCListKSWithAggShock]/100//N;
MPCListKSWithAggShockBottom20ByW = MPCListKSWithAggShock[[16]];
MPCListKSWithAggShockBottom20ByInc = MPCListKSWithAggShock[[17]];

MPCListKSHeteroWithAggShock = Import["MPCListKSHeteroWithAggShock.txt","List"]; 
MPCListKSHeteroWithAggShockQ = 1 - (1-MPCListKSHeteroWithAggShock)^(1/4); 
MPCListKSHeteroWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListKSHeteroWithAggShockQ[[1]] - MPCListKSHeteroWithAggShockQ[[7]]))^4)]/100 //N;
MPCListKSHeteroWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListKSHeteroWithAggShockQ[[1]] - MPCListKSHeteroWithAggShockQ[[13]]))^4)]/100 //N;
MPCListKSHeteroWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListKSHeteroWithAggShockQ[[5]] - 20 MPCListKSHeteroWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListKSHeteroWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListKSHeteroWithAggShockQ[[6]] - 40 MPCListKSHeteroWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListKSHeteroWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListKSHeteroWithAggShockQ[[1]] - 60 MPCListKSHeteroWithAggShockQ[[6]] - 20 MPCListKSHeteroWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListKSHeteroWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListKSHeteroWithAggShockQ[[11]] - 20 MPCListKSHeteroWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListKSHeteroWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListKSHeteroWithAggShockQ[[12]] - 40 MPCListKSHeteroWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListKSHeteroWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListKSHeteroWithAggShockQ[[1]] - 60 MPCListKSHeteroWithAggShockQ[[12]] - 20 MPCListKSHeteroWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListKSHeteroWithAggShock = Round[100 MPCListKSHeteroWithAggShock]/100//N;
MPCListKSHeteroWithAggShockBottom20ByW = MPCListKSHeteroWithAggShock[[16]];
MPCListKSHeteroWithAggShockBottom20ByInc = MPCListKSHeteroWithAggShock[[17]];

MPCListPointWithAggShock = Import["MPCListPointWithAggShock.txt","List"]; 
MPCListPointWithAggShockQ = 1 - (1-MPCListPointWithAggShock)^(1/4); 
MPCListPointWithAggShockTop50ByW    = Round[100 (1 - (1 - (2 MPCListPointWithAggShockQ[[1]] - MPCListPointWithAggShockQ[[7]]))^4)]/100 //N;
MPCListPointWithAggShockTop50ByInc  = Round[100 (1 - (1 - (2 MPCListPointWithAggShockQ[[1]] - MPCListPointWithAggShockQ[[13]]))^4)]/100 //N;
MPCListPointWithAggShockTop2040ByW  = Round[100 (1-(1-(40 MPCListPointWithAggShockQ[[5]] - 20 MPCListPointWithAggShockQ[[4]])/20)^4)]/100 //N;
MPCListPointWithAggShockTop4060ByW  = Round[100 (1-(1-(60 MPCListPointWithAggShockQ[[6]] - 40 MPCListPointWithAggShockQ[[5]])/20)^4)]/100 //N;
MPCListPointWithAggShockTop6080ByW  = Round[100 (1-(1-(100 MPCListPointWithAggShockQ[[1]] - 60 MPCListPointWithAggShockQ[[6]] - 20 MPCListPointWithAggShockQ[[16]])/20)^4)]/100 //N;
MPCListPointWithAggShockTop2040ByInc  = Round[100 (1-(1-(40 MPCListPointWithAggShockQ[[11]] - 20 MPCListPointWithAggShockQ[[10]])/20)^4)]/100 //N;
MPCListPointWithAggShockTop4060ByInc  = Round[100 (1-(1-(60 MPCListPointWithAggShockQ[[12]] - 40 MPCListPointWithAggShockQ[[11]])/20)^4)]/100 //N;
MPCListPointWithAggShockTop6080ByInc  = Round[100 (1-(1-(100 MPCListPointWithAggShockQ[[1]] - 60 MPCListPointWithAggShockQ[[12]] - 20 MPCListPointWithAggShockQ[[17]])/20)^4)]/100 //N;
MPCListPointWithAggShock = Round[100 MPCListPointWithAggShock]/100//N;
MPCListPointWithAggShockBottom20ByW = MPCListPointWithAggShock[[16]];
MPCListPointWithAggShockBottom20ByInc = MPCListPointWithAggShock[[17]];

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

MPCListDistSevenWithAggShockLiqFinPlsRet = Import["MPCListDistSevenWithAggShockLiqFinPlsRet.txt","List"]; 
MPCListDistSevenWithAggShockLiqFinPlsRetQ = 1 - (1-MPCListDistSevenWithAggShockLiqFinPlsRet)^(1/4); 
MPCListDistSevenWithAggShockLiqFinPlsRetTop50ByW    = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggShockLiqFinPlsRetQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop50ByInc  = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggShockLiqFinPlsRetQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop2040ByW  = Round[100 (1-(1-(40 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[5]] - 20 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[4]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop4060ByW  = Round[100 (1-(1-(60 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[6]] - 40 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[5]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop6080ByW  = Round[100 (1-(1-(100 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[1]] - 60 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[6]] - 20 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[16]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop2040ByInc  = Round[100 (1-(1-(40 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[11]] - 20 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[10]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop4060ByInc  = Round[100 (1-(1-(60 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[12]] - 40 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[11]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRetTop6080ByInc  = Round[100 (1-(1-(100 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[1]] - 60 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[12]] - 20 MPCListDistSevenWithAggShockLiqFinPlsRetQ[[17]])/20)^4)]/100 //N;
MPCListDistSevenWithAggShockLiqFinPlsRet = Round[100 MPCListDistSevenWithAggShockLiqFinPlsRet]/100//N;
MPCListDistSevenWithAggShockLiqFinPlsRetBottom20ByW = MPCListDistSevenWithAggShockLiqFinPlsRet[[16]];
MPCListDistSevenWithAggShockLiqFinPlsRetBottom20ByInc = MPCListDistSevenWithAggShockLiqFinPlsRet[[17]];


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

MPCListDistSevenWithAggPermShockLiqFinPlsRet = Import["MPCListDistSevenWithAggPermShocksLiqFinPlsRet.txt","List"]; 
MPCListDistSevenWithAggPermShockLiqFinPlsRetQ = 1 - (1-MPCListDistSevenWithAggPermShockLiqFinPlsRet)^(1/4); 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByW    = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[7]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop50ByInc  = Round[100 (1 - (1 - (2 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[13]]))^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop2040ByW  = Round[100 (1-(1-(40 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[5]] - 20 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[4]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop4060ByW  = Round[100 (1-(1-(60 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[6]] - 40 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[5]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop6080ByW  = Round[100 (1-(1-(100 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - 60 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[6]] - 20 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[16]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop2040ByInc  = Round[100 (1-(1-(40 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[11]] - 20 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[10]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop4060ByInc  = Round[100 (1-(1-(60 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[12]] - 40 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[11]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop6080ByInc  = Round[100 (1-(1-(100 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[1]] - 60 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[12]] - 20 MPCListDistSevenWithAggPermShockLiqFinPlsRetQ[[17]])/20)^4)]/100 //N;
MPCListDistSevenWithAggPermShockLiqFinPlsRet = Round[100 MPCListDistSevenWithAggPermShockLiqFinPlsRet]/100//N;
MPCListDistSevenWithAggPermShockLiqFinPlsRetBottom20ByW = MPCListDistSevenWithAggPermShockLiqFinPlsRet[[16]];
MPCListDistSevenWithAggPermShockLiqFinPlsRetBottom20ByInc = MPCListDistSevenWithAggPermShockLiqFinPlsRet[[17]];





kLevListKSWithAggShock = Import["kLevListKSWithAggShock.txt","List"]; 
SumOfDevSqRtKSWithAggShock=((kLevListKSWithAggShock[[2]]-100.2)^2+(kLevListKSWithAggShock[[3]]-99.0)^2+(kLevListKSWithAggShock[[5]]-94.7)^2+(kLevListKSWithAggShock[[7]]-82.9)^2)^0.5;
SumOfDevSqRtKSWithAggShock=Round[100 SumOfDevSqRtKSWithAggShock]/100//N; 

kLevListKSHeteroWithAggShock = Import["kLevListKSHeteroWithAggShock.txt","List"]; 
SumOfDevSqRtKSHeteroWithAggShock=((kLevListKSHeteroWithAggShock[[2]]-100.2)^2+(kLevListKSHeteroWithAggShock[[3]]-99.0)^2+(kLevListKSHeteroWithAggShock[[5]]-94.7)^2+(kLevListKSHeteroWithAggShock[[7]]-82.9)^2)^0.5;
SumOfDevSqRtKSHeteroWithAggShock=Round[100 SumOfDevSqRtKSHeteroWithAggShock]/100//N; 

kLevListPointWithAggShock = Import["kLevListPointWithAggShock.txt","List"]; 
SumOfDevSqRtPointWithAggShock=((kLevListPointWithAggShock[[2]]-100.2)^2+(kLevListPointWithAggShock[[3]]-99.0)^2+(kLevListPointWithAggShock[[5]]-94.7)^2+(kLevListPointWithAggShock[[7]]-82.9)^2)^0.5;
SumOfDevSqRtPointWithAggShock=Round[100 SumOfDevSqRtPointWithAggShock]/100//N; 

kLevListDistSevenWithAggShock = Import["kLevListDistSevenWithAggShock.txt","List"]; 
SumOfDevSqRtDistSevenWithAggShock=((kLevListDistSevenWithAggShock[[2]]-100.2)^2+(kLevListDistSevenWithAggShock[[3]]-99.0)^2+(kLevListDistSevenWithAggShock[[5]]-94.7)^2+(kLevListDistSevenWithAggShock[[7]]-82.9)^2)^0.5;
SumOfDevSqRtDistSevenWithAggShock=Round[100 SumOfDevSqRtDistSevenWithAggShock]/100//N; 

kLevListDistSevenWithAggShockLiqFinPlsRet = Import["kLevListDistSevenWithAggShockLiqFinPlsRet.txt","List"]; 
SumOfDevSqRtDistSevenWithAggShockLiqFinPlsRet=((kLevListDistSevenWithAggShockLiqFinPlsRet[[2]]-WealthDistStatsLiqFinPlsRet[[4]])^2+(kLevListDistSevenWithAggShockLiqFinPlsRet[[3]]-WealthDistStatsLiqFinPlsRet[[3]])^2+(kLevListDistSevenWithAggShockLiqFinPlsRet[[5]]-WealthDistStatsLiqFinPlsRet[[2]])^2+(kLevListDistSevenWithAggShockLiqFinPlsRet[[7]]-WealthDistStatsLiqFinPlsRet[[1]])^2)^0.5;
SumOfDevSqRtDistSevenWithAggShockLiqFinPlsRet=Round[100 SumOfDevSqRtDistSevenWithAggShockLiqFinPlsRet]/100//N; 


kLevListDistSevenWithAggPermShock = Import["kLevListDistSevenWithAggPermShock.txt","List"]; 
SumOfDevSqRtDistSevenWithAggPermShock=((kLevListDistSevenWithAggPermShock[[2]]-100.2)^2+(kLevListDistSevenWithAggPermShock[[3]]-99.0)^2+(kLevListDistSevenWithAggPermShock[[5]]-94.7)^2+(kLevListDistSevenWithAggPermShock[[7]]-82.9)^2)^0.5;
SumOfDevSqRtDistSevenWithAggPermShock=Round[100 SumOfDevSqRtDistSevenWithAggPermShock]/100//N; 


kLevListDistSevenWithAggPermShockLiqFinPlsRet = Import["kLevListDistSevenWithAggPermShockLiqFinPlsRet.txt","List"]; 
SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet=((kLevListDistSevenWithAggPermShockLiqFinPlsRet[[2]]-WealthDistStatsLiqFinPlsRet[[4]])^2+(kLevListDistSevenWithAggPermShockLiqFinPlsRet[[3]]-WealthDistStatsLiqFinPlsRet[[3]])^2+(kLevListDistSevenWithAggPermShockLiqFinPlsRet[[5]]-WealthDistStatsLiqFinPlsRet[[2]])^2+(kLevListDistSevenWithAggPermShockLiqFinPlsRet[[7]]-WealthDistStatsLiqFinPlsRet[[1]])^2)^0.5;
SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet=Round[100 SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet]/100//N; 

(*
kLevListDistSevenWithAggPermShockLiqFinPlsRet = Import["kLevListDistSevenWithAggPermShockLiqFinPlsRet.txt","List"]; 
SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet=((kLevListDistSevenWithAggPermShockLiqFinPlsRet[[2]]-100.2)^2+(kLevListDistSevenWithAggPermShockLiqFinPlsRet[[3]]-99.0)^2+(kLevListDistSevenWithAggPermShockLiqFinPlsRet[[5]]-94.7)^2+(kLevListDistSevenWithAggPermShockLiqFinPlsRet[[7]]-82.9)^2)^0.5;
SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet=Round[100 SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet]/100//N; 
*)



toplines = "
\\begin{center}

\\begin{tabular}{ld{5}d{5}d{3}d{3}d{3}d{3}d{7}d{3}d{3}d{3}}

\\toprule

&   \\multicolumn{5}{c}{\\text{Krusell--Smith (KS)}}  &                    \\multicolumn{2}{c}{Friedman/Buffer Stock }   &   \\multicolumn{3}{c}{\\text{Life Cycle Model}}    \\\\
&   \\multicolumn{5}{c}{\\text{Aggregate Process}}  &     \\multicolumn{2}{c}{(FBS) Aggr. Process}   \\\\
\\cmidrule(r){2-6} \\cmidrule(r){7-8} \\cmidrule(r){9-11}

Model  & \\multicolumn{1}{c}{\\text{KS-JEDC}} & \\multicolumn{1}{c}{\\text{KS-Hetero}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Point}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}}  & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Point}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} & \\multicolumn{1}{c}{\\text{$\\Discount$-Dist}} \\\\

 & \\multicolumn{1}{c}{\\text{Our Solution}} & \\multicolumn{1}{c}{\\text{Our Solution}}  & & &  &  & \\\\

Wealth Measure  & & & \\multicolumn{1}{c}{Net } &   \\multicolumn{1}{c}{Net}         &    \\multicolumn{1}{c}{Liquid}  &  \\multicolumn{1}{c}{Net} &  \\multicolumn{1}{c}{Liquid} & \\multicolumn{1}{c}{Net } &   \\multicolumn{1}{c}{Net}         &    \\multicolumn{1}{c}{Liquid} \\\\

&  & & \\multicolumn{1}{c}{Worth } &   \\multicolumn{1}{c}{Worth}         &    \\multicolumn{1}{c}{Assets}  & \\multicolumn{1}{c}{Worth} &  \\multicolumn{1}{c}{Assets} & \\multicolumn{1}{c}{Worth } &   \\multicolumn{1}{c}{Worth}         &    \\multicolumn{1}{c}{Assets} \\\\   \\midrule

"; 

bottomlines = "

\\end{tabular}

\\end{center}				
			";


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
"&
0.16
&
0.33
&
0.51
\\\\ \\midrule",


"\\multicolumn{11}{l}{By wealth/permanent income ratio} ",
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
"&
0.09
&
0.08
&
0.08
\\\\ ",

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
"&
0.10
&
0.08
&
0.07
\\\\ ",

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
"&
0.09
&
0.07
&
0.08
\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20--40\\%} &",   
MPCListKSWithAggShockTop2040ByW,
"&",  
MPCListKSHeteroWithAggShockTop2040ByW,
"&",  
MPCListPointWithAggShockTop2040ByW,
"&", 
MPCListDistSevenWithAggShockTop2040ByW,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop2040ByW,
"&", 
MPCListDistSevenWithAggPermShockTop2040ByW,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop2040ByW,
"&
0.08
&
0.07
&
0.28
\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40--60\\%} &",  
MPCListKSWithAggShockTop4060ByW,
"&",  
MPCListKSHeteroWithAggShockTop4060ByW,
"&",  
MPCListPointWithAggShockTop4060ByW,
"&", 
MPCListDistSevenWithAggShockTop4060ByW,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop4060ByW,
"&", 
MPCListDistSevenWithAggPermShockTop4060ByW,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop4060ByW,
"&
0.08
&
0.23
&
0.51
\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60--80\\%} &",   
MPCListKSWithAggShockTop6080ByW,
"&",  
MPCListKSHeteroWithAggShockTop6080ByW,
"&",  
MPCListPointWithAggShockTop6080ByW,
"&", 
MPCListDistSevenWithAggShockTop6080ByW,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop6080ByW,
"&", 
MPCListDistSevenWithAggPermShockTop6080ByW,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop6080ByW,
"&
0.15
&
0.21
&
0.40
\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 20\\%} &",  
MPCListKSWithAggShockBottom20ByW,
"&",  
MPCListKSHeteroWithAggShockBottom20ByW,
"&",  
MPCListPointWithAggShockBottom20ByW,
"&", 
MPCListDistSevenWithAggShockBottom20ByW,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetBottom20ByW,
"&", 
MPCListDistSevenWithAggPermShockBottom20ByW,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetBottom20ByW,
"&
0.41
&
0.81
&
0.94
\\\\ ",

"\\multicolumn{11}{l}{By income}", 
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
"&
0.10
&
0.22
&
0.37
\\\\ ",

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
"&
0.12
&
0.25
&
0.41
\\\\ ",

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
"&
0.13
&
0.30
&
0.42
\\\\ ",

"\\multicolumn{1}{l}{\\ Top 20--40\\%} &", 
MPCListKSWithAggShockTop2040ByInc,
"&",  
MPCListKSHeteroWithAggShockTop2040ByInc,
"&",  
MPCListPointWithAggShockTop2040ByInc,
"&", 
MPCListDistSevenWithAggShockTop2040ByInc,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop2040ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop2040ByInc,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop2040ByInc,
"&
0.15
&
0.30
&
0.42
\\\\ ",

"\\multicolumn{1}{l}{\\ Top 40--60\\%} &",  
MPCListKSWithAggShockTop4060ByInc,
"&",  
MPCListKSHeteroWithAggShockTop4060ByInc,
"&",  
MPCListPointWithAggShockTop4060ByInc,
"&", 
MPCListDistSevenWithAggShockTop4060ByInc,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop4060ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop4060ByInc,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop4060ByInc,
"&
0.16
&
0.33
&
0.50
\\\\ ",

"\\multicolumn{1}{l}{\\ Top 60--80\\%} &", 
MPCListKSWithAggShockTop6080ByInc,
"&",  
MPCListKSHeteroWithAggShockTop6080ByInc,
"&",  
MPCListPointWithAggShockTop6080ByInc,
"&", 
MPCListDistSevenWithAggShockTop6080ByInc,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetTop6080ByInc,
"&", 
MPCListDistSevenWithAggPermShockTop6080ByInc,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetTop6080ByInc,
"&
0.15
&
0.31
&
0.48
\\\\ ",

"\\multicolumn{1}{l}{\\ Bottom 20\\%} &", 
MPCListKSWithAggShockBottom20ByInc,
"&",  
MPCListKSHeteroWithAggShockBottom20ByInc,
"&",  
MPCListPointWithAggShockBottom20ByInc,
"&", 
MPCListDistSevenWithAggShockBottom20ByInc,
"&", 
MPCListDistSevenWithAggShockLiqFinPlsRetBottom20ByInc,
"&", 
MPCListDistSevenWithAggPermShockBottom20ByInc,
"&", 
MPCListDistSevenWithAggPermShockLiqFinPlsRetBottom20ByInc,
"&
0.18
&
0.40
&
0.59
\\\\ ",

"\\multicolumn{11}{l}{By employment status}", 
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
"&
0.13
&
0.28
&
0.44
\\\\ ",

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
"&
0.18
&
0.38
&
0.57
\\\\ \\midrule",


"\\multicolumn{11}{l}{Time preference parameters${}^\\ddagger$} 	 \\\\

\\multicolumn{1}{l}{$\\grave{\\Discount}$} & & &



\\input ../Code/Mathematica/Results/Beta.tex &

\\input ../Code/Mathematica/Results/BetamiddleWithAggShocks.tex &

\\input ../Code/Mathematica/Results/BetamiddleWithAggShocksLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/Betamiddle.tex &

\\input ../Code/Mathematica/Results/BetamiddleLiqFinPlsRet.tex
& 0.9890 & 0.9814 & 0.9659 \\\\

\\multicolumn{1}{l}{$\\nabla$} & & &

       &

\\input ../Code/Mathematica/Results/NablaWithAggShocks.tex &

\\input ../Code/Mathematica/Results/NablaWithAggShocksLiqFinPlsRet.tex &

\\input ../Code/Mathematica/Results/Nabla.tex &

\\input ../Code/Mathematica/Results/NablaLiqFinPlsRet.tex
& & 0.0182 & 0.0349

\\\\ \\midrule",

"\\multicolumn{1}{l}{\\ Lorenz Distance${}^\\star$}  &", 
SumOfDevSqRtKSWithAggShock,
"&", 
SumOfDevSqRtKSHeteroWithAggShock,
"&", 
SumOfDevSqRtPointWithAggShock,
"&", 
SumOfDevSqRtDistSevenWithAggShock,
"&", 
SumOfDevSqRtDistSevenWithAggShockLiqFinPlsRet,
"&", 
SumOfDevSqRtDistSevenWithAggPermShock,
"&", 
SumOfDevSqRtDistSevenWithAggPermShockLiqFinPlsRet,
"&
16.03
&
0.56
&
0.92
\\\\  \\bottomrule", 

bottomlines};

SetDirectory[TableDir];
Export["MPCall_LCM.tex", MPC, "text"]; 

(*
SetDirectory[MPCTableDir];
Export["MPCall_LCM.tex", MPC, "text"]; 
*)
 




