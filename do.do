clear all

cd "/Users/janwygnany/U-Turn Folder/bonds"
import delimited "Poland 2-Year Bond Yield Historical Data(1).csv"
rename price close_2Y
rename open open_2Y
drop low high change
gen change_2Y = (open_2Y-close_2Y)/open_2Y
gen time = _n
tsset time
save "Poland-2Y.dta", replace
clear

import delimited "Infringement_1.csv"
sort date
save "Infringement_1.dta", replace
use "Infringement_1.dta",clear
use "Poland-2Y.dta"
sort date 
save, replace
merge 1:1 date using "Infringement_1.dta"
drop _merge
replace infringementdummy = 0 if infringementdummy != 1
replace ruleoflawdummy = 0 if ruleoflawdummy !=1
replace budgetdummy = 0 if budgetdummy !=1
replace financialmarketsdummy = 0 if financialmarketsdummy !=1
save "master.dta",replace

clear all

import delimited "rates.csv"
sort date
save "rates.dta",replace
clear all

use "master.dta"
merge 1:1 date using rates.dta
sort time
replace rate_mom = 0 if rate_mom == .
save "master.dta",replace

twoway line rate_mom time
replace time = 2806-_n
sort time


reg change_2Y budgetdummy ruleoflawdummy financialmarketsdummy L(1/5).budgetdummy L(1/5).ruleoflawdummy L(1/5).financialmarketsdummy rate_mom L(1/5).rate_mom, vce(robust)
reg change_2Y ruleoflawdummy L(1/5).ruleoflawdummy rate_mom L(1/5).rate_mom, vce(cluster date)
reg change_2Y rate_mom L(1/5).rate_mom, vce(robust)

reg close_2Y infringementdummy

export delimited using "bonds_master_stata", replace
