
(*
uP[c_]:= If[c>0,(*then*) c^-\[Rho],(* else *)\[Infinity]];
*)
uP[c_]:= c^-\[Rho];
nP[z_]:= z^-(1/\[Rho]);

(* Marginal production (interest) function *)
FP[k_]    := \[Alpha] k^(\[Alpha]-1);
R[k_] := If[k>0,(*then*)1+\[Alpha] k^(\[Alpha]-1),(*else*)\[Infinity]];

(* Wage function *)
W[k_] := (1-\[Alpha])k^\[Alpha] ;

(* Function to conduct OLS regression *)
MyReg[DepVar_,IndepVar_] := Inverse[Transpose[IndepVar].IndepVar].Transpose[IndepVar].DepVar;

(* Function to calculate correlated coeffcient *)
Corr[x_,y_] := (x-Mean[x]).(y-Mean[y])/(Length[x]-1)/(StandardDeviation[x] StandardDeviation[y]);