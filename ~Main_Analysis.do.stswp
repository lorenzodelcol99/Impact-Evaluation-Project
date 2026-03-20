// =========================================================
// Impact Evaluation Project - Explanatory Analysis
// Authors: Lorenzo and Sofia
// =========================================================

clear all

// --- 1. Directories & Setup ---
global root "."
global raw "$root/ESS_Dataset/raw"
global clean "$root/ESS_Dataset/clean"
global Output "$root/Output"

// Load the pre-csv native dataset
// (Assuming you have a raw .dta file. If not, load the CSV and save it as raw .dta first)
use "$raw/ESS.dta", clear


// =========================================================
// --- 2. DATA CLEANING ---
// =========================================================

// A. Trust Variables (0-10 scale)
// trstplt = trust in politicians
// ESS missing codes: 55(Other, type that do not fit in the standard categories) 77 (Refusal), 88 (Don't Know), 99 (No Answer)
replace trstplt = . if inlist(trstplt, 77, 88, 99) // Politicians
replace trstprt = . if inlist(trstprt, 77, 88, 99) // Political parties

// B. Year of Birth (4-digit)
// ESS missing codes: 7777, 8888, 9999
tabulate yrbrn
replace yrbrn = . if inlist(yrbrn, 7777, 8888, 9999)

// C. Gender
// ESS missing code: 9 (No Answer)
replace gndr = . if gndr == 9

// D. Father's and Mother's Educational Level
// 
tabulate edulvlfa
tabulate edulvlma
// the ranking is 0 not complited primary, 5 university 
replace edulvlfa = . if inlist(edulvlfa, 55, 77, 88, 99)
replace edulvlma = . if inlist(edulvlma, 55, 77, 88, 99)

// E. Born in the country or Immigrant
tabulate brncntr
// 1 the individual was born in that country, 2 it is an immigrant
replace brncntr = . if inlist(brncntr, 7, 8, 9)

// F. Trust in the Police (police and military are similar, uniform culture)
tabulate trstplc
replace trstplc = . if inlist(trstplc, 77, 88, 99)

// G. Trust in the Legal System
tabulate trstlgl
replace trstlgl = . if inlist(trstlgl, 77, 88, 99)

// H. Domicile, big city vs contry (1 Big city, 2 Suburbs or outskirt of big city, 5 country, 5 farm)
tabulate domicil
replace domicil = . if inlist(domicil, 7, 8, 9)


// =========================================================
// --- 3. VARIABLE CREATION ---
// =========================================================

// Create the MALE dummy (1 = Male, 0 = Female)
generate male = .
replace male = 1 if gndr == 1
replace male = 0 if gndr == 2 // Fixed: Females are coded as 2 in ESS


// Generating the Policy Variables
generate pivotal_cohort = .

// Actual date of the abolition for each country, see Bove et all 2022 Table A.1 "Timeline Military Service Suspension"

replace pivotal_cohort = 1991 if cntry == "AL" // Albania
replace pivotal_cohort = 1976 if cntry == "BE" // Belgium
replace pivotal_cohort = 1989 if cntry == "BG" // Bulgaria
replace pivotal_cohort = 1990 if cntry == "HR" // Croatia
replace pivotal_cohort = 1986 if cntry == "CZ" // Czechia
replace pivotal_cohort = 1983 if cntry == "FR" // France
replace pivotal_cohort = 1994 if cntry == "DE" // Germany
replace pivotal_cohort = 1986 if cntry == "HU" // Hungary
replace pivotal_cohort = 1986 if cntry == "IT" // 
replace pivotal_cohort = 1988 if cntry == "LT" // Latvia
replace pivotal_cohort = 1948 if cntry == "LU" // Luxemburg
replace pivotal_cohort = 1988 if cntry == "MK" // North Macedonia
replace pivotal_cohort = 1979 if cntry == "NL" // Netherlands
replace pivotal_cohort = 1990 if cntry == "PL" // Poland
replace pivotal_cohort = 1986 if cntry == "PT" // Portugal
replace pivotal_cohort = 1988 if cntry == "RO" // Romania
replace pivotal_cohort = 1987 if cntry == "SK" // Slovak Republic
replace pivotal_cohort = 1987 if cntry == "SI" // Slovenia
replace pivotal_cohort = 1985 if cntry == "ES" // Spain
replace pivotal_cohort = 1992 if cntry == "SE" // Sweden
replace pivotal_cohort = 1942 if cntry == "GB" // United Kigdom

// WHEN WE ARE GOING TO USE THE FULL DATASET (check the next line)
// Note that for all countries that never abolished the draft we leve pivotal_cohort as missing

// Generate the "post" dummy
// starting with 0 for all the individuals that do not have a valid year of birth
generate post = 0 if !missing(yrbrn)

replace post = 1 if (yrbrn >= pivotal_cohort) & !missing(pivotal_cohort)

// Verify that the Dummy works
tabulate yrbrn post if cntry == "IT"









// =========================================================
// --- 4. SAVE CLEANED DATASET ---
// =========================================================
// Save this clean version so we never have to run the cleaning steps again
save "$clean/ESS_clean.dta", replace


// =========================================================
// --- 5. EXPLORATORY DATA ANALYSIS  & GRAPHS ---
// =========================================================

// --- A. Summary Statistics ---
// Basic overview of our main cleaned variables
summarize trstplt trstprt yrbrn male edulvlfa edulvlma brncntr trstplc trstlgl domicil

// Trust in politicians by country (Cleaned)
tabstat trstplt, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

// Year of birth by country
tabstat yrbrn, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

// Trust in police by country (Cleaned)
tabstat trstplc, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

// Trust in Legal System by country (Cleaned)
tabstat trstlgl, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

// Cross-tabulation: Gender distribution across waves in Italy
tabulate male essround if cntry == "IT", column


// --- B. Visualizing Italy's Data ---

// 1. Distribution of Trust in Politicians
histogram trstplt if cntry == "IT", ///
    discrete width(1) start(0) percent ///
    addlabels addlabopts(mlabsize(small) mlabcolor(black)) ///
    fcolor(navy) lcolor(white) ///
    title("Distribution of Trust in Politicians in Italy") ///
    subtitle("(0 = No trust at all, 10 = Complete trust)") ///
    ytitle("Percentage of Respondents (%)") ///
    xtitle("Trust Score") ///
    xlabel(0(1)10) ///
    graphregion(color(white))
    
graph export "$Output/Trust_Distribution_Italy.png", replace width(2000)

// 2. Trend of Median Trust Over Time
preserve
    keep if cntry == "IT"
    drop if missing(trstplt, essround)
    
    collapse (median) trstplt, by(essround)
    
    twoway line trstplt essround, ///
        title("Median Trust in Politicians Over Time (Italy)") ///
        ytitle("Median Trust Score (0-10)") ///
        xtitle("ESS Round") ///
        ylabel(0(1)10) ///
        graphregion(color(white))
        
    graph export "$Output/Trust_Median_Trend_Italy.png", replace width(2000)
restore

// 3. Distribution of Birth Years
histogram yrbrn if cntry == "IT", ///
    discrete width(1) ///
    fcolor(forest_green) lcolor(white) ///
    title("Distribution of Birth Years (Italy)") ///
    ytitle("Density") ///
    xtitle("Year of Birth") ///
    graphregion(color(white))

graph export "$Output/Birth_Year_Distribution_Italy.png", replace width(2000)

// 4. Cohort Analysis: Trust by Birth Year
preserve
    keep if cntry == "IT"
    drop if missing(trstplt, yrbrn)
    
    collapse (mean) trstplt, by(yrbrn)
    
    twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
           (lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
        title("Average Trust in Politicians by Birth Year (Italy)") ///
        ytitle("Mean Trust Score (0-10)") ///
        xtitle("Year of Birth") ///
        legend(order(1 "Average Trust per Cohort" 2 "Overall Trend") position(6) rows(1)) ///
        graphregion(color(white))

    graph export "$Output/Trust_by_BirthYear_Italy.png", replace width(2000)
restore






















