* This file i) calculates the fraction of households whose wealth level is between 0.5*mean and 1.5*mean, and ii) the distribution of wealth/permanent income ratio, using SCF2004
* This file closely follows codes written for SAS which create summary variables. 
* (These codes are available at http://www.federalreserve.gov/pubs/oss/oss2/bulletin.macro.txt)  

clear 
clear matrix

** Set memeory 
set memory 32m 
                   
** Load data and pick up necessary vars from original data
use y1 x42000 x42001 x5729 x6558 x6566 x6574 x6464 x6469 x6474 x6479 x6484 x6489 x6965 x6971 x6977 x6983 x6989 x6995 x7362 x5751 x7650 ///
    x3506 x3507 x3510 x3511 x3514 x3515 x3518 x3519 x3522 x3523 x3526 x3527 x3529 ///
    x3730 x3732 x3732 x3736 x3738 x3738 x3742 x3744 x3744 x3748 x3750 x3750 x3754 x3756 x3756 x3760 x3762 x3762 x3765 ///
    x3506 x3507 x9113 x9113 x3510 x3511 x9114 x9114 x3514 x3515 x9115 x9115 x3518 x3519 x9116 x9116 x3522 x3523 x9117 x9117 x3526 x3527 x9118 x9118 x3529 x3527 x9118 x9118 x3730 x3732 x9259 x9259 x3736 x3738 x9260 x9260 x3742 x3744 x9261 x9261 x3748 x3750 x9262 x9262 x3754 x3756 x9263 x9263 x3760 x3762 x9264 x9264 ///
    x3930 ///
    x3721 x3821 x3822 x3823 x3824 x3825 x3826 x3827 x3828 x3829 x3830 x7785 x7787 ///
    x3915 x3910 x3906 x3908 x7634 x7633 ///
    x6551 x6559 x6567 x6552 x6560 x6568 x6553 x6561 x6569 x6554 x6562 x6570 ///
    x11032 x11000 x11001 x11025 x11031 x11132 x11100 x11101 x11125 x11131 x11232 x11200 x11201 x11225 x11231 x11332 x11300 x11301 x11325 x11331 x11432 x11400 x11401 x11425 x11431 x11532 x11500 x11501 x11525 x11531 ///
    x11259 x11559 ///
    x3902 x4006 x6577 x6587 x4018 x4022 x4020 x4026 x4024 x4030 x4028 ///
    x8166 x8167 x8168 x8188 x2422 x2506 x2606 x2623 ///
    x507 x604 x614 x623 x716 x513 x526 x7134 x716 x701 x7133 ///
    x1405 x1409 x1505 x1509 x1605 x1609 x1619 x1703 x1706 x1705 x1803 x1806 x1805 x1903 x1906 x1905 x2002 x2012 x1715 x1815 x1915 x2016 x2723 x2710 x2740 x2727 x2823 x2810 x2840 x2827 x2923 x2910 x2940 x2927 ///
    x3129 x3124 x3126 x3127  x3121 x3122 x3122 x3229 x3224 x3226 x3227 x3221 x3222 x3222 x3329 x3324 x3326 x3327 x3321 x3322 x3322 x3335 x507 x513 x526 x3408 x3412 x3416 x3420 x3424 x3428 ///
    x4022 x4026 x4030 ///
    x805 x905 x1005 x1108 x1103 x1119 x1114 x1130 x1125 x1136 ///
    x1417 x1517 x1617 x1621 x2006 ///
    x1108 x1103 x1119 x1114 x1130 x1125 x1136 ///
    x427 x413 x421 x430 x424 x7575 ///
    x2218 x2318 x2418 x7169 x2424 x2519 x2619 x2625 x7183 x7824 x7847 x7870 x7924 x7947 x7970 x7179 x1044 x1215 x1219 ///
    x11027 x11070 x11127 x11170 x11227 x11270 x11327 x11370 x11427 x11470 x11527 x11570 ///
    x4010 x3932 x4032 ///
    x14 x19 x8020 x8023 x5902 x5904 x6102 x6104 ///
    using "scf2004.dta"

** Generate variables 
* ID
gen ID   = y1                  /* ID # */
gen HHID = (y1-mod(y1,10))/10  /* HH ID # */
gen YEAR = 2004                /* Indicates data is from which wave */

* Weight
gen WGT       = x42001



* Asset 
gen CHECKING = max(0,x3506)*(x3507==5)+max(0,x3510)*(x3511==5) ///
              +max(0,x3514)*(x3515==5)+max(0,x3518)*(x3519==5) ///
              +max(0,x3522)*(x3523==5)+max(0,x3526)*(x3527==5) ///
              +max(0,x3529)*(x3527==5) 
gen SAVING   = max(0,x3730*(x3732!=4 & x3732!=30)) ///
              +max(0,x3736*(x3738!=4 & x3738!=30)) ///
              +max(0,x3742*(x3744!=4 & x3744!=30)) ///
              +max(0,x3748*(x3750!=4 & x3750!=30)) ///
              +max(0,x3754*(x3756!=4 & x3756!=30)) ///
              +max(0,x3760*(x3762!=4 & x3762!=30))+max(0,x3765)
gen MMDA     = max(0,x3506)*((x3507==1)*(x9113>=11 & x9113<=13)) ///
              +max(0,x3510)*((x3511==1)*(x9114>=11 & x9114<=13)) ///
              +max(0,x3514)*((x3515==1)*(x9115>=11 & x9115<=13)) ///
              +max(0,x3518)*((x3519==1)*(x9116>=11 & x9116<=13)) ///
              +max(0,x3522)*((x3523==1)*(x9117>=11 & x9117<=13)) ///
              +max(0,x3526)*((x3527==1)*(x9118>=11 & x9118<=13)) ///
              +max(0,x3529)*((x3527==1)*(x9118>=11 & x9118<=13)) ///
              +max(0,x3730*(x3732==4|x3732==30)*(x9259>=11 & x9259<=13)) ///
              +max(0,x3736*(x3738==4|x3738==30)*(x9260>=11 & x9260<=13)) ///
              +max(0,x3742*(x3744==4|x3744==30)*(x9261>=11 & x9261<=13)) ///
              +max(0,x3748*(x3750==4|x3750==30)*(x9262>=11 & x9262<=13)) ///
              +max(0,x3754*(x3756==4|x3756==30)*(x9263>=11 & x9263<=13)) ///
              +max(0,x3760*(x3762==4|x3762==30)*(x9264>=11 & x9264<=13))
gen MMMF     = max(0,x3506)*((x3507==1)*(x9113<11 | x9113>13)) ///
              +max(0,x3510)*((x3511==1)*(x9114<11 | x9114>13)) ///
              +max(0,x3514)*((x3515==1)*(x9115<11 | x9115>13)) ///
              +max(0,x3518)*((x3519==1)*(x9116<11 | x9116>13)) ///
              +max(0,x3522)*((x3523==1)*(x9117<11 | x9117>13)) ///
              +max(0,x3526)*((x3527==1)*(x9118<11 | x9118>13)) ///
              +max(0,x3529)*((x3527==1)*(x9118<11 | x9118>13)) ///
              +max(0,x3730*(x3732==4|x3732==30)*(x9259<11 | x9259>13)) ///
              +max(0,x3736*(x3738==4|x3738==30)*(x9260<11 | x9260>13)) ///
              +max(0,x3742*(x3744==4|x3744==30)*(x9261<11 | x9261>13)) ///
              +max(0,x3748*(x3750==4|x3750==30)*(x9262<11 | x9262>13)) ///
              +max(0,x3754*(x3756==4|x3756==30)*(x9263<11 | x9263>13)) ///
              +max(0,x3760*(x3762==4|x3762==30)*(x9264<11 | x9264>13)) 
gen MMA      = MMDA+MMMF 
gen CALL     = max(0,x3930) 
gen LIQ      = CHECKING+SAVING+MMA+CALL 

gen CDS      = max(0,x3721) 
 gen STMUTF  = (x3821==1)*max(0,x3822) 
 gen TFBMUTF = (x3823==1)*max(0,x3824) 
 gen GBMUTF  = (x3825==1)*max(0,x3826) 
 gen OBMUTF  = (x3827==1)*max(0,x3828) 
 gen COMUTF  = (x3829==1)*max(0,x3830) 
 gen OMUTF   = (x7785==1)*max(0,x7787)
 gen SNMMF   = TFBMUTF+GBMUTF+OBMUTF+(.5*(COMUTF)) 
 gen RNMMF   = STMUTF + (.5*(COMUTF)) 
gen NMMF     = SNMMF + RNMMF + OMUTF
gen STOCKS   = max(0,x3915) 
 gen NOTXBND = x3910 
 gen MORTBND = x3906 
 gen GOVTBND = x3908 
 gen OBND    = x7634+x7633 
gen BOND     = NOTXBND + MORTBND + GOVTBND + OBND
 gen IRAKH   = x6551+x6559+x6567+x6552+x6560+x6568+x6553+x6561+x6569+x6554+x6562+x6570
 gen THRIFT  = max(0,x11032)*(x11000==5|x11000==6|x11000==10|x11001==2|x11001==3|x11001==4|x11001==6|x11025==1|x11031==1) /// 
              +max(0,x11132)*(x11100==5|x11100==6|x11100==10|x11101==2|x11101==3|x11101==4|x11101==6|x11125==1|x11131==1) ///
              +max(0,x11232)*(x11200==5|x11200==6|x11200==10|x11201==2|x11201==3|x11201==4|x11201==6|x11225==1|x11231==1) ///              
              +max(0,x11332)*(x11300==5|x11300==6|x11300==10|x11301==2|x11301==3|x11301==4|x11301==6|x11325==1|x11331==1) ///
              +max(0,x11432)*(x11400==5|x11400==6|x11400==10|x11401==2|x11401==3|x11401==4|x11401==6|x11425==1|x11431==1) ///
              +max(0,x11532)*(x11500==5|x11500==6|x11500==10|x11501==2|x11501==3|x11501==4|x11501==6|x11525==1|x11531==1) 
 gen PMOP    = x11259
 replace PMOP = 0 if x11259<=0
 replace PMOP = 0 if x11000!=0 & x11100!=0 & x11200!=0 & x11031!=0 & x11131!=0 & x11231!=0
 replace THRIFT = THRIFT + PMOP 
 replace  PMOP    = x11559
 replace PMOP = 0 if x11559<=0
 replace PMOP = 0 if x11300!=0 & x11400!=0 & x11500!=0 & x11331!=0 & x11431!=0 & x11531!=0
 replace THRIFT = THRIFT + PMOP 
gen RETQLIQ  = IRAKH+THRIFT
gen SAVBND   = x3902
gen CASHLI   = max(0,x4006)
 gen ANNUIT   = max(0,x6577)
 gen TRUSTS   = max(0,x6587)
gen OTHMA    = ANNUIT+TRUSTS
gen OTHFIN   = x4018 ///
              +x4022*(x4020==61|x4020==62|x4020==63|x4020==64|x4020==65|x4020==66|x4020==71| ///
                      x4020==72|x4020==73|x4020==74|x4020==77|x4020==80|x4020==81|x4020==-7) ///
              +x4026*(x4024==61|x4024==62|x4024==63|x4024==64|x4024==65|x4024==66|x4024==71| ///
                      x4024==72|x4024==73|x4024==74|x4024==77|x4024==80|x4024==81|x4024==-7) ///
              +x4030*(x4028==61|x4028==62|x4028==63|x4028==64|x4028==65|x4028==66|x4028==71| ///
                      x4028==72|x4028==73|x4028==74|x4028==77|x4028==80|x4028==81|x4028==-7)  
gen LiqFIN       = LIQ+CDS+NMMF+STOCKS+BOND        +SAVBND                     /* Total liquid fin asset */
gen LiqFINPlsRet = LIQ+CDS+NMMF+STOCKS+BOND+RETQLIQ+SAVBND                     /* Total liquid fin asset plus retirement assets*/
gen FIN          = LIQ+CDS+NMMF+STOCKS+BOND+RETQLIQ+SAVBND+CASHLI+OTHMA+OTHFIN /* Total fin asset */

gen VEHIC    = max(0,x8166)+max(0,x8167)+max(0,x8168)+max(0,x8188) ///
              +max(0,x2422)+max(0,x2506)+max(0,x2606)+max(0,x2623)
replace x507 = 9000 if x507 > 9000
gen HOUSES   = (x604+x614+x623+x716) + ((10000-x507)/10000)*(x513+x526)
 * replace HOUSES = (x7134/10000)*x716 if x701==-7 & x7133==1
gen ORESRE   = max(x1405,x1409)+max(x1505,x1509)+max(x1605,x1609)+max(0,x1619) ///
              +(x1703==12|x1703==14|x1703==21|x1703==22|x1703==25|x1703==40|x1703==41|x1703==42|x1703==43|x1703==44|x1703==49|x1703==50|x1703==52|x1703==999) ///
              *max(0,x1706)*(x1705/10000) ///
              +(x1803==12|x1803==14|x1803==21|x1803==22|x1803==25|x1803==40|x1803==41|x1803==42|x1803==43|x1803==44|x1803==49|x1803==50|x1803==52|x1803==999) ///
              *max(0,x1806)*(x1805/10000) ///
              +(x1903==12|x1903==14|x1903==21|x1903==22|x1903==25|x1903==40|x1903==41|x1903==42|x1903==43|x1903==44|x1903==49|x1903==50|x1903==52|x1903==999) ///
              *max(0,x1906)*(x1905/10000) ///
              +max(0,x2002)
gen NNRESRE  = (x1703==1|x1703==2|x1703==3|x1703==4|x1703==5|x1703==6|x1703==7|x1703==10|x1703==11|x1703==13|x1703==15|x1703==24|x1703==45|x1703==46|x1703==47|x1703==48|x1703==51|x1703==-7) ///
              *(max(0,x1706)*(x1705/10000)-x1715*(x1705/10000)) ///
              +(x1803==1|x1803==2|x1803==3|x1803==4|x1803==5|x1803==6|x1803==7|x1803==10|x1803==11|x1803==13|x1803==15|x1803==24|x1803==45|x1803==46|x1803==47|x1803==48|x1803==51|x1803==-7) ///
              *(max(0,x1806)*(x1805/10000)-x1815*(x1805/10000)) ///
              +(x1903==1|x1903==2|x1903==3|x1903==4|x1903==5|x1903==6|x1903==7|x1903==10|x1903==11|x1903==13|x1903==15|x1903==24|x1903==45|x1903==46|x1903==47|x1903==48|x1903==51|x1903==-7) ///
              *(max(0,x1906)*(x1905/10000)-x1915*(x1905/10000)) ///
              +max(0,x2012)-x2016
replace NNRESRE = NNRESRE-x2723*(x2710==78)-x2740*(x2727==78)-x2823*(x2810==78) ///
                 -x2840*(x2827==78)-x2923*(x2910==78)-x2940*(x2927==78) if NNRESRE!=0
gen FLAG781  = (NNRESRE!=0)
gen BUS      = max(0,x3129)+max(0,x3124)-max(0,x3126)*(x3127==5) ///
              +max(0,x3121)*(x3122==1|x3122==6) ///
              +max(0,x3229)+max(0,x3224)-max(0,x3226)*(x3227==5) ///
              +max(0,x3221)*(x3222==1|x3222==6) ///
              +max(0,x3329)+max(0,x3324)-max(0,x3326)*(x3327==5) ///
              +max(0,x3321)*(x3322==1|x3322==6) ///
              +max(0,x3335)+(x507/10000)*(x513+x526) ///
              +max(0,x3408)+max(0,x3412)+max(0,x3416)+max(0,x3420) ///
              +max(0,x3424)+max(0,x3428)
gen OTHNFIN  = x4022 + x4026 + x4030 - OTHFIN + x4018
gen NFIN     = VEHIC+HOUSES+ORESRE+NNRESRE+BUS+OTHNFIN
gen ASSET    = FIN+NFIN /* Total asset */

* Debt 
gen MRTHEL   = x805+x905+x1005+x1108*(x1103==1)+x1119*(x1114==1) ///
              +x1130*(x1125==1)+max(0,x1136)*(x1108*(x1103==1)+x1119*(x1114==1) ///
              +x1130*(x1125==1))/(x1108+x1119+x1130) if (x1108+x1119+x1130)>=1
replace MRTHEL = x805+x905+x1005+.5*(max(0,x1136)) if (x1108+x1119+x1130)<1
 gen MORT1    = (x1703==12|x1703==14|x1703==21|x1703==22|x1703==25|x1703==40|x1703==41|x1703==42|x1703==43|x1703==44|x1703==49|x1703==50|x1703==52|x1703==999) ///
               *x1715*(x1705/10000)
 gen MORT2    = (x1803==12|x1803==14|x1803==21|x1803==22|x1803==25|x1803==40|x1803==41|x1803==42|x1803==43|x1803==44|x1803==49|x1803==50|x1803==52|x1803==999) ///
               *x1815*(x1805/10000)
 gen MORT3    = (x1903==12|x1903==14|x1903==21|x1903==22|x1903==25|x1903==40|x1903==41|x1903==42|x1903==43|x1903==44|x1903==49|x1903==50|x1903==52|x1903==999) ///
               *x1915*(x1905/10000)
gen RESDBT   = x1417+x1517+x1617+x1621+MORT1+MORT2+MORT3+x2006
 gen FLAG782  = (FLAG781!=1 & ORESRE>0)
replace RESDBT = RESDBT+x2723*(x2710==78)+x2740*(x2727==78)+x2823*(x2810==78)+x2840*(x2827==78) ///
                +x2923*(x2910==78)+x2940*(x2927==78) if FLAG781!=1 & ORESRE>0
 gen FLAG67   = (ORESRE>0)
replace RESDBT= RESDBT+x2723*(x2710==67)+x2740*(x2727==67)+x2823*(x2810==67)+x2840*(x2827==67) ///
               +x2923*(x2910==67)+x2940*(x2927==67) if ORESRE>0 
gen OTHLOC   = x1108*(x1103!=1)+x1119*(x1114!=1)+x1130*(x1125!=1) ///
              +max(0,x1136)*(x1108*(x1103!=1)+x1119*(x1114!=1) ///
              +x1130*(x1125!=1))/(x1108+x1119+x1130) if (x1108+x1119+x1130)>=1
replace OTHLOC = .5*(max(0,x1136)) if (x1108+x1119+x1130)<1 
gen CCBAL    = max(0,x427)+max(0,x413)+max(0,x421)+max(0,x430)+max(0,x424)+max(0,x7575)
gen INSTALL  = x2218+x2318+x2418+x7169+x2424+x2519+x2619+x2625+x7183 ///
              +x7824+x7847+x7870+x7924+x7947+x7970+x7179+x1044+x1215+x1219
replace INSTALL = INSTALL+x2723*(x2710==78)+x2740*(x2727==78) ///
                 +x2823*(x2810==78)+x2840*(x2827==78)+x2923*(x2910==78)+x2940*(x2927==78) ///
                  if FLAG781==0 & FLAG782==0
replace INSTALL = INSTALL+x2723*(x2710==67)+x2740*(x2727==67)+x2823*(x2810==67) ///
                 +x2840*(x2827==67)+x2923*(x2910==67)+x2940*(x2927==67) if FLAG67==0
replace INSTALL = INSTALL+x2723*(x2710!=67&x2710!=78)+x2740*(x2727!=67&x2727!=78) ///
                 +x2823*(x2810!=67&x2810!=78)+x2840*(x2827!=67&x2827!=78)+x2923*(x2910!=67&x2910!=78) ///
                 +x2940*(x2927!=67&x2927!=78)
gen PENDBT   = max(0,x11027)*(x11070==5)+max(0,x11127)*(x11170==5) ///
              +max(0,x11227)*(x11270==5)+max(0,x11327)*(x11370==5) ///
              +max(0,x11427)*(x11470==5)+max(0,x11527)*(x11570==5)
gen CASHLIDB = max(0,x4010)
gen CALLDBT  = max(0,x3932)
gen ODEBT    = max(0,x4032)
gen DEBT     = MRTHEL+RESDBT+OTHLOC+CCBAL+INSTALL+PENDBT+CASHLIDB+CALLDBT+ODEBT /* Total debt */

* Net worth 
gen NETW     = ASSET-DEBT

* Adjust with CPI 
replace NETW = NETW*0.74


* Drop data, if age < 25 or >60 
gen AGE     = x14       /* Age */
drop if AGE < 25
drop if AGE > 60

* Income
gen PINCOME    = max(0,x5729)+x6558+x6566+x6574+max(0,x6464)+max(0,x6469) ///
               +max(0,x6474)+max(0,x6479)+max(0,x6484)+max(0,x6489) ///
               +max(0,x6965)+max(0,x6971)+max(0,x6977)+max(0,x6983) ///
               +max(0,x6989)+max(0,x6995)  /* Income before tax */
gen CINCOME    = PINCOME /* current income */	   
replace PINCOME = x7362 if x7650!=3
drop if PINCOME <=0  
replace PINCOME= PINCOME*0.76 /* Adjust with CPI (adjusted to 1992$ price) */   
sum PINCOME [weight= WGT]
gen NPINCOME = PINCOME /59451.66  /* P/M[P] */
sum NPINCOME  [weight= WGT]

* Calculate variance of p/M[p]
matrix std = r(sd)
matrix var = std*std
log using "results-variances", append text
* SCF2004
matrix list var 
log close

* Wealth (net worth) / perm inc ratio (note divided by quarterly perm inc)  
gen WYRATIO  = NETW/(PINCOME/4) 
gen MYRATIO  = (NETW+CINCOME/4)/(PINCOME/4) 
 * WYRATIO is wealth ratio to quraterly permanent income 

* Fraction of households whose wealth level is between 0.5*mean and 1.5*mean
sum NETW [weight= WGT] , d
gen NETWRatio = NETW/285327.1
sum NETWRatio [weight= WGT] 
gen dum=0 
replace dum=1 if NETWRatio>0.5 & NETWRatio<1.5 /* dum is 1 if net worth is between is between 0.5*mean and 1.5*mean*/
log using "results-fraction_between_05_and_15.txt", append text
* SCF2004
sum dum [weight=WGT] /* mean of dum is fraction of households whose wealth level is between 0.5*mean and 1.5*mean*/
log close

** WYRATIO by pecentile 
log using "results-WYDist", append text
* SCF2004
sum WYRATIO [weight= WGT]  if WYRATIO <10000, d
pctile pct = WYRATIO [weight=WGT] if WYRATIO <10000, nq(20) genp(percent)
list percent pct in 1/20

* MYRATIO by pecentile 
* SCF2004
sum MYRATIO [weight= WGT]  if MYRATIO <10000, d
pctile Mpct = MYRATIO [weight=WGT] if MYRATIO <10000, nq(20) genp(percentM)
list percentM Mpct in 1/20
log close 

* FINYRATIO (finanical assets/perm inc ratio) by percentile 
log using "results-WYDistFin", append text
* SCF2004
replace FIN    = FIN*0.74
gen FINYRATIO  = FIN/(PINCOME/4)
 
sum FINYRATIO [weight= WGT]  if FINYRATIO <10000, d
pctile pctF = FINYRATIO [weight=WGT] if FINYRATIO <10000, nq(40) genp(percentF)
list percentF  pctF in 1/40

* MFINYRATIO (current income + financial assets/perm inc ratio) by percentile 
* SCF2004
gen MFINYRATIO = (FIN+CINCOME*0.76/4)/(PINCOME/4) /* note that current inc in the prev yr was reported */
sum MFINYRATIO [weight= WGT]  if MFINYRATIO <10000, d
pctile pctMF = MFINYRATIO [weight=WGT] if MFINYRATIO <10000, nq(20) genp(percentMF)
list percentMF  pctMF in 1/20

log close


* LiqFINPlsRetYRATIO (liq financial assets plus ret assets/perm inc ratio) by percentile 
log using "results-WYDistLiqFINPlsRet", append text
* SCF2004
replace LiqFINPlsRet    = LiqFINPlsRet*0.74
gen LiqFINPlsRetYRATIO  = LiqFINPlsRet/(PINCOME/4)
 
sum LiqFINPlsRetYRATIO [weight= WGT]  if LiqFINPlsRetYRATIO <10000, d
pctile pctLiqFPlsRet = LiqFINPlsRetYRATIO [weight=WGT] if LiqFINPlsRetYRATIO <10000, nq(40) genp(percentLiqFPlsRet)
list percentLiqFPlsRet  pctLiqFPlsRet in 1/40

* MLiqFINPlsRetYRATIO (current income + liq financial assets plus ret asset/perm inc ratio) by percentile 
* SCF2004
gen MLiqFINPlsRetYRATIO = (LiqFINPlsRet+CINCOME*0.76/4)/(PINCOME/4) /* note that current inc in the prev yr was reported */
sum MLiqFINPlsRetYRATIO [weight= WGT]  if MLiqFINPlsRetYRATIO <10000, d
pctile pctMLiqFINPlsRet = MLiqFINPlsRetYRATIO [weight=WGT] if MLiqFINPlsRetYRATIO <10000, nq(20) genp(percentMLiqFINPlsRet)
list percentMLiqFINPlsRet  pctMLiqFINPlsRet in 1/20

log close


* LiqFINYRATIO (liquid financial assets/perm inc ratio) by percentile 
log using "results-WYDistLiqFIN", append text
* SCF2004
replace LiqFIN    = LiqFIN*0.74
gen LiqFINYRATIO  = LiqFIN/(PINCOME/4) 
sum LiqFINYRATIO [weight= WGT]  if LiqFINYRATIO <10000, d
pctile pctLiqF = LiqFINYRATIO [weight=WGT] if LiqFINYRATIO <10000, nq(20) genp(percentLiqF)
list percentLiqF  pctLiqF in 1/20

* MLiqFINYRATIO (current income + liquid financial assets/perm inc ratio) by percentile 
* SCF2004
gen MLiqFINYRATIO = (LiqFIN+CINCOME*0.76/4)/(PINCOME/4) /* note that current inc in the prev yr was reported */
sum MLiqFINYRATIO [weight= WGT]  if MLiqFINYRATIO <10000, d
pctile pctMLiqF = MLiqFINYRATIO [weight=WGT] if MLiqFINYRATIO <10000, nq(20) genp(percentMLiqF)
list percentMLiqF  pctMLiqF in 1/20

log close 



** Cumulative distribution of net worth
* normalize weight
gsort -NETW 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempNETW = NETW*WGT
egen float DistNETW = pc( TempNETW)
gen cumNETW     = DistNETW[1]
replace cumNETW = DistNETW[_n] + cumNETW[_n-1] if _n>1

* show net worth held by top x% (note that the order is reversed from RATIOS (above))
sum cumNETW [weight= WGT] , d
pctile pctcumNETW = cumNETW [weight=WGT], nq(20) genp(percentNETW)
list percentNETW pctcumNETW in 1/20

/*
* plot 
gen     percentile = WGT[1]
replace percentile = WGT[_n] + percentile[_n-1] if _n>1
replace percentile = (100-percentile*100)
gen CumNETWDist = 100-cumNETW
line CumNETWDist percentile
*/

* AGGREGATE Wealth (net worth) / perm inc ratio (note divided by quarterly perm inc)  
gen Temp = NETW * WGT
egen float MeanNETW = total(Temp)
drop Temp

gen Temp = PINCOME * WGT
egen float MeanPINCOME = total(Temp)
drop Temp

gen AggWYRATIO = MeanNETW/(MeanPINCOME/4)
mean AggWYRATIO /* show aggregate WYRATIO */

** Cumulative distribution of financial assets
* normalize weight
gsort -FIN 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempFIN = FIN*WGT
egen float DistFIN = pc( TempFIN)
gen cumFIN     = DistFIN[1]
replace cumFIN = DistFIN[_n] + cumFIN[_n-1] if _n>1

* show financial assets held by top x% (note that the order is reversed from RATIOS (above))
log using "results-FINCumDist", append text
* SCF2004
sum cumFIN [weight= WGT] , d
pctile pctcumFIN = cumFIN [weight=WGT], nq(20) genp(percentFIN)
list percentFIN pctcumFIN in 1/20

/*
* plot 
gen     percentileFIN = WGT[1]
replace percentileFIN = WGT[_n] + percentileFIN[_n-1] if _n>1
replace percentileFIN = (100-percentileFIN*100)
gen CumFINDist = 100-cumFIN
line CumFINDist percentileFIN
*/

* AGGREGATE financial assets / perm inc ratio (note divided by quarterly perm inc)  
gen Temp = FIN * WGT
egen float MeanFIN = total(Temp)
drop Temp
gen AggFINYRATIO = MeanFIN/(MeanPINCOME/4)
mean AggFINYRATIO /* show aggregate FINYRATIO */

log close


** Cumulative distribution of liq financial assets plus ret asset
* normalize weight
gsort -LiqFINPlsRet 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempLiqFINPlsRet = LiqFINPlsRet*WGT
egen float DistLiqFINPlsRet = pc( TempLiqFINPlsRet)
gen cumLiqFINPlsRet     = DistLiqFINPlsRet[1]
replace cumLiqFINPlsRet = DistLiqFINPlsRet[_n] + cumLiqFINPlsRet[_n-1] if _n>1

* show liq financial assets plus ret asset held by top x% (note that the order is reversed from RATIOS (above))
log using "results-LiqFINPlsRetCumDist", append text
* SCF2004
sum cumLiqFINPlsRet [weight= WGT] , d
pctile pctcumLiqFINPlsRet = cumLiqFINPlsRet [weight=WGT], nq(20) genp(percentLiqFINPlsRet)
list percentLiqFINPlsRet pctcumLiqFINPlsRet in 1/20

/*
* plot 
gen     percentileLiqFINPlsRet = WGT[1]
replace percentileLiqFINPlsRet = WGT[_n] + percentileLiqFINPlsRet[_n-1] if _n>1
replace percentileLiqFINPlsRet = (100-percentileLiqFINPlsRet*100)
gen CumLiqFINPlsRetDist = 100-cumLiqFINPlsRet
line CumLiqFINPlsRetDist percentileLiqFINPlsRet
*/

* AGGREGATE liq financial assets plus ret asset/ perm inc ratio (note divided by quarterly perm inc)  
gen Temp = LiqFINPlsRet * WGT
egen float MeanLiqFINPlsRet = total(Temp)
drop Temp
gen AggLiqFINPlsRetYRATIO = MeanLiqFINPlsRet/(MeanPINCOME/4)
mean AggLiqFINPlsRetYRATIO /* show aggregate LiqFINPlsRetYRATIO */

log close


***************
** Cumulative distribution of liquid financial assets
* normalize weight
gsort -LiqFIN 
egen float TempWGT = pc( WGT)
drop WGT
replace TempWGT = TempWGT/100
rename TempWGT WGT

* calculate cumulative distribution from the top 
gen TempLiqFIN = LiqFIN*WGT
egen float DistLiqFIN = pc( TempLiqFIN)
gen cumLiqFIN     = DistLiqFIN[1]
replace cumLiqFIN = DistLiqFIN[_n] + cumLiqFIN[_n-1] if _n>1

* show LiqFINancial assets held by top x% (note that the order is reversed from RATIOS (above))
log using "results-LiqFINCumDist", append text
* Summary of results: cumlative distriution of LiqFIN assets held by top x%
* SCF2004
sum cumLiqFIN [weight= WGT] , d
pctile pctcumLiqFIN = cumLiqFIN [weight=WGT], nq(20) genp(percentLiqFIN)
list percentLiqFIN pctcumLiqFIN in 1/20

/* 
* plot 
gen     percentileLiqFIN = WGT[1]
replace percentileLiqFIN = WGT[_n] + percentileLiqFIN[_n-1] if _n>1
replace percentileLiqFIN = (100-percentileLiqFIN*100)
gen CumLiqFINDist = 100-cumLiqFIN
line CumLiqFINDist percentileLiqFIN
*/

* AGGREGATE LiqFINancial assets / perm inc ratio (note divided by quarterly perm inc)  
gen Temp = LiqFIN * WGT
egen float MeanLiqFIN = total(Temp)
drop Temp
gen AggLiqFINYRATIO = MeanLiqFIN/(MeanPINCOME/4)
mean AggLiqFINYRATIO /* show aggregate LiqFINYRATIO */

log close 

* export and copy data for mathematica 
outfile MYRATIO       using "MYRATIOList.txt", replace      /* MYRatio */
outfile MLiqFINYRATIO using "MLiqFINYRATIO.txt", replace    /* Liq fin ratio  */
outfile MLiqFINPlsRetYRATIO using "MLiqFINPlsRetYRATIO.txt", replace    /* Liq fin ratio  */
outfile WGT           using "WGTList.txt", replace          /* WGT (weight) */

copy MYRATIOList.txt ../../Mathematica/WithAggShocks/MYRATIOList.txt, replace
copy MLiqFINYRATIO.txt ../../Mathematica/WithAggShocks/MLiqFINYRATIO.txt, replace
copy MLiqFINPlsRetYRATIO.txt ../../Mathematica/WithAggShocks/MLiqFINPlsRetYRATIO.txt, replace
copy WGTList.txt ../../Mathematica/WithAggShocks/WGTList.txt, replace

copy MYRATIOList.txt ../../Mathematica/WithAggPermShocks/MYRATIOList.txt, replace
copy MLiqFINYRATIO.txt ../../Mathematica/WithAggPermShocks/MLiqFINYRATIO.txt, replace
copy MLiqFINPlsRetYRATIO.txt ../../Mathematica/WithAggPermShocks/MLiqFINPlsRetYRATIO.txt, replace
copy WGTList.txt ../../Mathematica/WithAggPermShocks/WGTList.txt, replace


