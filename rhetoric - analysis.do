**** The Rhetoric of Recessions: How British Newspapers Talk about the Poor When Unemployment Rises, 1896–2000 
**** Sociology

**** Daniel McArthur and Aaron Reeves


/*
For any further questions email: d.mcarthur@lse.ac.uk

*/

* set directory

 cd "C:\Users\danmc\Dropbox\Recession and media\Poverty in the media and recessions\rhetoric-recessions-master"
/// CHANGE TO OWN FILE PATH

**** Run dofile to import data and create variables

clear all 

do "rhetoric - variables" 

tsset year


*** DESCRIPTIVE RELATIONSHIP

* FIGURE 1 Unemployment rates and stigmatising rhetoric about the poor in Britain, 1896–2000
twoway (line rhetoric_nph year, yaxis(1)) (line unemprate year, yaxis(2)) if year>1895, ///
ytitle("Negative rhetoric") ytitle("Unemployment rate", axis(2))  ///
xtitle("")  xlabel(1900(10)2000) yscale(log extend range(1 20) axis(2)) yscale(log extend range(25 200)) ylabel(25 50 100 200) ///
ylabel(0.125 0.25 0.5 1 2 4 8 16 32, axis(2)) ///
legend(pos(6) cols(2) label(1 "Mean frequency of negative words") label(2 "Unemployment rate"))


*** REGRESSION MODELS

*** TABLE 2 Association between unemployment rate and stigmatising rhetoric adjusting for covariates, 1896–2000.

eststo clear
* 1 changes
eststo: newey d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles, lag(2)
* 2 political covariates 
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles defence_pcgdp) i.party, lag(2)
* 3 fiscal covariates
eststo: newey D.(log_rhetoric_nph log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles) , lag(2)
* 4 all covariates
eststo: newey D.(log_rhetoric_nph log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles defence_pcgdp) i.party , lag(2)
esttab, label se(a2) b(a2)

*** FIGURE 2 Increases in unemployment are associated with increases in stigmatising rhetoric only when the level of unemployment is low

newey d.log_rhetoric_nph cd.log_unemprate##c.unemprate d.log_no_of_articles, lag(2)
margins , dydx(d.log_unemprate) at(unemprate=(0(1)15)) post
marginsplot, title(" ") xtitle("Level of unemployment (%)") plotopts(lcolor(sea) mcolor(sea) msymbol(i))  ci1opts(fcolor(sea%25) lwidth(none) )  recastci(rarea) ///
	ytitle("Association between changes in unemployment" "and changes in negative rhetoric") ///
	yline(0, lcolor(maroon))

** PLACEBO MODELS
** TABLE 3 Association between unemployment rate and placebo words adjusting for covariates, 1896–2000

eststo clear
* changes
eststo: newey d.log_placebo d.log_unemprate d.log_no_of_articles, lag(2)
*** b. political covariates 
eststo: newey D.(log_placebo log_unemprate log_no_of_articles defence_pcgdp) i.party  , lag(2)
*** c. fiscal covariates
eststo: newey D.(log_placebo log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles), lag(2)
*** d. all covariates
eststo: newey D.(log_placebo log_unemprate public_debt tax_rev_gdppc non_def_gov_exp_gdppc log_no_of_articles defence_pcgdp)  i.party , lag(2)
esttab, label se(a2) b(a2)


 ** WORD-BY-WORD ANALYSIS
*** FIGURE 3 Association between unemployment and the frequency of stigmatising words or phrases, 1896–2000

eststo clear

foreach var of varlist pauper_s_ovl_fre skiver_s_ovl_fre scrounger_s_ovl_fre loafer_s_ovl_fre ///
	shirker_s_ovl_fre idler_s_ovl_fre indolent_ovl_fre workshy_ovl_fre dependency_ovl_fre ///
	feckless_ovl_fre deservingpoor_ovl_fre dependentonbenefits_ovl_fre unemployable_ovl_fre ///
	delinquent_ovl_fre delinquency_ovl_fre criminalclass_ovl_fre riffraff_ovl_fre peon_s_ovl_fre ///
	peasant_s_ovl_fre underclass_ovl_fre lowerclass_ovl_fre dangerousclass_ovl_fre ///
	residuum_ovl_fre beggar_s_ovl_fre vagrant_ovl_fre vagrancy_ovl_fre tramps_ovl_fre ///
	indigent_ovl_fre {
	qui glm `var' log_unemprate year if year>1895 , exp(log_no_of_articles) family(nbinom) vce(hac nwest)
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

*** WEB APPENDICES

* WEB APPENDIX 2
* TABLE 2A: Descriptive statistics for dependent, independent, and control variables

summ log_rhetoric_nph log_unemprate log_no_of_articles log_placebo ///
 public_debt defence_pcgdp tax_rev_gdppc non_def_gov_exp_gdppc bn.party ///
if year>1895 , separator(0)

*** WEB APPENDIX 3

** TABLE 3A Robustness of association between unemployment and negative rhetoric to adjustment for autocorrelation.
eststo clear 
eststo: reg d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles 
eststo: prais d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles  
eststo: newey d.log_rhetoric_nph d.log_unemprate d.log_no_of_articles  , lag(2)
eststo: arima log_rhetoric_nph log_unemprate log_no_of_articles , arima(2,1,0) 
esttab, label se(a2) b(a2)
 	

* TABLE 3B: Bayesian Information Criterion from ARIMA models with various lag lengths	
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(0,1,0)
estat ic
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(1,1,0)
estat ic
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(2,1,0) 
estat ic
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(3,1,0)
estat ic
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(4,1,0)
estat ic
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(5,1,0)
estat ic
qui arima log_rhetoric_nph log_unemprate log_no_of_articles  , arima(6,1,0)
estat ic


*** Web Appendix 4

*** TABLE 4A regression models with controls for defence spending and alternative specifications of war-time.
eststo clear 
eststo: newey d.log_rhetoric_nph d.log_unemprate d.defence_pcgdp d.log_no_of_articles  , lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) i.war3  , lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) i.war , lag(2)
esttab, label se(a2) b(a2)

*** TABLE 4B Regression models with controls for election years.
eststo clear 
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) , lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) i.elections  , lag(2)
eststo: newey D.(log_rhetoric_nph log_unemprate log_no_of_articles) d.elections  , lag(2)
esttab, label se(a2) b(a2)	



*** Web Appendix 5

* TABLE 5A How the relationship between changes in unemployment and changes in stigmatising rhetoric depend on starting levels of unemployment
newey d.log_rhetoric_nph cd.log_unemprate##c.unemprate d.log_no_of_articles , lag(2)
	
