(* ::Package:: *)

WhichSpec = "NetWorthNoBequests";
WhichModel = "BetaDist";
MPCbyAge = Import[WhichSpec <> WhichModel <> "MPCbyAge.txt","List"]; (* Import data *)
MPCbyAgePatient = Import[WhichSpec <> WhichModel <> "MPCbyAgePatient.txt","List"]; (* Import data *)
MPCbyAgeImpatient = Import[WhichSpec <> WhichModel <> "MPCbyAgeImpatient.txt","List"]; (* Import data *)


AgeAxis = Table[25 + i/4,{i,0,299}];


MPCbyAgePlot = ListLinePlot[Transpose[{AgeAxis,MPCbyAge}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{24, 100},{0, 1}}
   , PlotStyle  -> {Black, Thickness[0.004]}
];


MPCbyAgePatientPlot = ListLinePlot[Transpose[{AgeAxis,MPCbyAgePatient}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{24, 100},{0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.02, 0.02}], Thickness[0.004]}
];


MPCbyAgeImpatientPlot = ListLinePlot[Transpose[{AgeAxis,MPCbyAgeImpatient}]
   , InterpolationOrder -> 1
   , PlotRange  -> {{24, 100},{0, 1}}
   , PlotStyle  -> {Black, Dashing[{0.04, 0.04}], Thickness[0.004]}
];


MPCbyAgeFigure = Show[
    {MPCbyAgePlot, MPCbyAgePatientPlot, MPCbyAgeImpatientPlot}
    , Graphics[Text["Most patient" , {30, 0.07}, {-1,0}]]
    , Graphics[Text["Most impatient" , {40, 0.66}, {-1,0}]]
    , Graphics[Text["Population average" , {30, 0.36}, {-1,0}]]
    , AxesLabel -> {Age,MPC}
    , AxesOrigin -> {24,0}
    , ImageSize -> {72. 6.5,72. 6.5/GoldenRatio}
    , Ticks     -> {{30, 40, 50, 60, 70, 80, 90, 100}, {0, .25, .50, .75, 1}}
    , TextStyle -> {FontSize -> 14}
];


Export["MPCbyAgeFigure.pdf", MPCbyAgeFigure, "pdf"];
Export["MPCbyAgeFigure.EPS", MPCbyAgeFigure, "EPS"];
Export["MPCbyAgeFigure.PNG", MPCbyAgeFigure, "PNG"];
