(* ::Package:: *)

Maxy = 100;
MyyAxis     = Table[i/2, {i, 1, 200}];
WhichSpec = "NoBequestsBetaDist";


(* MPCs matching net worth *)
MPCsListNetWorth  = Import["NetWorth" <> WhichSpec <> "MPClist.txt","List"]; (* Import data *)

MPCsNetWorthPlot = ListLinePlot[Transpose[{MPCsListNetWorth, MyyAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1},{0, Maxy}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];

NetWorthLegend = ListLinePlot[{{.85,20},{.99,20}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];


(* MPCs matching Finanical assets *)
MPCsListLiqFinRet  = Import["Liquid" <> WhichSpec <> "MPClist.txt","List"]; (* Import data *)

MPCsLiqFinRetPlot = ListLinePlot[Transpose[{MPCsListLiqFinRet, MyyAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1},{0, Maxy}}
   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];

LiqFinRetLegend = ListLinePlot[{{.85,10},{.99,10}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];


(* MPCs produced by the KS original *)
MPCsListKSTemp  = Import["MPCsListKS.txt","List"]; (* Import data *)
MPCsListKSTemp  = Sort[1-(1-MPCsListKSTemp)^4];
yAxisTemp = 99.9 Table[i/Length[MPCsListKSTemp], {i, 1, Length[MPCsListKSTemp]}];
MPCsListKSTemp = Append[MPCsListKSTemp,1];
yAxisTemp = Append[yAxisTemp,100];
MPCsListKS  = Interpolation[Transpose[{yAxisTemp,MPCsListKSTemp}]][MyyAxis];

MPCsKSPlot = ListLinePlot[Transpose[{MPCsListKS, MyyAxis}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{0, 1},{0, Maxy}}
   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}
];

KSlegend = ListLinePlot[{{.85,30},{.99,30}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}
];


MPCdistPlotLifeCycle = Show[
   {MPCsNetWorthPlot, MPCsLiqFinRetPlot , MPCsKSPlot, NetWorthLegend, LiqFinRetLegend, KSlegend}

   , Graphics[Text["Annual MPC" , {0.78, -8}, {-1,0}]]

   , Graphics[Text["KS-JEDC" , {0.83, 30}, {1,0}]]

   , Graphics[Text["Matching net worth" , {0.83, 20}, {1,0}]]

   , Graphics[Text["Matching liquid financial + retirement assets" , {0.83, 10}, {1,0}]]

   , PlotRangeClipping -> False
   , ImagePadding -> 29
   , AxesLabel -> {None, "Percentile"}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, .25, .50, .75, 1},{0, 25, 50, 75, 100}}
   , TextStyle -> {FontSize -> 14}
   ]


Export["MPCdistributionLifeCyclePlot.pdf", MPCdistPlotLifeCycle, "pdf"];
Export["MPCdistributionLifeCyclePlot.EPS", MPCdistPlotLifeCycle, "EPS"];
Export["MPCdistributionLifeCyclePlot.PNG", MPCdistPlotLifeCycle, "PNG"];
