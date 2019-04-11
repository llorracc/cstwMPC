

(* Below, each 4 state is defined as follows:
    State 1 = Currently Good, Came from Good;  
    State 2 = Currently Bad, Came from Good; 
    State 3 = Currently Bad, Came from Bad; 
    State 4 = Currently Good, Came From Bad *)

pibb = 7/8 // N;   (* Probability of Bad coming from Bad *)
pigg = 7/8 // N;   (* Probability of Good coming from Good *)
pibg = (1 - pibb); (* Probability of Good coming from Bad *)
pigb = (1 - pigg); (* Probability of Bad coming from Good *)

AggStateTransitionMatrix    = {{pigg, pigb, 0.00, 0.00},
                               {0.00, 0.00, pibb, pibg},
                               {0.00, 0.00, pibb, pibg},
                               {pigg, pigb, 0.00, 0.00}}; (* Matrix of probs of aggregate state transition (e.g., [1,2] element is prob of transition from state 1 to state 2) *) 

CumAggStateTransitionMatrix = {{pigg, 1.00, 1.00, 1.00},
                               {0.00, 0.00, pibb, 1.00},
                               {0.00, 0.00, pibb, 1.00},
                               {pigg, 1.00, 1.00, 1.00}}; (* Matrix of cumulative probs of aggregate state transition *)

(*
ub                   = 0.1;                                   (* Fraction of unemployed in bad times *)
ug                   = 0.04;                                  (* Fraction of unemployed in good times *)
*)
ub                   = 0.07;
ug                   = 0.07;

uList                = {ug,ub,ub,ug};

(*
ptyLevelByAggState  = {1.01,0.99,0.99,1.01}^(1/(1-\[Alpha])); (* Productivity level by aggregate state *)
*)
ptyLevelByAggState  = {1,1,1,1}^(1/(1-\[Alpha])); (* Productivity level by aggregate state *)

lbar                = 1/0.9;                                  (* Time endowment *)  
LLevelByAggState    = {1-ug,1-ub,1-ub,1-ug} lbar;             (* L level (Lt) times lbar by aggregate state *)
AdjustedLByAggState = ptyLevelByAggState LLevelByAggState;    (* Adjusted labor stock (Pt) by aggregate state *)
MeanOfL             = Mean[LLevelByAggState];                 (* Mean of L Level *)
(*
ptyGrowthByAggState = {1.00,(0.99/1.01),1.00,(1.01/0.99)}^(1/(1-\[Alpha])) //N; 
                                                              (* Productivity growth level by aggregate state *)
*)
ptyGrowthByAggState = {1,1,1,1}^(1/(1-\[Alpha])) //N; 
LGrowthByAggState   = {1.00,(1-ub)/(1-ug),1.00,(1-ug)/(1-ub)};(* L growth level by aggregate state *)  
GrowthByAggState    = ptyGrowthByAggState LGrowthByAggState;  (* Growth factor defined in paper (Gt) by aggregate state *)

(* Parameters and matrices used in model with idiosyncratic shocks *)
NumOfEmpStates        = 2;             (* Number of employment state *)  
UnempWage             = 0.15;          (* Wage when unemployed *)
\[Sigma]Theta = (0.01*4)^0.5;         (* Standard deviation of lognormal distribution of transitory shocks *)
\[Sigma]Psi   = (0.01/(11/4))^0.5;    (* Standard deviation of lognormal distribution of permanent shocks *)
NumOfThetaShockPoints = 5;             (* Num of tran shock points. Increasing this does not change results much. *)
NumOfPsiShockPoints   = 5;             (* Num of perm shock points. Increasing this does not change results much. *)

(* Matrix of employment state transition probability 
    g: good times; 
    b: bad times;
    0: unemployed;
    1: employed    *)


(* Case of no persistence with ind employment shocks. *)
pigg11 = pigg (1-ug);
pigb11 = pigb (1-ub);
pigg10 = pigg ug;
pigb10 = pigb ub;
pibg11 = pibg (1-ug);
pibb11 = pibb (1-ub);
pibg10 = pibg ug;
pibb10 = pibb ub;
pigg01 = pigg (1-ug);
pigb01 = pigb (1-ub);
pigg00 = pigg ug;
pigb00 = pigb ub;
pibg01 = pibg (1-ug);
pibb01 = pibb (1-ub);
pibg00 = pibg ug;
pibb00 = pibb ub;

EmpStateTransitionMatrix    = {{{pigg00,pigg01},{pigg10,pigg11}}/pigg,
                               {{pigb00,pigb01},{pigb10,pigb11}}/pigb,
                               {{pibb00,pibb01},{pibb10,pibb11}}/pibb,
                               {{pibg00,pibg01},{pibg10,pibg11}}/pibg}; 

CumEmpStateTransitionMatrix = {{{pigg00/pigg,1},{pigg10/pigg,1}},
                               {{pigb00/pigb,1},{pigb10/pigb,1}},
                               {{pibb00/pibb,1},{pibb10/pibb,1}},
                               {{pibg00/pibg,1},{pibg10/pibg,1}}};

(* Matrix of et values *)
etValsByAggEmpState = {{UnempWage, (1-(ug UnempWage)/LLevelByAggState[[1]]) lbar},
                       {UnempWage, (1-(ub UnempWage)/LLevelByAggState[[2]]) lbar},
                       {UnempWage, (1-(ub UnempWage)/LLevelByAggState[[3]]) lbar},
                       {UnempWage, (1-(ug UnempWage)/LLevelByAggState[[4]]) lbar}};



