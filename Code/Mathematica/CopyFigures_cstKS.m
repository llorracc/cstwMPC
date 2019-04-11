(* CopyFigures_cstKS.m *)
(* This file copies figures for cstKS to Figures folder under cstKS and cstMPC. *)

Print["==========================================================================="];
Print["Copy figures "];
ClearAll["Global`*"];

SetDirectory[NotebookDirectory[]];

FiguresDir   = ParentDirectory[ParentDirectory[]] <> "/Figures" ; (* Directory where tex tables are stored *)

KSFiguresDir  = ParentDirectory[ParentDirectory[ParentDirectory[]]] <> "/cstKS/Latest/Figures" ; (* Directory where tex tables are stored *)

Off[DeleteFile::"nffil"];


(* RPlot *)
DeleteFile[KSFiguresDir  <> "/RPlot.pdf"];
CopyFile[FiguresDir <> "/RPlot.pdf", KSFiguresDir <> "/RPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/RPlot.EPS"];
CopyFile[FiguresDir <> "/RPlot.EPS", KSFiguresDir <> "/RPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/RPlot.PNG"];
CopyFile[FiguresDir <> "/RPlot.PNG", KSFiguresDir <> "/RPlot.PNG"];


(* dlAggCtPlot *)
DeleteFile[KSFiguresDir  <> "/dlAggCtPlot.pdf"];
CopyFile[FiguresDir <> "/dlAggCtPlot.pdf", KSFiguresDir <> "/dlAggCtPlot.pdf"];

DeleteFile[KSFiguresDir  <> "/dlAggCtPlot.EPS"];
CopyFile[FiguresDir <> "/dlAggCtPlot.EPS", KSFiguresDir <> "/dlAggCtPlot.EPS"];

DeleteFile[KSFiguresDir  <> "/dlAggCtPlot.PNG"];
CopyFile[FiguresDir <> "/dlAggCtPlot.PNG", KSFiguresDir <> "/dlAggCtPlot.PNG"];

(* fCrossSectionVar *)
DeleteFile[KSFiguresDir  <> "/fCrossSectionVar.pdf"];
CopyFile[FiguresDir <> "/fCrossSectionVar.pdf", KSFiguresDir <> "/fCrossSectionVar.pdf"];

DeleteFile[KSFiguresDir  <> "/fCrossSectionVar.EPS"];
CopyFile[FiguresDir <> "/fCrossSectionVar.EPS", KSFiguresDir <> "/fCrossSectionVar.EPS"];

DeleteFile[KSFiguresDir  <> "/fCrossSectionVar.PNG"];
CopyFile[FiguresDir <> "/fCrossSectionVar.PNG", KSFiguresDir <> "/fCrossSectionVar.PNG"];
