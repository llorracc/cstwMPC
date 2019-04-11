
**********************************************************************************
* Calculates correlations between aggregate series
**********************************************************************************

clear
#delimit;
version 8.0;

gr drop _all; discard;
global basePath "C:\Jirka\Research\cstCode\20120522\Software\Stata\aggregate\";
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;

cd $basePath;

capture log close;
log using $basePath\calculatecorrelations_01.log, replace;
set more off;

***********************************************************************************;
global startSample  "1960q1";
global endSample  "2011q4";

***********************************************************************************;

use $basePath\aggregateUSdata.dta;

gen t =  q(1950q1)+_n-1;
format t %tq;
tsset t;

gen ndsC_real=nondurablesc_real+servicesc_real;
gen ndsC_nominal=nondurablesc_nominal+servicesc_nominal;
gen ndsC_price=ndsC_nominal/ndsC_real;
gen infl=100*(log(ndsC_price/L4.ndsC_price));
gen ir_real=tb_nominal-infl;

gen cGrowth_1=400*(log(ndsC_real/L.ndsC_real));
gen yGrowth_1=400*(log(ydisp_real/L.ydisp_real));
gen cGrowth_4=100*(log(ndsC_real/L4.ndsC_real));
gen yGrowth_4=100*(log(ydisp_real/L4.ydisp_real));
gen cGrowth_8=50*(log(ndsC_real/L8.ndsC_real));
gen yGrowth_8=50*(log(ydisp_real/L8.ydisp_real));

gen cGrowth_total_1=400*(log(totalc_real/L.totalc_real));

*** Correlations;
correlate cGrowth_1 L.cGrowth_1;
sca rho_cons1_Lcons1=r(rho);

correlate cGrowth_1 yGrowth_1;
sca rho_cons1_inc1=r(rho);

correlate cGrowth_1 L.yGrowth_1;
sca rho_cons1_Linc1=r(rho);

correlate cGrowth_1 L2.yGrowth_1;
sca rho_cons1_L2inc1=r(rho);

correlate cGrowth_1 ir_real;
sca rho_cons1_ir=r(rho);

correlate cGrowth_1 L.ir_real;
sca rho_cons1_Lir=r(rho);

correlate cGrowth_4 yGrowth_4;
sca rho_cons4_inc4=r(rho);

correlate cGrowth_8 yGrowth_8;
sca rho_cons8_inc8=r(rho);

disp "cLc " rho_cons1_Lcons1;
disp "cy " rho_cons1_inc1;
disp "cLy " rho_cons1_Linc1;
disp "cL2y " rho_cons1_L2inc1;
disp "cr " rho_cons1_ir;
disp "cLr " rho_cons1_Lir;
disp "4c4y " rho_cons4_inc4;
disp "8c8y " rho_cons8_inc8;

**************************************************
log close;