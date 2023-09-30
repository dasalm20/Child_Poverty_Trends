*******************************************************************************
* This program generates all of the tables to be reported in the note
* Ani Rudra Silwal
* Date: September 2020
*******************************************************************************

*******************************************************************************
*Table 1: Child poverty by age group
*******************************************************************************
 clear
 
 
 
 
 ** 01- This look generates the child poverty tables by age for each year below. 
 local  years 2013 2014 2015 2016 2017 2018 2019  2020 2020_covid  2021 2021_covid 2022 2022_covid
 
 foreach year of local years{
 
 use "$out\dataForTables_nowcast_SSA", clear
	
	drop if childagecat==-1
    tabulate childagecat poor215_`year' [iw=pop_`year'], nofreq row matcell(F)
    mata: shares()
    mat Table1_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    tabulate child  poor215_`year' [iw=pop_`year'], nofreq row matcell(F)
    mata: shares()
    mat Table1_2=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat Table1=Table1_2[2,1...]
    mat Table1=Table1\Table1_1[1..4,1...]
    mat Table1=Table1\Table1_2[1,1...]
    mat Table1=Table1\Table1_1[5...,1...]
    matrix rownames Table1= "0_17" "0_4" "5_9" "10_14" "15_17" "18plus" "18_59" "60plus" "Total"
    matrix colnames Table1="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table1, f(%4.1fc)


*******************************************************************************
*Table 2: Child poverty by age group for LMIC line
*******************************************************************************
    use "$out\dataForTables_nowcast_SSA", clear
    qui tabulate childagecat poor365_`year' [iw=pop_`year'], nofreq row matcell(F)
    mata: shares()
    mat Table2_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate child poor365_`year' [iw=pop_`year'], nofreq row matcell(F)
    mata: shares()
    mat Table2_2=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat Table2=Table2_2[2,1...]
    mat Table2=Table2\Table2_1[1..4,1...]
    mat Table2=Table2\Table2_2[1,1...]
    mat Table2=Table2\Table2_1[5...,1...]
    matrix rownames Table2= "0_17" "0_4" "5_9" "10_14" "15_17" "18plus" "18_59" "60plus" "Total"
    matrix colnames Table2="Npoor_lmic" "PovHR_lmic" "Sh_poor_lmic" "Sh_pop_lmic"

    mat li Table2, f(%4.1fc)
	 
	
*******************************************************************************
*Table 3: Child poverty by age group for UMIC line
*******************************************************************************
    use "$out\dataForTables_nowcast_SSA", clear
    qui tabulate childagecat poor685_`year'[iw=pop_`year'], nofreq row matcell(F)
    mata: shares()
    mat Table5_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate child poor685_`year' [iw=pop_`year'], nofreq row matcell(F)
    mata: shares()
    mat Table3_2=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat Table3=Table3_2[2,1...]
    mat Table3=Table3\Table3_1[1..4,1...]
    mat Table3=Table3\Table3_2[1,1...]
    mat Table3=Table3\Table3_1[5...,1...]
    matrix rownames Table3= "0_17" "0_4" "5_9" "10_14" "15_17" "18plus" "18_59" "60plus" "Total"
    matrix colnames Table3="Npoor_umic" "PovHR_umic" "Sh_poor_umic" "Sh_pop_umic"

    mat li Table3, f(%4.1fc)
	
	
*******************************************************************************
* Export all tables to Excel
*******************************************************************************
   
	 putexcel set "$out/all_years_child_pov.xlsx", sheet("Sheet`year'") modify
    loc row=4
    foreach  i  in 1 4 5 {
        di as error "Table `i'"
        mat li Table`i' 
        putexcel b`row' = matrix(Table`i'), names nformat(#.00)
        di _newline
        loc row = `row'+16
    }
     putexcel save
	 
	 
 }
	 
	
	
	**02- This code generates the poverty gap 
*******************************************************************************
* Poverty gap
*******************************************************************************
    use "$out\dataForTables_nowcast_SSA", clear
	ta	child [aw=pop_2022_covid], su(poor215_2022_covid)
	apoverty welfare2022_covid [aw=pop_2022_covid], line(2.15) h pgr //Full sample
	apoverty welfare2022_covid if child==1 [aw=pop_2022_covid], line(2.15) h pgr //Children
	apoverty welfare2022_covid if child==0 [aw=pop_2022_covid], line(2.15) h pgr //Adults
	
	* Age categories
	forvalues i=1(1)6{
		local lab`i' : label childagecat `i'
		di in red "Category: " "`lab`i''"
		apoverty welfare2022_covid if childagecat==`i' [aw=pop_2022_covid], line(2.15) h pgr
		di in red "Poverty gap ratio (%) for category " "`lab`i'': "  r(pogapr_1)
	}
	
	
	
	
********************************************************************************
***03 - this code generates the regional tables and income group tables for ****
******** years 13 17 20_covid and 22_covid considering the scenarios of with ****
********* and without China-India-NIgeria*****************************************
********************************************************************************
	
local years 2022_covid 2013  2017 2020_covid 

foreach year of local years {
    
	
	**Table 1: Regional 215 
	
	use "$out\dataForTables_nowcast_SSA_SSA", clear
	 gen regioncode1=.
    replace regioncode1=1 if inlist(region,"East Asia & Pacific","EAP") & countrycode !="CHN"
    replace regioncode1=2 if inlist(region,"South Asia","SAR") & countrycode != "IND"
    replace regioncode1=3 if inlist(region,"Sub-Saharan Africa","SSA") & countrycode !="NGA"
    replace regioncode1=4 if inlist(region,"Latin America & Caribbean","LAC")
    replace regioncode1=5 if inlist(region,"Europe & Central Asia","ECA")
    replace regioncode1=6 if inlist(region,"Middle East & North Africa","MNA")

    gen regioncode2=regioncode1
         
	replace regioncode2 =7 if   inlist(countrycode,"CHN")
    replace regioncode2=8 if inlist(countrycode,"IND")
	replace regioncode2=9 if inlist(countrycode,"NGA")


	qui tabulate regioncode1 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table1_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table1_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table1=Table1_1a[1,1...]\Table1_1b[1,1...]
    mat Table1=Table1\Table1_1a[2,1...]\Table1_1b[2,1...]
    mat Table1=Table1\Table1_1a[3,1...]\Table1_1b[3,1...]
    mat Table1=Table1\Table1_1a[4...,1...]
    mat rownames Table1="EAP without China" "China" "SAR without India" "India" "SSA without Nigeria" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table1="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table1, f(%4.1fc)
	
	
	**Table 2 : Regional 365
	

    
	qui tabulate regioncode1 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table2_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table2_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table2=Table2_1a[1,1...]\Table2_1b[1,1...]
    mat Table2=Table2\Table2_1a[2,1...]\Table2_1b[2,1...]
    mat Table2=Table2\Table2_1a[3,1...]\Table2_1b[3,1...]
    mat Table2=Table2\Table2_1a[4...,1...]
    mat rownames Table2="EAP" "China" "SAR" " India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table2="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table2, f(%4.1fc)


**Table 3 

*********child poverty by region 685  	
	
    

	qui tabulate regioncode1 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table3_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table3_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table3=Table3_1a[1,1...]\Table3_1b[1,1...]
    mat Table3=Table3\Table3_1a[2,1...]\Table3_1b[2,1...]
    mat Table3=Table3\Table3_1a[3,1...]\Table3_1b[3,1...]
    mat Table3=Table3\Table3_1a[4...,1...]
    mat rownames Table3="EAP" "China" "SAR" "India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table3="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table3, f(%4.1fc)

**************************
**************************
*************************
*************************

**Table 4: Regional 215 With ALL
	
	use "$out\dataForTables_nowcast_SSA", clear
	 gen regioncode1=.
    replace regioncode1=1 if inlist(region,"East Asia & Pacific","EAP") 
    replace regioncode1=2 if inlist(region,"South Asia","SAR") 
    replace regioncode1=3 if inlist(region,"Sub-Saharan Africa","SSA") 
    replace regioncode1=4 if inlist(region,"Latin America & Caribbean","LAC")
    replace regioncode1=5 if inlist(region,"Europe & Central Asia","ECA")
    replace regioncode1=6 if inlist(region,"Middle East & North Africa","MNA")

    gen regioncode2=regioncode1
         
	replace regioncode2 =7 if   inlist(countrycode,"CHN")
    replace regioncode2=8 if inlist(countrycode,"IND")
	replace regioncode2=9 if inlist(countrycode,"NGA")


	qui tabulate regioncode1 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table4_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table4_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table4=Table4_1a[1,1...]\Table4_1b[1,1...]
    mat Table4=Table4\Table4_1a[2,1...]\Table4_1b[2,1...]
    mat Table4=Table4\Table4_1a[3,1...]\Table4_1b[3,1...]
    mat Table4=Table4\Table4_1a[4...,1...]
    mat rownames Table4="EAP without China" "China" "SAR without India" "India" "SSA without Nigeria" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table4="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table4, f(%4.1fc)
	
	
	**Table 5 : Regional 365
	
	qui tabulate regioncode1 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table5_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table5_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table5=Table5_1a[1,1...]\Table5_1b[1,1...]
    mat Table5=Table5\Table5_1a[2,1...]\Table5_1b[2,1...]
    mat Table5=Table5\Table5_1a[3,1...]\Table5_1b[3,1...]
    mat Table5=Table5\Table5_1a[4...,1...]
    mat rownames Table5="EAP" "China" "SAR" " India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table5="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table5, f(%4.1fc)


**Table 6

*********child poverty by region 685  	
	
	

	qui tabulate regioncode1 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table6_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table6_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table6=Table6_1a[1,1...]\Table6_1b[1,1...]
    mat Table6=Table6\Table6_1a[2,1...]\Table6_1b[2,1...]
    mat Table6=Table6\Table6_1a[3,1...]\Table6_1b[3,1...]
    mat Table6=Table6\Table6_1a[4...,1...]
    mat rownames Table6="EAP" "China" "SAR" "India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table6="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table6, f(%4.1fc)


 *****************************************************************************************************
 
	

	
	**Table7: By income group without CHN and IND
   
   use "$out\dataForTables_nowcast_SSA", clear
    cap drop incgrcode*
    gen incgrcode=.
    replace incgrcode=1 if inlist(incgroup_2019,"High income")
    replace incgrcode=2 if inlist(countrycode,"GRC")
    replace incgrcode=3 if inlist(incgroup_2019,"Upper middle income") & countrycode != "CHN"
    replace incgrcode=4 if inlist(incgroup_2019,"Lower middle income") & countrycode != "IND"
    replace incgrcode=5 if inlist(incgroup_2019,"Low income")

     gen incgrcode2=incgrcode
	 
	 replace incgrcode2=7 if incgrcode==3 & countrycode=="CHN"
	replace incgrcode2=6 if countrycode=="IND"
	replace incgrcode2=8 if countrycode=="NGA"
	
    tabulate incgrcode poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table7_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table7_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table7=Table7_1[1..3,1...]
    mat Table7=Table7\Table7_2[2,1...]
    mat Table7=Table7\Table7_1[4,1...]
    mat Table7=Table7\Table7_2[1,1...]
    mat Table7=Table7\Table7_2[3,1...]
    mat Table7=Table7\Table7_1[5..6,1...]
    mat rownames Table7="HI" "HI_nonOECD" "UMI without China" "China" "LMI without IND" "India" " Nigeria" "LI" "Total"
    matrix colnames Table7="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table7, f(%4.1fc)
	
	

	
	***Table 8: 365 income group w/ CHN and w/IND
	
	 tabulate incgrcode poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table8_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table8_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table8=Table8_1[1..3,1...]
    mat Table8=Table8\Table8_2[2,1...]
    mat Table8=Table8\Table8_1[4,1...]
    mat Table8=Table8\Table8_2[1,1...]
    mat Table8=Table8\Table8_2[3,1...]
    mat Table8=Table8\Table8_1[5..6,1...]
    mat rownames Table8="HI" "HI_nonOECD" "UMI w/ CNH" "China" "LMI w/ IND" "India" " Nigeria" "LI" "Total"
    matrix colnames Table8="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table4, f(%4.1fc)
	
	
	
	

	
	***Table 9 : 685 income group  w/ IND w/ CHN
	
	 tabulate incgrcode poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table9_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table9_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table9=Table9_1[1..3,1...]
    mat Table9=Table9\Table9_2[2,1...]
    mat Table9=Table9\Table9_1[4,1...]
    mat Table9=Table9\Table9_2[1,1...]
    mat Table9=Table9\Table9_2[3,1...]
    mat Table9=Table9\Table9_1[5..6,1...]
    mat rownames Table9="HI" "HI_nonOECD" "UMI w/ CHN" "China" "LMI W/ IND" "India" " Nigeria" "LI" "Total"
    matrix colnames Table9="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table9, f(%4.1fc)
	
	
	

	*table 12
** INCOME GROUP WITHOUT NGA 
use "$out\dataForTables_nowcast_SSA", clear
    cap drop incgrcode*
    gen incgrcode=.
    replace incgrcode=1 if inlist(incgroup_2019,"High income")
    replace incgrcode=2 if inlist(countrycode,"GRC")
    replace incgrcode=3 if inlist(incgroup_2019,"Upper middle income") 
    replace incgrcode=4 if inlist(incgroup_2019,"Lower middle income") & countrycode !="NGA"
    replace incgrcode=5 if inlist(incgroup_2019,"Low income")

     gen incgrcode2=incgrcode
	 
	 replace incgrcode2=7 if incgrcode==3 & countrycode=="CHN"
	replace incgrcode2=6 if countrycode=="IND"
	replace incgrcode2=8 if countrycode=="NGA"
	
    tabulate incgrcode poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table10_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table10_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table10=Table10_1[1..3,1...]
    mat Table10=Table10\Table10_2[2,1...]
    mat Table10=Table10\Table10_1[4,1...]
    mat Table10=Table10\Table10_2[1,1...]
    mat Table10=Table10\Table10_2[3,1...]
    mat Table10=Table10\Table10_1[5..6,1...]
    mat rownames Table10="HI" "HI_nonOECD" "UMI" "China" "LMI w/o NGA" "India" " Nigeria" "LI" "Total"
    matrix colnames Table10="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table10, f(%4.1fc)
	
	

	
	***Table 11 : 365 income group 
	
	 tabulate incgrcode poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table11_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table11_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table11=Table11_1[1..3,1...]
    mat Table11=Table11\Table11_2[2,1...]
    mat Table11=Table11\Table11_1[4,1...]
    mat Table11=Table11\Table11_2[1,1...]
    mat Table11=Table11\Table11_2[3,1...]
    mat Table11=Table11\Table11_1[5..6,1...]
    mat rownames Table11="HI" "HI_nonOECD" "UMI" "China" "LMI w/o NGA" "India" " Nigeria" "LI" "Total"
    matrix colnames Table11="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table11, f(%4.1fc)
	
	
	
	***Table 12 : 685 income group 
	
	 tabulate incgrcode poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table12_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table12_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table12=Table12_1[1..3,1...]
    mat Table12=Table12\Table12_2[2,1...]
    mat Table12=Table12\Table12_1[4,1...]
    mat Table12=Table12\Table12_2[1,1...]
    mat Table12=Table12\Table12_2[3,1...]
    mat Table12=Table12\Table12_1[5..6,1...]
    mat rownames Table12="HI" "HI_nonOECD" "UMI" "China" "LMI w/o NGA" "India" " Nigeria" "LI" "Total"
    matrix colnames Table12="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table12, f(%4.1fc)


   

   ***ALL
   use "$out\dataForTables_nowcast_SSA", clear
    cap drop incgrcode*
    gen incgrcode=.
    replace incgrcode=1 if inlist(incgroup_2019,"High income")
    replace incgrcode=2 if inlist(countrycode,"GRC")
    replace incgrcode=3 if inlist(incgroup_2019,"Upper middle income") 
    replace incgrcode=4 if inlist(incgroup_2019,"Lower middle income") 
    replace incgrcode=5 if inlist(incgroup_2019,"Low income")

     gen incgrcode2=incgrcode
	 
	 replace incgrcode2=7 if incgrcode==3 & countrycode=="CHN"
	replace incgrcode2=6 if countrycode=="IND"
	replace incgrcode2=8 if countrycode=="NGA"
	
    tabulate incgrcode poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table13_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor215_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table13_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table13=Table13_1[1..3,1...]
    mat Table13=Table13\Table13_2[2,1...]
    mat Table13=Table13\Table13_1[4,1...]
    mat Table13=Table13\Table13_2[1,1...]
    mat Table13=Table13\Table13_2[3,1...]
    mat Table13=Table13\Table13_1[5..6,1...]
    mat rownames Table13="HI" "HI_nonOECD" "UMI" "China" "LMI" "India" " Nigeria" "LI" "Total"
    matrix colnames Table13="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table13, f(%4.1fc)
	
	

	
	***Table 14 : 365 income group 
	
	 tabulate incgrcode poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table14_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor365_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table14_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table14=Table14_1[1..3,1...]
    mat Table14=Table14\Table14_2[2,1...]
    mat Table14=Table14\Table14_1[4,1...]
    mat Table14=Table14\Table14_2[1,1...]
    mat Table14=Table14\Table14_2[3,1...]
    mat Table14=Table14\Table14_1[5..6,1...]
    mat rownames Table14="HI" "HI_nonOECD" "UMI" "China" "LMI" "India" " Nigeria" "LI" "Total"
    matrix colnames Table14="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table14, f(%4.1fc)
	
	
	
	***Table 15 : 685 income group 
	
	 tabulate incgrcode poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table15_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T
    tabulate incgrcode2 poor685_`year' [iw=pop_`year'] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table15_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table15=Table15_1[1..3,1...]
    mat Table15=Table15\Table15_2[2,1...]
    mat Table15=Table15\Table15_1[4,1...]
    mat Table15=Table15\Table15_2[1,1...]
    mat Table15=Table15\Table15_2[3,1...]
    mat Table15=Table15\Table15_1[5..6,1...]
    mat rownames Table15="HI" "HI_nonOECD" "UMI" "China" "LMI" "India" " Nigeria" "LI" "Total"
    matrix colnames Table15="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table15, f(%4.1fc)

  
  ** Write matrix to new sheet in Excel file
    putexcel set "$out/without_issue_v02.xlsx", sheet("Sheet`year'") modify
    loc row=4
  foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15  {
        di as error "Table `i'"
        mat li Table`i' 
        putexcel b`row' = matrix(Table`i'), names nformat(#.00)
        di _newline
        loc row = `row'+16
    }
    putexcel save
}
	
	
	
	
	
	
	
	
	


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
	
	