clear 
set more off
capture log close

global voting "C:/Users/wb478787/Dropbox/MORE - DEC/MORE_temp/Temporary Esha/Voting_Lasso/Final Tables_Data_Code/Tables/Feb23/Data"
log using "$voting/Table_4_OA11_OA16.log", replace

*Generates Table 4, OA11, and OA16

use "$voting/Female_Voting_Lasso.dta", clear

merge m:1 neighborhood_code using "$voting/Prob_weights_bound_cluster.dta", keepusing(actual_prob weight_t1 bound_1)
ren actual_prob prob_t1
drop _m

*Final Lasso Controls
local controls1 "NAregist_vot_F hhsize age nc05 nall tv_access mobil_ins_allow advice_pir"

su `controls1'

gen d_hhsize=0
replace d_hhsize=1 if hhsize==.
replace hhsize=0 if hhsize==.

****TABLE 4***

***WLS with Controls***

xi: reg v_noinknovote t1_nocc t2_nocc `controls1' d_hhsize d_age d_num_child0to5  i.village_code  [iweight=weight_t1] , cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test t1_nocc = t2_nocc 
local test1=r(p)
test t1_nocc  t2_nocc 
local test2=r(p)
outreg2 t1_nocc t2_nocc using "$voting/Table4.xls", replace bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(t1_nocc t2_nocc)

***WLS with Controls***

xi:reg v_noinknovote cc1 cc2   `controls1'  d_hhsize d_age d_num_child0to5 i.village_code  [iweight=weight_t1] , cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test cc1=cc2
local test1=r(p)
test cc1 cc2
local test2=r(p)
outreg2 cc1 cc2 using "$voting/Table4.xls", append bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(cc1 cc2)

***TABLE OA11***

***WLS without covariates***

xi: reg v_noinknovote t1_nocc t2_nocc i.village_code [iweight=weight_t1], cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test t1_nocc =t2_nocc 
local test1=r(p)
test t1_nocc  t2_nocc 
local test2=r(p)
outreg2 t1_nocc t2_nocc using "$voting/TableOA11.xls", replace bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(t1_nocc t2_nocc)

***OLS with probability of being assigned to T1 as additional covariate***

xi: reg v_noinknovote t1_nocc t2_nocc  `controls1' d_hhsize d_age d_num_child0to5 prob_t1 i.village_code  , cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test t1_nocc =t2_nocc 
local test1=r(p)
test t1_nocc  t2_nocc 
local test2=r(p)
outreg2 t1_nocc t2_nocc using "$voting/TableOA11.xls", append bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(t1_nocc t2_nocc)

***OLS without boundary clusters***

xi: reg v_noinknovote t1_nocc t2_nocc  `controls1' d_hhsize d_age d_num_child0to5  i.village_code  if bound_1==0, cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test t1_nocc =t2_nocc 
local test1=r(p)
test t1_nocc  t2_nocc 
local test2=r(p)
outreg2 t1_nocc t2_nocc using "$voting/TableOA11.xls", append bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(t1_nocc t2_nocc)

***WLS without covariates***

xi:reg v_noinknovote cc1 cc2 i.village_code [iweight=weight_t1], cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test cc1=cc2
local test1=r(p)
test cc1 cc2
local test2=r(p)
outreg2 cc1 cc2 using "$voting/TableOA11.xls", append bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(cc1 cc2)

***OLS with probability of being assigned to T1 as additional covariate***

xi:reg v_noinknovote cc1 cc2   `controls1'  d_hhsize d_age d_num_child0to5 prob_t1 i.village_code, cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test cc1=cc2
local test1=r(p)
test cc1 cc2
local test2=r(p)
outreg2 cc1 cc2 using "$voting/TableOA11.xls", append bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(cc1 cc2)

***OLS without boundary clusters***

xi:reg v_noinknovote cc1 cc2   `controls1'  d_hhsize d_age d_num_child0to5 i.village_code if bound_1==0, cl(neighborhood_code)
sum v_noinknovote if e(sample)==1 & t_m==0
local ymean=r(mean)
display `ymean'
test cc1=cc2
local test1=r(p)
test cc1 cc2
local test2=r(p)
outreg2 cc1 cc2 using "$voting/TableOA11.xls", append bracket dec(3) addstat ("test1", `test1', "test2", `test2') keep(cc1 cc2)

***TABLE OA16***

***Pooled Regressions***

**targeted t1 and t2
gen tag_t1 =1 if t1 ==1 
replace tag_t1 =0 if tag_t1 ==.

gen tag_t2 = 1 if t2==1
replace tag_t2 = 0 if tag_t2 ==.

**untargeted t1 and t2
gen untag_t1 = 1 if t1==0 & t1_m==1
replace untag_t1 = 0 if untag_t1 ==.

gen untag_t2 = 1 if t2==0 & t2_m==1
replace untag_t2 = 0 if untag_t2 ==.

local controls1 "NAregist_vot_F hhsize age nc05 nall tv_access mobil_ins_allow advice_pir"

***WLS with Controls***

xi:reg v_noinknovote tag_t1 tag_t2 untag_t1 untag_t2 `controls1'  d_hhsize d_age d_num_child0to5 i.village_code [iweight=weight_t1], cl(neighborhood_code)
test tag_t1=untag_t1
local test1=r(p)
test tag_t1=untag_t2
local test2=r(p)
outreg2 using "$voting/TableOA16.xls", replace bracket dec(3) addstat ("test_t1", `test1', "test_t2", `test2') keep(tag_t1 tag_t2 untag_t1 untag_t2)

log close
