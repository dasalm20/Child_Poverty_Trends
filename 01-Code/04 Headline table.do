*******************************************************************************
* This program generates the headline numbers to be reported in the note
*
*******************************************************************************

*******************************************************************************
* Population UNDESA
*******************************************************************************
   
   /*use "$UNpopdata_nowcast", clear
	
    gen double child=1 if inlist(cohort,"00to04","05to09","10to14")
    replace child=3/5 if inlist(cohort,"15to19")
    replace child=0 if !inlist(cohort,"00to04","05to09","10to14")
    ren pop_w2020 popUN
    gen double popUN_child=popUN*child
    collapse (sum) popUN*, by(countrycode)
    gen popUN_adult=popUN-popUN_child
    tempfile popUN
	
    save `popUN', replace
    su*/

*******************************************************************************
* Povcalnet data	
*******************************************************************************
	
    
*******************************************************************************
* Generate country-level file    
*******************************************************************************
    use "$out\dataForTables_nowcast", clear

   
   collapse (sum) /*
        */ n_poor_ch215_2022_covid =child_poor215_2022_covid n_poor_ad215_2022_covid=adult_poor215_2022_covid n_poor215_2022_covid=poor215_2022_covid    /*
        */ n_poor_ch365_2022_covid=child_poor365_2022_covid n_poor_ad365_2022_covid=adult_poor365_2022_covid n_poor365_2022_covid=poor365_2022_covid    /*
        */ n_poor_ch685_2022_covid=child_poor685_2022_covid n_poor_ad685_2022_covid=adult_poor685_2022_covid n_poor685_2022_covid=poor685_2022_covid    /*
        */ n_pop_ch_2022_covid=child n_pop_ad_2022_covid=adult n_pop_2022_covid=one        /*
        */ (mean)                                           /*
        */ pc_poor_ch215_2022_covid=child_poor215_2022_covid pc_poor_ad215_2022_covid=adult_poor215_2022_covid pc_poor215_2022_covid=poor215_2022_covid   /*
        */ pc_poor_ch365_2022_covid=child_poor365_2022_covid pc_poor_ad365_2022_covid=adult_poor365_2022_covid pc_poor365_2022_covid=poor365_2022_covid   /*
        */ pc_poor_ch685_2022_covid=child_poor685_2022_covid pc_poor_ad685_2022_covid=adult_poor685_2022_covid pc_poor685_2022_covid=poor685_2022_covid  /*
        */ (min) year1=year (max) year2=year                /*
        */ [iw=pop_2022_covid], by(countrycode countryname) 

       
        for var pc_*: replace X=X*100
		**This generates the numbers in Millions or Thousands, adjust as needed
        for var n_*: replace X=X/1000000
	
 merge 1:1 countrycode using "$wbcodes"
 
 keep if _merge==3
 

 ***Now you can either save the dta or take it to an excel sheet 
 
 
 *** Save the dta for maps 
 keep countrycode countryname  pc_poor_ch215_2022_covid pc_poor_ch365_2022_covid pc_poor_ch685_2022_covid n_poor_ch215_2022_covid n_poor_ch365_2022_covid n_poor_ch685_2022_covid
 
 save "$out/formaps.dta",replace
 
 
 
 
 
 
 
 
