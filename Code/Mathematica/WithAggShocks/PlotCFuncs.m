
SetDirectory[NotebookDirectory[]];
If[Directory[] != WithAggShocksDir, SetDirectory[WithAggShocksDir]]; (* If this file is run in DoAll file and current folder is "Mathematica", current folder is changed to "WithAggShocks". *)

maxis = Import["maxis.txt","List"]; 
caxis = Import["caxis.txt","List"]; 
mRat = Import["mRat.txt","List"][[1]]; 

MaxXVal = 20; 

maxisDumLessThanMaxXVal =   Map[If[# <= MaxXVal, 1, 0] &, maxis]; (* list of dum if maxis val < MaxXVal *)
maxis = Take[maxis, {1,Total[maxisDumLessThanMaxXVal]}]; (* use maxis val < MaxXVa only *)
caxis = Take[caxis, {1,Total[maxisDumLessThanMaxXVal]}];


(* consumption function *)
CFuncPoint = 
 ListLinePlot[Transpose[{maxis, caxis}], 
  PlotRange -> {{-1, MaxXVal}, {0, 1.6}}, 
  PlotStyle -> {Black, Thickness[.006]}, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}
(* , TextStyle -> {FontSize -> 14}*) ];(* Plot consumption function when the agg state is good and employed  *)

Line20 = 
 ListLinePlot[{{0.8, 0}, {0.8, 1.5}}, 
  PlotStyle -> {Black, Dashing[{0.01, 0.01}], 
    Thickness[0.004]}];(* Plot net worth/p ratio,20th percentile,using SCF2004 *)
Line80 = 
 ListLinePlot[{{18.5, 0}, {18.5, 1.5}}, 
  PlotStyle -> {Black, Dashing[{0.01, 0.01}], 
    Thickness[0.004]}];(* Plot net worth/p ratio,80th percentile,using SCF2004 *)
Line20LiqFINPlsRetAssets = 
 ListLinePlot[{{1.0, 0}, {1.0, 1.5}}, 
  PlotStyle -> {Black, Dashing[{0.02, 0.02}],
    Thickness[0.007]}];(* Plot liquid fin assets/p ratio,20th percentile,using SCF2004 *)
Line80LiqFINPlsRetAssets = 
 ListLinePlot[{{2.9, 0}, {2.9, 1.5}}, 
  PlotStyle -> {Black, Dashing[{0.02, 0.02}],
    Thickness[0.007]}];(* Plot liquid fin assets/p ratio,80th percentile,using SCF2004 *)

(* Consumption function *)
CFuncPointPlot = 
 Show[{CFuncPoint}, 
  Graphics[Text[
    "\[UpArrow] Consumption/(quarterly) permanent", {4, 0.8}, {-1, 0}]], 
  Graphics[Text["   income ratio", {4, 0.7}, {-1, 0}]],
  Graphics[Text["\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\_\[ScriptT]\))", {17.4, -0.16}, {-1, 0}]], 
  PlotRangeClipping -> False, 
  ImagePadding -> 32, ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlot.EPS", CFuncPointPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlot.PDF", CFuncPointPlot, "PDF"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlot.PNG", CFuncPointPlot, "PNG"];


(* Consumption function with 20 and 80 percentiles in net worth *)
CFuncPointPlotNW2080 = 
 Show[{CFuncPoint, Line20, Line80}, 
  Graphics[Text[
    "\[UpArrow] Consumption/(quarterly) permanent", {4, 0.8}, {-1, 0}]], 
  Graphics[Text["   income ratio", {4, 0.7}, {-1, 0}]],
  Graphics[{Arrowheads[.02], Arrow[{{3.6, 1.45}, {1.9, 1.45}}]}],
  Graphics[Text["80th percentile in net worth ratio\[RightArrow]", {7, 0.5}, {-1, 0}]],
  Graphics[Text["Empirical (SCF) 20th percentile", {3.7, 1.45}, {-1, 0}]], 
  Graphics[Text["       in net worth/(quarterly) permanent", {2.1, 1.35}, {-1, 0}]], 
  Graphics[Text["       income ratio", {2.1, 1.25}, {-1, 0}]],
  Graphics[Text["\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\_\[ScriptT]\))", {17.4, -0.16}, {-1, 0}]],
  PlotRangeClipping -> False, 
  ImagePadding -> 32, ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlotNW2080.EPS", CFuncPointPlotNW2080, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlotNW2080.PNG", CFuncPointPlotNW2080, "PNG"];

(* Consumption function with 20 and 80 percentiles in liquid fin assets *)
CFuncPointPlotLA2080 = 
 Show[{CFuncPoint, Line20LiqFINPlsRetAssets, Line80LiqFINPlsRetAssets}, 
  Graphics[Text[
    "\[UpArrow] Consumption/(quarterly) permanent", {4, 0.8}, {-1, 0}]], 
  Graphics[Text["   income ratio", {4, 0.7}, {-1, 0}]],
  Graphics[{Arrowheads[.02], Arrow[{{3.7, 0.4}, {1.1, 0.4}}]}],
  Graphics[Text["20th percentile in liquid fin assets ratio", {4.1, 0.4}, {-1,0}]],
  Graphics[Text["\[LeftArrow] 80th percentile in liquid fin assets ratio", {3.4, 0.2}, {-1, 0}]], 
  Graphics[Text["\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\_\[ScriptT]\))", {17.4, -0.16}, {-1, 0}]],
  PlotRangeClipping -> False, 
  ImagePadding -> 32, ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}]

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlotLA2080.EPS", CFuncPointPlotLA2080, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlotLA2080.PNG", CFuncPointPlotLA2080, "PNG"];

CFuncPointPlotALL = 
 Show[{CFuncPoint, Line20, Line80, Line20LiqFINPlsRetAssets, Line80LiqFINPlsRetAssets}, 
  Graphics[Text[
    "\[UpArrow] Consumption/(quarterly) permanent", {4, 0.8}, {-1, 0}]], 
  Graphics[Text["   income ratio", {4, 0.7}, {-1, 0}]],
  Graphics[{Arrowheads[.02], Arrow[{{3.6, 1.43}, {0.82, 1.43}}]}],
  Graphics[Text["80th percentile in net worth ratio\[RightArrow]", {7, 0.5}, {-1, 0}]],
  Graphics[Text["Empirical (SCF) 20th percentile", {3.7, 1.45}, {-1, 0}]], 
  Graphics[Text["       in net worth/(quarterly) permanent", {2.1, 1.35}, {-1, 0}]], 
  Graphics[Text["       income ratio", {2.1, 1.25}, {-1, 0}]],
  Graphics[{Arrowheads[.02], Arrow[{{3.7, 0.4}, {1.1, 0.4}}]}],
  Graphics[Text["20th percentile in liquid fin assets ratio", {4.1, 0.4}, {-1,0}]],
  Graphics[Text["\[LeftArrow] 80th percentile in liquid fin assets ratio", {3.4, 0.2}, {-1, 0}]], 
  Graphics[Text["\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\_\[ScriptT]\))", {17.4, -0.16}, {-1, 0}]],
  PlotRangeClipping -> False, 
  ImagePadding -> 32, ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}]


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlotALL.EPS", CFuncPointPlotALL, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <>  "/Figures/CFuncPointPlotALL.PNG", CFuncPointPlotALL, "PNG"];



(* Add histogram(s) to the consumption function  *) 
(* Import SCF data *)
MYRATIOList = Import["MYRATIOList.txt", "List"];             (* net worth. 2004 data from software\Stata\SCF folder *)
LiqFINPlsRetYRATIOList =  Import["MLiqFINPlsRetYRATIO.txt", "List"];  (* liq fin. 2004 data from software\Stata\SCF folder  *)
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

MYRATIOData = Flatten[{MYRATIOData, 0}]; (* inseted zero at the end *)
xAxis       = Flatten[{xAxis, MaxXVal + e}];

HistDataNetWorth = Transpose[{xAxis, MYRATIOData}];
FigHistNetWorth  = ListPlot[{HistDataNetWorth}, Joined -> True, Filling -> Axis(* ,
   FillingStyle->Gray *) ];


(* Histogram of liquid financial assets *)
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




(* ********************************************* *)
(* Plot c func and histogram of net worth *)

plot1=ListPlot[{Transpose[{maxis, caxis}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Thick,    Thickness[0.01]}},
(*
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
*)
PlotRange -> {{-0.1, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text["  Consumption/(quarterly) perm", {4, 1.27}, {-1, 0}]], 
    Graphics[Text["  income ratio (left scale)", {4, 1.17}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {4, 1}, {-1, 0}]],
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)", {18, -0.16}, {-1, 0}]],

    Graphics[{Thickness[0.005], Dotted, Line[{{mRat, 0}, {mRat, 1.6}}]}],
    Graphics[Text["Rep agent's ratio of ", {5.5, 0.82}, {-1, 0}]],
    Graphics[Text["M to (quarterly) perm income   \[RightArrow]", {5.5, 0.72}, {-1, 0}]],

 

    Graphics[
   Text["   Histogram: empirical (SCF2004)", {4.8, 0.55}, {-1, 0}]],
    Graphics[
   Text["   density of \!\(\[ScriptM]\_\[ScriptT]\) (right scale)", {4.85,      0.45}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {8, .35}, {-1, 0}]],

    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];


plot2=ListPlot[{HistDataNetWorth},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-0.1, 20}, {0, 0.22}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncPointAndHistNetWorthPlot = Overlay[{plot2, plot1}]; 

CFuncPointAndHistNetWorthPlot

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistNetWorthPlot.EPS", CFuncPointAndHistNetWorthPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistNetWorthPlot.pdf", CFuncPointAndHistNetWorthPlot, "pdf"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistNetWorthPlot.PNG", CFuncPointAndHistNetWorthPlot, "PNG"];


(* ********************************************* *)
(* Plot c func and histogram of net worth *)

plot1=ListPlot[{Transpose[{maxis, caxis}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Thick,    Thickness[0.01]}},
(*
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
*)
PlotRange -> {{-0.1, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text["  Identical patience", {4, 1.2}, {-1, 0}]], 
    Graphics[Text["  \[DownArrow]", {4, 1.08}, {-1, 0}]],
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)", {18, -0.16}, {-1, 0}]],
    Graphics[
   Text["Histogram: empirical density of", {4.8, 0.55}, {-1, 0}]],

    Graphics[
   Text["     net worth (right scale)", {4.8, 0.45}, {-1, 0}]],

    Graphics[Text["  \[DownArrow]", {8, .35}, {-1, 0}]],

    Graphics[{Thickness[0.005], Dotted, Line[{{mRat, 0}, {mRat, 1.65}}]}],
    Graphics[Text["Representative agent's net worth \[RightArrow]", {5, 1.5}, {-1, 0}]],

    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];


plot2=ListPlot[{HistDataNetWorth},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-0.1, 20}, {0, 0.22}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterlyBetaPoint = Overlay[{plot2, plot1}]; 

CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterlyBetaPoint


Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS", CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterlyBetaPoint, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf", CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterlyBetaPoint, "pdf"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG", CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterlyBetaPoint, "PNG"];


(* ********************************************* *)
(* Plot c func and histogram of liq fin assets *)

plot1=ListPlot[{Transpose[{maxis, caxis}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Thick,    Thickness[0.01]}},
(*
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
*)
PlotRange -> {{-0.1, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text["  Consumption/(quarterly) permanent", {4, 1.3}, {-1, 0}]], 
    Graphics[Text["  income ratio (left scale)", {4, 1.2}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {4, 1.08}, {-1, 0}]],
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\))", {16.5, -0.16}, {-1, 0}]],
    Graphics[
   Text["   Histogram: empirical (SCF2004) density of ", {3, 0.45}, {-1, 0}]],
    Graphics[
   Text["   liquid financial assets/", {3,      0.35}, {-1, 0}]],
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
PlotRange -> {{-0.1, 20}, {0, 0.62}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]}} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];


CFuncPointAndHistLiqFINPlsRetPlot = Overlay[{plot2, plot1}]; 

CFuncPointAndHistLiqFINPlsRetPlot

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistLiqFINPlsRetPlot.EPS", CFuncPointAndHistLiqFINPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistLiqFINPlsRetPlot.PNG", CFuncPointAndHistLiqFINPlsRetPlot, "PNG"];


(* ********************************************* *)
(* C func and histograms of net worth and liq fin assets *)

plot1=ListPlot[{Transpose[{maxis, caxis}]},
Frame->{True,True,True,False},
PlotStyle -> {{Black, Thick,    Thickness[0.01]}},
(*
PlotStyle -> {{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]},{Black, Thick,    Thickness[0.01]},{Black, Dashing[{0.04, 0.04}],    Thickness[0.01]}},
*)
PlotRange -> {{-0.1, 20}, {0, 1.7}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
Joined -> True];


plot1 = 
 Show[plot1,
    Graphics[
      Text["  Consumption/(quarterly) permanent", {2, 1.25}, {-1, 0}]], 
    Graphics[Text["  income ratio (left scale)", {2, 1.15}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {4, 1.03}, {-1, 0}]],
    Graphics[
      Text[
    "\!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\))", {16.5, -0.16}, {-1, 0}]],
    Graphics[
   Text["   Histogram: empirical (SCF2004) density of ", {4.8, 0.40}, {-1, 0}]],
    Graphics[
   Text["   \!\(\[ScriptM]\_\[ScriptT]\)/(\!\(\[ScriptP]\_\[ScriptT]\)\!\(W\
\_\[ScriptT]\)) (right scale)", {4.85,      0.30}, {-1, 0}]],
    Graphics[Text["  \[DownArrow]", {8, .18}, {-1, 0}]],

    Graphics[
   Text["    Histogram: empirical (SCF2004) density of ", {0.8, 1.63}, {-1, 0}]],
    Graphics[
   Text["    liquid financial assets/", {0.8,      1.53}, {-1, 0}]],
    Graphics[
   Text["    permanent income ratio (right scale)", {0.8,      1.43}, {-1, 0}]],
    Graphics[
   Text[" \[DownArrow]", {1,      1.33}, {-1, 0}]],

    PlotRangeClipping -> False,
    ImagePadding -> 39,
    
    ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio},
    TextStyle -> {FontSize -> 14}];


plot2=ListPlot[{HistDataNetWorth, HistDataLiqFINPlsRet},
Frame->{False,False,False,True},
PlotStyle -> {{Black}, {Black}},
PlotRange -> {{-0.1, 20}, {0, 0.62}},
FrameStyle->{Automatic,Automatic,Automatic,Automatic},
FrameTicks -> {None, None, None, All},
Filling->{1->{Axis,Lighter[Blue,0.5]},2->{Axis,Lighter[RGBColor[1,0,0,0.5],0.8] }} ,
Joined -> True];

plot2 = 
 Show[plot2,
  PlotRangeClipping -> False, ImagePadding -> 39, 
  ImageSize -> {72. 6.5, 72. 6.5/GoldenRatio}, 
  TextStyle -> {FontSize -> 14}];

CFuncPointAndHistNetWorthLiqFINPlsRetPlot = Overlay[{plot2, plot1}]; 

CFuncPointAndHistNetWorthLiqFINPlsRetPlot

Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistNetWorthLiqFINPlsRetPlot.EPS", CFuncPointAndHistNetWorthLiqFINPlsRetPlot, "EPS"];
Export[ParentDirectory[ParentDirectory[ParentDirectory[]]] <> 
   "/Figures/CFuncPointAndHistNetWorthLiqFINPlsRetPlot.PNG", CFuncPointAndHistNetWorthLiqFINPlsRetPlot, "PNG"];














