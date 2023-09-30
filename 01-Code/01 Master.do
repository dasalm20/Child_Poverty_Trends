/*******************************************************************************
* Project: Trends Global estimate of child poverty 
* Author: Daylan Salmeron Gomez
* This code is bilt up on a previous version by Ani Sidra
* Earlier contribution to this project by David Newhouse.
* Date: JUL 2022
*******************************************************************************/

*******************************************************************************
* Preliminaries
*******************************************************************************
	cls
	version 16.0

* Paths
    gl root			"\\WBGMSAFR1001\AFR_Database\SSAPOV-Harmonization\Daylan\Child_poverty_projects"
    gl do			"$root\001.do215 _NowCast"
    gl out			"$root\03.output\output_10_01_2022"
    gl inp           "$root\02.input"

* Log and timer
    cls
    timer clear
    timer on 100 //Timer for all programs
    timer on 1
    cap log close _all
   
* Datasets
  
    gl tabledata2019_nowcast  "$inp\derived_input\new_global.dta"
	
    gl wbcodes       "$inp\Class.dta"
    gl rawPovcal	 "$inp\Misc\new_global"
	gl povPovcal 	 "$inp\derived_input\PovcalNet_data.dta"
	
    gl popWDI_2020        "$inp\derived_input\popWDI_pop_2020.dta"
	gl popWDI_2029        "$inp\derived_input\popWDI_pop_2029.dta"
    gl popWDI_nowcast        "$inp\derived_input\popWDI_pop_2019.dta"
    
	
* PSPR data 2019

	gl old_global            "$inp\global_lineup100@2.dta" 
	gl new_global            "$inp\derived_input\new_global.dta"
	
	**Data from Nishan, welfare in 1000 bins
	gl thousandbins          "$inp\GlobalDist_1000bins_PSPR2022.dta"
	
*UN population estimates 
    gl UNpopdata_2019   	 "$inp\derived_input\UNDESA population_2019.dta"
	gl UNpopdata_nowcast   	 "$inp\derived_input\UNDESA population_nowcast.dta"	
	
	
* Strings
    gl p215 		"poor215"
    gl p365 		"poor360"
    gl p685 		"poor685"
	gl np			"nearpoor"

  
set checksum off //for wbopendata
	
*******************************************************************************
*** Install required user-written commands if not installed
*******************************************************************************
	global package "povcalnet wbopendata"
	foreach package in $package {
			capture which `package'
			if (_rc) ssc install `package'
	}
		
*******************************************************************************
* Mata procedure to compute a matrix of shares
* Matrix F contains results of the two-way tabulation
*******************************************************************************
     cap mata : mata drop shares()
    mata
        void shares()
        {
            real matrix X  
            real matrix C
            real matrix R
            real matrix T
            
            X = st_matrix("F") //Convert Stata F matrix into mata X matrix
            R = rowsum(X)
            C = colsum(X)
            T = sum(X)
            Z = (X\C)/1000000

            st_matrix("H",  (X:/R \ C:/T)) //save mata results to Stata matrix H
            st_matrix("S",  X:/C \ C:/C)
            st_matrix("T",  (R:/T) \ T:/T )
            st_matrix("Z", Z)
        }
    end

   