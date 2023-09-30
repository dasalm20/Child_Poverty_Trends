*******************************************************************************
* This program generates the database used to create all the tables for this project
* Author: Daylan Salmeron and David Newhouse 
* Date: NOV 2022
*******************************************************************************
	
	

	** 1.  To match Nishans' data, we put the gallT_ppp into 1000 xtiles 
	
clear 
save "${inp}\derived_input\quantiles.dta", empty replace
	
	
use "$tabledata2019_nowcast", clear

 **clean the data and drop duplicates
 duplicates tag countrycode year hhid pid, gen(dub)
 duplicates drop  countrycode year hhid pid if dub==1, force
 
   
	**Take the PSPR data and put it into 1000 bin quantiles 
	drop _merge
	
set processors 4

    egen survey_id=group(ctrycodeyear) 
	summarize survey_id 
	local Nsurveys=r(max)
	macro list
	
	foreach survey of numlist 1/`Nsurveys' {
		preserve 
		keep  hhid pid survey_id weight gallT_ppp 
		keep if survey_id==`survey'
		xtile quantile= gallT_ppp if survey_id==`survey' [aw=weight], nq(1000)
		drop weight gallT_ppp
	   
	   append using "${inp}\derived_input\quantiles.dta", force
		save "${inp}\derived_input\quantiles.dta", replace
		restore
		if mod(`survey', 1)==0 {
		dis `survey'
	}

	}
	
	
	merge 1:m survey_id hhid pid using "${inp}\derived_input\quantiles.dta", assert(3)
    save "$out\table2019_quantiles.dta", replace
	
	

** Use Nishans data and merge it with the quintiles from the 2019 PSPR data 
	u "$thousandbins",clear 
	keep if coverage=="national"
	tempfile nishan
	save `nishan'
	
   u "$out\table2019_quantiles.dta", clear

	drop _merge
   **Merge nishant to PSPR** 
	merge m:1 code quantile using `nishan'
	keep if _merge==3
	unique code
	
	**Group the data \mean\  by countrycode year quantile 
	preserve 
    collapse(mean) welfare   [aw=weight],  by(countrycode year quantile)
	rename welfare avg_quantile_wel
	tempfile collaped_mean
	save `collaped_mean'
	restore 
	
	**Compute  the welfares for each year 
	drop _merge
	merge m:1 countrycode year quantile  using `collaped_mean' 
	
	drop _merge
	gen welfare2020 = welfare*welfprecovid2020/avg_quantile_wel
	
	gen welfare2021 = welfare*welfprecovid2021/avg_quantile_wel
	
	gen welfare2022 = welfare*welfprecovid2022/avg_quantile_wel
	
	gen welfare2020_covid = welfare*welfcovid2020/avg_quantile_wel
	
	gen welfare2021_covid = welfare*welfcovid2021/avg_quantile_wel
	
	gen welfare2022_covid = welfare*welfcovid2022/avg_quantile_wel
	
	
	tempfile welfares 
	save `welfares'
	
	
	**Add the nowcast data to the 2019 
	u "$new_global " ,clear 
duplicates tag countrycode year hhid pid, gen(dub)

	
bysort countrycode year : egen rescale_du = total(pop)
	
	 
 duplicates drop  countrycode year hhid pid if dub==1, force
	
	keep if _merge==3
	drop _merge
	
	
** Rescale population to pspr to ajusts the population  of duplicates

	 total(pop) if countrycode =="BGR"
	 ta rescale_du if countrycode =="BGR"
	 
	egen sum_pop=sum(pop), by(countrycode year)
	
   gen pop19_scaled = pop*rescale_du/ sum_pop
	
	
	total(pop19_scaled) if countrycode =="BGR"
	
	merge 1:1 countrycode year hhid pid  using `welfares'
	
	ta countrycode if _merge==1
	keep if _merge==3
	rename pop19_scaled pop_2019
	
	**rename the pop variable 

	save "$out\final_data.dta", replace
	

****************************************************************
****************************************************************
*** Rescale the weights for each year 
****************************************************************
*****************************************************************

*India uses a 2018 baselineup population
* Import the population growth between 2017 and 2018
	wbopendata, indicator(SP.POP.TOTL) year(2018:2019) clear
	gen popgr18_19=yr2019/yr2018
	keep countrycode popgr18_19 yr2019
	keep if countrycode=="IND"
	tempfile popgr_ind
	save `popgr_ind'

		
	** Get the UNDESA population pospect median for 2022
	import excel "$inp\UN_PPP2022_Output_PopTot.xlsx", sheet(		"Median") cellrange(A17:K307) firstrow clear
 **clean the data 
	drop if Locationcode>=900
	rename K pop_2022
	rename ISO3Alphacode countrycode
	replace pop_2022="." if pop_2022=="…"
	destring pop_2022 , replace
	** This will makes it in millions	
	replace pop_2022=pop_2022/1000
	replace pop_2022= pop_2022*1000000
	keep pop_2022 countrycode 
	tempfile UN2022
	save `UN2022'

	
	* Import the population growth for 2013- 2021
	wbopendata, indicator(SP.POP.TOTL) year(2013:2021) clear
	merge 1:1 countrycode using `UN2022'
	keep if _merge==3
	drop _merge
	
	*Gen the population growth 
	gen popgr21_22 = pop_2022/yr2021
	gen popgr20_21 = yr2021/yr2020 
	gen popgr19_20 = yr2020/yr2019
	gen popgr18_19 = yr2019/yr2018
	gen popgr17_18 = yr2018/yr2017
	gen popgr16_17 = yr2017/yr2016
	gen popgr15_16 = yr2016/yr2015
    gen popgr14_15 = yr2015/yr2014
	gen popgr13_14 = yr2014/yr2013
	//gen pop_19_rescale = yr2019
	
	keep countrycode popgr21_22 popgr20_21 popgr19_20 popgr18_19 popgr17_18 popgr16_17 popgr15_16 popgr14_15 popgr13_14 //pop_19_rescale
	tempfile popgr
	save `popgr'

	u "$out\final_data.dta", clear 
	merge m:1 countrycode using "$wbcodes", keep(match) nogen
	drop _merge
	

	**re-scale India's population from 2018 to 2019 ** the base year seems to be 2018 not 2019 ** as advised by David
	merge m:1 countrycode using `popgr_ind'
	gen pop_ind2018=pop_2019 if countrycode=="IND"
	gen pop_ind= pop_ind2018 * popgr18_19
	replace pop_2019= pop_ind if countrycode=="IND"
	drop pop_ind pop_ind2018 popgr18_19
	
	**re-scale for 2013, 2017,  2020,  2021  and 2022 
merge m:1 countrycode using `popgr', keep(match) nogen

 
	
	

	gen pop_2020= pop_2019*popgr19_20
	gen pop_2021= pop_2020*popgr20_21
	gen pop_2022= pop_2021*popgr21_22
	
	
	gen pop_2018 = pop_2019/popgr18_19
	gen pop_2017 = pop_2018/popgr17_18
	gen pop_2016 = pop_2017/popgr16_17
	gen pop_2015 = pop_2016/popgr15_16
	gen pop_2014 = pop_2015/popgr14_15
	gen pop_2013 = pop_2014/popgr13_14
	
	
	***Here we just create pop variables with the "_covid" to help out loops later
	gen pop_2020_covid= pop_2020
	gen pop_2021_covid= pop_2021
	gen pop_2022_covid= pop_2022 
    
	

	
	
	
****************************************************************
*** Create the variables of interest
*****************************************************************

***Children age variables for tables
	*drop child child_age
	replace age=0 if age==-1
	gen 	child=age<=17 if age~=.
	gen 	adult=1-child
	recode 	age (0/4.49=1) (4.5/9=2) (10/14=3) (15/17=4) (18/59=5) (60/200=6), generate(childagecat)
	label var child 		"Child (aged between 0 and 17)"
	label var childagecat 	"Children Age Groups"
	label def child 		0 "Adults (18 or more)" 1 "Children (0-17)"
	label val child child
	label def childagecat 	1 "Children 0-4" 2 "Children 5-9" ///
		3 "Children 10-14" 4 "Children 15-17" 5 "Adults 18-59" 6 "Adults 60 or more"
	label val childagecat childagecat
	numlabel childagecat, mask(#.) add

	drop _merge
	
	
	
*** Generate numeric poverty status for 2020,2021,2022 using welfare vars

foreach year in 2020 2020_covid 2021 2021_covid 2022 2022_covid{
	gen line_`year'=""
	replace line_`year' = "Non-poor" if welfare`year' >6.85
	replace line_`year' = "between US$ 3.65 and US$ 6.85" if welfare`year' >3.65 & welfare`year' <6.85
	replace line_`year' = "between US$ 2.15 and US$ 3.65" if welfare`year' >2.15 & welfare`year'<3.65
	replace line_`year' = "below US$ 2.15" if welfare`year'<2.15
	
}
*** Generate numeric poverty status for 2020,2021,2022 using the dummies

foreach year in 2013 2014 2015 2016 2017 2018 2019{
	gen line_`year'=""
	replace line_`year'="Non-poor" if poor685_`year'==0
	replace line_`year'="between US$ 3.65 and US$ 6.85" if poor365_`year'==1 & poor685_`year'==1
	replace line_`year' ="between US$ 2.15 and US$ 3.65" if poor215_`year'==0 & poor365_`year'==1
	replace line_`year' ="below US$ 2.15" if poor215_`year'==1
}
	

foreach year in 2013 2014 2015 2016 2017 2018 2019 2020 2020_covid 2021 2021_covid 2022 2022_covid {
	gen povline`year' = .
	replace povline`year' = 1 if line_`year' =="below US$ 2.15"
	replace povline`year' = 2 if line_`year' =="between US$ 2.15 and US$ 3.65"
	replace povline`year' = 3 if line_`year' =="between US$ 3.65 and US$ 6.85"
	replace povline`year' = 9 if line_`year' =="Non-poor"
	
}

foreach line in 2013 2014 2015 2016 2017 2018 2019 2020 2020_covid 2021 2021_covid 2022 2022_covid {
	
	label define povline`line' 1 "below US$ 2.15" /*
	*/ 2 "between US$ 2.15 and US$ 3.65" /*
	*/ 3 "between US$ 3.65 and US$ 6.85" /*
	*/ 9 "Non-poor (>US$  6.85)", modify
	label values povline`line' povline`line' 
	
}
		
**** Generate poverty dummy variables for 2020,2021,2022,

foreach year in  2020 2020_covid 2021 2021_covid 2022 2022_covid {
	recode povline`year' (1 = 1) (2 3 9 = 0), gen(poor215_`year') 
	lab var poor215_`year' "Poor under $2.15 line"
	recode povline`year' (1 2 = 1) (3 9 = 0), gen(poor365_`year')
	lab var poor365_`year' "Poor under $3.65 line"
	recode povline`year' (1 2 3 = 1) (9 = 0), gen(poor685_`year')
	lab var poor685_`year' "Poor under $6.85 line"

}
	
	
	local lineyear  215_2013 365_2013 685_2013 215_2014 365_2014 685_2014 215_2015 365_2015 685_2015 215_2016 365_2016 685_2016 215_2017 365_2017 685_2017 215_2018 365_2018 685_2018 215_2019 365_2019 685_2019 215_2020 365_2020 685_2020 215_2021 365_2021 685_2021 215_2022 365_2022 685_2022 215_2020_covid 365_2020_covid 685_2020_covid 215_2021_covid 365_2021_covid 685_2021_covid 215_2022_covid 365_2022_covid 685_2022_covid
	
*** Child poverty variables
	foreach line of local lineyear  {
		gen child_poor`line'		=poor`line'*child 	if child==1
		label var child_poor`line' "Child is poor under $`line' line"
		gen adult_poor`line'		=poor`line'*adult 	if adult==1
		label var adult_poor`line' "Adult is poor under $`line' line"
	}

*** Clean up and save
	recode  relationharm (1=1) (nonmissing=0), gen(head)
	lab var head "Household head"
	//drop code gallT_ppp_2019 pop_2019
	gen one=1
	
	
	rename fcv_current fragile 
	 gen developing =0
	 replace developing =1 if incgroup_2019=="Low income" | incgroup_2019=="Lower middle income"
	
	order countrycode  region  developing fragile year 
	
	cap drop _me
	sort countrycode hhid
	compress
	
	local fcv "BFA SOM SYR YEM ARM AZE AFG BDI CMR CAF TCD COD ETH HTI IRQ LBY MLI MOZ MMR NER NGA SSD COG ERI GNB XKX LBN PNG SDN VEN PSE ZWE COM KIR MLH FSM SLB TLS TUV"
	
	gen fragile_2022 = "No"
foreach country of local fcv {
    replace fragile_2022 ="Yes" if strpos(countrycode, "`country'") 
}
	
	
	
	save "$out\dataForTables_nowcast", replace
	 
	 
	 

	 
	 
	 
	 
	 
	
