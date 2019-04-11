(* SetupFuncs.m *)


(* CRRA marginal utility function *)
uP[c_]    := c^-\[Rho];     

(* Inverse of the CRRA marginal utility function *) 
nP[z_]    := z^ - (1/\[Rho]);  

(* Production function *)
F[k_]     := k^\[Alpha];

(* Marginal production (interest) function *)
FP[k_]    := \[Alpha] k^(\[Alpha]-1);

(* Wage function *)
wFunc[k_] := (1-\[Alpha]) k^(\[Alpha]);

(* Function to find the position number of the first element in listname whose value is greater than the value of comparison (used in simulation) *)
FirstElementGreaterThan[listname_,comparison_] := Block[{ListLength=Length[listname]},
  For[CurrentElement=1,
      comparison>listname[[CurrentElement]] && CurrentElement<ListLength,
      CurrentElement++];
  CurrentElement]; (* End of Block *)

(* Function to conduct OLS regression *)
MyReg[DepVar_,IndepVar_] := Inverse[Transpose[IndepVar].IndepVar].Transpose[IndepVar].DepVar;

(* Function to calculate correlated coeffcient *)
Corr[x_,y_] := (x-Mean[x]).(y-Mean[y])/(Length[x]-1)/(StandardDeviation[x] StandardDeviation[y]);

(* Find\[Beta]middleSolution gives \[Beta]middle which minimizes the deviation from KSS. This is used when mathcing net worth. *)
Find\[Beta]middleSolution := Block[{},


Inc = 0.00005;

While[Abs[KLevMean - KSS] > 0.1,

   IncTemp =   10 * (KLevMean - KSS) Inc;
   \[Beta]middle = \[Beta]middle - IncTemp;

   Export["Betamiddle.txt", \[Beta]middle, "Table"];
   << SolveAndSimDistSevenInEstimation.m;

   RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"]

]; (* End While *)

]; (* End Find\[Beta]middleSolution *)


(* This is used when mathcing financial assets *)
Find\[Beta]middleSolutionFin := Block[{},

(*
Inc = 0.00005;
*)
Inc = 0.00010;

While[Abs[KLevMean - KSS] > 0.1,

   IncTemp =   10 * (KLevMean - KSS) Inc;
   \[Beta]middle = \[Beta]middle - IncTemp;

    Export["BetamiddleFin.txt", \[Beta]middle, "Table"];
    << SolveAndSimDistSevenFinInEstimation.m; 

   RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"]

]; (* End While *)

]; (* End Find\[Beta]middleSolutionFin *)


(* This is used when mathcing liquid financial assets plus ret assets *)
Find\[Beta]middleSolutionLiqFinPlsRet := Block[{},

(*
Inc = 0.00005;
*)
Inc = 0.00010;

While[Abs[KLevMean - KSS] > 0.1,

   IncTemp =   10 * (KLevMean - KSS) Inc;
   \[Beta]middle = \[Beta]middle - IncTemp;

    Export["BetamiddleLiqFinPlsRet.txt", \[Beta]middle, "Table"];
    << SolveAndSimDistSevenLiqFinPlsRetInEstimation.m; 

   RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"]

]; (* End While *)

]; (* End Find\[Beta]middleSolutionLiqFinPlsRet *)


(* This is used when mathcing liquid financial assets *)
Find\[Beta]middleSolutionLiqFin := Block[{},

(*
Inc = 0.00005;
Inc = 0.00010;
*)
Inc = 0.00020;

While[Abs[KLevMean - KSS] > 0.1,

   IncTemp =   10 * (KLevMean - KSS) Inc;
   \[Beta]middle = \[Beta]middle - IncTemp;

    Export["BetamiddleLiqFin.txt", \[Beta]middle, "Table"];
    << SolveAndSimDistSevenLiqFinInEstimation.m; 

   RunModelt = RunModelt + 1; Export["RunModelt.txt", RunModelt, "Table"]

]; (* End While *)

]; (* End Find\[Beta]middleSolutionLiqFin *)