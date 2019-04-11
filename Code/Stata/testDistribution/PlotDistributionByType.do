* this file plots the distribution of MPCs by (impatience) type
* data are from the dist seven model under agg shocks

clear 

cd "C:\Economics\JEDC project\BSinKS-private\cstCode\Latest\Code\Mathematica\WithAggShocks"
* Current directory needs to be changed depending on working environment.


infile kRattNormalizedByw using "kRattNormalizedByw.txt"
gen t = _n
sort t
save "kRattNormalizedByw.dta", replace
clear 

infile cRattNormalizedByw using "cRattNormalizedByw.txt"
gen t = _n
sort t
save "cRattNormalizedByw.dta", replace
clear 

infile mRattNormalizedByw using "mRattNormalizedByw.txt"
gen t = _n
sort t
save "mRattNormalizedByw.dta", replace
clear 

infile cLevt using "cLevt.txt"
gen t = _n
sort t
save "cLevt.dta", replace
clear 

infile MPCsList using "MPCsList.txt"
gen t = _n
sort t
save "MPCsList.dta", replace
clear 

infile MPCsListLiqFinPlsRet using "MPCsListLiqFinPlsRet.txt"
gen t = _n
sort t
save "MPCsListLiqFinPlsRet.dta", replace
clear 

infile PatientIndicatorList using "PatientIndicatorList.txt"
gen t = _n
sort t
save "tempdata.dta", replace


merge t using "cRattNormalizedByw.dta"
drop _merge
sort t
save "tempdata.dta", replace


merge t using "kRattNormalizedByw.dta"
drop _merge
sort t
save "tempdata.dta", replace

merge t using "mRattNormalizedByw.dta"
drop _merge
sort t
save "tempdata.dta", replace

merge t using "cLevt.dta"
drop _merge
sort t
save "tempdata.dta", replace

merge t using "MPCsList.dta"
drop _merge
sort t
save "tempdata.dta", replace

merge t using "MPCsListLiqFinPlsRet.dta"
drop _merge
sort t
save "tempdata.dta", replace


*** clean up folder 
erase "kRattNormalizedByw.dta"
erase "cRattNormalizedByw.dta"
erase "mRattNormalizedByw.dta"
erase "cLevt.dta"
erase "MPCsList.dta"
erase "MPCsListLiqFinPlsRet.dta"
erase "tempdata.dta"


*** gen vars and data analysis 
gen PatientIndicator7 = (PatientIndicatorList==7)
gen PatientIndicator6 = (PatientIndicatorList==6)
gen PatientIndicator5 = (PatientIndicatorList==5)
gen PatientIndicator4 = (PatientIndicatorList==4)
gen PatientIndicator3 = (PatientIndicatorList==3)
gen PatientIndicator2 = (PatientIndicatorList==2)
gen PatientIndicator1 = (PatientIndicatorList==1)


* bot 20 pct of kRat
egen kRatBot20PctThreshold  = pctile(kRattNormalizedByw), p(20)
gen DumkRattBot20PctList = 0
replace DumkRattBot20PctList=1 if kRattNormalizedByw<kRatBot20PctThreshold

* share of most impatient in the bottom 20%
sum PatientIndicator7 ///
    PatientIndicator6 ///
    PatientIndicator5 ///
    PatientIndicator4 ///
	PatientIndicator3 ///
	PatientIndicator2 ///
	PatientIndicator1 if DumkRattBot20PctList==1


*fraction of most impatient whose krat (to income) is in the bottom 20%
sum DumkRattBot20PctList if PatientIndicatorList==7
sum DumkRattBot20PctList if PatientIndicatorList==6
sum DumkRattBot20PctList if PatientIndicatorList==5
sum DumkRattBot20PctList if PatientIndicatorList==4
sum DumkRattBot20PctList if PatientIndicatorList==3
sum DumkRattBot20PctList if PatientIndicatorList==2
sum DumkRattBot20PctList if PatientIndicatorList==1



*** show graphs
* histogram  kRattNormalizedByw if  kRattNormalizedByw<=20, bin(20) by(PatientIndicatorList)
* histogram  cRattNormalizedByw if  cRattNormalizedByw<=20, bin(20) by(PatientIndicatorList)
* histogram  mRattNormalizedByw if  mRattNormalizedByw<=20, bin(20) by(PatientIndicatorList)
* histogram  cLevt if  cLevt<=20, bin(20) by(PatientIndicatorList)

* AnnualMPC
gen AnnualMPC = 1-(1-MPCsList)^4


gen     Type = "Most impatient" if PatientIndicatorList==7
replace Type = "6th patient" if PatientIndicatorList==6
replace Type = "5th patient" if PatientIndicatorList==5
replace Type = "4th patient" if PatientIndicatorList==4
replace Type = "3rd patient" if PatientIndicatorList==3
replace Type = "2nd patient" if PatientIndicatorList==2
replace Type = "1st patient" if PatientIndicatorList==1

* histogram  AnnualMPC if  AnnualMPC<=1, width(0.05)   percent normal by(PatientIndicatorList)

histogram  AnnualMPC if  AnnualMPC<=1, width(0.05)   percent xtitle(Annual MPC) xmtick(##5, labels) by(Type) 
* graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) bgcolor(white)

 * needs to edit the graph a bit after running "histogram"

* graph export "AnnualMPCDistSevenAggShocksByType.eps", as(eps) preview(on) replace     /* create eps file */

/*
* AnnualMPCsListLiqFinPlsRet
gen AnnualMPCsListLiqFinPlsRet = 1-(1-MPCsListLiqFinPlsRet)^4
histogram  AnnualMPCsListLiqFinPlsRet if  AnnualMPCsListLiqFinPlsRet<=1, bin(20)  percent by(PatientIndicatorList)
*/

cd "C:\Economics\JEDC project\BSinKS-private\cstCode\Latest\Code\Stata\testDistribution"

log using "results-DistributionByType", replace text

sum AnnualMPC if PatientIndicatorList==7
sum AnnualMPC if PatientIndicatorList==6
sum AnnualMPC if PatientIndicatorList==5
sum AnnualMPC if PatientIndicatorList==4
sum AnnualMPC if PatientIndicatorList==3
sum AnnualMPC if PatientIndicatorList==2
sum AnnualMPC if PatientIndicatorList==1

log close







