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


**** Import raw data 

**** Run variable creation file 


* TABLE OF DESCRIPTIVES

tsset year

summ rhetoric_nph log_rhetoric_nph d.log_rhetoric_nph unemprate log_unemprate d.log_unemprate bn.highunemp8 ///
no_of_articles log_no_of_articles d.log_no_of_articles log_placebo d.log_placebo ///
bn.war2 bn.party public_debt d.public_debt tax_rev_gdppc d.tax_rev_gdppc spending_gov_gdppc d.spending_gov_gdppc ///
if year>1895 & year<2001 , separator(0)

*** DESCRIPTIVE RELATIONSHIP
twoway (line rhetoric_nph year, yaxis(1)) (line unemprate year, yaxis(2)) if year>1895 & year<2001, ///
ytitle("Negative rhetoric") ytitle("Unemployment rate", axis(2))  ///
xtitle("")  xlabel(1900(10)2000) yscale(log extend range(1 20) axis(2)) yscale(log extend range(25 200)) ylabel(25 50 100 200) ///
ylabel(0.125 0.25 0.5 1 2 4 8 16 32, axis(2)) ///
legend(pos(6) cols(2) label(1 "Mean frequency of negative words") label(2 "Unemployment rate"))


*** CORRELATION BETWEEN LEVELS
pwcorr log_rhetoric_nph log_unemprate  if year>1895 & year<2001, sig




*** REGRESSION MODELS


*** Table 2
eststo clear
* changes
eststo: newey d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles if year>1895 & year<2001, lag(2)
*** b. political covariates 
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles defence_pcgdp) i.party  if year>1895 & year<2001, lag(2)
*** c. fiscal covariates
eststo: newey D.(log_rhetoric_nph log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles) ///
if year>1895 & year<2001, lag(2)
*** d. all covariates
eststo: newey D.(log_rhetoric_nph log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles defence_pcgdp) ///
  i.party if year>1895 & year<2001 , lag(2)
esttab, label se(a2) b(a2)


*** Figure 2
*** NON-LINEARITY
newey d.log_rhetoric_nph cd.log_unemprate##c.unemprate d.log_no_of_articles if year>1895 & year<2001, lag(2)
margins , dydx(d.log_unemprate) at(unemprate=(0(1)15)) post
marginsplot, title(" ") xtitle("Level of unemployment (%)") plotopts(lcolor(sea) mcolor(sea))  ci1opts(fcolor(sea%25) lwidth(none) )  recastci(rarea) ///
	ytitle("Association between changes in unemployment" "and changes in negative rhetoric") ///
	yline(0, lcolor(maroon))



*** Table 3
** PLACEBO MODELS
eststo clear
* changes
eststo: newey d.log_placebo d.log_unemprate d.log_no_of_articles if year>1895 & year<2001, lag(2)
*** b. political covariates 
eststo: newey D.(log_placebo log_unemprate log_no_of_articles defence_pcgdp) i.party  if year>1895 & year<2001, lag(2)
*** c. fiscal covariates
eststo: newey D.(log_placebo log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles) ///
if year>1895 & year<2001, lag(2)
*** d. all covariates
eststo: newey D.(log_placebo log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles defence_pcgdp) ///
  i.party if year>1895 & year<2001 , lag(2)
esttab, label se(a2) b(a2)



*** Figure 3
 ** WORD-BY-WORD
 eststo clear

foreach var of varlist pauper_s_ovl_fre skiver_s_ovl_fre scrounger_s_ovl_fre loafer_s_ovl_fre ///
	shirker_s_ovl_fre idler_s_ovl_fre indolent_ovl_fre workshy_ovl_fre dependency_ovl_fre ///
	feckless_ovl_fre deservingpoor_ovl_fre dependentonbenefits_ovl_fre unemployable_ovl_fre ///
	delinquent_ovl_fre delinquency_ovl_fre criminalclass_ovl_fre riffraff_ovl_fre peon_s_ovl_fre ///
	peasant_s_ovl_fre underclass_ovl_fre lowerclass_ovl_fre dangerousclass_ovl_fre ///
	residuum_ovl_fre beggar_s_ovl_fre vagrant_ovl_fre vagrancy_ovl_fre tramps_ovl_fre ///
	indigent_ovl_fre {
	qui glm `var' log_unemprate year if year>1895 & year<2001, exp(log_no_of_articles) family(nbinom) vce(hac nwest)
	eststo `var'
	}
	
coefplot underclass_ovl_fre || deservingpoor_ovl_fre || loafer_s_ovl_fre || pauper_s_ovl_fre || vagrant_ovl_fre || beggar_s_ovl_fre || ///
riffraff_ovl_fre || criminalclass_ovl_fre || workshy_ovl_fre || indigent_ovl_fre || vagrancy_ovl_fre || dependency_ovl_fre || unemployable_ovl_fre ||  ///
dangerousclass_ovl_fre || dependentonbenefits_ovl_fre || indolent_ovl_fre ||  lowerclass_ovl_fre ||  ///
feckless_ovl_fre || peon_s_ovl_fre ||  tramps_ovl_fre ||   scrounger_s_ovl_fre ||  peasant_s_ovl_fre ||  idler_s_ovl_fre ||  ///
delinquent_ovl_fre || residuum_ovl_fre || skiver_s_ovl_fre ||  delinquency_ovl_fre || shirker_s_ovl_fre ///
, drop(_cons year log_no_of_articles) bycoefs xlabel(-.5(.5)1.5) xline(0, lcolor(reddish)) xtitle("Coefficient of unemployment on stigmatising words") ///
ylabel(1 "Underclass" 2 "Deserving poor" 3 "Loafer" 4 "Pauper" 5 "Vagrant" 6 "Beggar" 7 "Riff Raff" 8 "Criminal Class" ///
	9 "Workshy" 10 "Indigent" 11 "Vagrancy" 12 "Dependency" 13 "Unemployable" 14 "Dangerous class" ///
	15 "Dependent on benefits" 16 "Indolent" 17 "Lower class" 18 "Feckless" ///
	19 "Peon" 20 "Tramps" 21 "Scrounger" 22 "Peasant" 23 "Idler" 24 "Delinquent" ///
	25 "Residuum" 26 "Skiver" 27 "Delinquency" 28 "Shirker") 

	
*** Web Appendix 3
** Auto-correlation
eststo clear 
eststo: reg d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles if year>1895 & year<2001
eststo: prais d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles if year>1895 & year<2001 
eststo: newey d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles if year>1895 & year<2001, lag(2)
esttab, label se(a2) b(a2)
 	

	
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(0,1,0)
estat ic
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(1,1,0)
estat ic
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(2,1,0) 
estat ic
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(3,1,0)
estat ic
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(4,1,0)
estat ic
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(5,1,0)
estat ic
arima log_rhetoric_nph log_unemprate log_no_of_articles if year>1895 & year<2001, arima(6,1,0)
estat ic


*** Web Appendix 4
*** Alternative war coding
eststo clear 
eststo: newey d.log_rhetoric_nph d.log_unemprate d.defence_pcgdp d.log_no_of_articles  if year>1895 & year<2001, lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) i.war3  if year>1895 & year<2001, lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) i.war  if year>1895 & year<2001, lag(2)
esttab, label se(a2) b(a2)



*** Elections
eststo clear 
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) if year>1895 & year<2001, lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) i.elections  if year>1895 & year<2001, lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) d.elections  if year>1895 & year<2001, lag(2)
esttab, label se(a2) b(a2)	



*** Web Appendix 5
newey d.log_rhetoric_nph cd.log_unemprate##c.unemprate d.log_no_of_articles if year>1895 & year<2001, lag(2)
	
