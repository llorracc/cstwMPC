#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
/* Fix pragmas later */

/* This kernel is the multiperiod backward-induction solver for the CDC buffer saving model using endogenous gridpoints with cubic interpolation. */
/* It can accept multiple rho and beth inputs */
__kernel void SolveLifeCycle(
     __global double *CoeffsLifeAll          /* the first two buffers are read-write outputs */
    ,__global double *mGridLifeAll
    ,__global double *cVec                   /* temporary storage between periods: c value for each gridpoint */
    ,__global double *cPVec                  /* temporary storage between periods: c prime value for each gridpoint */
    ,__global double *mVec                   /* temporary storage between periods: m values for each gridpoint */
    ,__global double *aGridLife              /* these other buffers are read-only inputs */
    ,__global double *RLife
    ,__global double *FancyGLife
    ,__global double *DiscountBase           /* this is betaHat*FancyDCancel; adjust by beth to get beta_t */
    ,__global double *ThetaValsLife
    ,__global double *PsiValsLife
    ,__global double *ThetaProbsLife
    ,__global double *PsiProbsLife
    ,__global double *aLowerBoundLife
    ,__global double *bethVec                /* beth inputs for each parameter set */
    ,__global double *rhoVec                 /* rho inputs for each parameter set */
    ,__global double *alphaVec               /* alpha inputs for each parameter set */
    ,__global double *nuVec                  /* nu inputs for each parameter set */
    ,__global double *gammaVec               /* gamma inputs for each parameter set */
    ,__global int *IntegerInputs             /* some relevant integers for this run */
) {

    /* Initialize this thread's id */
    int Gid = get_global_id(0);             /* global thread id */
    int Lid = get_local_id(0);              /* local thread id */
    int Nid = get_group_id(0);              /* workgroup number; each workgroup does one parameter set */
    int k;                                  /* index of future state currently working on */
    int jj;                                 /* index of asset gridpoint currently working on */
    int Pass;                               /* number of asset points already looked at */
    
    /* Unpack the integer parameters */
    int aPoints = IntegerInputs[0];         /* number of points in the assets grid */
    int ThetaPoints = IntegerInputs[1];     /* number of points in the transitory shocks grid */
    int PsiPoints = IntegerInputs[2];       /* number of points in the permanent shocks grid */
    int BigT = IntegerInputs[3];            /* number of periods to be solved in total */
    int ParamCount = IntegerInputs[4];      /* number of parameter sets to be solved this run */
    int WorkGroupSize = IntegerInputs[5];   /* number of threads in each workgroup */
    int MaxPasses = IntegerInputs[6];       /* number of asset gridpoints each thread has to look at; often 1 */
    int ShockPoints = ThetaPoints*PsiPoints;/* total number of future states for each gridpoint */
    int CoeffsOffset = (aPoints+1)*4;       /* shifters for time period when reading output */
    int mOffset = aPoints;
    int CoeffsOffsetBig = CoeffsOffset*(BigT+1);/* shifters for parameter set when reading output */
    int mOffsetBig = mOffset*(BigT+1);
    int OtherOffsetBig = (BigT+1);
    
    /* Quit working now if this is not a valid workgroup */
    if (Nid >= ParamCount) {
        return;
    }

    /* Initialize private variables (these are the same within a workgroup) */
    double beth = bethVec[Nid];            /* adjustment factor for beta */
    double rho = rhoVec[Nid];              /* coefficient of relative risk aversion */
    double alpha = alphaVec[Nid];          /* bequest motive intensity */
    double nu = nuVec[Nid];                /* CRRA for bequest motive */
    double gamma = gammaVec[Nid];          /* location shifter for bequest motive */
    int PosA = CoeffsOffsetBig*Nid;        /* beginning of this parameter set's coefficients */
    int PosB = mOffsetBig*Nid;             /* beginning of this parameter set's m grid */
    int PosC = OtherOffsetBig*Nid;         /* beginning of this parameter set's other time-varying parameters */
    double R;                              /* gross interest rate */
    double FancyG;                         /* expected income growth rate */
    double beta;                           /* intertemporal discount factor adjusted by beth */
    double DeathProb;                      /* probability of dying before next period begins */
    double aBoundtp1;                      /* lower bound on assets next period */
    double aBoundt;                        /* lower bound on assets this period */
    double a;                              /* end of period t assets for this gridpoint */

    /* Initialize private variables (these are different across threads) */
    double Theta;                           /* transitory shock to income */
    double Psi;                             /* permanent shock to income */
    double Prob;                            /* probability of this shock combination happening */
    double m;                               /* resources available in period t+1 */
    double Deltam;                          /* difference between resources and minimum resources */
    double mX;                              /* Deltam mapped to [0,1] interval for interpolation purposes */
    double Span;                            /* width of this m grid segment */
    double b0;
    double b1;                              /* four interpolation coefficients */
    double b2;
    double b3;
    double c;                               /* consumption */
    double cP;                              /* dc/dm, or c prime */
    double kappa;                           /* MPC in period t+1 */
    double GothicvP;                        /* end-of-period expected marginal value of wealth */
    double GothicvPP;                       /* end-of-period expected marginal marginal value of wealth */
    double dcda;                            /* derivative of consumption with respect to end of period assets */
    int ThetaIdx;                           /* index of this transitory shock */
    int PsiIdx;                             /* index of this permanent shock */
    int Botj;                               /* bottom index of possible range during segment search */
    int Topj;                               /* top index of possible range during segment search */
    int Newj;                               /* next index of possible range during segment search */
    int Diffj;                              /* difference between top and bottom indices, want this to be 1 */
    double Botm;                            /* bottom value of possible range during segment search */
    double Topm;                            /* top value of possible range during segment search */
    double Newm;                            /* next value of possible range during segment search */
    int j;                                  /* index of correct segment for this m */
    int Start;                              /* beginning index of coefficients for this period */
    double c0;                              /* c value at lower end of segment */
    double c1;                              /* c value at upper end of segment */
    double cP0;                             /* c prime value at lower end of segment */
    double cP1;                             /* c prime value at upper end of segment */
    int LocA;
    int LocB;

    /* Begin the time loop, starting from the period before the terminal period */
    int t = 0;
    while (t <= BigT) {
    
        /* Update time-based variables */
        R = RLife[t];                           /* gross interest rate */
        FancyG = FancyGLife[PosC+t];            /* expected income growth rate */
        DeathProb = 1-DiscountBase[PosC+t];     /* probability of dying before next period */
        beta = beth;                            /* intertemporal discount factor adjusted by beth */
        aBoundt = aLowerBoundLife[PosC+t];      /* lower bound on assets this period */
        if (t > 0) {
            aBoundtp1 = aLowerBoundLife[PosC+t-1];  /* lower bound on assets next period */
        }
        
        /* Loop through asset points as needed by the workgroup size and number of asset gridpoints */
        Pass = 0;
        while (Pass < MaxPasses) {
            /* Find the asset gridpoint to work on this pass */
            jj = WorkGroupSize*Pass + Lid;
            if (jj < aPoints) {
                a = aGridLife[PosB + t*aPoints + jj];/* end of period t assets for this gridpoint */

                /* If this period is NOT the terminal period: */
                if (t > 0) {
                    /* Loop through each shock, adding contributions to GothicvP and GothicvPP */
                    GothicvP = 0;
                    GothicvPP = 0;
                    k = 0;
                    while (k < ShockPoints) {

                        /* Determine which shocks to use and the probability of them occuring */
                        PsiIdx = k/ThetaPoints;
                        ThetaIdx = k - PsiIdx*ThetaPoints;
                        Psi = PsiValsLife[t*PsiPoints + PsiIdx];
                        Theta = ThetaValsLife[t*ThetaPoints + ThetaIdx];
                        Prob = PsiProbsLife[t*PsiPoints + PsiIdx]*ThetaProbsLife[t*ThetaPoints + ThetaIdx];

                        /* Find next period's resources with these shocks */
                        m = a*R/(Psi*FancyG) + Theta;
                        Deltam = m - aBoundtp1;

                        /* Find next period's consumption and marginal consumption: */
                        /* First identify which segment of the m grid I am on */
                        Start = PosB + mOffset*(BigT + 1 - t);
                        Botj = 0;
                        Topj = aPoints-1;
                        Botm = mGridLifeAll[Start + Botj];
                        Topm = mGridLifeAll[Start + Topj];
                        Diffj = Topj - Botj;
                        Newj = Botj + Diffj/2;
                        Newm = mGridLifeAll[Start + Newj];
                        if (Deltam < Botm) { /* If m is outside the grid bounds, this is easy */
                            j = 0;
                            Topm = Botm;
                        }
                        else if (Deltam > Topm) {
                            j = aPoints;
                            Botm = Topm;
                        }
                        else { /* Otherwise, perform a binary/golden search for the right segment */
                            while (Diffj > 1) {
                                if (Deltam < Newm) {
                                    Topj = Newj;
                                    Topm = Newm;
                                }
                                else {
                                    Botj = Newj;
                                    Botm = Newm;
                                }
                                Diffj = Topj - Botj;
                                Newj = Botj + Diffj/2;
                                Newm = mGridLifeAll[Start + Newj];
                            }
                            j = Topj;
                        }

                        /* Get the interpolation coefficients for this segment */
                        Start = PosA + CoeffsOffset*(BigT + 1 - t) + j*4;
                        b0 = CoeffsLifeAll[Start + 0];
                        b1 = CoeffsLifeAll[Start + 1];
                        b2 = CoeffsLifeAll[Start + 2];
                        b3 = CoeffsLifeAll[Start + 3];
                        if (Topm > Botm) {
                            Span = (Topm - Botm);
                            mX = (Deltam - Botm)/Span;
                        }
                        else {
                            Span = 1;
                            mX = Deltam;
                        }

                        /* Use the interpolated function to get consumption and marginal consumption in t+1 */
                        c = b0 + mX*(b1 + mX*(b2 + mX*(b3)));
                        cP = (b1 + mX*(2*b2 + mX*(3*b3)))/Span;

                        /* Apply the liquidity constraint: can't consume more than resources */
                        if (c >= Deltam) {
                            c = Deltam - 0.000001;
                            kappa = 1;
                        }
                        else {
                            kappa = cP;
                        }
                    
                    /* Calculate contribution to expected marginal value and marginal marginal value */
                    GothicvP += Prob*powr(Psi*FancyG*c,-rho);
                    GothicvPP += Prob*powr(Psi*FancyG*c,-rho-1)*(-rho)*kappa;

                    k++;
                    } /* end of looping over shocks */

                } /* end of calculating GothicvP and GothicvPP */
                
                else { /* if solving the terminal period, GothicvP doesn't exist and can be arbitrarily assigned */
                    GothicvP = 0; 
                    GothicvPP = 0; /* (these are about to be multiplied by zero anyway) */
                } 

                /* Use GothicvP and GothicvPP to calculate consumption and marginal consumption in period t */
                GothicvP = beta*R*((1 - DeathProb)*GothicvP + DeathProb*alpha*powr(a*R + gamma,-nu));
                GothicvPP = beta*R*R*((1 - DeathProb)*GothicvPP + DeathProb*alpha*(-nu)*powr(a*R + gamma,-nu-1));
                c = powr(GothicvP,-1/rho);
                dcda = GothicvPP/(-rho*powr(c,-rho-1));
                kappa = dcda/(dcda + 1);
                m = c + a;                   /* This is the endogenous gridpoint */

                /* Store m, c, and cP for the coefficient calculator to work with */
                Start = Nid*mOffset + jj;
                mVec[Start] = m;
                cVec[Start] = c;
                cPVec[Start] = kappa;

            } /* end of if (jj < aPoints) */
            Pass++;

        }  /* end of multi-pass over asset points for solver */
        mem_fence(CLK_GLOBAL_MEM_FENCE);
        barrier(CLK_GLOBAL_MEM_FENCE);

        /* Move time forward one period  */
        t++;

        /* Now loop over asset points again to calculate coefficients, etc */
        Pass = 0;
        while (Pass < MaxPasses) {
            /* Find the asset gridpoint to work on this pass */
            jj = WorkGroupSize*Pass + Lid;
            if (jj < aPoints) {

                /* Find where to write the calculated output */
                LocA = PosA + CoeffsOffset*(BigT + 1 - t) + (jj+1)*4;     /* location for coefficients */
                LocB = PosB + mOffset*(BigT + 1 - t) + jj;                /* location for m grid */

                /* Record the m value in the intertemporal grid */
                Start = Nid*mOffset + jj;
                m = mVec[Start];
                mGridLifeAll[LocB] = m;

                /* Calculate interior coefficients (if I'm not the rightmost gridpoint) */
                if (jj < (aPoints-1)) {
                    Span = mVec[Start+1] - mVec[Start]; 
                    c0 = cVec[Start];
                    c1 = cVec[Start+1];
                    cP0 = cPVec[Start]*Span;
                    cP1 = cPVec[Start+1]*Span;
                    CoeffsLifeAll[LocA + 0] = c0;
                    CoeffsLifeAll[LocA + 1] = cP0;
                    CoeffsLifeAll[LocA + 2] = 3*(c1 - c0) - 2*cP0 - cP1;
                    CoeffsLifeAll[LocA + 3] = cP0 + cP1 + 2*(c0 - c1);
                }
                /* If I am the rightmost gridpoint, then... */
                else {
                    /* ...calculate upper extrapolation coefficients */
                    c1 = cVec[Start];
                    cP1 = cPVec[Start];
                    CoeffsLifeAll[LocA + 0] = c1 - cP1*m;
                    CoeffsLifeAll[LocA + 1] = cP1;
                    CoeffsLifeAll[LocA + 2] = 0;
                    CoeffsLifeAll[LocA + 3] = 0;
            
                    /* ...then calculate lower extrapolation coefficients */
                    Start = Nid*mOffset;
                    c0 = cVec[Start];
                    cP0 = cPVec[Start];
                    m = mVec[Start];
                    LocA = PosA + CoeffsOffset*(BigT + 1 - t);
                    CoeffsLifeAll[LocA + 0] = c0 - cP0*m;
                    CoeffsLifeAll[LocA + 1] = cP0;
                    CoeffsLifeAll[LocA + 2] = 0;
                    CoeffsLifeAll[LocA + 3] = 0;
                }
            }
            Pass++;
        } /* end of multi-pass loop for coefficients */
        mem_fence(CLK_GLOBAL_MEM_FENCE);
        barrier(CLK_GLOBAL_MEM_FENCE);

    } /* end of time loop */
    

} /* End of multi-period solver kernel */




/* This is is the multi-period simulator (for estimation) */
__kernel void SimMultiPeriod(
      __global double *WealthOut
    , __global double *MPCout
    , __global double *ConOut
    , __global double *WealthInit
    , __global double *ThetaGrid
    , __global double *PsiGrid
    , __global double *mGridLifeAll
    , __global double *CoeffsLifeAll
    , __global double *aLowerBoundLife
    , __global double *FancyGLife
    , __global double *RLife
    , __global double *BequestVec
    , __global int *IntegerInputs
) {

    /* Get this thread's ID */
    int Gid = get_global_id(0);

    /* Initialize local variables */
    double w;                               /* Wealth to income ratio */
    int t;                                  /* time, counting forward */
    double Bequest;                         /* bequest received in this period */
    double Theta;                           /* transitory shock to income */
    double Psi;                             /* permanent shock to income */
    double m;                               /* available money resources */
    double Deltam;                          /* difference between resources and minimum */
    double mX;                              /* m mapped to [0,1] interval */
    double Span;                            /* span length of this sector */
    int Start;                              /* beginning of correct coefficient segment */
    double b0;
    double b1;                              /* four interpolation coefficients */
    double b2;
    double b3;
    double c;                               /* consumption */
    double kappa;                           /* actual MPC of realist */
    double a;                               /* end of period assets */
    int Loc;
    int LocBase;
    int Botj;                               /* bottom index of possible range during segment search */
    int Topj;                               /* top index of possible range during segment search */
    int Newj;                               /* next index of possible range during segment search */
    int Diffj;                              /* difference between top and bottom indices, want this to be 1 */
    double Botm;                            /* bottom value of possible range during segment search */
    double Topm;                            /* top value of possible range during segment search */
    double Newm;                            /* next value of possible range during segment search */
    int j;                                  /* index of correct segment for this m */
    int PosA;
    int PosB;
    int PosC;

    /* Unpack the inputs */
    int aPoints = IntegerInputs[0];         /* number of points in the assets grid */
    int BigT = IntegerInputs[3];            /* number of periods to be solved in total */
    int ParamCount = IntegerInputs[4];      /* number of parameter sets to do this run */
    int SimPeriods = IntegerInputs[8];      /* number of periods to simulate */
    int SimPop = IntegerInputs[9];          /* number of individuals to simulate */
    int CoeffsOffset = (aPoints+1)*4;       /* shifter for time period when reading output */
    int mOffset = aPoints;
    int CoeffsOffsetBig = CoeffsOffset*(BigT+1);/* shifters for parameter set when reading output */
    int mOffsetBig = mOffset*(BigT+1);
    int OtherOffsetBig = (BigT+1);

    /* Quit if this thread is invalid */
    if (Gid >= SimPop*ParamCount) {return;}
    int ParamNum = Gid/SimPop;

    PosA = CoeffsOffsetBig*ParamNum;        /* beginning of this parameter set's coefficients */
    PosB = mOffsetBig*ParamNum;             /* beginning of this parameter set's m grid */
    PosC = OtherOffsetBig*ParamNum;         /* beginning of this parameter set's kappaMins */

    /* Simulate several periods of data */
    w = WealthInit[Gid];
        
    t = 0;
    while (t < SimPeriods) {

        Loc = t*SimPop*ParamCount + Gid;

        /* get this period's shocks */
        Theta = ThetaGrid[Loc];
        Psi = PsiGrid[Loc];
        Bequest = BequestVec[Loc];

        /* Calculate this period's Deltam */
        m = w + Theta + Bequest;
        Deltam = m - aLowerBoundLife[PosC+t];

        /* search for the correct segment of the m grid for this Deltam */
        Start = PosB + mOffset*t;
        Botj = 0;
        Topj = aPoints-1;
        Botm = mGridLifeAll[Start + Botj];
        Topm = mGridLifeAll[Start + Topj];
        Diffj = Topj - Botj;
        Newj = Botj + Diffj/2;
        Newm = mGridLifeAll[Start + Newj];
        if (Deltam < Botm) { /* If m is outside the grid bounds, this is easy */
            j = 0;
            Topm = Botm;
        }
        else if (Deltam > Topm) {
            j = aPoints;
            Botm = Topm;
        }
        else { /* Otherwise, perform a binary/golden search for the right segment */
            while (Diffj > 1) {
                if (Deltam < Newm) {
                    Topj = Newj;
                    Topm = Newm;
                }
                else {
                    Botj = Newj;
                    Botm = Newm;
                }
                Diffj = Topj - Botj;
                Newj = Botj + Diffj/2;
                Newm = mGridLifeAll[Start + Newj];
            }
            j = Topj;
        }

        /* pull the interpolation coefficients for this segment */
        Start = PosA + t*CoeffsOffset + 4*j;
        b0 = CoeffsLifeAll[Start+0];
        b1 = CoeffsLifeAll[Start+1];
        b2 = CoeffsLifeAll[Start+2];
        b3 = CoeffsLifeAll[Start+3];
        if (Topm > Botm) {
            Span = (Topm - Botm);
            mX = (Deltam - Botm)/Span;
        } else {
            Span = 1;
            mX = Deltam;
        }

        /* calculate consumption */
        c = b0 + mX*(b1 + mX*(b2 + mX*(b3)));
        c = min(c, Deltam - 0.000001);

        /* calculate the MPC with respect to wealth-to-income ratio */
        kappa = (b1 + mX*(2*b2 + mX*(3*b3)))/Span;

        /* find next period's wealth and record it */
        a = m - c;
        w = a*(RLife[t]/(FancyGLife[PosC+t]*Psi));
        WealthOut[Loc] = w;
        MPCout[Loc] = kappa;
        ConOut[Loc] = c; /* This line is only needed for FindAltMPC */

        /* Advance time one period */
        t++;
    } /* end of time loop */

} /* end of simulator kernel */



/* This kernel uses simulated wealth from the previous run to update the bequest received by each observation */
__kernel void CalculateBequest(
      __global double *WealthVec
    , __global double *BequestVec
    , __global int *FromVec
    , __global int *StartVec
    , __global int *CountVec
    , __global double *ScaleVec
    , __global int *IntegerInputs
) {

    /* Unpack the inputs */
    int ParamCount = IntegerInputs[4];      /* number of parameter sets to do this run */
    int SimPeriods = IntegerInputs[8];      /* number of periods to simulate */
    int SimPop = IntegerInputs[9];          /* number of individuals to simulate */

    /* Identify the thread number, quit if too high */
    int Gid = get_global_id(0);
    if (Gid >= SimPop*ParamCount) {
        return;
    }

    int id;
    int Start;
    int Count;
    int From;
    int Here;
    double Scale;
    double Bequest;
    double Temp;
    
    /* loop through each period of this individual's simulation */
    int t = 0;
    int j;
    while (t < SimPeriods) {
        id = Gid + t*SimPop*ParamCount;
        Start = StartVec[id];
        Count = CountVec[id];

        /* loop through each bequest left to this individual */
        j = 0;
        Bequest = 0;
        while (j < Count) {
            Here = Start + j;
            From = FromVec[Here];
            Temp = WealthVec[From];
            Scale = ScaleVec[Here];
            Bequest = Bequest + Temp*Scale;
            j++;
        }

        BequestVec[id] = Bequest;
        t++;
    }

} /* end of bequest calculator */
