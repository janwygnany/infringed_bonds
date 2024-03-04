clear all

cd "/Users/janwygnany/Documents/GitHub/infringed_bonds/main/stata files"
import delimited "../data/bonds_complete2.csv"
drop v1 unnamed
sort dates
drop change
rename dates date
rename closing_values close
rename opening_values open
gen change = (open-close)/open
gen time = _n
tsset time
save "Poland-TBSP.dta", replace
clear

import delimited "../data/Infringement_2.csv"
sort date
save "Infringement_1.dta", replace
use "Infringement_1.dta",clear
use "Poland-TBSP.dta"
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
merge m:1 date using "rates.dta"
sort time
replace rate_mom = 0 if rate_mom == .
drop _merge
save "master.dta",replace

twoway line rate_mom time
twoway line open time


reg change budgetdummy ruleoflawdummy financialmarketsdummy L(1/5).budgetdummy L(1/5).ruleoflawdummy L(1/5).financialmarketsdummy rate_mom L(1/5).rate_mom, vce(robust)
reg change ruleoflawdummy L(1/5).ruleoflawdummy rate_mom L(1/5).rate_mom, vce(cluster date)
reg change rate_mom L(1/5).rate_mom, vce(robust)
reg change L(4/5).ruleoflawdummy L(0/5).rate_mom, vce(robust)

reg change L(4/5).ruleoflawdummy L(0/5).rate_mom, vce(robust)

reg close infringementdummy, vce(robust)

reg open L(0/5).rate_mom, vce(robust)

export delimited using "bonds_master_stata", replace


import delimited "../data/Infringement_Langier_Dates.csv"
merge m:1 date using "master.dta"
sort date

replace letter_of_formal_notice = 0 if letter_of_formal_notice != 1
replace reasoned_opinion = 0 if reasoned_opinion != 1
replace court = 0 if court != 1
replace interim_measures = 0 if interim_measures != 1
replace judgement = 0 if judgement != 1
save "master.dta",replace

use "master.dta"
sort date
reg change L(0/5).letter_of_formal_notice L(0/5).rate_mom, vce(robust)
reg change L(0/5).reasoned_opinion L(0/5).rate_mom, vce(robust)
reg change L(0/5).interim_measures L(0/5).rate_mom, vce(robust)

reg change L(0/5).reasoned_opinion L(0/5).court L(0/5).interim_measures L(0/5).rate_mom, vce(robust)
outreg2 using "regression_table.tex", replace
estout, replace tex("regression_table.tex") label title("Regression Results") type

irf set infringement_exo.irf, replace
lpirf  close rate_mom, lags(1/5) step(10) exog(reasoned_opinion)
irf create exog_model
irf graph dm, impulse(reasoned_opinion) irf(exog_model) 






