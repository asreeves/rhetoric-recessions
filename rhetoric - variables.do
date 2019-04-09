**** The Rhetoric of Recessions: How British Newspapers Talk about the Poor When Unemployment Rises, 1896–2000 
**** Sociology

**** Daniel McArthur and Aaron Reeves

**** Variable creation file

/* 
Note:
A separate set of code files will replicate the analysis.
*/


/*
For any further questions email: d.mcarthur@lse.ac.uk

*/


**** Import raw data (rhetoric.csv)
 

**** Create variables

*** Main dependent variable
egen rhetoric_nph = rowmean(pauper_s_ovl_fre skiver_s_ovl_fre scrounger_s_ovl_fre loafer_s_ovl_fre ///
	shirker_s_ovl_fre idler_s_ovl_fre indolent_ovl_fre workshy_ovl_fre dependency_ovl_fre ///
	feckless_ovl_fre deservingpoor_ovl_fre dependentonbenefits_ovl_fre unemployable_ovl_fre ///
	delinquent_ovl_fre delinquency_ovl_fre criminalclass_ovl_fre riffraff_ovl_fre peon_s_ovl_fre ///
	peasant_s_ovl_fre underclass_ovl_fre lowerclass_ovl_fre dangerousclass_ovl_fre ///
	residuum_ovl_fre beggar_s_ovl_fre vagrant_ovl_fre vagrancy_ovl_fre tramps_ovl_fre ///
	indigent_ovl_fre)
	
	
gen log_rhetoric_nph = log(rhetoric_nph) 



*** Placebo words

egen placebo_fre = rowmean(shakespeare mozart football cricket opera theatre france germany america bedroom bathroom kitchen)

gen log_placebo = log(placebo_fre)


*** Number of articles published

gen log_no_of_articles = log(no_of_articles)


*** Unemployment rate

gen log_unemprate = log(unemprate)

gen highunemp8 = 0
replace highunemp8 = 1 if unemprate >=8

tab1 highunemp8


*** Conflict
gen war = 0
replace war = 1 if year>1852 & year<1857
replace war = 1 if year>1879 & year<1882
replace war = 1 if year>1888 & year<1903
replace war = 1 if year>1913 & year<1919
replace war = 1 if year>1938 & year<1946
replace war = 1 if year>1955 & year<1958
replace war = 1 if year==1982
replace war = 1 if year==1991


gen war2 = 0
replace war2 = 1 if year>1913 & year<1919
replace war2 = 1 if year>1938 & year<1946


gen ww1 = 0
replace ww1 = 1 if year>1919
gen ww2 = 0
replace ww2 = 1 if year>1946


gen war3 = 0
replace war3 = 1 if year>1913 & year<1919
replace war3 = 2 if year>1938 & year<1946


*** LABEL POL PARTY/ WAR
label define party 0 "Conservative" 1 "Labour" 2 "Coalition" 3 "Whig/Liberal"
label values party party

label define war2 0 "No war" 1 "WW1-2"
label values war2 war2

label define war3 0 "No war" 1 "WW1" 2 "WW2"
label values war3 war3


*** govt spending

gen non_def_gov_exp_gdppc = spending_gov_gdppc - defence_pcgdp



*** Log unemprates
gen log_uerate_ihs = log(uerate_ihs) if uerate_ihs>0
gen log_uerate_boe = log(uerate_boe) if uerate_boe>0

*** Unemprate breaks
gen uerate_breaks = 0
replace uerate_breaks = 1 if year<1923
replace uerate_breaks = 2 if year>1922 & year<1950
replace uerate_breaks = 3 if year>1949 & year<1989
replace uerate_breaks = 4 if year>1988



*** general elections and major referendum
gen elections = 0
replace elections = 1 if (year == 1895 | year == 1900 | year == 1906 | year == 1910 | year == 1918 ///
	| year == 1922 | year == 1923 | year == 1924 | year == 1929 | year == 1931 | year == 1935 | year == 1945 ///
	| year == 1950 | year == 1951 | year == 1955 | year == 1959 | year == 1964 | year == 1966 | year == 1906 ///
	| year == 1970 | year == 1974 | year == 1979 | year == 1983 | year == 1987 | year == 1992 | year == 1997 ///
	| year == 2001)


