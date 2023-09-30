*******************************************************************************
* Download PIP data for 2019
* Author: Daylan Salmeron
* Date: September 2020
****************************************************************************
****************************************************************************

**Here we get the poverty numbers from PIP and merge it to the PSPR 2019 to create the poverty dummy for 2019. In this way we ensure the data quality.  

pip, country(all) year(2019) povline(2.15 3.65 6.85)clear  fillgaps

keep if reporting_level=="national" 

	keep if year==2019
    replace poverty_line=poverty_line*100
    tostring poverty_line, gen(pline) force
	loc ivars "country_code country_name population year welfare_type mean "
    keep pline headcount `ivars'
    reshape wide headcount, i(`ivars') j(pline) string
	ren (country_code country_name year welfare_type mean headcount215 headcount365 headcount685 population ) ///
    (countrycode country year inccon mean headcount215_2019 headcount365_2019 headcount685_2019 populationmil )
	
	keep  headcount215_2019 headcount365_2019 headcount685_2019 year countrycode
	
	tempfile pip_2019
	save `pip_2019'
	

	**Create dummies using PSPR data
u "$old_global", clear 	

merge m:1 countrycode using `pip_2019' , keep(1 3)

**Loop through each poverty line 
foreach  povline in 215_2019 365_2019 685_2019{
	
ta headcount`povline'
replace headcount`povline'=headcount`povline'*100
levelsof  countrycode, local(countries)
gen poor`povline'=. 

**loop through each country 
foreach country in `countries'{

                quietly su headcount`povline' if countrycode=="`country'"

                local povrate=r(mean)

                if `povrate'==0 {

                replace poor`povline'=0 if countrycode=="`country'"

                }

                else if `povrate' <.  {

                _pctile gallT_ppp [aw=weight] if countrycode=="`country'", p(`povrate')

                local pline=r(r1)

                replace poor`povline'=(gallT_ppp<`pline') if countrycode=="`country'"

                }

}

}

save "$new_global", replace


*******************************************************************************
**Now we run a loop for years 2013-2018 to get the headcounts for each year****
*******************************************************************************


local pip_13_18  2013 2014 2015 2016 2017 2018

foreach year of local pip_13_18 {
	
	pip, country(all) year(`year') povline(2.15 3.65 6.85)clear  fillgaps

keep if reporting_level=="national" 

	keep if year==`year'
    replace poverty_line=poverty_line*100
    tostring poverty_line, gen(pline) force
	loc ivars "country_code country_name population year welfare_type mean "
    keep pline headcount `ivars'
    reshape wide headcount, i(`ivars') j(pline) string
	ren (country_code country_name year welfare_type mean headcount215 headcount365 headcount685 population ) ///
    (countrycode country year inccon mean headcount215_`year' headcount365_`year' headcount685_`year' populationmil )
	
	keep  headcount215_`year' headcount365_`year' headcount685_`year' year countrycode
	
	tempfile pip_`year'
	save `pip_`year''
	
********************************************************************************
**Create the poverty dummies using the welfare from PSPR and our headcounts *****
********************************************************************************
	
	u "$new_global", clear 
drop _merge
merge m:1 countrycode using `pip_`year'' , keep(1 3)

**Loop through each poverty line 
foreach  povline in 215_`year' 365_`year' 685_`year' {
	
ta headcount`povline'
replace headcount`povline'=headcount`povline'*100
levelsof  countrycode, local(countries)
gen poor`povline'=. 

**loop through each country 
foreach country in `countries'{

                quietly su headcount`povline' if countrycode=="`country'"

                local povrate=r(mean)

                if `povrate'==0 {

                replace poor`povline'=0 if countrycode=="`country'"

                }

                else if `povrate' <.  {

                _pctile gallT_ppp [aw=weight] if countrycode=="`country'", p(`povrate')

                local pline=r(r1)

                replace poor`povline'=(gallT_ppp<`pline') if countrycode=="`country'"

                }

}

}

save "$new_global", replace 

	
}






