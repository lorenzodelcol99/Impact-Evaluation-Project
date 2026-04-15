 // =========================================================
// Impact Evaluation Project - Explanatory Analysis
// Authors: Lorenzo and Sofia
// =========================================================

clear all

// --- 0. REQUIRED PACKAGES INSTALLATION ---
// Remove the comment (//) from the lines below if running the code for the first time on a new PC
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

// Load the pre-csv native dataset
use "$raw/ESS.dta", clear


// =========================================================
// --- 2. DATA CLEANING ---
// =========================================================

// A. Trust Variables (0-10 scale)
replace trstplt = . if inlist(trstplt, 77, 88, 99) // Politicians
replace trstprt = . if inlist(trstprt, 77, 88, 99) // Political parties

// B. Year of Birth (4-digit)
replace yrbrn = . if inlist(yrbrn, 7777, 8888, 9999)

// C. Gender
replace gndr = . if gndr == 9

// D. Father's and Mother's Educational Level
replace edulvlfa = . if inlist(edulvlfa, 55, 77, 88, 99)
replace edulvlma = . if inlist(edulvlma, 55, 77, 88, 99)

// E. Born in the country or Immigrant
replace brncntr = . if inlist(brncntr, 7, 8, 9)

// F. Trust in the Police
replace trstplc = . if inlist(trstplc, 77, 88, 99)

// G. Trust in the Legal System
replace trstlgl = . if inlist(trstlgl, 77, 88, 99)

// H. Domicile
replace domicil = . if inlist(domicil, 7, 8, 9)

// I. Preferred decision level of immigration and refugees policies
replace dclmig = . if inlist(dclmig, 7, 8, 9)

// J. dmcntov - How democratic do you think [country] is overall?
replace dmcntov = . if inlist(dmcntov, 77, 88, 99)
 
// K. euftf - European unification go further or gone too far
replace euftf = . if inlist(euftf, 77, 88, 99)

// L. freehms - Gays and lesbians free to live life as they wish (Main Outcome)
replace freehms = . if inlist(freehms, 7, 8, 9)

// M. gincdif - Government should reduce differences in income levels
replace gincdif = . if inlist(gincdif, 7, 8, 9)

// N. hmsacld - Gay and lesbian couples right to adopt children
replace hmsacld = . if inlist(hmsacld, 7, 8, 9)

// N. hmsfmlsh - Ashamed if close family member gay or lesbian
replace hmsfmlsh = . if inlist(hmsfmlsh, 7, 8, 9)

// O. implvdm - How important for you to live in democratically governed country
replace implvdm = . if inlist(implvdm, 77, 88, 99)

// P. polintr - How interested in politics
replace polintr = . if inlist(polintr, 7, 8, 9)

// R. prtyban - Ban political parties that wish overthrow democracy
replace prtyban = . if inlist(prtyban, 7, 8, 9)

// S. stfdem - How satisfied with the way democracy works in country
replace stfdem = . if inlist(stfdem, 77, 88, 99)

// T. stfedu - State of education in country nowadays
replace stfedu = . if inlist(stfedu, 77, 88, 99)

// U. vote - Voted last national election
replace vote = . if inlist(vote, 7, 8, 9)

// V. FATHER OCCUPATION when you were 14 years old
generate fthr_occup_14 = .
replace fthr_occup_14 = occf14 if !missing(occf14)
replace fthr_occup_14 = occf14a if !missing(occf14a)
replace fthr_occup_14 = occf14b if !missing(occf14b)
replace fthr_occup_14 = . if inlist(fthr_occup_14, 66, 77, 88, 99)

// W. Mother OCCUPATION when you were 14 years old
generate mthr_occup_14 = .
replace mthr_occup_14 = occm14 if !missing(occm14)
replace mthr_occup_14 = occm14a if !missing(occm14a)
replace mthr_occup_14 = occm14b if !missing(occm14b)
replace mthr_occup_14 = . if inlist(mthr_occup_14, 66, 77, 88, 99)

// X. Father EMPLOYEMENT status when you were 14 years old
replace emprf14 = . if inlist(emprf14, 7, 8, 9)

// Y. Mother EMPLOYEMENT status when you were 14 years old
replace emprm14 = . if inlist(emprm14, 7, 8, 9)

// Z. Was the father born in the country?
replace facntr = . if inlist(facntr, 7, 8, 9)

// A.1 Was the mother born in the country?
replace mocntr = . if inlist(mocntr, 7, 8, 9)
 
// A.2 Belong to a minority ethnic group in country.
replace blgetmg = . if inlist(blgetmg, 7, 8, 9)

// =========================================================
// --- 3. VARIABLE CREATION ---
// =========================================================

// 3.1 Create the MALE dummy (1 = Male, 0 = Female)
generate male = .
replace male = 1 if gndr == 1
replace male = 0 if gndr == 2 // Fixed: Females are coded as 2 in ESS

// 3.2 Generating the Vote Dummy
generate vote_dummy = .
replace vote_dummy = 1 if vote == 1
replace vote_dummy = 0 if vote == 2

// 3.3 Generating the Policy Variables (Pivotal Cohorts)
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

// 3.4 Generate the "post_treatment" dummy
generate post_treatment = 0 if !missing(yrbrn)
replace post_treatment = 1 if (yrbrn >= pivotal_cohort) & !missing(pivotal_cohort)

// 3.5 Creating the distance from pivotal cohort
generate dstnc_frm_pvtl_cohort = 0
replace dstnc_frm_pvtl_cohort = yrbrn - pivotal_cohort


// =========================================================
// --- 4. SAVE CLEANED DATASET ---
// =========================================================
save "$clean/ESS_clean.dta", replace


// =========================================================
// --- 5. EXPLORATORY DATA ANALYSIS ---
// =========================================================
summarize trstplt trstprt yrbrn male edulvlfa edulvlma brncntr trstplc trstlgl domicil
tabstat trstplt, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)


// =========================================================
// --- 6. BASELINE NAIVE DiD (TWFE) ---
// =========================================================

// Clear stored estimates
eststo clear

// 1. Run Model 1 (Baseline DiD) 
quietly eststo: reghdfe freehms i.male##i.post_treatment, absorb(cntry yrbrn) cluster(cntry)

// 2. Run Model 2 (Adding Father's Education)
quietly eststo: reghdfe freehms i.male##i.post_treatment edulvlfa, absorb(cntry yrbrn) cluster(cntry)

// 3. Run Model 3 (Adding Both Parents' Education)
quietly eststo: reghdfe freehms i.male##i.post_treatment edulvlfa edulvlma, absorb(cntry yrbrn) cluster(cntry)

// 4. Run Model 4 (Full 14-years-old Controls)
quietly eststo: reghdfe freehms i.male##i.post_treatment edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, absorb(cntry yrbrn) cluster(cntry)

// 5. Export to Word via Stargazer
esttab using "$Output/Baseline_TWFE_Table.rtf", replace ///
    label ///
    se b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    keep(1.male#1.post_treatment 1.male 1.post_treatment) ///
    order(1.male#1.post_treatment) ///
    mtitle("Baseline" "+ Father Edu" "+ Both Parents" "+ All Controls") ///
    scalars("N Observations" "r2_within Within R-sq.") /// 
    title("Table 1: Naive TWFE Effect of Draft Abolition on Tolerance wrt Gay and Lesbians") ///
    addnotes("Standard errors in parentheses. Clustered at the country level.")


// --- 6.1 Testing Other Outcomes (Exploratory) ---
// European Union integration
// reghdfe euftf i.male##i.post_treatment edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, absorb(cntry yrbrn) cluster(cntry)
// Satisfaction with democracy
// reghdfe stfdem i.male##i.post_treatment edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, absorb(cntry yrbrn) cluster(cntry)


// =========================================================
// --- 7. EVENT STUDY (TWFE VERSION) ---
// =========================================================

capture drop event_time
generate event_time = dstnc_frm_pvtl_cohort

// Cap the ends at -10 and +10
replace event_time = -10 if event_time <= -10
replace event_time = 10 if event_time >= 10

// THE TIME SHIFT: Add 15 to make all numbers strictly positive (Baseline -1 is now 14)
capture drop time_pos
generate time_pos = event_time + 15

// Run the Event Study Regression
reghdfe freehms i.male##ib14.time_pos edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, absorb(cntry yrbrn) cluster(cntry)

// Plot the event study
coefplot, ///
    keep(1.male#*.time_pos) ///  
    baselevels omitted ///       
    vertical ///                 
    yline(0, lcolor(black) lpattern(solid)) /// 
    xline(10.5, lcolor(red) lpattern(dash)) /// 
    ciopts(recast(rcap) color(gs7)) /// 
    msymbol(O) mcolor(navy) ///  
    coeflabels( ///              
        1.male#5.time_pos = "-10" 1.male#6.time_pos = "-9" 1.male#7.time_pos = "-8" ///
        1.male#8.time_pos = "-7" 1.male#9.time_pos = "-6" 1.male#10.time_pos = "-5" ///
        1.male#11.time_pos = "-4" 1.male#12.time_pos = "-3" 1.male#13.time_pos = "-2" ///
        1.male#14.time_pos = "-1" 1.male#15.time_pos = "0" 1.male#16.time_pos = "1" ///
        1.male#17.time_pos = "2" 1.male#18.time_pos = "3" 1.male#19.time_pos = "4" ///
        1.male#20.time_pos = "5" 1.male#21.time_pos = "6" 1.male#22.time_pos = "7" ///
        1.male#23.time_pos = "8" 1.male#24.time_pos = "9" 1.male#25.time_pos = "10" ///
    ) ///
    xtitle("Years Since Abolition of Mandatory Draft") ///
    ytitle("Difference in Tolerance (Men vs. Women)") ///
    title("TWFE Event Study: Effect of Draft Abolition (freehms)") ///
    note("95% Confidence Intervals shown. Reference year is -1.")


// ======================================================================
// --- 8. CALLAWAY & SANT'ANNA (2021) ROBUST ESTIMATOR ---
// ======================================================================

// Group Variable creation (Year of treatment, 0 for control)
capture drop gvar_cs
generate gvar_cs = 0
replace gvar_cs = pivotal_cohort if male == 1 & !missing(pivotal_cohort)

preserve
	// Drop N/A in used variables to allow CSDID to run smoothly
	drop if missing(yrbrn, freehms, edulvlfa, edulvlma, fthr_occup_14, mthr_occup_14, facntr, mocntr, blgetmg, brncntr)
    
    // Zooming in to avoid extreme outliers (-20 to +20 years relative to reform)
    keep if dstnc_frm_pvtl_cohort >= -20 & dstnc_frm_pvtl_cohort <= 20

	// Execute CSDID
	csdid freehms edulvlfa edulvlma fthr_occup_14 mthr_occup_14 facntr mocntr blgetmg brncntr, ///
		  time(yrbrn) ///      
		  gvar(gvar_cs) ///    
		  vce(cluster cntry)   

	// Aggregate for Event Study
	estat event

	// Plot the Robust Event Study
	csdid_plot, title("CS Event Study: Tolerance towards homosexuals (freehms)") ///
				xtitle("Years relative to the first exempted cohort") ///
				ytitle("Estimated effect on attitude (ATT)") ///
				graphregion(color(white))

	// Export Graph
	graph export "$Output/CS_Event_Study_freehms.png", replace width(2000)

restore 


// =========================================================
// --- 9. COUNTRY-SPECIFIC VISUALIZATIONS ---
// =========================================================

// ITALY: Gays and lesbians free to live life as they wish
preserve
	keep if cntry == "IT"
	drop if missing(freehms, dstnc_frm_pvtl_cohort, male)
	keep if dstnc_frm_pvtl_cohort >= -36 & dstnc_frm_pvtl_cohort <= 17
	
	collapse (mean) freehms, by(dstnc_frm_pvtl_cohort male)
	
	twoway ///
		(line freehms dstnc_frm_pvtl_cohort if male == 1, lcolor(navy) lwidth(medthick)) ///
		(line freehms dstnc_frm_pvtl_cohort if male == 0, lcolor(cranberry) lwidth(medthick)), ///
		xline(0, lpattern(dash) lcolor(black) lwidth(thin)) /// 
		title("Tolerance towards homosexuals by Birth Cohort (Italy)") ///
		subtitle("Dashed line = First cohort exempted from draft (1986)") ///
		ytitle("Average Tolerance Score") xtitle("Years relative to reform") ///
		legend(order(1 "Men (Treated)" 2 "Women (Control)") position(6) rows(1)) ///
		graphregion(color(white))
restore

// GERMANY: Gays and lesbians free to live life as they wish
preserve
	keep if cntry == "DE"
	drop if missing(freehms, dstnc_frm_pvtl_cohort, male)
	keep if dstnc_frm_pvtl_cohort >= -36 & dstnc_frm_pvtl_cohort <= 17
	
	collapse (mean) freehms, by(dstnc_frm_pvtl_cohort male)
	
	twoway ///
		(line freehms dstnc_frm_pvtl_cohort if male == 1, lcolor(navy) lwidth(medthick)) ///
		(line freehms dstnc_frm_pvtl_cohort if male == 0, lcolor(cranberry) lwidth(medthick)), ///
		xline(0, lpattern(dash) lcolor(black) lwidth(thin)) /// 
		title("Tolerance towards homosexuals by Birth Cohort (Germany)") ///
		subtitle("Dashed line = First cohort exempted from draft (1994)") ///
		ytitle("Average Tolerance Score") xtitle("Years relative to reform") ///
		legend(order(1 "Men (Treated)" 2 "Women (Control)") position(6) rows(1)) ///
		graphregion(color(white))
restore


