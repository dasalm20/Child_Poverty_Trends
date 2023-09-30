 clear
*******
******* 05- This code generate all the Tabels needed for our year of analysis 
******
 use "$out\dataForTables_nowcast", clear
	
	drop if childagecat==-1
    tabulate childagecat poor215_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table1_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    tabulate child  poor215_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
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
*Table 2: Child poverty by region
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    gen regioncode1=.
    replace regioncode1=1 if inlist(region,"East Asia & Pacific","EAP")
    replace regioncode1=2 if inlist(region,"South Asia","SAR")
    replace regioncode1=3 if inlist(region,"Sub-Saharan Africa","SSA")
    replace regioncode1=4 if inlist(region,"Latin America & Caribbean","LAC")
    replace regioncode1=5 if inlist(region,"Europe & Central Asia","ECA")
    replace regioncode1=6 if inlist(region,"Middle East & North Africa","MNA")

    gen regioncode2=regioncode1
    replace regioncode2=7 if inlist(countrycode,"CHN")
    replace regioncode2=8 if inlist(countrycode,"IND")
	replace regioncode2=9 if inlist(countrycode,"NGA")

	qui tabulate regioncode1 poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table2_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table2_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table2=Table2_1a[1,1...]\Table2_1b[1,1...]
    mat Table2=Table2\Table2_1a[2,1...]\Table2_1b[2,1...]
    mat Table2=Table2\Table2_1a[3,1...]\Table2_1b[3,1...]
    mat Table2=Table2\Table2_1a[4...,1...]
    mat rownames Table2="EAP" "China" "SAR" "India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table2="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table2, f(%4.1fc)


    

quietly tab regioncode2 poor215_2022_covid [iw=pop_2022_covid] if child==1, matcell(num) 
quietly tab regioncode2 poor215_2022_covid [iw=pop_2022_covid], matcell(den)
mata : st_matrix("chpop",  st_matrix("num") :/ st_matrix("den"))
mat li chpop



	
	
	
*******************************************************************************
*Table 3: Child poverty by income group
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    cap drop incgrcode*
    gen incgrcode=.
    replace incgrcode=1 if inlist(incgroup_2019,"High income")
    replace incgrcode=2 if inlist(countrycode,"GRC")
    replace incgrcode=3 if inlist(incgroup_2019,"Upper middle income")
    replace incgrcode=4 if inlist(incgroup_2019,"Lower middle income")
    replace incgrcode=5 if inlist(incgroup_2019,"Low income")

    gen incgrcode2=incgrcode
    replace incgrcode2=6 if inlist(countrycode,"IND")
    replace incgrcode2=7 if inlist(countrycode,"CHN")
    replace incgrcode2=8 if inlist(countrycode,"NGA")

    tabulate incgrcode poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table3_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    tabulate incgrcode2 poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table3_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table3=Table3_1[1..3,1...]
    mat Table3=Table3\Table3_2[2,1...]
    mat Table3=Table3\Table3_1[4,1...]
    mat Table3=Table3\Table3_2[1,1...]
    mat Table3=Table3\Table3_2[3,1...]
    mat Table3=Table3\Table3_1[5..6,1...]
    mat rownames Table3="HI" "HI_nonOECD" "UMI" "China" "LMI" "India" "Nigeria" "LI" "Total"
    matrix colnames Table3="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table3, f(%4.1fc)

	
	
	*Table 3.5: Child poverty by income group 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	local tn 4
    cap drop incgrcode*
    gen incgrcode=.
    replace incgrcode=1 if inlist(incgroup_2019,"High income")
    replace incgrcode=2 if inlist(countrycode,"GRC")
    replace incgrcode=3 if inlist(incgroup_2019,"Upper middle income")
    replace incgrcode=4 if inlist(incgroup_2019,"Lower middle income")
    replace incgrcode=5 if inlist(incgroup_2019,"Low income")

    gen incgrcode2=incgrcode
    replace incgrcode2=6 if inlist(countrycode,"IND")
    replace incgrcode2=7 if inlist(countrycode,"CHN")
    replace incgrcode2=8 if inlist(countrycode,"NGA")

    tabulate incgrcode poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    tabulate incgrcode2 poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table`tn'=Table`tn'_1[1..3,1...]
    mat Table`tn'=Table`tn'\Table`tn'_2[2,1...]
    mat Table`tn'=Table`tn'\Table`tn'_1[4,1...]
    mat Table`tn'=Table`tn'\Table`tn'_2[1,1...]
    mat Table`tn'=Table`tn'\Table`tn'_2[3,1...]
    mat Table`tn'=Table`tn'\Table`tn'_1[5..6,1...]
    mat rownames Table`tn'="HI" "HI_nonOECD" "UMI" "China" "LMI" "India" "Nigeria" "LI" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	*Table 3.9: Child poverty by income group 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	local tn 5
    cap drop incgrcode*
    gen incgrcode=.
    replace incgrcode=1 if inlist(incgroup_2019,"High income")
    replace incgrcode=2 if inlist(countrycode,"GRC")
    replace incgrcode=3 if inlist(incgroup_2019,"Upper middle income")
    replace incgrcode=4 if inlist(incgroup_2019,"Lower middle income")
    replace incgrcode=5 if inlist(incgroup_2019,"Low income")

    gen incgrcode2=incgrcode
    replace incgrcode2=6 if inlist(countrycode,"IND")
    replace incgrcode2=7 if inlist(countrycode,"CHN")
    replace incgrcode2=8 if inlist(countrycode,"NGA")

    tabulate incgrcode poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    tabulate incgrcode2 poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'_2=Z[6..8,2],100*H[6..8,2],100*S[6..8,2],100*T[6..8,1]

    mat Table`tn'=Table`tn'_1[1..3,1...]
    mat Table`tn'=Table`tn'\Table`tn'_2[2,1...]
    mat Table`tn'=Table`tn'\Table`tn'_1[4,1...]
    mat Table`tn'=Table`tn'\Table`tn'_2[1,1...]
    mat Table`tn'=Table`tn'\Table`tn'_2[3,1...]
    mat Table`tn'=Table`tn'\Table`tn'_1[5..6,1...]
    mat rownames Table`tn'="HI" "HI_nonOECD" "UMI" "China" "LMI" "India" "Nigeria" "LI" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	putexcel set "$root\03.output\Child poverty results_2022_covid_2.xlsx", sheet(fromStata) modify
    loc row=4
    forvalues i =1/5{
        di as error "Table `i'"
        mat li Table`i' 
        putexcel b`row' = matrix(Table`i'), names nformat(#.00)
        di _newline
        loc row = `row'+16
    }
     putexcel save
	e
*******************************************************************************
*Table 4: Child poverty by age group for LMIC line
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    qui tabulate childagecat poor365_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table4_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate child poor365_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table4_2=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat Table4=Table4_2[2,1...]
    mat Table4=Table4\Table4_1[1..4,1...]
    mat Table4=Table4\Table4_2[1,1...]
    mat Table4=Table4\Table4_1[5...,1...]
    matrix rownames Table4= "0_17" "0_4" "5_9" "10_14" "15_17" "18plus" "18_59" "60plus" "Total"
    matrix colnames Table4="Npoor_lmic" "PovHR_lmic" "Sh_poor_lmic" "Sh_pop_lmic"

    mat li Table4, f(%4.1fc)
	
	
*******************************************************************************
*Table 5: Child poverty by age group for UMIC line
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    qui tabulate childagecat poor685_2022_covid[iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table5_1=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate child poor685_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table5_2=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat Table5=Table5_2[2,1...]
    mat Table5=Table5\Table5_1[1..4,1...]
    mat Table5=Table5\Table5_2[1,1...]
    mat Table5=Table5\Table5_1[5...,1...]
    matrix rownames Table5= "0_17" "0_4" "5_9" "10_14" "15_17" "18plus" "18_59" "60plus" "Total"
    matrix colnames Table5="Npoor_umic" "PovHR_umic" "Sh_poor_umic" "Sh_pop_umic"

    mat li Table5, f(%4.1fc)
	

******************************************************************************* 
*Table 6: Fragile countries 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	
	
	
    local tn 6

    tabulate fragile_2022 poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Non-fragile states_2022" "Fragile states_2022" "Total"
    matrix colnames Table`tn'="N_poor" "pov_HR" "Sh_pov" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	******************************************************************************* 
*Table 7: Fragile countries 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear

    local tn 7

    tabulate fragile_2022 poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Non-fragile states_2022" "Fragile states_2022" "Total"
    matrix colnames Table`tn'="N_poor" "pov_HR" "Sh_pov" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	******************************************************************************* 
*Table 8: Fragile countries 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	
    local tn 8

    tabulate fragile_2022 poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Non-fragile states_2022" "Fragile states_2022" "Total"
    matrix colnames Table`tn'="N_poor" "pov_HR" "Sh_pov" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
*******************************************************************************
*Table 9: Child poverty by gender 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    drop if mi(male) | mi(adult)
    local tn 9
    gen child_gender=.
    replace child_gender=1 if child==1 & male==0
    replace child_gender=2 if child==1 & male==1
    replace child_gender=3 if adult==1 & male==0
    replace child_gender=4 if adult==1 & male==1
    la def child_gender 1 "Children - female" 2 "Children - male" 3 "Adults - female" 4 "Adults - female"
    numlabel child_gender, mask(#.) add
    lab val child_gender child_gender

    tabulate child_gender poor215_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Female children" "Male children" "Female adults" "Male adults" "Total"
    matrix colnames Table`tn'="N_poor" "pov_HR" "Sh_pov" "Sh_pop"
    mat li Table`tn', f(%4.1fc)


	*******************************************************************************
*Table 10: Child poverty by gender 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    drop if mi(male) | mi(adult)
    local tn 10
    gen child_gender=.
    replace child_gender=1 if child==1 & male==0
    replace child_gender=2 if child==1 & male==1
    replace child_gender=3 if adult==1 & male==0
    replace child_gender=4 if adult==1 & male==1
    la def child_gender 1 "Children - female" 2 "Children - male" 3 "Adults - female" 4 "Adults - female"
    numlabel child_gender, mask(#.) add
    lab val child_gender child_gender

    tabulate child_gender poor365_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Female children" "Male children" "Female adults" "Male adults" "Total"
    matrix colnames Table`tn'="N_poor" "pov_HR" "Sh_pov" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	*******************************************************************************
*Table 11: Child poverty by gender 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    drop if mi(male) | mi(adult)
    local tn 11
    gen child_gender=.
    replace child_gender=1 if child==1 & male==0
    replace child_gender=2 if child==1 & male==1
    replace child_gender=3 if adult==1 & male==0
    replace child_gender=4 if adult==1 & male==1
    la def child_gender 1 "Children - female" 2 "Children - male" 3 "Adults - female" 4 "Adults - female"
    numlabel child_gender, mask(#.) add
    lab val child_gender child_gender

    tabulate child_gender poor685_2022_covid [iw=pop_2022_covid], nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Female children" "Male children" "Female adults" "Male adults" "Total"
    matrix colnames Table`tn'="N_poor" "pov_HR" "Sh_pov" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
*******************************************************************************
*table 12 Child poverty by rural/urban 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	local tn 12
    qui tabulate urban poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Rural" "Urban" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	*******************************************************************************
*table 13 Child poverty by rural/urban  365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	local tn 13
    qui tabulate urban poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Rural" "Urban" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	*******************************************************************************
*table 14 Child poverty by rural/urban  685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
	local tn 14
    qui tabulate urban poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Rural" "Urban" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
*******************************************************************************
* table 15 Child poverty by household size 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 15
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/6.25=6 "Six") ///
        (6.5/7.25=7 "Seven") (7.5/8.25=8 "Eight") (8.5/9.25=9 "Nine") (9.5/100=10 "Ten or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three or less" "Four" "Five" "Six" "Seven" "Eight" "Nine" "Ten or more" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	*******************************************************************************
* table 16  Child poverty by household size 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 16
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/6.25=6 "Six") ///
        (6.5/7.25=7 "Seven") (7.5/8.25=8 "Eight") (8.5/9.25=9 "Nine") (9.5/100=10 "Ten or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three or less" "Four" "Five" "Six" "Seven" "Eight" "Nine" "Ten or more" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	*******************************************************************************
* table 17  Child poverty by household size 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 17
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/6.25=6 "Six") ///
        (6.5/7.25=7 "Seven") (7.5/8.25=8 "Eight") (8.5/9.25=9 "Nine") (9.5/100=10 "Ten or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three or less" "Four" "Five" "Six" "Seven" "Eight" "Nine" "Ten or more" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	*******************************************************************************
* table 18 Child poverty by gender of household head 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
   local tn 18

	** Identify households with female head
	gen hf = (head == 1 & male == 0)
	replace hf = . if missing(male) | missing(head)
	bysort countrycode year hhid : egen headfemale = max(hf)
	drop hf
	label var headfemale  "Household headed by female"
	label define headfemale 1 "Female head" 0 "Male head", modify
	label values headfemale headfemale
    numlabel headfemale, mask(#.) add
**GEN TABLES
    tabulate headfemale poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Male head" "Female head" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	
		*******************************************************************************
* table 19 Child poverty by gender of household head 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
   local tn 19

	** Identify households with female head
	gen hf = (head == 1 & male == 0)
	replace hf = . if missing(male) | missing(head)
	bysort countrycode year hhid : egen headfemale = max(hf)
	drop hf
	label var headfemale  "Household headed by female"
	label define headfemale 1 "Female head" 0 "Male head", modify
	label values headfemale headfemale
    numlabel headfemale, mask(#.) add
**GEN TABLES
    tabulate headfemale poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Male head" "Female head" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

		*******************************************************************************
* table 20 Child poverty by gender of household head 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
   local tn 20

	** Identify households with female head
	gen hf = (head == 1 & male == 0)
	replace hf = . if missing(male) | missing(head)
	bysort countrycode year hhid : egen headfemale = max(hf)
	drop hf
	label var headfemale  "Household headed by female"
	label define headfemale 1 "Female head" 0 "Male head", modify
	label values headfemale headfemale
    numlabel headfemale, mask(#.) add
**GEN TABLES
    tabulate headfemale poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Male head" "Female head" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	
*******************************************************************************
*table 21 Child poverty by education of household head 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 21

	** Identify education of head
	gen eh= educat4 if head==1
    bysort countrycode year hhid: egen eduhead = max(eh)
	drop eh
	label var eduhead  "Education of household head"
	label define eduhead 1 "No education" 2 "Primary" 3 "Secondary" 4 "Tertiary", modify
	label values eduhead eduhead
    numlabel eduhead, mask(#.) add

    tabulate eduhead poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="No education" "Primary" "Secondary" "Tertiary" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	*******************************************************************************
*table 22 Child poverty by education of household head 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 22

	** Identify education of head
	gen eh= educat4 if head==1
    bysort countrycode year hhid: egen eduhead = max(eh)
	drop eh
	label var eduhead  "Education of household head"
	label define eduhead 1 "No education" 2 "Primary" 3 "Secondary" 4 "Tertiary", modify
	label values eduhead eduhead
    numlabel eduhead, mask(#.) add

    tabulate eduhead poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="No education" "Primary" "Secondary" "Tertiary" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	*******************************************************************************
*table 23 Child poverty by education of household head 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 23

	** Identify education of head
	gen eh= educat4 if head==1
    bysort countrycode year hhid: egen eduhead = max(eh)
	drop eh
	label var eduhead  "Education of household head"
	label define eduhead 1 "No education" 2 "Primary" 3 "Secondary" 4 "Tertiary", modify
	label values eduhead eduhead
    numlabel eduhead, mask(#.) add

    tabulate eduhead poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="No education" "Primary" "Secondary" "Tertiary" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

    

    
    
*******************************************************************************
* table 24 Child poverty by industry of household head 215
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 24

	** Identify education of head
    * 1=Agri; 2=Mining, manufacturing, public utility services, construction; ///
        *3=commerce, transport & communications, fin & business svcs, public admin; 4=other services, unspecified
    drop industrycat4 //This variable isn't coded correctly
    recode industrycat10 (1=1)(2 3 4 5=2)(6 7 8 9=3)(10=4), gen(industrycat4)
	gen ih= industrycat4 if head==1
    bysort countrycode year hhid: egen indhead = max(ih)
	drop ih
	label var indhead  "Industry of household head"
	label define indhead 1 "Agriculture" 2 "Industry" 3 "Services" 4 "Other", modify
	label values indhead indhead
    numlabel indhead, mask(#.) add

    tabulate indhead poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Agriculture" "Industry" "Services" "Other" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

	
	*******************************************************************************
* table 25 Child poverty by industry of household head 365
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 25

	** Identify education of head
    * 1=Agri; 2=Mining, manufacturing, public utility services, construction; ///
        *3=commerce, transport & communications, fin & business svcs, public admin; 4=other services, unspecified
    drop industrycat4 //This variable isn't coded correctly
    recode industrycat10 (1=1)(2 3 4 5=2)(6 7 8 9=3)(10=4), gen(industrycat4)
	gen ih= industrycat4 if head==1
    bysort countrycode year hhid: egen indhead = max(ih)
	drop ih
	label var indhead  "Industry of household head"
	label define indhead 1 "Agriculture" 2 "Industry" 3 "Services" 4 "Other", modify
	label values indhead indhead
    numlabel indhead, mask(#.) add

    tabulate indhead poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Agriculture" "Industry" "Services" "Other" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	
	*******************************************************************************
* table 26 Child poverty by industry of household head 685
*******************************************************************************
    use "$out\dataForTables_nowcast", clear
    local tn 26

	** Identify education of head
    * 1=Agri; 2=Mining, manufacturing, public utility services, construction; ///
        *3=commerce, transport & communications, fin & business svcs, public admin; 4=other services, unspecified
    drop industrycat4 //This variable isn't coded correctly
    recode industrycat10 (1=1)(2 3 4 5=2)(6 7 8 9=3)(10=4), gen(industrycat4)
	gen ih= industrycat4 if head==1
    bysort countrycode year hhid: egen indhead = max(ih)
	drop ih
	label var indhead  "Industry of household head"
	label define indhead 1 "Agriculture" 2 "Industry" 3 "Services" 4 "Other", modify
	label values indhead indhead
    numlabel indhead, mask(#.) add

    tabulate indhead poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'="Agriculture" "Industry" "Services" "Other" "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	
	
		
	


	
	*********************************************************************
**Table 27 children or not children 215
********************************************************************  

use "$out\dataForTables_nowcast", clear
local tn 27
gen hijo=0
replace hijo =1 if !mi(hsize) & child==1 

 qui tabulate hijo poor215_2022_covid [iw=pop_2022_covid]  , nofreq row matcell(F)
 mata: shares()
 mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

 mat rownames Table`tn'="No Children" "Children" "Total"
 matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
 mat li Table15, f(%4.1fc)	
	
	
		
	*********************************************************************
**Table 28 children or not children 365
********************************************************************  

use "$out\dataForTables_nowcast", clear
local tn 28
gen hijo=0
replace hijo =1 if !mi(hsize) & child==1 

 qui tabulate hijo poor365_2022_covid [iw=pop_2022_covid]  , nofreq row matcell(F)
 mata: shares()
 mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

 mat rownames Table`tn'="No Children" "Children" "Total"
 matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
 mat li Table15, f(%4.1fc)	
	
		
		
			
	*********************************************************************
**Table 29 children or not children 685
********************************************************************  

use "$out\dataForTables_nowcast", clear
local tn 29
gen hijo=0
replace hijo =1 if !mi(hsize) & child==1 

 qui tabulate hijo poor685_2022_covid [iw=pop_2022_covid]  , nofreq row matcell(F)
 mata: shares()
 mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

 mat rownames Table`tn'="No Children" "Children" "Total"
 matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
 mat li Table15, f(%4.1fc)	
	*********************************************************************
**Table 30 child poverty by region 3.65
********************************************************************  	

	
	use "$out\dataForTables_nowcast", clear
	
	local tn 30
    gen regioncode1=.
    replace regioncode1=1 if inlist(region,"East Asia & Pacific","EAP")
    replace regioncode1=2 if inlist(region,"South Asia","SAR")
    replace regioncode1=3 if inlist(region,"Sub-Saharan Africa","SSA")
    replace regioncode1=4 if inlist(region,"Latin America & Caribbean","LAC")
    replace regioncode1=5 if inlist(region,"Europe & Central Asia","ECA")
    replace regioncode1=6 if inlist(region,"Middle East & North Africa","MNA")

    gen regioncode2=regioncode1
    replace regioncode2=7 if inlist(countrycode,"CHN")
    replace regioncode2=8 if inlist(countrycode,"IND")
	replace regioncode2=9 if inlist(countrycode,"NGA")

	qui tabulate regioncode1 poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table30_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table30_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table30=Table30_1a[1,1...]\Table30_1b[1,1...]
    mat Table30=Table30\Table30_1a[2,1...]\Table30_1b[2,1...]
    mat Table30=Table30\Table30_1a[3,1...]\Table30_1b[3,1...]
    mat Table30=Table30\Table30_1a[4...,1...]
    mat rownames Table30="EAP" "China" "SAR" "India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table30="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table30, f(%4.1fc)


 
quietly tab regioncode2 poor365_2022_covid [iw=pop_2022_covid] if child==1, matcell(num) 
quietly tab regioncode2 poor365_2022_covid [iw=pop_2022_covid], matcell(den)
mata : st_matrix("chpop",  st_matrix("num") :/ st_matrix("den"))
mat li chpop


*********************************************************************
**Table 31 child poverty by region 685
********************************************************************  	

	
	use "$out\dataForTables_nowcast", clear
    gen regioncode1=.
    replace regioncode1=1 if inlist(region,"East Asia & Pacific","EAP")
    replace regioncode1=2 if inlist(region,"South Asia","SAR")
    replace regioncode1=3 if inlist(region,"Sub-Saharan Africa","SSA")
    replace regioncode1=4 if inlist(region,"Latin America & Caribbean","LAC")
    replace regioncode1=5 if inlist(region,"Europe & Central Asia","ECA")
    replace regioncode1=6 if inlist(region,"Middle East & North Africa","MNA")

    gen regioncode2=regioncode1
    replace regioncode2=7 if inlist(countrycode,"CHN")
    replace regioncode2=8 if inlist(countrycode,"IND")
	replace regioncode2=9 if inlist(countrycode,"NGA")

	qui tabulate regioncode1 poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table31_1a=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    qui tabulate regioncode2 poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table31_1b=Z[7..9,2],100*H[7..9,2],100*S[7..9,2],100*T[7..9,1]

    mat Table31=Table31_1a[1,1...]\Table31_1b[1,1...]
    mat Table31=Table31\Table31_1a[2,1...]\Table31_1b[2,1...]
    mat Table31=Table31\Table31_1a[3,1...]\Table31_1b[3,1...]
    mat Table31=Table31\Table31_1a[4...,1...]
    mat rownames Table31="EAP" "China" "SAR" "India" "SSA" "Nigeria" "LAC" "ECA" "MNA" "Total"
    matrix colnames Table31="Npoor" "PovHR" "Sh_poor" "Sh_pop"

    mat li Table31, f(%4.1fc)


 
quietly tab regioncode2 poor685_2022_covid [iw=pop_2022_covid] if child==1, matcell(num) 
quietly tab regioncode2 poor685_2022_covid[iw=pop_2022_covid], matcell(den)
mata : st_matrix("chpop",  st_matrix("num") :/ st_matrix("den"))
mat li chpop

	
 

 
 
 
 
 
 ****table 32  215
 use "$out\dataForTables_nowcast", clear
    local tn 32
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/100=6 "Six or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three" "Four" "Five" "Six or more"  "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	****table 33  365
 use "$out\dataForTables_nowcast", clear
    local tn 33
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/100=6 "Six or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three" "Four" "Five" "Six or more"  "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)
	
	
	****table 33  215
 use "$out\dataForTables_nowcast", clear
    local tn 33
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/100=6 "Six or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor215_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three" "Four" "Five" "Six or more"  "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)

****table 34  365
 use "$out\dataForTables_nowcast", clear
    local tn 34
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/100=6 "Six or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor365_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three" "Four" "Five" "Six or more"  "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)


****table 35  685
 use "$out\dataForTables_nowcast", clear
    local tn 35
    recode hsize  (1/2.25=2 "Two or less") (2.5/3.25=3 "Three") (3.5/4.25=4 "Four") (4.5/5.25=5 "Five") (5.5/100=6 "Six or more"), gen(hsizecat)
	*ta hsize hsizecat
    tabulate hsizecat poor685_2022_covid [iw=pop_2022_covid] if child==1, nofreq row matcell(F)
    mata: shares()
    mat Table`tn'=Z[1...,2],100*H[1...,2],100*S[1...,2],100*T

    mat rownames Table`tn'=  "Two or less" "Three" "Four" "Five" "Six or more"  "Total"
    matrix colnames Table`tn'="Npoor" "PovHR" "Sh_poor" "Sh_pop"
    mat li Table`tn', f(%4.1fc)



*******************************************************************************
* Export all tables to Excel
*******************************************************************************
   
	putexcel set "$out\final_from_2022_lines_2022_covid.xlsx", sheet(fromStata) modify
    loc row=4
    forvalues i =1/35{
        di as error "Table `i'"
        mat li Table`i' 
        putexcel b`row' = matrix(Table`i'), names nformat(#.00)
        di _newline
        loc row = `row'+16
    }
     putexcel save
	 
	 
