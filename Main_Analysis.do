// Impact Evaluation Project - DiD Analysis
// Authors: Lorenzo and Sofia
clear all

global root "/Users/lorenzodelcol/Desktop/GIT/Impact Evaluation Project"
global raw "$root/ESS_Dataset/raw"
global clean "$root/ESS_Dataset/clean"
global Output "$root/Output"


// import delimited "$raw/ESS.csv", clear

// save "$clean/ESS.dta", replace
use "$clean/ESS_clean.dta", clear

////////////////////////////////////////////////////////////////
// CLEANING THE DATA OF trstplt and ybrn
// REPLACING with (.) which in stata means MISSING VALUE

//replace trstplt = . if inlist(trstplt, 77, 88, 99)
//replace yrbrn    = . if inlist(yrbrn, 7777, 8888, 9999)

//summarize trstplt yrbrn // it worked perfectly

//save "$clean/ESS_clean.dta"

////////////////////////////////////////////////////////////////



// sumarize; sumary statistics code,(continous,dummy), N, mean, std. dev. min max for all the variables

// tabulate cntry, categorical variables & frequency
tabulate cntry

// two-way tabulation
tabulate cntry essround

// Missing values counter
// misstable summarize --> the dataset and the number of variables are huge, so pay attention because might take a lot of time. run it just for the variables in which we are interested with
misstable summarize trstplt

// lookfor trst, and stata search for all the variables which are labeled with the word "trst"
lookfor trst
// trstplt --> trust in politicians
// trstpr --> trust in country's parliament
// trstprt --> trust in political parties

tabulate trstplt
tabulate trstpr
tabulate trstprt

// In ESS uses 77(refusal), 88(don't know), 99(no answer) hence later we will need to clean these variables


// Now we want to sumarise trust in politics variables with countries


// cleaned
tabstat trstplt, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)

// these values are raw, we need to clean the variable trstplt from tjhe "refusal, don't know, and no answer" because they yield huge values that distort ou statistics
// the format %9.2f means that stata will provide digits up to 9 numbers, and up to 2 decimals, the f stands for "fixed" format, not weird numbers with 3.4e+00

// Now we want to dive into country by country statistics

tabulate trstplt if cntry == "IT"
// now we can se the distribution of the answares for trstplt regarding Italy, we still see that these are raw data

// plotting the results
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
	
// save the graph to your output folder
graph export "$Output/Trust_Distribution_Italy.png", replace width(2000)
	
	
	
	
// Now we want to see the same, but distributing the answares per year

// Distribution and Trend of Trust in Politics over Time (Italy)

// Two-Way tabulation, tabulating trust scores (rows) by survey waves (columns). The column option computes the percentages, vertically we have % of italians aswered "0" in Wave 1 vs Wave 2 and so on and so forth

tabulate trstplt essround if cntry == "IT", column

// (still, these are raw data)
// We interpret the table like the following. taking first cell as example. In italy, at wave 1, 147 people, that where the 12.18% of italians in the first wave sample, aswered 0 the variable related to trust in politics. 
// The total column says that. among all the waves, there where 2973 people that votet 0, and are the 22.79% of the total italians among all the waves.


// cleaned
// Now we want to visualize the Trend Over Time
// (Still using raw data)

preserve
	// Keep only Italy in this example
	keep if cntry == "IT"
	
	// Drop missing values for cleaning the graph
	drop if missing(trstplt, essround)
	
	// Collapse the data to get the median trust per wave
	collapse (median) trstplt, by (essround)
	
	// Plot trend line
	twoway line trstplt essround, ///
	title("Median Trust in Politicians Over Time (Italy)") ///
	ytitle("Median Trust Score (0-10)") ///
	xtitle("ESS Round") ///
	ylabel(0(1)10) ///
	graphregion(color(white))
	
restore

// saving the graph
	graph export "$Output/Trust_Median_Trend_Italy.png", replace width(2000)




// Now we want to sudy and visualise some statistics relative to the year of birth --> ATTENTION, the raw ESS data we will find output as 7777 (refusal), 8888 (Don't know), 9999 (No Answare) --> so a crucial step to perform later is data cleaning


// Cleaned
summarize yrbrn if cntry == "IT", detail

// Visualizing the Distribution of Birth Years
histogram yrbrn if cntry == "IT", ///
	discrete width(1) ///
	fcolor(forest_green) lcolor(white) ///
	title("Distribution of Birth Years (Italy)") ///
	ytitle("Density") ///
	xtitle("Year of Birth") ///
	graphregion(color(white))

// Saving the graph
graph export "$Output/Birth_Year_Distribution_Italy.png", replace width(2000)

// Trust on politicians by year of birth (cohort analysis)
// Calculating the average trust for very single birth year, and then draws a trend lin throught it

//celaned
preserve
	keep if cntry =="IT"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Italy)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore

graph export "$Output/Trust_by_Birth_Year_Italy.png", replace width(2000)


// looking at toher countries

// FRANCE
preserve
	keep if cntry =="FR"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (France)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore


// Great Britain
preserve
	keep if cntry =="GB"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Great Britain)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore


// GERMANY
preserve
	keep if cntry =="DE"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Germany)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore

// NETHERLAND
preserve
	keep if cntry =="NL"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Netherland)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore


// POLONIA
preserve
	keep if cntry =="PL"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Poland)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore

// Hungary
preserve
	keep if cntry =="HU"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Hungary)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore


// Spain
preserve
	keep if cntry =="ES"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Spain)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore

// Albania
preserve
	keep if cntry =="AL"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Albania)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore

// Belgium
preserve
	keep if cntry =="BE"
	drop if missing(trstplt, yrbrn)
	
	// Calculate the average trust for each birth year
	collapse (mean) trstplt, by(yrbrn)
	
	// Plot scatter averages, and overly a linear regression line
	twoway (scatter trstplt yrbrn, mcolor(navy) msize(small)) ///
	(lfit trstplt yrbrn, lcolor(red) lwidth(thick)), ///
	title("Average Trus in Politicians by Birth Year (Belgium)") ///
	ytitle("Mean Trust Score (0-10)") ///
	xtitle("Year of Birth") ///
	legend(order(1 "Average Trust per Cohordt" 2 "Overall Trend") position (6) rows(1)) ///
	graphregion(color(white))

restore

// Now we want to sumarise Year of Birth variable with countries

tabstat yrbrn, by(cntry) statistics(mean sd n) columns(statistics) format(%9.2f)



tabulate gndr if cntry == "IT"

// we see that there is "9" which means "No Answare", need to clean it

// replace gndr = . if gndr == 9

tabulate gndr if cntry == "IT"

// save "$clean/ESS_clean.dta", replace



// Now we want to sumarise Gender variable with countries

tabulate gndr essround if cntry == "IT", column

// I want to create the MALE dummy

// creating an empty variable
generate male = .

// assigning 1 for males
replace male = 1 if gndr == 1

// assigning 0 for females
replace male = 0 if gndr == 0

tabulate gndr
























