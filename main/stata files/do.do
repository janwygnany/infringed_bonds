clear all

cd "/Users/janwygnany/Documents/GitHub/infringed_bonds/main/stata files"
import delimited "../data/bonds_complete2.csv"
drop v1 unnamed
sort dates
rename dates date
rename closing_values close_2Y
rename opening_values open_2Y
gen change_2Y = (open_2Y-close_2Y)/open_2Y
gen time = _n
tsset time
save "Poland-2Y.dta", replace
clear

import delimited "../data/Infringement_2.csv"
sort date
save "Infringement_1.dta", replace
use "Infringement_1.dta",clear
use "Poland-2Y.dta"
sort date
save, replace

merge m:1 date using "Infringement_1.dta"
replace infringementdummy = 0 if infringementdummy != 1
replace ruleoflawdummy = 0 if ruleoflawdummy !=1
replace budgetdummy = 0 if budgetdummy !=1
replace financialmarketsdummy = 0 if financialmarketsdummy !=1
sort date
save "master.dta",replace

clear all

import delimited "../data/rates_2.csv"
sort date
save "rates.dta",replace
clear all

use "master.dta"
drop _merge
merge m:1 date using rates.dta
sort time
replace rate_mom = 0 if rate_mom == .
save "master.dta",replace

twoway line rate_mom time
twoway line open_2Y time


reg change_2Y budgetdummy ruleoflawdummy financialmarketsdummy L(1/5).budgetdummy L(1/5).ruleoflawdummy L(1/5).financialmarketsdummy rate_mom L(1/5).rate_mom, vce(robust)
reg change_2Y ruleoflawdummy L(1/5).ruleoflawdummy rate_mom L(1/5).rate_mom, vce(cluster date)
reg change_2Y rate_mom L(1/5).rate_mom, vce(robust)

reg close_2Y infringementdummy

export delimited using "bonds_master_stata", replace

quietly lpirf  change_2Y budgetdummy ruleoflawdummy financialmarketsdummy, lags(1/12) step(24)
