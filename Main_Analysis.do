// Impact Evaluation Project - DiD Analysis
// Authors: Lorenzo and Sofia
clear all

global root "/Users/lorenzodelcol/Desktop/GIT/Impact Evaluation Project"
global raw "$root/ESS_Dataset/raw"
global clean "$root/ESS_Dataset/clean"
global Output "$root/Output"


// import delimited "$raw/ESS.csv", clear

// save "$clean/ESS.dta", replace

use "$clean/ESS.dta", clear


// sumarize; sumary statistics code,(continous,dummy), N, mean, std. dev. min max for all the variables

// tabulate cntry, categorical variables & frequency
tabulate cntry

// two-way tabulation
tabulate cntry essround

// Missing values counter
// misstable summarize --> the dataset and the number of variables are huge, so pay attention because might take a lot of time. run it just for the variables in which we are interested with
misstable summarize cntry

// lookfor trst, and stata search for all the variables which are labeled with the word "trst"
lookfor trst
// trstplt --> trust in politicians
// trstpr --> trust in country's parliament
// trstprt --> trust in political parties

tabulate trstplt
tabulate trstpr
tabulate trstprt

// (gemini) tells us that in ESS uses 77(refusal), 88(don't know), 99(no answer) hence later we will need to clean these variables


// Now we want to sumarise trust in politics variables with countries

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
























