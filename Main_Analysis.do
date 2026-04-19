// =========================================================
// Impact Evaluation Project - Explanatory Analysis
// Authors: Lorenzo and Sofia
// =========================================================

clear all

// --- 0. REQUIRED PACKAGES INSTALLATION ---
// ssc install ftools, replace
// ssc install reghdfe, replace
// ssc install estout, replace
// ssc install drdid, replace
// ssc install csdid, replace
// ssc install coefplot, replace
// ssc install require, replace

// --- 1. Directories & Setup ---
global root "."
global raw "$root/ESS_Dataset/raw"
global clean "$root/ESS_Dataset/clean"
global Output "$root/Output"
// Load the dataset
use "$raw/ESS_ALL.dta", clear


// =========================================================
// --- 2. DATA CLEANING ---
// =========================================================

replace trstplt = . if inlist(trstplt, 77, 88, 99) 
replace trstprt = . if inlist(trstprt, 77, 88, 99) 
replace yrbrn = . if inlist(yrbrn, 7777, 8888, 9999)
replace gndr = . if gndr == 9
replace edulvlfa = . if inlist(edulvlfa, 55, 77, 88, 99)
replace edulvlma = . if inlist(edulvlma, 55, 77, 88, 99)
replace brncntr = . if inlist(brncntr, 7, 8, 9)
replace trstplc = . if inlist(trstplc, 77, 88, 99)
replace trstlgl = . if inlist(trstlgl, 77, 88, 99)
replace domicil = . if inlist(domicil, 7, 8, 9)
replace dclmig = . if inlist(dclmig, 7, 8, 9)
replace dmcntov = . if inlist(dmcntov, 77, 88, 99)
replace euftf = . if inlist(euftf, 77, 88, 99)
replace freehms = . if inlist(freehms, 7, 8, 9)
replace gincdif = . if inlist(gincdif, 7, 8, 9)
replace hmsacld = . if inlist(hmsacld, 7, 8, 9)
replace hmsfmlsh = . if inlist(hmsfmlsh, 7, 8, 9)
replace implvdm = . if inlist(implvdm, 77, 88, 99)
replace polintr = . if inlist(polintr, 7, 8, 9)
replace prtyban = . if inlist(prtyban, 7, 8, 9)
replace stfdem = . if inlist(stfdem, 77, 88, 99)
replace stfedu = . if inlist(stfedu, 77, 88, 99)
replace vote = . if inlist(vote, 7, 8, 9)

generate fthr_occup_14 = .
replace fthr_occup_14 = occf14 if !missing(occf14)
replace fthr_occup_14 = occf14a if !missing(occf14a)
replace fthr_occup_14 = occf14b if !missing(occf14b)
replace fthr_occup_14 = . if inlist(fthr_occup_14, 66, 77, 88, 99)

generate mthr_occup_14 = .
replace mthr_occup_14 = occm14 if !missing(occm14)
replace mthr_occup_14 = occm14a if !missing(occm14a)
replace mthr_occup_14 = occm14b if !missing(occm14b)
replace mthr_occup_14 = . if inlist(mthr_occup_14, 66, 77, 88, 99)

replace emprf14 = . if inlist(emprf14, 7, 8, 9)
replace emprm14 = . if inlist(emprm14, 7, 8, 9)
replace facntr = . if inlist(facntr, 7, 8, 9)
replace mocntr = . if inlist(mocntr, 7, 8, 9)
replace blgetmg = . if inlist(blgetmg, 7, 8, 9)


// =========================================================
// --- 3. VARIABLE CREATION ---
// =========================================================

generate male = .
replace male = 1 if gndr == 1
replace male = 0 if gndr == 2 

generate vote_dummy = .
replace vote_dummy = 1 if vote == 1
replace vote_dummy = 0 if vote == 2

generate pivotal_cohort = .
replace pivotal_cohort = 1991 if cntry == "AL"
replace pivotal_cohort = 1976 if cntry == "BE"
replace pivotal_cohort = 1989 if cntry == "BG"
replace pivotal_cohort = 1990 if cntry == "HR"
replace pivotal_cohort = 1986 if cntry == "CZ"
replace pivotal_cohort = 1983 if cntry == "FR"
replace pivotal_cohort = 1994 if cntry == "DE"
replace pivotal_cohort = 1986 if cntry == "HU"
replace pivotal_cohort = 1986 if cntry == "IT"
replace pivotal_cohort = 1988 if cntry == "LT"
replace pivotal_cohort = 1948 if cntry == "LU"
replace pivotal_cohort = 1988 if cntry == "MK"
replace pivotal_cohort = 1979 if cntry == "NL"
replace pivotal_cohort = 1990 if cntry == "PL"
replace pivotal_cohort = 1986 if cntry == "PT"
replace pivotal_cohort = 1988 if cntry == "RO"
replace pivotal_cohort = 1987 if cntry == "SK"
replace pivotal_cohort = 1987 if cntry == "SI"
replace pivotal_cohort = 1985 if cntry == "ES"
replace pivotal_cohort = 1992 if cntry == "SE"
replace pivotal_cohort = 1942 if cntry == "GB"

generate post_treatment = 0 if !missing(yrbrn)
replace post_treatment = 1 if (yrbrn >= pivotal_cohort) & !missing(pivotal_cohort)

generate dstnc_frm_pvtl_cohort = 0
replace dstnc_frm_pvtl_cohort = yrbrn - pivotal_cohort


// =========================================================
// --- 4. SAVE CLEANED DATASET ---
// =========================================================
save "$clean/ESS_ALL_clean.dta", replace


// =========================================================
// --- 5. EXPLORATORY DATA ANALYSIS ---
// =========================================================
summarize trstplt trstprt yrbrn male edulvlfa edulvlma brncntr trstplc trstlgl domicil
tabstat trstplt, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)


// *********************************************************
// SECTION 6: BASELINE NAIVE DiD (TWFE) - WITH WAVE FE
// *********************************************************

eststo clear
quietly eststo: reghdfe freehms i.male##i.post_treatment, absorb(cntry yrbrn essround) cluster(cntry)
quietly eststo: reghdfe freehms i.male##i.post_treatment edulvlfa, absorb(cntry yrbrn essround) cluster(cntry)
quietly eststo: reghdfe freehms i.male##i.post_treatment edulvlfa edulvlma, absorb(cntry yrbrn essround) cluster(cntry)
quietly eststo: reghdfe freehms i.male##i.post_treatment edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, absorb(cntry yrbrn essround) cluster(cntry)

esttab using "$Output/Baseline_TWFE_Table_FINAL.rtf", replace label se b(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(1.male#1.post_treatment 1.male 1.post_treatment) order(1.male#1.post_treatment) ///
    mtitle("Baseline" "+ Father" "+ Parents" "+ All") scalars("N Observations" "r2_within Within R-sq.") ///
    title("Table 1: Naive TWFE Effect with Country, Birth Year, and Wave FE") ///
    addnotes("Standard errors clustered at country level." "Fixed effects: Country, Birth Year, and Survey Wave.")


// *********************************************************
// SECTION 7: EVENT STUDY (TWFE VERSION) - WITH WAVE FE
// *********************************************************

capture drop event_time time_pos
generate event_time = dstnc_frm_pvtl_cohort
replace event_time = -10 if event_time <= -10
replace event_time = 10 if event_time >= 10
generate time_pos = event_time + 15

reghdfe freehms i.male##ib14.time_pos edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, absorb(cntry yrbrn essround) cluster(cntry)

coefplot, keep(1.male#*.time_pos) baselevels omitted vertical yline(0, lcolor(black)) xline(10.5, lcolor(red) lpattern(dash)) ///
    ciopts(recast(rcap) color(gs7)) msymbol(O) mcolor(navy) ///
    coeflabels(1.male#5.time_pos="-10" 1.male#6.time_pos="-9" 1.male#7.time_pos="-8" 1.male#8.time_pos="-7" ///
               1.male#9.time_pos="-6" 1.male#10.time_pos="-5" 1.male#11.time_pos="-4" 1.male#12.time_pos="-3" ///
               1.male#13.time_pos="-2" 1.male#14.time_pos="-1" 1.male#15.time_pos="0" 1.male#16.time_pos="1" ///
               1.male#17.time_pos="2" 1.male#18.time_pos="3" 1.male#19.time_pos="4" 1.male#20.time_pos="5" ///
               1.male#21.time_pos="6" 1.male#22.time_pos="7" 1.male#23.time_pos="8" 1.male#24.time_pos="9" ///
               1.male#25.time_pos="10") ///
    xtitle("Years Since Abolition of Mandatory Draft") ytitle("Difference in Tolerance (Men vs. Women)") ///
    title("TWFE Event Study: Fixed Effects for Country, Birth Year, and Wave")

graph export "$Output/TWFE_Event_Study.png", replace width(2000)
    

// ======================================================================
// --- 8. CALLAWAY & SANT'ANNA (2021) ROBUST ESTIMATOR ---
// ======================================================================

capture drop gvar_cs
generate gvar_cs = 0
replace gvar_cs = pivotal_cohort if male == 1 & !missing(pivotal_cohort)

preserve
    drop if missing(yrbrn, freehms, edulvlfa, edulvlma, fthr_occup_14, mthr_occup_14, facntr, mocntr, blgetmg, brncntr)
    keep if dstnc_frm_pvtl_cohort >= -20 & dstnc_frm_pvtl_cohort <= 20
    csdid freehms edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, time(yrbrn) gvar(gvar_cs) vce(cluster cntry)   
    estat event
    csdid_plot, title("CS Event Study: Tolerance towards homosexuals") xtitle("Years relative to reform") ytitle("ATT") graphregion(color(white))
    graph export "$Output/CS_Event_Study.png", replace width(2000)
restore


// =========================================================
// --- 9. COUNTRY-SPECIFIC VISUALIZATIONS ---
// =========================================================

// ITALY
preserve
    keep if cntry == "IT"
    drop if missing(freehms, dstnc_frm_pvtl_cohort, male)
    keep if dstnc_frm_pvtl_cohort >= -36 & dstnc_frm_pvtl_cohort <= 17
    collapse (mean) freehms, by(dstnc_frm_pvtl_cohort male)
    
    twoway (line freehms dstnc_frm_pvtl_cohort if male == 1, lcolor(navy) lwidth(medthick)) ///
           (line freehms dstnc_frm_pvtl_cohort if male == 0, lcolor(cranberry) lwidth(medthick)), ///
           ylabel(, format(%9.1f)) xline(0, lpattern(dash) lcolor(black) lwidth(thin)) ///
           title("Tolerance towards homosexuals by Birth Cohort (Italy)") ///
           subtitle("Dashed line = First cohort exempted from draft (1986)") ///
           ytitle("Average Tolerance Score") xtitle("Years relative to reform") ///
           legend(order(1 "Men (Treated)" 2 "Women (Control)") position(6) rows(1)) ///
           graphregion(color(white))
    
    graph export "$Output/Graph_Italy.png", replace
restore

// GERMANY
preserve
    keep if cntry == "DE"
    drop if missing(freehms, dstnc_frm_pvtl_cohort, male)
    keep if dstnc_frm_pvtl_cohort >= -36 & dstnc_frm_pvtl_cohort <= 17
    collapse (mean) freehms, by(dstnc_frm_pvtl_cohort male)
    
    twoway (line freehms dstnc_frm_pvtl_cohort if male == 1, lcolor(navy) lwidth(medthick)) ///
           (line freehms dstnc_frm_pvtl_cohort if male == 0, lcolor(cranberry) lwidth(medthick)), ///
           ylabel(1.2(0.2)2.2, format(%9.1f)) xline(0, lpattern(dash) lcolor(black) lwidth(thin)) ///
           title("Tolerance towards homosexuals by Birth Cohort (Germany)") ///
           subtitle("Dashed line = First cohort exempted from draft (1994)") ///
           ytitle("Average Tolerance Score") xtitle("Years relative to reform") ///
           legend(order(1 "Men (Treated)" 2 "Women (Control)") position(6) rows(1)) ///
           graphregion(color(white))

    graph export "$Output/Graph_Germany.png", replace
restore

// ALBANIA
preserve
    keep if cntry == "AL"
    drop if missing(freehms, dstnc_frm_pvtl_cohort, male)
    keep if dstnc_frm_pvtl_cohort >= -20 & dstnc_frm_pvtl_cohort <= 10
    collapse (mean) freehms, by(dstnc_frm_pvtl_cohort male)
    
    twoway (line freehms dstnc_frm_pvtl_cohort if male == 1, lcolor(navy) lwidth(medthick)) ///
           (line freehms dstnc_frm_pvtl_cohort if male == 0, lcolor(cranberry) lwidth(medthick)), ///
           ylabel(, format(%9.1f)) xline(0, lpattern(dash) lcolor(black) lwidth(thin)) ///
           title("Tolerance towards homosexuals by Birth Cohort (Albania)") ///
           subtitle("Dashed line = First cohort exempted from draft (1991)") ///
           ytitle("Average Tolerance Score") xtitle("Years relative to reform") ///
           legend(order(1 "Men (Treated)" 2 "Women (Control)") position(6) rows(1)) ///
           graphregion(color(white))
    
    graph export "$Output/Graph_Albania.png", replace
restore

// POLAND
preserve
    keep if cntry == "PL"
    drop if missing(freehms, dstnc_frm_pvtl_cohort, male)
    keep if dstnc_frm_pvtl_cohort >= -30 & dstnc_frm_pvtl_cohort <= 15
    collapse (mean) freehms, by(dstnc_frm_pvtl_cohort male)
    
    twoway (line freehms dstnc_frm_pvtl_cohort if male == 1, lcolor(navy) lwidth(medthick)) ///
           (line freehms dstnc_frm_pvtl_cohort if male == 0, lcolor(cranberry) lwidth(medthick)), ///
           ylabel(, format(%9.1f)) xline(0, lpattern(dash) lcolor(black) lwidth(thin)) ///
           title("Tolerance towards homosexuals by Birth Cohort (Poland)") ///
           subtitle("Dashed line = First cohort exempted from draft (1990)") ///
           ytitle("Average Tolerance Score") xtitle("Years relative to reform") ///
           legend(order(1 "Men (Treated)" 2 "Women (Control)") position(6) rows(1)) ///
           graphregion(color(white))
    
    graph export "$Output/Graph_Poland.png", replace
restore












