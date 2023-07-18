clear all

cd "/Users/janwygnany/Documents/GitHub/infringed_bonds/main/stata files"

use "master.dta"

irf set infringement_exo.irf, replace
lpirf  change_2Y rate_mom, lags(1/5) step(10) exog(L(0/5).budgetdummy L(0/5).ruleoflawdummy L(0/5).financialmarketsdummy)
irf create exog_model
irf graph dm, impulse(ruleoflawdummy) irf(exog_model) 
irf graph dm, impulse(budgetdummy) irf(exog_model)
