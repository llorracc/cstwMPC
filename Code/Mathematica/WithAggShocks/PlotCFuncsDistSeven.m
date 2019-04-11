
SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)

<<Params.m;

maxisKSHetero = Import["maxisKSHetero.txt","List"]; 
caxisKSHeteroLow = Import["caxisKSHeteroLow.txt","List"]; 
caxisKSHeteroHigh = Import["caxisKSHeteroHigh.txt","List"]; 

maxisSeven = Import["maxisSeven.txt","List"]; 
caxisSevenLow = Import["caxisSevenLow.txt","List"]; 
caxisSevenHigh = Import["caxisSevenHigh.txt","List"]; 

maxis = Import["maxis.txt","List"]; 
caxis = Import["caxis.txt","List"]; 

mRat = Import["mRat.txt","List"][[1]]; 



MaxXVal = 20; 

maxisKSHeteroDumLessThanMaxXVal =   Map[If[# <= MaxXVal, 1, 0] &, maxisKSHetero]; (* list of dum if maxisKSHetero val < MaxXVal *)
maxisKSHetero = Take[maxisKSHetero, {1,Total[maxisKSHeteroDumLessThanMaxXVal]}]; (* use maxisKSHetero val < MaxXVa only *)
caxisKSHeteroLow = Take[caxisKSHeteroLow, {1,Total[maxisKSHeteroDumLessThanMaxXVal]}];
caxisKSHeteroHigh = Take[caxisKSHeteroHigh, {1,Total[maxisKSHeteroDumLessThanMaxXVal]}];

maxisSevenDumLessThanMaxXVal =   Map[If[# <= MaxXVal, 1, 0] &, maxisSeven]; (* list of dum if maxisSeven val < MaxXVal *)
maxisSeven = Take[maxisSeven, {1,Total[maxisSevenDumLessThanMaxXVal]}]; (* use maxisSeven val < MaxXVa only *)
caxisSevenLow = Take[caxisSevenLow, {1,Total[maxisSevenDumLessThanMaxXVal]}];
caxisSevenHigh = Take[caxisSevenHigh, {1,Total[maxisSevenDumLessThanMaxXVal]}];


maxisDumLessThanMaxXVal =   Map[If[# <= MaxXVal, 1, 0] &, maxis]; (* list of dum if maxis val < MaxXVal *)
maxis = Take[maxis, {1,Total[maxisDumLessThanMaxXVal]}]; (* use maxis val < MaxXVa only *)
caxis = Take[caxis, {1,Total[maxisDumLessThanMaxXVal]}];


(* Add histogram(s) to the consumption function  *) 
(* Import Dist Seven data *)

(* use most impatient only *)
PatientIndicatorList       = Import["PatientIndicatorList.txt", "List"];
mRattDistSevenWithAggShock = Import["mRattDistSevenWithAggShock.txt", "List"];

DumMostImpatientListDistSeven = Map[If[# == 7, 1, 0] &, PatientIndicatorList];
NumOfMostImpatientHHsDistSeven = Total[DumMostImpatientListDistSeven];
mRattMostImpatientDistSeven = Table[0, {NumOfMostImpatientHHsDistSeven}]; (* prepare empty matrix*)

CountImpatient = 0;
(* collect mRatt of most impatient *)
For[i = 1, i <= Length[DumMostImpatientListDistSeven],
  i++,
  If[DumMostImpatientListDistSeven[[i]] == 1, 
   mRattMostImpatientDistSeven[[CountImpatient + 1]] = 
    mRattDistSevenWithAggShock[[i]]; 
   CountImpatient = CountImpatient + 1]
  ]; 

mRattDistSevenWithAggShock   = mRattMostImpatientDistSeven/wSS; (* rename and rescale *)
WGTDistSevenWithAggShockList = Table[1,{Length[mRattDistSevenWithAggShock]}]/Length[mRattDistSevenWithAggShock];

(*
(* if using all in mRattDistSevenWithAggShock *)
mRattDistSevenWithAggShock = Import["mRattDistSevenWithAggShock.txt", "List"]/wSS;  
WGTDistSevenWithAggShockList = Table[1,{Length[mRattDistSevenWithAggShock]}]/Length[mRattDistSevenWithAggShock];
*)

LowestValinHist = -3; 
IncrementList = Table[inci, {inci, LowestValinHist+1, MaxXVal}]; 
e = 0.1^5;

(* Histogram of wealth in Dist Seven *)
mRattDistSevenWithAggShockData = Table[0, {MaxXVal}];

(* Calc density *)
mRattDistSevenWithAggShockDumTemp = 
 Map[If[# <= LowestValinHist, 1, 0] &, mRattDistSevenWithAggShock]; (* if LowestValinHist or lower *)

mRattDistSevenWithAggShockData = Table[
  mRattDistSevenWithAggShockDumTempOld = mRattDistSevenWithAggShockDumTemp;
  mRattDistSevenWithAggShockDumTemp = Map[If[# <= mRattDistSevenWithAggShockDatai, 1, 0] &, mRattDistSevenWithAggShock];
  (mRattDistSevenWithAggShockDumTemp - mRattDistSevenWithAggShockDumTempOld) .WGTDistSevenWithAggShockList,
  {mRattDistSevenWithAggShockDatai, LowestValinHist+1, MaxXVal}
  ];

mRattDistSevenWithAggShockData = 
  Flatten[Table[{0, mRattDistSevenWithAggShockData[[mRattDistSevenWithAggShockDatai]], 
     mRattDistSevenWithAggShockData[[mRattDistSevenWithAggShockDatai]]}, {mRattDistSevenWithAggShockDatai, 1, MaxXVal-LowestValinHist}]]; 

xAxis = Sort[Flatten[{IncrementList, IncrementList - 1 + e, IncrementList-1 + e/2}]];

mRattDistSevenWithAggShockData = Flatten[{mRattDistSevenWithAggShockData, 0}]; (* inserted zero at the end *)
xAxis       = Flatten[{xAxis, MaxXVal + e}];

HistDataDistSevenWithAggShock = Transpose[{xAxis, mRattDistSevenWithAggShockData}];
FigHistDistSevenWithAggShock  = ListPlot[{HistDataDistSevenWithAggShock}, Joined -> True, Filling -> Axis, PlotRange->All (* ,
   FillingStyle->Gray *) ];

(*
FigHistDistSevenWithAggShock
*)


(* Import KS hetero data *)

(* use most impatient only *)
PatientIndicatorListKSHetero = Import["PatientIndicatorListKSHetero.txt", "List"];
mRattKSHetero = Import["mRattKSHetero.txt", "List"];

DumMostImpatientListKSHetero  = Map[If[# == 1, 1, 0] &, PatientIndicatorListKSHetero];
NumOfMostImpatientHHsKSHetero = Total[DumMostImpatientListKSHetero];
mRattMostImpatientKSHetero    = Table[0, {NumOfMostImpatientHHsKSHetero}]; (* prepare empty matrix*)

CountImpatient = 0;
(* collect mRatt of most impatient *)
For[i = 1, i <= Length[DumMostImpatientListKSHetero],
 i++,
 If[DumMostImpatientListKSHetero[[i]] == 1, 
  mRattMostImpatientKSHetero[[CountImpatient + 1]] = 
   mRattKSHetero[[i]]; CountImpatient = CountImpatient + 1]
 ]; (* "mRattMostImpatientKSHetero" is mRatt for most impatient *)

mRattKSHetero = mRattMostImpatientKSHetero/wSS; (* rename *)
WGTHeteroList = Table[1,{Length[mRattKSHetero]}]/Length[mRattKSHetero];

(*
(* if using all in mRattKSHetero *)
mRattKSHetero = Import["mRattKSHetero.txt", "List"]/wSS;  
WGTHeteroList = Table[1,{Length[mRattKSHetero]}]/Length[mRattKSHetero];
*)

LowestValinHist = -3; 
IncrementList = Table[inci, {inci, LowestValinHist+1, MaxXVal}]; 
e = 0.1^5;

(* Histogram of wealth in KS Hetero *)
mRattKSHeteroData = Table[0, {MaxXVal}];

(* Calc density *)
mRattKSHeteroDumTemp = 
 Map[If[# <= LowestValinHist, 1, 0] &, mRattKSHetero]; (* if LowestValinHist or lower *)

mRattKSHeteroData = Table[
  mRattKSHeteroDumTempOld = mRattKSHeteroDumTemp;
  mRattKSHeteroDumTemp = Map[If[# <= mRattKSHeteroDatai, 1, 0] &, mRattKSHetero];
  (mRattKSHeteroDumTemp - mRattKSHeteroDumTempOld) .WGTHeteroList,
  {mRattKSHeteroDatai, LowestValinHist+1, MaxXVal}
  ];

mRattKSHeteroData = 
  Flatten[Table[{0, mRattKSHeteroData[[mRattKSHeteroDatai]], 
     mRattKSHeteroData[[mRattKSHeteroDatai]]}, {mRattKSHeteroDatai, 1, MaxXVal-LowestValinHist}]]; 

xAxis = Sort[Flatten[{IncrementList, IncrementList - 1 + e, IncrementList-1 + e/2}]];

mRattKSHeteroData = Flatten[{mRattKSHeteroData, 0}]; (* inserted zero at the end *)
xAxis       = Flatten[{xAxis, MaxXVal + e}];

HistDataKSHetero = Transpose[{xAxis, mRattKSHeteroData}];
FigHistKSHetero  = ListPlot[{HistDataKSHetero}, Joined -> True, Filling -> Axis(* ,
   FillingStyle->Gray *) ];

(*
FigHistKSHetero
*)

(* Import SCF data *)
MYRATIOList = Import["MYRATIOList.txt", "List"];             (* net worth. 2004 data from software\Stata\SCF folder *)
LiqFINPlsRetYRATIOList =  Import["MLiqFINPlsRetYRATIO.txt", "List"];  (* liq fin plus retirement assets. 2004 data from software\Stata\SCF folder  *)
WGTList = Import["WGTList.txt", "List"];                     (* weight. 2004 data from software\Stata\SCF folde *)

WGTList = WGTList/Total[WGTList];

IncrementList = Table[inci, {inci, 1, MaxXVal}]; 
e = 0.1^5;

(* Histogram of net worth *)
MYRATIOData = Table[0, {MaxXVal}];

(* Calc density *)
MYRATIOListDumTemp = 
 Map[If[# <= 0, 1, 0] &, MYRATIOList]; (* if 0 or lower *)

MYRATIOData = Table[
  MYRATIOListDumTempOld = MYRATIOListDumTemp;
  MYRATIOListDumTemp = Map[If[# <= MYRATIODatai, 1, 0] &, MYRATIOList];
  (MYRATIOListDumTemp - MYRATIOListDumTempOld) .WGTList,
  {MYRATIODatai, 1, MaxXVal}
  ];

(*
MYRATIOData = 
  Flatten[Table[{MYRATIOData[[MYRATIODatai]], 
     MYRATIOData[[MYRATIODatai]]}, {MYRATIODatai, 1, MaxXVal}]]; 
*)

MYRATIOData = 
  Flatten[Table[{0, MYRATIOData[[MYRATIODatai]], 
     MYRATIOData[[MYRATIODatai]]}, {MYRATIODatai, 1, MaxXVal}]]; 

(*
xAxis = Sort[Flatten[{IncrementList, IncrementList - 1 + e}]];
*)
xAxis = Sort[Flatten[{IncrementList, IncrementList - 1 + e, IncrementList-1 + e/2}]];

MYRATIOData = Flatten[{MYRATIOData, 0}]; (* inserted zero at the end *)
xAxis       = Flatten[{xAxis, MaxXVal + e}];

HistDataNetWorth = Transpose[{xAxis, MYRATIOData}];
FigHistNetWorth  = ListPlot[{HistDataNetWorth}, Joined -> True, Filling -> Axis(* ,
   FillingStyle->Gray *) ];

HistDataNetWorthRev = Transpose[{xAxis, 7 MYRATIOData}];

(* Histogram of liquid financial asset plus retirement assetss *)
LiqFINPlsRetYRATIOData = Table[0, {MaxXVal}];

(* Calc density *)
LiqFINPlsRetYRATIOListDumTemp = 
 Map[If[# <= 0, 1, 0] &, LiqFINPlsRetYRATIOList]; (* if 0 or lower *)

LiqFINPlsRetYRATIOData = Table[
  LiqFINPlsRetYRATIOListDumTempOld = LiqFINPlsRetYRATIOListDumTemp;
  LiqFINPlsRetYRATIOListDumTemp = 
   Map[If[# <= LiqFINPlsRetYRATIODatai, 1, 0] &, LiqFINPlsRetYRATIOList];
  (LiqFINPlsRetYRATIOListDumTemp - LiqFINPlsRetYRATIOListDumTempOld) .WGTList,
  {LiqFINPlsRetYRATIODatai, 1, MaxXVal}
  ];

(*
LiqFINPlsRetYRATIOData = 
  Flatten[Table[{LiqFINPlsRetYRATIOData[[LiqFINPlsRetYRATIODatai]], 
     LiqFINPlsRetYRATIOData[[LiqFINPlsRetYRATIODatai]]}, {LiqFINPlsRetYRATIODatai, 1, 
     MaxXVal}]]; 
*)

LiqFINPlsRetYRATIOData = 
  Flatten[Table[{0, LiqFINPlsRetYRATIOData[[LiqFINPlsRetYRATIODatai]], 
     LiqFINPlsRetYRATIOData[[LiqFINPlsRetYRATIODatai]]}, {LiqFINPlsRetYRATIODatai, 1, 
     MaxXVal}]]; 

(*
xAxis = Sort[Flatten[{IncrementList, IncrementList - 1 + e}]];
*)
xAxis = Sort[Flatten[{IncrementList, IncrementList - 1 + e, IncrementList-1 + e/2}]];

LiqFINPlsRetYRATIOData = Flatten[{LiqFINPlsRetYRATIOData, 0}];
xAxis            = Flatten[{xAxis, MaxXVal + e}];

HistDataLiqFINPlsRet = Transpose[{xAxis, LiqFINPlsRetYRATIOData}];
FigHistNLiqFINPlsRet = 
  ListPlot[{HistDataLiqFINPlsRet}, Joined -> True, Filling -> Axis(* ,
   FillingStyle->Gray *) ];


(* Add histogram(s) to the ANNUAL consumption function  *) 
WidthHist = 0.2; 
(*
WidthHist = 0.2; 
*)
MaxXValAnnual = 5; 
MYRATIOAnnualList   = MYRATIOList/4; 
IncrementListAnnual = Table[WidthHist inci, {inci, 1, (1/WidthHist) MaxXValAnnual}]; 
(*
IncrementListAnnual = Table[0.5 inci, {inci, 1, 2* MaxXValAnnual}]; 
*)

(* Histogram of net worth *)
MYRATIOAnnualData = Table[0, {MaxXValAnnual}];

(* Calc density *)
MYRATIOAnnualListDumTemp = 
 Map[If[# <= 0, 1, 0] &, MYRATIOAnnualList]; (* if 0 or lower *)

MYRATIOAnnualData = Table[
  MYRATIOAnnualListDumTempOld = MYRATIOAnnualListDumTemp;

  MYRATIOAnnualListDumTemp = Map[If[# <= WidthHist MYRATIOAnnualDatai, 1, 0] &, MYRATIOAnnualList];
(*
  MYRATIOAnnualListDumTemp = Map[If[# <= 0.5 MYRATIOAnnualDatai, 1, 0] &, MYRATIOAnnualList];
*)
  (MYRATIOAnnualListDumTemp - MYRATIOAnnualListDumTempOld) .WGTList,

  {MYRATIOAnnualDatai, 1, (1/WidthHist) MaxXValAnnual}
(*
  {MYRATIOAnnualDatai, 1, 2 MaxXValAnnual}
*)
  ];

MYRATIOAnnualData = 
  Flatten[Table[{0, MYRATIOAnnualData[[MYRATIOAnnualDatai]], 
     MYRATIOAnnualData[[MYRATIOAnnualDatai]]}, 
{MYRATIOAnnualDatai, 1, (1/WidthHist) MaxXValAnnual}
(*
{MYRATIOAnnualDatai, 1, 2 MaxXValAnnual}
*)
]
]; 

xAxisAnnual = Sort[Flatten[{IncrementListAnnual, IncrementListAnnual - WidthHist + e, IncrementListAnnual-WidthHist + e/2}]];
(*
xAxisAnnual = Sort[Flatten[{IncrementListAnnual, IncrementListAnnual - 0.5 + e, IncrementListAnnual-0.5 + e/2}]];
*)

MYRATIOAnnualData = Flatten[{MYRATIOAnnualData, 0}]; (* inseted zero at the end *)
xAxisAnnual       = Flatten[{xAxisAnnual, MaxXValAnnual + e}];

HistDataNetWorthAnnual  = Transpose[{xAxisAnnual, MYRATIOAnnualData}];



(* ********************************************* *)
(* Plot c funcs (KS hetero and dist) and histogram of KS hetero *)

plot1=ListPlot[{Transpose[{maxisSeven, caxisSevenLow}],Transpose[{maxisKSHetero, caxisKSHeteroLow}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]}},
PlotRange -> {{-3.5, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];

plot1 = 
 Show[plot1,
  Graphics[Text["\[Beta]-Dist: Most Impatient ", {1, 1.62}, {-1, 0}]],
   Graphics[Text["(left scale) \[DownArrow]", {4, 1.47}, {-1, 0}]],
  
  Graphics[
   Text["  \[UpArrow] KS-Hetero: Most Impatient (left scale)", {3.3, 
     1.05}, {-1, 0}]],
  
  Graphics[
   Text["   \[LeftArrow] Histogram: density of cash on hand ", {3.5, 
     0.4}, {-1, 0}]],
  Graphics[Text["   for most impatients", {4.7, 0.28}, {-1, 0}]],
  Graphics[
   Text["   under \[Beta]-Dist (right scale)", {4.7, 0.16}, {-1, 0}]],
  
  Graphics[
   Text["   \[LongLeftArrow] Histogram: density of cash on hand ", \
{1.2, 0.9}, {-1, 0}]],
  Graphics[Text["   for most impatients", {2.7, 0.78}, {-1, 0}]],
  Graphics[
   Text["   under KS-Hetero (right scale)", {2.7, 0.66}, {-1, 0}]],
  
  Graphics[Text["\!\(\[ScriptM]\_\[ScriptT]\)", {18, -0.16}, {-1, 0}]],
  Graphics[
   Text["\!\(\[ScriptC]\_\[ScriptT]\)", {-4.4, 1.7}, {-1, 0}]], 
  Graphics[Text["\[ScriptF]", {21, 1.73}, {-1, 0}]], 
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

plot2=ListPlot[{HistDataKSHetero, 
   HistDataDistSevenWithAggShock},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-3.5, 20}, {0, 0.65}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]},2->{Axis,Lighter[RGBColor[1,0,0,0.5],0.8] }} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot = Overlay[{plot2, plot1}]; 

CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS", CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG", CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf", CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot, "pdf"];



(* ********************************************* *)
(* Plot c func and histogram of net worth *)

plot1=ListPlot[{Transpose[{maxisSeven, caxisSevenLow}], Transpose[{maxisSeven, caxisSevenHigh}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
PlotRange -> {{0, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text["  \[UpArrow] Consumption/(quarterly) permanent", {7, 1.3}, {-1, 0}]], 
    Graphics[Text["     income ratio ", {7, 1.2}, {-1, 0}]],
    Graphics[Text["     for least patient (left scale)", {7, 1.1}, {-1, 0}]],
    Graphics[Text["  \[UpArrow] for most patient (left scale)", {7, 0.8}, {-1, 0}]],
(*
    Graphics[Text["  \[DownArrow]", {7, 0.98}, {-1, 0}]],
*)
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\))", {16.5, -0.16}, {-1, 0}]],
    Graphics[
   Text["   Histogram: empirical density of ", {4.8, 0.55}, {-1, 0}]],
    Graphics[
   Text["   \!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\)) (right scale)", {4.85,      0.45}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {8, .35}, {-1, 0}]],
    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];

plot2=ListPlot[{HistDataNetWorth},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{0, 20}, {0, 0.23}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenAndHistNetWorthPlot = Overlay[{plot2, plot1}]; 

CFuncDistSevenAndHistNetWorthPlot


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistNetWorthPlot.EPS", CFuncDistSevenAndHistNetWorthPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistNetWorthPlot.PNG", CFuncDistSevenAndHistNetWorthPlot, "PNG"];



(* ********************************************* *)
(* Plot c func and histogram of liq fin plus retirement assets *)

plot1=ListPlot[{Transpose[{maxisSeven, caxisSevenLow}], Transpose[{maxisSeven, caxisSevenHigh}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
PlotRange -> {{0, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text["  \[UpArrow] Consumption/(quarterly) permanent", {7, 1.3}, {-1, 0}]], 
    Graphics[Text["     income ratio ", {7, 1.2}, {-1, 0}]],
    Graphics[Text["     for least patient (left scale)", {7, 1.1}, {-1, 0}]],
    Graphics[Text["  \[UpArrow] for most patient (left scale)", {7, 0.6}, {-1, 0}]],
(*
    Graphics[Text["  \[DownArrow]", {7, 0.98}, {-1, 0}]],
*)
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\))", {16.5, -0.16}, {-1, 0}]],
    Graphics[
   Text["   Histogram: empirical density of ", {3, 0.45}, {-1, 0}]],
    Graphics[
   Text["   liquid financial asset + retirement assets/", {3,      0.35}, {-1, 0}]],
    Graphics[
   Text["   permanent income ratio (right scale)", {3,      0.25}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {4, .15}, {-1, 0}]],
    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];

plot2=ListPlot[{HistDataLiqFINPlsRet},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{0, 20}, {0, 0.62}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenAndHistLiqFINPlsRetPlot = Overlay[{plot2, plot1}]; 

CFuncDistSevenAndHistLiqFINPlsRetPlot


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistLiqFINPlsRetPlot.EPS", CFuncDistSevenAndHistLiqFINPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistLiqFINPlsRetPlot.PNG", CFuncDistSevenAndHistLiqFINPlsRetPlot, "PNG"];


(* ********************************************* *)
(* C func and histograms of net worth and liq fin plus retirement assets *)

plot1=ListPlot[{Transpose[{maxisSeven, caxisSevenLow}], Transpose[{maxisSeven, caxisSevenHigh}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
PlotRange -> {{0, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
      Graphics[
         Text[
    "  \[UpArrow] Most Impatient (left scale)", {7, 1.3}, {-1, 0}]], 
      Graphics[
   Text["  Most Patient (left scale)", {4, 0.99}, {-1, 0}]],
      Graphics[Text["  \[DownArrow]", {6, 0.88}, {-1, 0}]],
  (*
      Graphics[Text["  \[DownArrow]", {7, 0.98}, {-1, 0}]],
  *)
  
  
      Graphics[
      Text[
    "           Histogram: empirical density of ", {5.8, 0.35}, {-1, 
     0}]],
      Graphics[
      Text[
    "           net worth (right scale)", {5.85,      0.25}, {-1, 0}]],
      Graphics[Text["  \[DownArrow]", {8, .14}, {-1, 0}]],
  
      Graphics[
      Text[
    "           Histogram: empirical density of ", {2, 0.68}, {-1, 
     0}]],
      Graphics[
      Text[
    "  \[LongLeftArrow]    liquid financial asset + retirement \
assets", {2,      0.58}, {-1, 0}]],
      Graphics[
      Text["           (right scale)", {2,      0.48}, {-1, 0}]],
  
  Graphics[
   Text["\!\(\[ScriptM]\_\[ScriptT]\)", {18, -0.16}, {-1, 0}]], 
  Graphics[Text[
    "\!\(\[ScriptC]\_\[ScriptT]\)", {-1.4, 1.7}, {-1, 0}]], 
  Graphics[Text["\[ScriptF]", {21, 1.73}, {-1, 0}]],
  
      PlotRangeClipping -> False,
      ImagePadding -> 39,
      
      ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
      TextStyle -> {FontSize -> 14}];


plot2=ListPlot[{HistDataNetWorth, HistDataLiqFINPlsRet},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{0, 20}, {0, 0.62}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]},2->{Axis,Lighter[RGBColor[1,0,0,0.5],0.8] }} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot = Overlay[{plot2, plot1}]; 

CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS", CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG", CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf", CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot, "pdf"];


(* ********************************************* *)
(* Plot c func and histogram of net worth *)

plot1=ListPlot[{Transpose[{maxisSeven, caxisSevenLow}], Transpose[{maxis, caxis}], Transpose[{maxisSeven, caxisSevenHigh}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
PlotRange -> {{-0.5, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text[" Consumption/(quarterly) permanent", {-0.3, 1.63}, {-1, 0}]], 
    Graphics[Text[" income ratio for least patient", {-0.3, 1.53}, {-1, 0}]],
    Graphics[Text[" in \[Beta]-Dist (left scale) ", {-0.3, 1.43}, {-1, 0}]],
    Graphics[Text[" \[DownArrow] ", {5.5, 1.35}, {-1, 0}]],
    Graphics[Text["  \[Beta]-Point (left scale)", {6, 1.20}, {-1, 0}]],
    Graphics[Text["  \[DownArrow] ", {8, 1.11}, {-1, 0}]],
    Graphics[Text["  \[UpArrow] for most patient in \[Beta]-Dist (left scale)", {4, 0.65}, {-1, 0}]],
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\))", {16.5, -0.16}, {-1, 0}]],
    Graphics[
   Text["   Histogram: empirical density of ", {4.8, 0.55}, {-1, 0}]],
    Graphics[
   Text["   \!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\)) (right scale)", {4.85,      0.45}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {8, .35}, {-1, 0}]],
    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];

plot2=ListPlot[{HistDataNetWorth},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-0.5, 20}, {0, 0.22}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenPointAndHistNetWorthPlot = Overlay[{plot2, plot1}]; 

CFuncDistSevenPointAndHistNetWorthPlot

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlot.EPS", CFuncDistSevenPointAndHistNetWorthPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlot.PNG", CFuncDistSevenPointAndHistNetWorthPlot, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlot.pdf", CFuncDistSevenPointAndHistNetWorthPlot, "pdf"];


(* ********************************************* *)
(* Figure for Fed *)

plot1=ListPlot[{Transpose[{maxisSeven/4, caxisSevenLow}], Transpose[{maxis/4, caxis}], Transpose[{maxisSeven/4, caxisSevenHigh}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
PlotRange -> {{-0.1, 5}, {0, 1.9}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text[" Most Impatient  (left scale) \[DownArrow] ", {0, 1.53}, {-1, 0}]], 
    Graphics[Text["  Identical Patience", {1.6, 1.28}, {-1, 0}]],
    Graphics[Text["  (left scale) \[DownArrow]", {1.6, 1.18}, {-1, 0}]],
    Graphics[Text["  \[UpArrow] Most Patient (left scale)", {1.9, 0.7}, {-1, 0}]],

    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)", {4.5, -0.16}, {-1, 0}]],

    Graphics[
   Text["   Histogram: empirical", {1, 0.51}, {-1, 0}]],
    Graphics[
   Text["    density of net worth (right scale)", {1.05,      0.37}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {2.2, 0.25}, {-1, 0}]],

    Graphics[{Thickness[0.005], Dotted, Line[{{mRat/4, 0}, {mRat/4, 1.9}}]}],
    Graphics[Text["Representative agent's \!\(\[ScriptM]\_\[ScriptT]\) \[RightArrow]", {1.83, 1.83}, {-1, 0}]],

    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];


plot2=ListPlot[{HistDataNetWorthAnnual},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-0.1, 5}, {0, 0.26}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenPointAndHistNetWorthPlotFed = Overlay[{plot2, plot1}]; 

CFuncDistSevenPointAndHistNetWorthPlotFed


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlotFed.EPS", CFuncDistSevenPointAndHistNetWorthPlotFed, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlotFed.PNG", CFuncDistSevenPointAndHistNetWorthPlotFed, "PNG"];


(* ********************************************* *)
(* Figure for Fed but quarterly *)

plot1=ListPlot[{Transpose[{maxisSeven, caxisSevenLow}], 
  Transpose[{maxis, caxis}], Transpose[{maxisSeven, caxisSevenHigh}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
PlotRange -> {{-0.1, 20}, {0, 1.9}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text[" Most impatient \[DownArrow] ", {3, 1.53}, {-1, 0}]], 
    Graphics[Text["  Identical patience \[DownArrow]", {7, 1.22}, {-1, 0}]],
    Graphics[Text["  \[UpArrow] Most patient ", {7.5, 0.7}, {-1, 0}]],

    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)", {18, -0.16}, {-1, 0}]],

    Graphics[
   Text["   Histogram: empirical", {5.25, 0.53}, {-1, 0}]],
    Graphics[Text["    density of net worth ", {5.25,      0.39}, {-1, 0}]],
    Graphics[Text["    \[DownArrow]", {9,      0.27}, {-1, 0}]],

    Graphics[{Thickness[0.005], Dotted, Line[{{mRat, 0}, {mRat, 1.9}}]}],
    Graphics[Text["Representative agent's net worth \[RightArrow]", {5, 1.83}, {-1, 0}]],

    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];


plot2=ListPlot[{HistDataNetWorthRev},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-0.1, 20}, {0, 1.9}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly = Overlay[{plot2, plot1}]; 

CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS", CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG", CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly, "PNG"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/figures/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf", CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly, "pdf"];




