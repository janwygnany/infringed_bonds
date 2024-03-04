clear all
cd "/Users/janwygnany/Documents/GitHub/infringed_bonds/main/stata files"
import delimited "../data/DD/PL2Y_workable.csv"
sort date
merge m:1 date using "Infringement_1.dta"
replace infringementdummy = 0 if infringementdummy != 1
replace ruleoflawdummy = 0 if ruleoflawdummy !=1
replace budgetdummy = 0 if budgetdummy !=1
replace financialmarketsdummy = 0 if financialmarketsdummy !=1
sort date
drop _merge
save "master_DD.dta",replace
clear

import delimited "../data/DD/V4_workable.csv"
drop v1
save "V4.dta", replace
clear

use "master_DD.dta"
merge m:1 date using "rates.dta"
sort time
replace rate_mom = 0 if rate_mom == .
gen time = _n
tsset time
save "master_DD.dta",replace

*** merge m:1 date using "V4.dta"
*** drop _merge

reg pl2y_change budgetdummy ruleoflawdummy financialmarketsdummy L(1/5).budgetdummy L(1/5).ruleoflawdummy L(1/5).financialmarketsdummy rate_mom L(1/5).rate_mom, vce(robust)

reg pl2y_change ruleoflawdummy L(1/5).ruleoflawdummy rate_mom L(1/5).rate_mom, vce(cluster date)

