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
// ESS missing codes: 77 (Refusal), 88 (Don't Know), 99 (No Answer)
replace trstplt = . if inlist(trstplt, 77, 88, 99) // Politicians
replace trstprt = . if inlist(trstprt, 77, 88, 99) // Political parties

// B. Year of Birth (4-digit)
// ESS missing codes: 7777, 8888, 9999
replace yrbrn = . if inlist(yrbrn, 7777, 8888, 9999)

// C. Gender
// ESS missing code: 9 (No Answer)
replace gndr = . if gndr == 9


// =========================================================
// --- 3. VARIABLE CREATION ---
// =========================================================

// Create the MALE dummy (1 = Male, 0 = Female)
generate male = .
replace male = 1 if gndr == 1
replace male = 0 if gndr == 2 // Fixed: Females are coded as 2 in ESS


// =========================================================
// --- 4. SAVE CLEANED DATASET ---
// =========================================================
// Save this clean version so we never have to run the cleaning steps again
save "$clean/ESS_clean.dta", replace


// =========================================================
// --- 5. EXPLORATORY DATA ANALYSIS (EDA) & GRAPHS ---
// =========================================================

// --- A. Summary Statistics ---
// Basic overview of our main cleaned variables
summarize trstplt trstprt yrbrn male

// Trust in politics by country (Cleaned)
tabstat trstplt, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

// Year of birth by country
tabstat yrbrn, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

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






















