(* CopyFigures *)
(* This file copies figures to Figures folders under cstKS and cstMPC. This file is run in DoAll.nb but we can run this file independently. *)

Print["==========================================================================="];
Print["Copy figures "];
ClearAll["Global`*"];

SetDirectory[NotebookDirectory[]];

FiguresDir   = ParentDirectory[ParentDirectory[]] <> "/Figures" ; (* Directory where tex tables are stored *)

KSFiguresDir  = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]] <> "/cstKS/Latest/Figures" ; (* Directory where tex tables are stored *)


MPCFiguresDir  = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]] <> "/cstMPC/Latest/Figures" ; (* Directory where tex tables are stored *)

xcFiguresDir  = ParentDirectory[ParentDirectory[ParentDirectory[ParentDirectory[]]]] <> "/cstMPCxc/Latest/Figures" ; (* Directory where tex tables are stored *)


Off[DeleteFile::"nffil"];


(* RPlot *)
DeleteFile[KSFiguresDir  <> "/RPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/RPlot.pdf"];
CopyFile[FiguresDir <> "/RPlot.pdf", KSFiguresDir <> "/RPlot.pdf"];
CopyFile[FiguresDir <> "/RPlot.pdf", MPCFiguresDir <> "/RPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/RPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/RPlot.EPS"];
CopyFile[FiguresDir <> "/RPlot.EPS", KSFiguresDir <> "/RPlot.EPS"];
CopyFile[FiguresDir <> "/RPlot.EPS", MPCFiguresDir <> "/RPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/RPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/RPlot.PNG"];
CopyFile[FiguresDir <> "/RPlot.PNG", KSFiguresDir <> "/RPlot.PNG"];
CopyFile[FiguresDir <> "/RPlot.PNG", MPCFiguresDir <> "/RPlot.PNG"];


(* dlAggCtPlot *)
DeleteFile[KSFiguresDir  <> "/dlAggCtPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/dlAggCtPlot.pdf"];
CopyFile[FiguresDir <> "/dlAggCtPlot.pdf", KSFiguresDir <> "/dlAggCtPlot.pdf"];
CopyFile[FiguresDir <> "/dlAggCtPlot.pdf", MPCFiguresDir <> "/dlAggCtPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/dlAggCtPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/dlAggCtPlot.EPS"];
CopyFile[FiguresDir <> "/dlAggCtPlot.EPS", KSFiguresDir <> "/dlAggCtPlot.EPS"];
CopyFile[FiguresDir <> "/dlAggCtPlot.EPS", MPCFiguresDir <> "/dlAggCtPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/dlAggCtPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/dlAggCtPlot.PNG"];
CopyFile[FiguresDir <> "/dlAggCtPlot.PNG", KSFiguresDir <> "/dlAggCtPlot.PNG"];
CopyFile[FiguresDir <> "/dlAggCtPlot.PNG", MPCFiguresDir <> "/dlAggCtPlot.PNG"];

(* fCrossSectionVar *)
DeleteFile[KSFiguresDir  <> "/fCrossSectionVar.pdf"];
DeleteFile[MPCFiguresDir <> "/fCrossSectionVar.pdf"];
CopyFile[FiguresDir <> "/fCrossSectionVar.pdf", KSFiguresDir <> "/fCrossSectionVar.pdf"];
CopyFile[FiguresDir <> "/fCrossSectionVar.pdf", MPCFiguresDir <> "/fCrossSectionVar.pdf"];

DeleteFile[KSFiguresDir  <> "/fCrossSectionVar.EPS"];
DeleteFile[MPCFiguresDir <> "/fCrossSectionVar.EPS"];
CopyFile[FiguresDir <> "/fCrossSectionVar.EPS", KSFiguresDir <> "/fCrossSectionVar.EPS"];
CopyFile[FiguresDir <> "/fCrossSectionVar.EPS", MPCFiguresDir <> "/fCrossSectionVar.EPS"];

DeleteFile[KSFiguresDir  <> "/fCrossSectionVar.PNG"];
DeleteFile[MPCFiguresDir <> "/fCrossSectionVar.PNG"];
CopyFile[FiguresDir <> "/fCrossSectionVar.PNG", KSFiguresDir <> "/fCrossSectionVar.PNG"];
CopyFile[FiguresDir <> "/fCrossSectionVar.PNG", MPCFiguresDir <> "/fCrossSectionVar.PNG"];

(* CumWLevSCFCastanedaAndDistSevenNoAggShockPlot *)
DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.pdf", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.pdf", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.EPS", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.EPS", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.PNG", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.PNG", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockPlot.PNG"];


(* CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot (plots two figures side by side ) *)
DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.pdf", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.pdf", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.EPS", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.EPS", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.PNG", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.PNG", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockLRPlot.PNG"];

(* CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot (plots two top and bottom) *)
DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.pdf", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.pdf", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.EPS", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.EPS", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.PNG", KSFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.PNG", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenNoAggShockTBPlot.PNG"];


(* CumWLevSCFCastanedaAndPointNoAggShockPlot *)
DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf", KSFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf", MPCFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS", KSFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS", MPCFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG", KSFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG", MPCFiguresDir <> "/CumWLevSCFCastanedaAndPointNoAggShockPlot.PNG"];

(* CumWLevSCFAndDistSevenNoAggShockPlot *)
DeleteFile[KSFiguresDir  <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf"];
DeleteFile[xcFiguresDir  <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf", KSFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf", MPCFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf", xcFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS"];
DeleteFile[xcFiguresDir  <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS", KSFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS", MPCFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS", xcFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG"];
DeleteFile[xcFiguresDir  <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG", KSFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG", MPCFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG", xcFiguresDir <> "/CumWLevSCFAndDistSevenNoAggShockPlot.PNG"];


(* CumWLevSCFCastanedaAndDistSevenPermPlot *)
DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.pdf"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.pdf", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.pdf"];

DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.EPS"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.EPS", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.EPS"];

DeleteFile[MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.PNG"];
CopyFile[FiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.PNG", MPCFiguresDir <> "/CumWLevSCFCastanedaAndDistSevenPermPlot.PNG"];


(* CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot *)
DeleteFile[KSFiguresDir  <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf", KSFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf", MPCFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS", KSFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS", MPCFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG", KSFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG", MPCFiguresDir <> "/CFuncKSHeteroAndDistSevenAndHistDataKSHeteroPlot.PNG"];


(* CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly *)
DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf", KSFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf", MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS", KSFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS", MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG", KSFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG", MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlotFedQuarterly.PNG"];

(* CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot *)
DeleteFile[KSFiguresDir  <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf", KSFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf", MPCFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS", KSFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS", MPCFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG", KSFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG", MPCFiguresDir <> "/CFuncDistSevenAndHistNetWorthLiqFinPlsRetPlot.PNG"];


(* CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly *)
DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.pdf", KSFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.pdf", MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.EPS", KSFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.EPS", MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.PNG", KSFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.PNG", MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly.PNG"];


(* CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint *)
DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf", KSFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf", MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS", KSFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS", MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG", KSFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG", MPCFiguresDir <> "/CFuncDistSevenPointPermAndHistNetWorthPlotFedQuarterly-BetaPoint.PNG"];

(* CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot *)
DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.pdf", KSFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.pdf", MPCFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.EPS", KSFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.EPS", MPCFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.PNG", KSFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.PNG", MPCFiguresDir <> "/CFuncDistSevenPermAndHistNetWorthLiqFinPlsRetPlot.PNG"];

(* CFuncandDeltaMZeroPlot *)
DeleteFile[KSFiguresDir  <> "/CFuncandDeltaMZeroPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncandDeltaMZeroPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncandDeltaMZeroPlot.pdf", KSFiguresDir <> "/CFuncandDeltaMZeroPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncandDeltaMZeroPlot.pdf", MPCFiguresDir <> "/CFuncandDeltaMZeroPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncandDeltaMZeroPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncandDeltaMZeroPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncandDeltaMZeroPlot.EPS", KSFiguresDir <> "/CFuncandDeltaMZeroPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncandDeltaMZeroPlot.EPS", MPCFiguresDir <> "/CFuncandDeltaMZeroPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncandDeltaMZeroPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncandDeltaMZeroPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncandDeltaMZeroPlot.PNG", KSFiguresDir <> "/CFuncandDeltaMZeroPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncandDeltaMZeroPlot.PNG", MPCFiguresDir <> "/CFuncandDeltaMZeroPlot.PNG"];

(* DistributionsMPCsDistSevenAndKSKSAggShocksPlot *)
DeleteFile[KSFiguresDir  <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf", KSFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf", MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS", KSFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS", MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG", KSFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG", MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSKSAggShocksPlot.PNG"];

(* DistributionsMPCsDistSevenAndKSPermShocksPlot *)
DeleteFile[MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.pdf"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.pdf", MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.pdf"];

DeleteFile[MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.EPS"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.EPS", MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.EPS"];

DeleteFile[MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.PNG"];
CopyFile[FiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.PNG", MPCFiguresDir <> "/DistributionsMPCsDistSevenAndKSPermShocksPlot.PNG"];


(* MPCsByIncomeQuintileAggShocksPlot (plotting average MPC by income quintile ) *)
DeleteFile[KSFiguresDir  <> "/MPCsByIncomeQuintileAggShocksPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.pdf"];
CopyFile[FiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.pdf", KSFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.pdf"];
CopyFile[FiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.pdf", MPCFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/MPCsByIncomeQuintileAggShocksPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.EPS"];
CopyFile[FiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.EPS", KSFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.EPS"];
CopyFile[FiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.EPS", MPCFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/MPCsByIncomeQuintileAggShocksPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.PNG"];
CopyFile[FiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.PNG", KSFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.PNG"];
CopyFile[FiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.PNG", MPCFiguresDir <> "/MPCsByIncomeQuintileAggShocksPlot.PNG"];



(* for slides *)
(* CFuncPointAndHistNetWorthPlot *)
DeleteFile[KSFiguresDir  <> "/CFuncPointAndHistNetWorthPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncPointAndHistNetWorthPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncPointAndHistNetWorthPlot.pdf", KSFiguresDir <> "/CFuncPointAndHistNetWorthPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncPointAndHistNetWorthPlot.pdf", MPCFiguresDir <> "/CFuncPointAndHistNetWorthPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncPointAndHistNetWorthPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncPointAndHistNetWorthPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncPointAndHistNetWorthPlot.EPS", KSFiguresDir <> "/CFuncPointAndHistNetWorthPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncPointAndHistNetWorthPlot.EPS", MPCFiguresDir <> "/CFuncPointAndHistNetWorthPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncPointAndHistNetWorthPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncPointAndHistNetWorthPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncPointAndHistNetWorthPlot.PNG", KSFiguresDir <> "/CFuncPointAndHistNetWorthPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncPointAndHistNetWorthPlot.PNG", MPCFiguresDir <> "/CFuncPointAndHistNetWorthPlot.PNG"];



(* CFuncDistSevenPointAndHistNetWorthPlot *)
DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointAndHistNetWorthPlot.pdf"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.pdf", KSFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.pdf"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.pdf", MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointAndHistNetWorthPlot.EPS"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.EPS", KSFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.EPS"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.EPS", MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/CFuncDistSevenPointAndHistNetWorthPlot.PNG"];
DeleteFile[MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.PNG", KSFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.PNG"];
CopyFile[FiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.PNG", MPCFiguresDir <> "/CFuncDistSevenPointAndHistNetWorthPlot.PNG"];
