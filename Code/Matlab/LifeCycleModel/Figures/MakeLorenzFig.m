(* ::Package:: *)

Maxx = 100;
MyXaxis = Table[x/2,{x,0,200}];
WhichSpec = "NetWorthNoBequests";


(* SCF from Castaneda. *)

WSCFCum  = {0,  0, (100-99.0)/100, (100-94.7)/100, (100-82.9)/100, (100-69.7)/100, (100-57.9)/100, (100-33.9)/100, 1} ; (* SCF2004 *)

yAxisSCF = {0, 20,    40,    60,    80,    90,    95,    99, 100};



CumSCFPlot = ListLinePlot[Transpose[{yAxisSCF, WSCFCum}]

   , InterpolationOrder -> 3

   , PlotRange  -> {{0, Maxx}, {0, 1}}

   (*, PlotLegends \[Rule] Placed[LineLegend[{"US data (SCF)"}],{Left,Top}]*)

   , PlotStyle  -> {Black, Thickness[0.004]}

];

CumSCFlegend = ListLinePlot[{{2,0.9},{15,0.9}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Thickness[0.004]}
];


(* Plot simulated data *)

kLevListKSNoAggShock       = Import["KSLorenz.txt","List"]/100; (* Import data *)

kLevtsortedCumKS = 1-kLevListKSNoAggShock; 

yAxisKS           = {0,       20,      40,      50,      60,      75,      80,      90,      95, 99, 100};



CumKSPlot     = ListLinePlot[Transpose[{yAxisKS, kLevtsortedCumKS}] 

   , InterpolationOrder -> 3

   , PlotRange  -> {{0, Maxx}, {0, 1}}

   (*, PlotLegends \[Rule] Placed[LineLegend[{"KS-JEDC"}],{Left,Top}]*)

   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}

   ];

CumKSlegend = ListLinePlot[{{2,0.8},{15,0.8}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}],Thickness[0.004]}
];


(* import beta-point and beta-dist estimated Lorenz curves for net worth *)

BetaPointLorenz = Import[WhichSpec <> "BetaPointLorenz.txt","List"];
BetaDistLorenz = Import[WhichSpec <> "BetaDistLorenz.txt","List"];


BetaPointPlot     = ListLinePlot[Transpose[{MyXaxis, BetaPointLorenz}] 

   , InterpolationOrder -> 1

   , PlotRange  -> {{0, Maxx}, {0, 1}}

   (*, PlotLegends \[Rule] Placed[LineLegend[{"\[Beta]-Point"}],{Left,Top}]*)

   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}

   ];

BetaPointLegend = ListLinePlot[{{2,0.7},{15,0.7}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}],Thickness[0.004]}
];


BetaDistPlot     = ListLinePlot[Transpose[{MyXaxis, BetaDistLorenz}] 

   , InterpolationOrder -> 1

   , PlotRange  -> {{0, Maxx}, {0, 1}}

   (*, PlotLegends \[Rule] Placed[LineLegend[{"\[Beta]-Dist"}],{Left,Top}]*)

   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}

   ];

BetaDistLegend = ListLinePlot[{{2,0.6},{15,0.6}}

   , InterpolationOrder -> 1

   , PlotStyle  -> {Black, Dashing[{0.01, 0.01}],Thickness[0.004]}
];


LifeCycleLorenzPlot = Show[

   {CumSCFPlot, CumKSPlot, BetaPointPlot, BetaDistPlot, CumSCFlegend, CumKSlegend, BetaPointLegend, BetaDistLegend}

   (*, Graphics[Text["\[LongLeftArrow] US data (SCF, solid line) "              ,{58, 0.028},{-1,0}]]

   , Graphics[Text[" KS-JEDC \[LongRightArrow]"                  ,{55, 0.6}, {-1,0}]]

   , Graphics[Text["\[LongLeftArrow] \[Beta]-Point"             ,{75, 0.3}, {-1,0}]]

   , Graphics[Text[" \[Beta]-Dist"              ,{28, 0.27}, {-1,0}]]

   , Graphics[{Arrowheads[.02],Arrow[{{35,0.2},{35,0.02}}]}]*)

   , Graphics[Text[" Percentile" , {87, -0.1}, {-1,0}]]

   , Graphics[Text["US data (SCF)",{17,0.9},{-1,0}]]

   , Graphics[Text["KS-JEDC",{17,0.8},{-1,0}]]

   , Graphics[Text["\[Beta]-Point",{17,0.7},{-1,0}]]

   , Graphics[Text["\[Beta]-Dist",{17,0.6},{-1,0}]]

   , PlotRangeClipping -> False

   , ImagePadding -> 29

   , AxesLabel -> {None, \[ScriptCapitalF]}

   , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}

   , Ticks     -> {{0, 25, 50, 75, 100}, {0, .25, .50, .75, 1}}

   , TextStyle -> {FontSize -> 14}

   ]



Export["LifeCycleLorenzPlot.pdf", LifeCycleLorenzPlot, "pdf"];
Export["LifeCycleLorenzPlot.EPS", LifeCycleLorenzPlot, "EPS"];
Export["LifeCycleLorenzPlot.PNG", LifeCycleLorenzPlot, "PNG"];
