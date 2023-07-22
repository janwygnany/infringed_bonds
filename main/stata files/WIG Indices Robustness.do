clear all

cd "/Users/janwygnany/Documents/GitHub/infringed_bonds/main/stata files"

*** start with data exploration:
*** import delimited "../data/WIG20.csv", varnames(1)
*** drop high low vol change
*** export delimited using "../data/WIG20_unworkable", replace
*** clear
***import delimited "../data/WIG_Banks.csv", varnames(1)
***drop high low vol change
***export delimited using "../data/WIGBanks_unworkable", replace
*** clear
*** issues dealt with in python for simplicity

import delimited "../data/WIG20_workable.csv", varnames(1)
drop v1
sort date
gen change_wig20 = (open-price)/open
drop price open day_of_week
save "wig20.dta",replace

use "master.dta"
drop _merge
merge m:1 date using "wig20.dta"

*** missing values on 2 significant dates:
***2020-03-11
***2021-11-30

drop if _merge == 2
drop tser
drop time
gen time = _n
tset time

reg change_wig20 L(0/5).infringementdummy L(0/5).rate_mom L(0/5).change_2Y, vce(cluster date)
reg change_wig20 L(0/5).ruleoflawdummy L(0/5).rate_mom, vce(cluster date)

save "master.dta", replace

import delimited "../data/WIGBanks_workable.csv", varnames(1)
drop v1
sort date
drop if day_of_week == "Sunday"
gen change_wigBanks = (open-price)/open
drop price open day_of_week
save "wigBanks.dta",replace

use "master.dta"
drop _merge
merge m:1 date using "wigBanks.dta"

drop if _merge == 2
drop time
gen time = _n
tset time

reg change_wigBanks L(0/5).infringementdummy L(0/5).rate_mom, vce(cluster date)
reg change_wigBanks L(0/5).ruleoflawdummy L(0/5).rate_mom, vce(cluster date)
reg change_wigBanks L(0/5).financialmarketsdummy L(0/5).rate_mom L(0/5).change_2Y, vce(cluster date)

