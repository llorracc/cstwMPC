(* This file sets up a common list of agg states. *) 

AggStateJEDC = Import["AggStateJEDC.txt","List"]; (* This list is commonly used by economists who solve the Krusell-Smith problem. Available at http://www1.feb.uva.nl/mint/wdenhaan/suite/agg_switch.txt. *)

AggStatecstCode = Table[0, {Length[AggStateJEDC]}];

If[AggStateJEDC[[1]] == 1 (* if the state is bad *), AggStatecstCode[[1]] = 3, AggStatecstCode[[1]] = 1];

For[T = 2, T <= Length[AggStatecstCode], 
  If[AggStateJEDC[[T]]==2 && AggStateJEDC[[T-1]]==2, AggStatecstCode[[T]] = 1]; (* Currently Good, Came from Good *)
  If[AggStateJEDC[[T]]==1 && AggStateJEDC[[T-1]]==2, AggStatecstCode[[T]] = 2]; (* Currently Bad,  Came from Good *)
  If[AggStateJEDC[[T]]==1 && AggStateJEDC[[T-1]]==1, AggStatecstCode[[T]] = 3]; (* Currently Bad,  Came from Bad  *)
  If[AggStateJEDC[[T]]==2 && AggStateJEDC[[T-1]]==1, AggStatecstCode[[T]] = 4]; (* Currently Good, Came from Bad  *)   

  T++]; 