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

// I. Preferred decision level of immigration and refugees policies
// dclmig "Preferred decision level of immigration and refugees policies"
// "1= International Level, 2=European Level, 3=National, 4= Regional or local" --> indicating 3 or 4 could be seen as proxy towards "populism(?)"
tabulate dclmig if cntry == "IT"
replace dclmig = . if inlist(dclmig, 7, 8, 9)

// J. dmcntov
// How democratic do you think [country] is overall? Choose your answer from this card where 0 is not at all democratic and 10 is completely democratic.
tabulate dmcntov
replace dmcntov = . if inlist(dmcntov, 77, 88, 99)

// K. euftf 
// European Union: European unification go further or gone too far
tabulate euftf
replace euftf = . if inlist(euftf, 77, 88, 99)

// L. freehms 
// Gays and lesbians free to live life as they wish
// 1 strongly agree, 5 Strongly disagree
tabulate freehms
replace freehms = . if inlist(freehms, 7, 8, 9)

// M. gincdif
// Government should reduce differences in income levels
// 1 strongly agree, 5 Strongly disagree
tabulate gincdif
replace gincdif = . if inlist(gincdif, 7, 8, 9)

// N. hmsacld 
// Gay and lesbian couples right to adopt children
tabulate hmsacld
replace hmsacld = . if inlist(hmsacld, 7, 8, 9)

// N. hmsfmlsh 
// Ashamed if close family member gay or lesbian
tabulate hmsfmlsh
replace hmsfmlsh = . if inlist(hmsfmlsh, 7, 8, 9)

// O. implvdm 
// How important for you to live in democratically governed country
tabulate implvdm
replace implvdm = . if inlist(implvdm, 77, 88, 99)

// P. polintr 
// How interested in politics
// 1 very interest, 4 not interest at all
tabulate polintr
replace polintr = . if inlist(polintr, 7, 8, 9)

// R. prtyban
// Ban political parties that wish overthrow democracy
// 1 strongly agree, 5 disagree strongly
tabulate prtyban
replace prtyban = . if inlist(prtyban, 7, 8, 9)

// S. stfdem
// How satisfied with the way democracy works in country
// 0 extrimely dissatisfied, 10 Extrimely satisfied
tabulate stfdem
replace stfdem = . if inlist(stfdem, 77, 88, 99)


// T. stfedu
// State of education in country nowadays
// 0 extrimely bad, 10 Extrimely good
tabulate stfedu
replace stfedu = . if inlist(stfedu, 77, 88, 99)


// U. vote 
// Voted last national election
// 1 yes, 2 no --> to convert it in Dummy
tabulate vote
replace vote = . if inlist(vote, 7, 8, 9)

// =========================================================
// --- 3. VARIABLE CREATION ---
// =========================================================

// Create the MALE dummy (1 = Male, 0 = Female)
generate male = .
replace male = 1 if gndr == 1
replace male = 0 if gndr == 2 // Fixed: Females are coded as 2 in ESS

// Generating the Vote 1 = Yes, 0 = No
generate vote_dummy = .
replace vote_dummy = 1 if vote == 1
replace vote_dummy = 0 if vote == 2
tabulate vote_dummy


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




// Per cercare la la variabile d'interesse ---> Prendere tutti i potenziali outcome cui ho pensate e testare i pre-trend, faccio girare le regressione DiD sulle coorti non trattate, aggregato per tutti i paesi. 
// 

// In generale devo fare
// Post = 1 if year of birth >= Pivotal cohort
// Distance from pivotal cohort (year of birth - pivotal_cohort) (numeri negativi, gente che non è stata esposta alla leva militare)
// pensare a controlli che non debbano influenzare la variabile dipendente pre treatment

// Pensare a event study graph

// TRIPLE DID --> DDD
// utilizzare il fatto che un paese abbia abolito o mai abolito la leva militare
// Dummy che dice "abolished at a ceirtan time" vs "never abolished"
// Dobbiamo pensare se questa assumptuon regarding the oarallel trend is to huge
// stiamo dicendo che le differenze di trend, tra unomini e donne, prima della riforma sono comuni tra paesi che poi hanno effettuato la riforma e paesi che non l'hanno mai effettuata
// Bisogna forse (il trattamento è la riforma), occhio a non inserire nel campione paesi che NON hanno MAI avuto la leva militare obbligatoria.












































