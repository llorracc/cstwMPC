clear 

cd "C:\Economics\JEDC project\BSinKS-private\cstCode\Latest\Code\Stata\KS"
* Current directory needs to be changed depending on working environment

infile dlCLev using "dlCLevUsedKS.txt"
gen t = _n
sort t
save "dlCLev.dta", replace
clear 

infile r using "RUsedKS.txt"
gen t = _n
sort t
save "r.dta", replace

merge t using "dlCLev.dta"
save "data.dta", replace

log using "results-EstimateEulerEq", replace text

/* Gen lag var */
gen r1=r[_n-1]

/* Estimate Euler Eq */
ivreg  dlCLev (r= r1)

* export coeff 
mat rcoeff = e(b)
svmat rcoeff
format rcoeff1 %3.2f  /* meaning that overall 3 nums including 2 below digit */
outfile  rcoeff1 using "rcoeff.tex" in 1, replace

* export std
mat rvar = e(V)
svmat rvar
gen  rstd =  (rvar1^0.5)
format rstd %3.2f 
outfile  rstd using "rstd.tex" in 1, replace


/* Examine Euler Eq errors */
predict e, resid
gen e1=e[_n-1]
corr e e1
reg e e1, nocon


/* Estimate corr of errors after controlling for predictable component*/
reg r r1
predict rpredict
gen rpredict1 = rpredict[_n-1]

replace rcoeff1 = rcoeff1[_n-1] if rcoeff1==.
replace rcoeff2 = rcoeff2[_n-1] if rcoeff2==.

gen epredict = dlCLev - (rcoeff1*rpredict + rcoeff2) 
gen epredict1=epredict[_n-1]
corr epredict epredict1
reg epredict epredict1, nocon

* export coeff 
mat e1coeff = e(b)
svmat e1coeff
format e1coeff1 %3.2f  /* meaning that overall 3 nums including 2 below digit */
outfile  e1coeff1 using "e1coeff.tex" in 1, replace

* export std
mat e1var = e(V)
svmat e1var
gen  e1std =  e1var^0.5
format e1std %3.2f  /* meaning that overall 3 nums including 2 below digit */
outfile  e1std using "e1std.tex" in 1, replace

/*
/* Remove transition periods */
ivreg  dlCLev (r= r1) if aggstate==1 | aggstate==3
*/

log close
