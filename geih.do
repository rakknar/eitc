* This .do file was used to prepare the GEIH data in workdata.dta

*---------------------------------------------------------------------
* Michigan State University		                      
* Department of Economics				                      
* Written by: Pablo Adrian Garlati Bertoldi (garlatib@msu.edu) 
* Function: process GEIH data                                       
*---------------------------------------------------------------------
/*
*extract years of education for 2008
use "$data\original\dane\geih\2008\data\Julio\stata\cabecera_caracter_sticas_generales_personas_7_.dta" 
keep p6160 p6170 p6175 p6210 p6210s1 p6220 esc
duplicates drop
sort esc p6160 p6170 p6175 p6210 p6210s1 p6220
foreach v in p6160 p6170 p6175 p6210 p6210s1 p6220 {
    gen aux = `v'
    drop `v'
    rename aux `v'
}
save "$data_temp\\years_edu_cod_2008.dta", replace

*-------------------------
*datasets assembly by year
*-------------------------
*2008-2008
forvalues y = 2008/2008 {
	display "`y'"
    forvalues m = 1/12 {
    	local month: word `m' of Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre
        foreach g in cabecera resto {
            use "$data\original\dane\geih\\`y'\\data\\`month'\\stata\\`g'_caracter_sticas_generales_personas_`m'_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden using "$data\original\dane\geih\\`y'\\data\\`month'\\stata\\`b'_`m'_.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\dane\geih\\`y'\\data\\`month'\\stata\\`g'_vivienda_y_hogares_`m'_.dta", nogen force
            *month var
            if `y' == 2008 {
            	gen mes = `m'
            }
            *save dataset
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *year var
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\1_`y'.dta", clear
    forvalues m = 2/12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2009-2010
forvalues y = 2008/2010 {
	display "`y'"
    forvalues m = 1/12 {
    	local month: word `m' of Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre
        foreach g in cabecera resto {
            use "$data\original\dane\geih\\`y'\\data\\`month'\\stata\\`g'_caracter_sticas_generales_personas_`m'_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\dane\geih\\`y'\\data\\`month'\\stata\\`b'_`m'_.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\dane\geih\\`y'\\data\\`month'\\stata\\`g'_vivienda_y_hogares_`m'_.dta", nogen force
            *month var
            if `y' == 2009 {
            	gen mes = `m'
            }
            *save dataset
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *year var
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\1_`y'.dta", clear
    forvalues m = 2/12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2011
forvalues y = 2011/2011 {
	display "`y'"
    forvalues m = 1/12 {
        foreach g in cabecera resto {
            use "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\1_`y'.dta", clear
    forvalues m = 2/12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2012
forvalues y = 2012/2012 {
	display "`y'"
    foreach m in 01 02 03 04 05 06 07 08 09 10 11 12 {
        foreach g in cabecera resto {
            use "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\01_`y'.dta", clear
    foreach m in 02 03 04 05 06 07 08 09 10 11 12 {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2013-2015
forvalues y = 2013/2015 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in cabecera resto {
            use "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*2016
forvalues y = 2016/2016 {
	display "`y'"
    foreach m in Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
        foreach g in cabecera resto {
            use "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_caracter_sticas_generales_personas_.dta", clear
            foreach b in `g'_fuerza_de_trabajo ///
                         `g'_ocupados ///
                         `g'_desocupados ///
                         `g'_inactivos ///
                         `g'_otras_actividades_y_ayudas_en_la_semana ///
                         `g'_otros_ingresos ///
                         {
                         	 display "`b'"
                         	 merge 1:1 directorio secuencia_p orden hogar using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`b'.dta"
                         	 if "`b'" != "`g'_otras_actividades_y_ayudas_en_la_semana" {
                         	     gen     `b' = 0 
                         	     replace `b' = 1 if _merge == 3
                         	 }
                         	 else {
                         	 	 gen     otras = 0 
                         	     replace otras = 1 if _merge == 3
                         	 }
                         	 drop _merge
            }
            *add household data
            display "`g'_vivienda_y_hogares"
            merge m:1 directorio secuencia_p using "$data\original\dane\geih\\`y'\\data\\`m'\\stata\\`g'_vivienda_y_hogares.dta", nogen
            save "$data_temp\\`g'_`m'_`y'.dta", replace
        }
        *merge all database
        use "$data_temp\\cabecera_`m'_`y'.dta", clear
        append using "$data_temp\\resto_`m'_`y'.dta"
        duplicates report
        *extra vars
        gen anio = `y'
        *save dataset
        compress
		destring p6980, replace
		destring p6980s1, replace
        save "$data_temp\\`m'_`y'.dta", replace
    }
    
    use "$data_temp\\Enero_`y'.dta", clear
    foreach m in Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre {
	    display "`m'" 
        append using "$data_temp\\`m'_`y'.dta"
    }
    duplicates report
    compress
    save "$process\\geih\\`y'.dta", replace
}

*----------------------------------------
* from raw data to workdata by year
*----------------------------------------
forvalues y = 2008/2016 {         
    use "$process\\geih\\`y'.dta", clear
    
    *TIME
    *year
    rename anio year
    *month
    destring mes, force replace
    rename mes month
    *quarter
    gen     quarter = .
    replace quarter = 1 if month >= 1  & month <= 3
    replace quarter = 2 if month >= 4  & month <= 6
    replace quarter = 3 if month >= 7  & month <= 9
    replace quarter = 4 if month >= 10 & month <= 12
    label var quarter "Quarter"
    *semester
    gen     semester = .
    replace semester=1 if quarter == 1 | quarter == 2
    replace semester=2 if quarter == 3 | quarter == 4
    label var semester "Semester"
    *year-quarter
    gen    year_q = yq(year,quarter)
    format year_q %tq
    label var year_q "Year-Quarter"
    *after 2012 dummy
    gen     after_2012 = .
    replace after_2012 = 0 if year <= 2012
    replace after_2012 = 1 if year >= 2013
    
    *HOUSEHOLD
    gen aux = 1
    egen hh_size = total(aux), by(month directorio secuencia_p)
    label var hh_size "Household size"
    drop aux
    
    *LOCATION
    *department
    gen     department = ""
    replace department = "Antioquia"           if dpto == "05"
    replace department = "Atlántico"           if dpto == "08"
    replace department = "Bogotá DC"           if dpto == "11"
    replace department = "Bolívar"             if dpto == "13"
    replace department = "Boyacá"              if dpto == "15"
    replace department = "Caldas"              if dpto == "17"
    replace department = "Caquetá"             if dpto == "18"
    replace department = "Cauca"               if dpto == "19"
    replace department = "Cesar"               if dpto == "20"
    replace department = "Córdoba"             if dpto == "23"
    replace department = "Cundinamarca"        if dpto == "25"
    replace department = "Chocó"               if dpto == "27"
    replace department = "Huila"               if dpto == "41"
    replace department = "La guajira"          if dpto == "44"
    replace department = "Magdalena"           if dpto == "47"
    replace department = "Meta"                if dpto == "50"
    replace department = "Nariño"              if dpto == "52"
    replace department = "Norte de santander"  if dpto == "54"
    replace department = "Quindio"             if dpto == "63"
    replace department = "Risaralda"           if dpto == "66"
    replace department = "Santander"           if dpto == "68"
    replace department = "Sucre"               if dpto == "70"
    replace department = "Tolima"              if dpto == "73"
    replace department = "Valle del cauca"     if dpto == "76"
    encode  department, gen(dep_cod)
    drop dpto
    
    *city                                            
    gen     city = "" 
    replace city = "Medellín MA"       if area == "05" 
    replace city = "Barranquilla MA"   if area == "08" 
    replace city = "Bogotá DC"         if area == "11" 
    replace city = "Cartagena"         if area == "13"
    replace city = "Tunja"             if area == "15"
    replace city = "Manizales MA"      if area == "17"
    replace city = "Florencia"         if area == "18"
    replace city = "Popayán"           if area == "19"
    replace city = "Valledupar"        if area == "20"
    replace city = "Montería"          if area == "23"
    replace city = "Quibdó"            if area == "27"
    replace city = "Neiva"             if area == "41"
    replace city = "Riohacha"          if area == "44"
    replace city = "Santa Marta"       if area == "47"
    replace city = "Villavicencio"     if area == "50" 
    replace city = "Pasto"             if area == "52" 
    replace city = "Cúcuta MA"         if area == "54"
    replace city = "Armenia"           if area == "63"
    replace city = "Pereira MA"        if area == "66" 
    replace city = "Bucaramanga MA"    if area == "68"
    replace city = "Sincelejo"         if area == "70"
    replace city = "Ibagué"            if area == "73" 
    replace city = "Cali MA"           if area == "76"
    replace city = "Rest"              if area == ""
    label define city 1  "Bogotá DC" ///
                      2  "Medellín MA" ///
                      3  "Cali MA" ///
                      4  "Barranquilla MA" ///
                      5  "Bucaramanga MA" ///
                      6  "Manizales MA" ///
                      7  "Pasto" ///
                      8  "Pereira MA" ///
                      9  "Cúcuta MA" ///
                      10 "Ibagué" ///
                      11 "Montería" ///
                      12 "Cartagena" ///
                      13 "Villavicencio" ///
                      14 "Tunja" ///
                      15 "Florencia" ///
                      16 "Popayán" ///
                      17 "Valledupar" ///
                      18 "Quibdó" ///
                      19 "Neiva" ///
                      20 "Riohacha" ///
                      21 "Santa Marta" ///
                      22 "Armenia" ///
                      23 "Sincelejo" ///
                      24 "Rest" ///
                              
    encode  city, gen(city_cod) label(city) 
    drop area                          
    drop city
    rename city_cod city
    
    *Cities groups
    *13 áreas:  Bogotá D.C, ///
              * Medellín - Valle de Aburrá, ///
              * Cali - Yumbo, ///
              * Barranquilla - Soledad, ///
              * Bucaramanga, Girón, Piedecuesta y Floridablanca, ///
              * Manizales y Villa María, ///
              * Pasto, ///
              * Pereira, Dos Quebradas y La Virginia, ///
              * Cúcuta, Villa del Rosario, Los Patios y El Zulia, ///
              * Ibagué, ///
              * Montería, ///
              * Cartagena, ///
              * Villavicencio.
    *10 ciudades: Tunja, ///
              * Florencia, ///
              * Popayán, /// 
              * Valledupar, ///
              * Quibdó, /// 
              * Neiva,  ///
              * Riohacha,  /// 
              * Santa Marta,  /// 
              * Armenia,  /// 
              * Sincelejo. ///
              
    gen          city_group = .
    replace      city_group = 1 if city >= 1  & city <= 13 
    replace      city_group = 2 if city >= 14 & city <= 23
    replace      city_group = 3 if city == 24
    label define city_group 1  "13 areas"   ///
                            2  "10 cities"   ///
                            3  "Rest"   ///
                                   
    label values city_group city_group
    label var city_group "Group of cities"
    
    *urban
    rename clase area
    destring area, replace
    label var    area "Urban/Rural"
    label define area 1  "Urban"   ///
                      2  "Rural"   ///
                             
    label values area area
    
    *AGE
    *age
    gen age=p6040
    *gender
    gen     gender = . 
    replace gender = 1 if p6020==1
    replace gender = 2 if p6020==2
    label var    gender "gender"
    label define gender 1  "Male"   ///
                        2  "Female"   ///
                             
    label values gender gender
    
    *marital status
    gen          marital = . 
    replace      marital = 1 if p6070==1
    replace      marital = 2 if p6070==2
    replace      marital = 3 if p6070==3
    replace      marital = 4 if p6070==4
    replace      marital = 5 if p6070==5
    replace      marital = 6 if p6070==6
    label var    marital "marital status"
    label define marital 1  "Not married - living together less 2 yrs"   ///
                         2  "Not married - living together more 2 yrs"   ///
                         3  "Married"   ///
                         4  "Separated/divorced"   ///
                         5  "Widow"   ///
                         6  "Single"   ///
    
    label values marital marital
    
    *relation with head hh
    gen          rel_head = p6050 
    label var    rel_head "relation w/head hh"
    label define rel_head 1  "Head hh"   ///
                          2  "Husband/Wife/Partner"   ///
                          3  "Son/Daughter"   ///
                          4  "Grandson"   ///
                          5  "Other relative"   ///
                          6  "Housemaid"   ///
                          7  "Tenant"   ///
                          8  "Worker"   ///
                          8  "Other non-relative"   ///
    
    label values rel_head rel_head 
    replace rel_head = . if p6050 == 9 

    *strata
    gen strata = .
    forvalues i = 1/6 {
    	replace strata = `i' if p4030s1a1 == `i'
    }
    label var strata "Colombian Strata"    
    
    *EDUCATION
    *---------
    *reads & write
    gen       read_write = .
    replace   read_write = 1 if p6160 == 1
    replace   read_write = 0 if p6160 == 2
    label var read_write "=1 if reads & write"
    
    *years of education
    rename esc edu_years
    label var  edu_years "Years of Education"
    table year quarter, c(mean edu_years)
    if year == 2008 {
         forvalues m = 1/6 {
             if month == `m' {
             	 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==2 & p6175==. & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==1 & p6170==2 & p6175==. & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==2 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==2 & p6175==. & p6210==1 & p6210s1==0 & p6220==.
                 replace edu_years = 0 if p6160==2 & p6170==2 & p6175==. & p6210==2 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 1 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==1 & p6220==.
                 replace edu_years = 2 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 2 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==2 & p6220==.
                 replace edu_years = 3 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 3 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==3 & p6220==.
                 replace edu_years = 4 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 4 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 4 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 4 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==4 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==1 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==0 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==2 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==0 & p6220==.
                 replace edu_years = 5 if p6160==1 & p6170==2 & p6175==. & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==2 & p6170==1 & p6175==1 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==2 & p6170==1 & p6175==2 & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 5 if p6160==2 & p6170==2 & p6175==. & p6210==3 & p6210s1==5 & p6220==.
                 replace edu_years = 6 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==6 & p6220==.
                 replace edu_years = 6 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==6 & p6220==.
                 replace edu_years = 6 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==6 & p6220==.
                 replace edu_years = 7 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==7 & p6220==.
                 replace edu_years = 7 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==7 & p6220==.
                 replace edu_years = 7 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==7 & p6220==.
                 replace edu_years = 8 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==8 & p6220==.
                 replace edu_years = 8 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==8 & p6220==.
                 replace edu_years = 8 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==8 & p6220==.
                 replace edu_years = 9 if p6160==1 & p6170==1 & p6175==1 & p6210==4 & p6210s1==9 & p6220==.
                 replace edu_years = 9 if p6160==1 & p6170==1 & p6175==2 & p6210==4 & p6210s1==9 & p6220==.
                 replace edu_years = 9 if p6160==1 & p6170==2 & p6175==. & p6210==4 & p6210s1==9 & p6220==.
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==10 & p6220==1
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==10 & p6220==2
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==10 & p6220==1
                 replace edu_years = 10 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==10 & p6220==2
                 replace edu_years = 10 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==10 & p6220==1
                 replace edu_years = 10 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==10 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==11 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==11 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==0 & p6220==4
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==11 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==11 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==11 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==0 & p6220==4
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==1
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==2
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==3
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==4
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==5
                 replace edu_years = 11 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==11 & p6220==9
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==12 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==12 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==1 & p6220==4
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==12 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==1 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==1 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==1 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==12 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==12 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==12 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==1
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==2
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==3
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==5
                 replace edu_years = 12 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==1 & p6220==9
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==13 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==5 & p6210s1==13 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==1
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==2 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==5 & p6210s1==13 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==1
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==2 & p6220==5
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==13 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==13 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==5 & p6210s1==13 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==1
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==2
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==3
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==4
                 replace edu_years = 13 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==2 & p6220==5
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==3 & p6220==2
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==3 & p6220==3
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==3 & p6220==4
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==1
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==2
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==3
                 replace edu_years = 14 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==3 & p6220==4
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==1
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==2
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==3
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==4
                 replace edu_years = 14 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==3 & p6220==5
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==1
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==2
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==3
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==4 & p6220==4
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==1
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==2
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==3
                 replace edu_years = 15 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==4 & p6220==4
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==1
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==2
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==3
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==4
                 replace edu_years = 15 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==4 & p6220==5
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==1
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==2
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==3
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==4
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==5 & p6220==5
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==1
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==2
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==3
                 replace edu_years = 16 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==5 & p6220==4
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==2
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==3
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==4
                 replace edu_years = 16 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==5 & p6220==5
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==2
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==3
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==4
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==6 & p6220==5
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==1
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==2
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==3
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==4
                 replace edu_years = 17 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==6 & p6220==5
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==2
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==3
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==4
                 replace edu_years = 17 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==6 & p6220==5
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==7 & p6220==3
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==7 & p6220==4
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==7 & p6220==5
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==2
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==3
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==4
                 replace edu_years = 18 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==7 & p6220==5
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==2
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==3
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==4
                 replace edu_years = 18 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==7 & p6220==5
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==2
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==3
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==4
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==8 & p6220==5
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==2
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==3
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==4
                 replace edu_years = 19 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==8 & p6220==5
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==2
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==3
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==4
                 replace edu_years = 19 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==8 & p6220==5
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==9 & p6220==4
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==9 & p6220==5
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==2
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==3
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==4
                 replace edu_years = 20 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==9 & p6220==5
                 replace edu_years = 20 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==9 & p6220==4
                 replace edu_years = 20 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==9 & p6220==5
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==10 & p6220==4
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==10 & p6220==2
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==10 & p6220==3
                 replace edu_years = 21 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==10 & p6220==4
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==2
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==3
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==4
                 replace edu_years = 21 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==10 & p6220==5
                 replace edu_years = 22 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==11 & p6220==5
                 replace edu_years = 22 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==11 & p6220==4
                 replace edu_years = 22 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==11 & p6220==5
                 replace edu_years = 23 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==12 & p6220==4
                 replace edu_years = 23 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==12 & p6220==5
                 replace edu_years = 23 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==12 & p6220==4
                 replace edu_years = 23 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==12 & p6220==5
                 replace edu_years = 24 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==13 & p6220==4
                 replace edu_years = 24 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==13 & p6220==5
                 replace edu_years = 25 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==14 & p6220==4
                 replace edu_years = 25 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==14 & p6220==3
                 replace edu_years = 25 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==14 & p6220==4
                 replace edu_years = 25 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==14 & p6220==5
                 replace edu_years = 26 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==15 & p6220==4
                 replace edu_years = 26 if p6160==1 & p6170==1 & p6175==1 & p6210==6 & p6210s1==15 & p6220==5
                 replace edu_years = 26 if p6160==1 & p6170==1 & p6175==2 & p6210==6 & p6210s1==15 & p6220==5
                 replace edu_years = 26 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==15 & p6220==4
                 replace edu_years = 26 if p6160==1 & p6170==2 & p6175==. & p6210==6 & p6210s1==15 & p6220==5
             }
         }
    }
             
    *enrolled
    gen       enroll = .
    replace   enroll = 1 if p6170 == 1
    replace   enroll = 0 if p6170 == 2
    label var enroll "=1 if enrolled in any level of education"
    table year quarter, c(mean enroll)
    
    *highest level of education
    gen edu_level = .
    forvalues i = 0/4 {
        local j = `i' + 1
        replace edu_level = `i' if p6220   == `j' & month >=1 & month <= 7 & year == 2011    
        replace edu_level = `i' if p6210s1 == `j' & month >=8 & month <= 12 & year == 2011
    }
    forvalues i = 0/4 {
        local j = `i' + 1
        replace edu_level = `i' if p6220 == `j' & year != 2011
    }
    label define edu_level 0  "None"   ///
                           1  "High School"   ///
                           2  "Technical/Technological"   ///
                           3  "University"   ///
                           4  "Post-graduate"   ///
                        
    label values edu_level edu_level
    table edu_level year month
    
    *labor market
    *------------
    *vars from survey
    foreach v in fuerza_de_trabajo ///
                 ocupados ///
                 desocupados ///
                 inactivos ///
                 otros_ingresos ///
                 {
                     gen     `v' = .
                     replace `v' = 0 if cabecera_`v' == 0 | resto_`v' == 0
                     replace `v' = 1 if cabecera_`v' == 1 | resto_`v' == 1
    }
    *workage
    gen       workage = 0
    replace   workage = 1 if age >= 12 & age != . & area == 1
    replace   workage = 1 if age >= 10 & age != . & area == 2
    label var workage "=1 if age to work"
    
    *indicator of labor force participation (employed + unemployed + inactive)
    gen     inlf = .
    //DANE
    *inactive: all non-workers 
    replace inlf = 3 if p6240 >=2 & p6240 <=6
    //Quiénes son los ocupados (OC)?
    //Son las personas que durante el período de referencia se encontraban en una de las siguientes situaciones:
    //1. Trabajó por lo menos una hora remunerada en dinero o en especie en la semana de referencia.
    replace inlf = 1 if p6240 == 1
    replace inlf = 1 if p6250 == 1
    //2. Los que no trabajaron la semana de referencia, pero tenían un trabajo.
    replace inlf = 1 if p6260 == 1
    //3. Trabajadores familiares sin remuneración que trabajaron en la semana de referencia por lo menos 1 hora
    replace inlf = 1 if p6270 == 1
    //DANE
    // Desocupados (D): Son las personas que en la semana de referencia se encontraban en una de
    // las siguientes situaciones:
    // 1. Desempleo abierto:
    //   a. Sin empleo en la semana de referencia.
    //   b. Hicieron diligencias en el último mes.
    //   c. Disponibilidad.
    replace inlf = 2 if p6240 == 2              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 3              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 4              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if p6240 == 6              & p6250 == 2 & p6351 == 1
    replace inlf = 2 if              p6280 == 1 & p6250 == 2 & p6351 == 1
    // 2. Desempleo oculto:
    //   a. Sin empleo en la semana de referencia.
    //   b. No hicieron diligencias en el último mes, pero sí en los últimos 12 meses y tienen una razón válida de desaliento.
    //   c. Disponibilidad.
    //Razones válidas de desempleo:
    //  a. No hay trabajo disponible en la ciudad.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 2 
    //  b. Está esperando que lo llamen.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 3
    //  f. Está esperando la temporada alta.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 3
    //  c. No sabe cómo buscar trabajo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 4
    //  d. Está cansado de buscar trabajo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 5
    //  e. No encuentra trabajo apropiado en su oficio o profesión.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 2
    //  g. Carece de la experiencia necesaria.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 6
    //  h. No tiene recursos para instalar un negocio.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 7
    //  i. Los empleadores lo consideran muy joven o muy viejo.
    replace inlf = 2 if p6280 == 2 & p6340 == 1 & p6351 == 1 & p6310 == 8
    label define inlf 1  "Employed"   ///
                      2  "Unemployed"   ///
                      3  "Inactive"   ///
                        
    label values inlf inlf
    label var inlf "Labor force participation"
    tab inlf if workage == 1, miss
    *active
    gen       active = .
    replace   active = 0 if inlf != .
    replace   active = 1 if inlf == 1 | inlf == 2
    label var active "=1 if active"
    *employed
    gen       employed = .
    replace   employed = 0 if inlf == 1 | inlf == 2
    replace   employed = 1 if inlf == 1
    label var employed "=1 if employed"
    *unemployed
    gen       unemployed = .
    replace   unemployed = 0 if inlf == 1 | inlf == 2
    replace   unemployed = 1 if inlf == 2
    label var unemployed "=1 if unemployed"
    
    *labor status
    *------------
    gen          labor_state = p6430
    label define labor_state 1 "Private employee"   ///
                             2 "Public employee"   ///
                             3 "Domestic employee"   ///
                             4 "Self-employed"   ///
                             5 "Employer"   ///
                             6 "Unpaid family worker"   ///
                             7 "Unpaid private worker"   ///
                             8 "Laborer or farmhand"   ///
                             9 "Other"   ///
    
    label values labor_state labor_state
    label var    labor_state "labor state in main occupation"
    
    *job quality
    *-----------
    *type of contract
    gen          con_type = .
    replace      con_type = 1 if p6440 == 1 & p6450 == 1  
    replace      con_type = 2 if p6440 == 1 & p6450 == 2
    replace      con_type = 3 if p6440 == 1 & p6450 == 3
    replace      con_type = 3 if p6440 == 1 & p6450 == 9 & month <= 2
    replace      con_type = 4 if p6440 == 2
    label define con_type 1  "Yes, verbal"   ///
                          2  "Yes, written"   ///
                          3  "Yes, do not know"   ///
                          4  "None"   ///
    
    label values con_type con_type
    label var con_type "labor contract type"
    
    *contract term
    gen          con_term = .
    replace      con_term = 1 if p6460 == 1
    replace      con_term = 2 if p6460 == 2
    replace      con_term = 3 if p6460 == 3
    label define con_term 1  "Indefinite"   ///
                          2  "Fixed"   ///
                          3  "Do not know"   ///
    
    label values con_term con_term
    label var    con_term "labor contract term"
    
    *contract length
    gen          con_term_m = p6460s1
    replace      con_term_m = . if p6460s1 == 99 | p6460s1 == 98 
    label var    con_term_m "labor contract fixed term in months"
    
    *chrismas bonus
    gen          con_bonus = .
    replace      con_bonus = 1 if p6424s2 == 1
    replace      con_bonus = 0 if p6424s2 == 2
    label var    con_bonus "=1 if labor contract includes chrismas bonus"
    
    *severance
    gen          con_sever = .
    replace      con_sever = 1 if p6424s3 == 1
    replace      con_sever = 0 if p6424s3 == 2
    label var    con_sever "=1 if labor contract includes severance"
    
    *vacations
    gen          con_vacation = .
    replace      con_vacation = 1 if p6424s1 == 1
    replace      con_vacation = 0 if p6424s1 == 2
    label var    con_vacation "=1 if labor contract includes paid vacations"
    
    *tenure
    *-------
    gen       tenure_firm = p6426
    label var tenure_firm "tenure in firm (months)"
    
    *PENSION
    *dummy
    gen       pension = .
    replace   pension = 1 if p6920 == 1
    replace   pension = 0 if p6920 == 2
    label var pension "=1 if contributes to a pension fund"
    *type
    gen          pension_type = p6930
    label define pension_type 1  "Private"   ///
                              2  "Colpensiones"   ///
                              3  "Special (FFMM, Ecopetrol)"   ///
                              4  "Subsidized (Prosperar)"   ///
    
    label values pension_type pension_type
    label var    pension_type "type of pension fund"
    *type
    gen          pension_who = p6940
    label define pension_who 1  "Shared w/employer"   ///
                              2  "Pays all"   ///
                              3  "Employer pays all"   ///
                              4  "Does not pay"   ///
    
    label values pension_who pension_who
    label var    pension_who "who pays pension contrib."
    
    *health care
    *-----------
    *yes/no
    gen       health = .
    replace   health = 1 if p6090 == 1
    replace   health = 0 if p6090 == 2
    label var health "=1 if affiliated for health care"
    *type
    gen          health_type = .
    replace      health_type = 1 if p6100 == 1
    replace      health_type = 2 if p6100 == 2
    replace      health_type = 3 if p6100 == 3
    label define health_type 1  "Contributive"   ///
                             2  "Special"   ///
                             3  "Subsidized"   ///
    
    label values health_type health_type
    label var    health_type "Type of health care"
    
    *who pays
    gen          health_who = .
    replace      health_who = 1 if p6110 == 1
    replace      health_who = 2 if p6110 == 2
    replace      health_who = 3 if p6110 == 3
    replace      health_who = 4 if p6110 == 4
    replace      health_who = 5 if p6110 == 5
    replace      health_who = 6 if p6110 == 6
    label define health_who 1  "Shared with employer"   ///
                            2  "Discounted from pension"   ///
                            3  "Pays all"   ///
                            4  "Employer pays all"   ///
                            5  "Beneficiary"   ///
                            6  "Do not know"   ///
    
    label values health_who health_who
    label var    health_who "Who pays for health care"
                            
    *union membership
    *----------------
    gen       union = .
    replace   union = 1 if p7180 == 1
    replace   union = 0 if p7180 == 2
    label var union "=1 if affiliated to a labor union"
     
    *income
    *------
    *wages
    *-----
    *gross wage
    gen       w_m_gross = p6500
    label var w_m_gross "Gross monthly wage LCU"
            
    *overtime
    gen       w_overtime = p6510s1
    label var w_overtime "Overtime paid LCU"
    
    *overtime included
    gen       w_overtime_inc = .
    replace   w_overtime_inc = 1 if p6510s2 == 1
    replace   w_overtime_inc = 0 if p6510s2 == 2
    label var w_overtime_inc "Overtime paid LCU included in wage"
    
    *food
    gen       w_food =      p6590s1
    replace   w_food = . if p6590s1 == 98
    label var w_food "Food paid LCU"
    
    *rent
    gen       w_rent =      p6600s1
    replace   w_rent = . if p6600s1 == 98
    label var w_rent "Rent paid LCU"
    
    *transport
    gen       w_transport =      p6610s1
    replace   w_transport = . if p6610s1 == 98
    label var w_transport "Transport paid LCU"
    
    *in kind
    gen       w_in_kind =      p6620s1
    replace   w_in_kind = . if p6620s1 == 98
    label var w_in_kind "In kind paid LCU"
    
    *SUBSIDIES
    *food
    gen       sub_food =      p6585s1a1
    replace   sub_food = . if p6585s1a1 == 98
    label var sub_food "Subsidy food"
    gen       sub_food_inc = .
    replace   sub_food_inc = 1 if p6585s1a2 == 1
    replace   sub_food_inc = 0 if p6585s1a2 == 2
    label var sub_food_inc "=1 if Subsidy food included in income"
    
    *transport
    gen       sub_trans =      p6585s2a1
    replace   sub_trans = . if p6585s2a1 == 98
    label var sub_trans "Subsidy transport"
    gen       sub_trans_inc = .
    replace   sub_trans_inc = 1 if p6585s2a2 == 1
    replace   sub_trans_inc = 0 if p6585s2a2 == 2
    label var sub_trans_inc "=1 if Subsidy transport included in income"
    
    *family
    gen       sub_fam =      p6585s3a1
    replace   sub_fam = . if p6585s3a1 == 98
    label var sub_fam "Subsidy family"
    gen       sub_fam_inc = .
    replace   sub_fam_inc = 1 if p6585s3a2 == 1
    replace   sub_fam_inc = 0 if p6585s3a2 == 2
    label var sub_fam_inc "=1 if Subsidy family included in income"
     
    *education
    gen       sub_edu =      p6585s4a1
    replace   sub_edu = . if p6585s4a1 == 98
    label var sub_edu "Subsidy education"
    gen       sub_edu_inc = .
    replace   sub_edu_inc = 1 if p6585s4a2 == 1
    replace   sub_edu_inc = 0 if p6585s4a2 == 2
    label var sub_edu_inc "=1 if Subsidy education included in income"
    
    *MAIN OCCUPATION
    *primes last month
    *prime 
    gen       prime_m =      p6545s1
    replace   prime_m = . if p6545s1 == 98
    label var prime_m "last month prime"
    
    *bonus 
    gen       bonus_m =      p6545s1
    replace   bonus_m = . if p6545s1 == 98
    label var bonus_m "last month monthly bonus"
    
    *last 12 month plus
    *prime services 
    gen       prime_serv_12m =      p6630s1a1
    replace   prime_serv_12m = . if p6630s1a1 == 98
    label var prime_serv_12m "12m income prime services"
    
    *prime chrismas 
    gen       prime_xmas_12m =      p6630s2a1
    replace   prime_xmas_12m = . if p6630s2a1 == 98
    label var prime_xmas_12m "12m income prime chrismas"
    
    *prime vacations
    gen       prime_vac_12m =      p6630s3a1
    replace   prime_vac_12m = . if p6630s3a1 == 98
    label var prime_vac_12m "12m income prime vacations"
    
    *prime travel
    gen       prime_travel_12m =      p6630s4a1
    replace   prime_travel_12m = . if p6630s4a1 == 98
    label var prime_travel_12m "12m income prime travel"
    
    *prime accident 
    gen       prime_acc_12m =      p6630s6a1
    replace   prime_acc_12m = . if p6630s6a1 == 98
    label var prime_acc_12m "12m income prime work accident"
    
    *INDEPENDENT WORKERS
    *type of independent work
    gen          indep_type = p6765
    label var    indep_type "type of independent work"
    label define indep_type 1  "Location of services"   ///
                            2  "By project"   ///
                            3  "By piece"   ///
                            4  "On comission"   ///
                            5  "Catalog sales"   ///
                            6  "Profession (plumber, carpenter, taxi driver)"   ///
                            7  "Owner of business or land"   ///
                            8  "Other"   ///
    
    label values indep_type indep_type
    
    *employer
    gen          employer = .
    replace      employer = 0 if employed == 1
    replace      employer = 1 if employed == 1 & indep_type == 7
    label var    employer "=1 if employer"
    
    *registered bussiness
    gen       firm_regis = .
    replace   firm_regis = 1 if p6772 == 1
    replace   firm_regis = 0 if p6772 == 2
    label var firm_regis "=1 if firm is registered"
    
    *profit
    gen       profit =      p6750
    replace   profit = . if p6750 == 98 | p6750 == 99
    label var profit "profit from activity last month"
         
    *12 month crop profit
    gen       profit_crop =      p550
    replace   profit_crop = . if p550 == 98 | p550 == 99
    label var profit_crop "12m profit from crop RURAL"
    
    *WORK HOURS
    *regular
    gen       job_hrs_reg =      p6800
    label var job_hrs_reg "main jobs regular weekly hours"
    
    *last week
    gen       job_hrs_lastw =      p6850
    label var job_hrs_lastw "main jobs last week hours"
    
    *FIRM SIZE
    gen          firm_size = p6870
    label var    firm_size "number of employees in firm"
    label define firm_size 1  "Alone"   ///
                           2  "[2-3]"   ///
                           3  "[4-5]"   ///
                           4  "[6-10]"   ///
                           5  "[11-19]"   ///
                           6  "[20-30]"   ///
                           7  "[31-50]"   ///
                           8  "[51-100]"   ///
                           9  "101 or more"   ///
    
    label values firm_size firm_size
    
    *ECONOMIC SECTOR
    *ISIC Rev4 4 digits
    gen          sector4d = rama4d
    label var    sector4d "sector ISIC Rev3 A.C. 4 digits"
    
    *ISIC Rev3 2 digits
    gen          sector2d = rama2d
    destring     sector2d, force replace
    replace      sector2d = . if sector2d == 0 
    label var    sector2d "sector ISIC Rev3 2 digits"
    label define sector2d 1  "Agriculture, hunting and related service activities"   ///
                          2  "Forestry, logging and related service activities"   ///
                          5  "Fishing, operation of fish hatcheries and fish farms"   ///
                          10 "Mining of coal and lignite"   ///
                          11 "Extraction of crude petroleum and natural gas"   ///
                          12 "Mining of uranium and thorium ores"   ///
                          13 "Mining of metal ores"   ///
                          14 "Other mining and quarrying"   ///
                          15 "Manufacture of food products and beverages"   ///
                          16 "Manufacture of tobacco products"   ///
                          17 "Manufacture of textiles"   ///
                          18 "Manufacture of wearing apparel"   ///
                          19 "Tanning and dressing of leather"   ///
                          20 "Manufacture of wood and of products of wood and cork"   ///
                          21 "Manufacture of paper and paper products"   ///
                          22 "Publishing, printing and reproduction of recorded media"   ///
                          23 "Manufacture of coke, refined petroleum products and nuclear fuel"   ///
                          24 "Manufacture of chemicals and chemical products"   ///
                          25 "Manufacture of rubber and plastics products"   ///
                          26 "Manufacture of other non-metallic mineral products"   ///
                          27 "Manufacture of basic metals"   ///
                          28 "Manufacture of fabricated metal products"   ///
                          29 "Manufacture of machinery and equipment"   ///
                          30 "Manufacture of office, accounting and computing machinery"   ///
                          31 "Manufacture of electrical machinery and apparatus"   ///
                          32 "Manufacture of radio, television and communication equipment and apparatus"   ///
                          33 "Manufacture of medical, precision and optical instruments, watches and clocks"   ///
                          34 "Manufacture of motor vehicles, trailers and semi-trailers"   ///
                          35 "Manufacture of other transport equipment"   ///
                          36 "Manufacture of furniture"   ///
                          37 "Recycling"   ///
                          40 "Electricity, gas, steam and hot water supply"   ///
                          41 "Collection, purification and distribution of water"   ///
                          45 "Construction"   ///
                          50 "Sale, maintenance and repair of motor vehicles and motorcycles"   ///
                          51 "Wholesale trade and commission trade"   ///
                          52 "Retail trade, except of motor vehicles and motorcycles"   ///
                          55 "Hotels and restaurants"   ///
                          60 "Land transport"   ///
                          61 "Water transport"   ///
                          62 "Air transport"   ///
                          63 "Supporting and auxiliary transport activities"   ///
                          64 "Post and telecommunications"   ///
                          65 "Financial intermediation"   ///
                          66 "Insurance and pension funding"   ///
                          67 "Activities auxiliary to financial intermediation"   ///
                          70 "Real estate activities"   ///
                          71 "Renting of machinery and equipment without operator and of personal and household goods"   ///
                          72 "Computer and related activities"   ///
                          73 "Research and development"   ///
                          74 "Other business activities"   ///
                          75 "Public administration and defence"   ///
                          80 "Education"   ///
                          85 "Health and social work"   ///
                          90 "Sewage and refuse disposal, sanitation and similar activities"   ///
                          91 "Activities of membership organizations"   ///
                          92 "Recreational, cultural and sporting activities"   ///
                          93 "Other service activities"   ///
                          95 "Private households with employed persons"   ///
                          99 "Extra-territorial organizations and bodies"   ///
    
    label values sector2d sector2d
    
    *ISIC Rev3 1 digit
    gen          sector1d = .
    replace      sector1d = 1  if sector2d >= 1  & sector2d <= 2
    replace      sector1d = 2  if sector2d == 5
    replace      sector1d = 3  if sector2d >= 10 & sector2d <= 14
    replace      sector1d = 4  if sector2d >= 15 & sector2d <= 37
    replace      sector1d = 5  if sector2d >= 40 & sector2d <= 41
    replace      sector1d = 6  if sector2d == 45
    replace      sector1d = 7  if sector2d >= 50 & sector2d <= 52
    replace      sector1d = 8  if sector2d == 55
    replace      sector1d = 9  if sector2d >= 60 & sector2d <= 64
    replace      sector1d = 10 if sector2d >= 65 & sector2d <= 67
    replace      sector1d = 11 if sector2d >= 70 & sector2d <= 74
    replace      sector1d = 12 if sector2d == 75
    replace      sector1d = 13 if sector2d == 80
    replace      sector1d = 14 if sector2d == 85
    replace      sector1d = 15 if sector2d >= 90 & sector2d <= 93
    replace      sector1d = 16 if sector2d == 95
    replace      sector1d = 17 if sector2d == 99
    label define sector1d 1  "Agriculture, hunting and forestry"   ///
                          2  "Fishing"   ///
                          3  "Mining and quarrying"   ///
                          4  "Manufacturing"   ///
                          5  "Electricity, gas and water supply"   ///
                          6  "Construction"   ///
                          7  "Wholesale and retail trade"   ///
                          8  "Hotels and restaurants"   ///
                          9  "Transport, storage and communications"   ///
                          10 "Financial intermediation"   ///
                          11 "Real estate, renting and business activities"   ///
                          12 "Public administration and defence"   ///
                          13 "Education"   ///
                          14 "Health and social work"   ///
                          15 "Other community, social and personal service activities"   ///
                          16 "Private households with employed persons"   ///
                          17 "Extra-territorial organizations and bodies"   ///
    
    label values sector1d sector1d
    label var    sector1d "sector ISIC Rev3 1 digit"
    
    *Main sector
    gen          sector3 = .            
    replace      sector3 = 1 if sector1d >= 1 & sector1d <= 2
    replace      sector3 = 2 if sector1d >= 3 & sector1d <= 6
    replace      sector3 = 3 if sector1d >= 7 & sector1d <= 17
    label define sector3 1 "Agriculture" ///
                         2 "Industry" ///
                         3 "Services" ///
    					 
    label values sector3 sector3
    
    *ADDITIONAL VARIABLES
    *--------------------
    *weights
    gen wgt        = fex_c_2011
    gen wgt_year   = wgt/12
    gen wgt_sem    = wgt/6
    gen wgt_quarter= wgt/3
    
    *save 
    keep year month        quarter    semester year_q after_2012 /// time 
              area         department dep_cod  city   city_group  /// location
              age          gender     marital  rel_head /// personal
              hh_size      strata /// household
              read_write   enroll       edu_years      edu_level /// education
              workage      inlf         active         employed  unemployed labor_state /// labor state
              con_type     con_term     con_term_m     con_bonus con_sever  con_vacation tenure_firm union /// job quality
              pension      pension_type pension_who    health    health_type health_who /// formality
              w_m_gross    w_overtime   w_overtime_inc w_food    w_rent w_transport w_in_kind /// wages
              sub_food     sub_food_inc sub_trans      sub_trans_inc sub_fam sub_fam_inc sub_edu sub_edu_inc /// subsidies
              prime_m      bonus_m      prime_serv_12m prime_xmas_12m    prime_vac_12m prime_travel_12m prime_acc_12m /// primes
              profit       profit_crop   /// profits
              job_hrs_reg  job_hrs_lastw /// work hours 
              firm_size    sector4d      sector2d     sector1d       sector3 /// firm
              wgt* /// weights
              
    order year month      quarter    semester year_q    after_2012 /// time 
               area       department dep_cod  city   city_group  /// location
               age        gender     marital  rel_head /// personal
               hh_size    strata /// household
               read_write   enroll       edu_years      edu_level /// education
               workage      inlf         active         employed    unemployed labor_state /// labor state
               con_type     con_term     con_term_m     con_bonus   con_sever  con_vacation tenure_firm union /// job quality
               pension      pension_type pension_who    health      health_type health_who /// formality
               w_m_gross    w_overtime   w_overtime_inc w_food    w_rent w_transport w_in_kind /// wages
               sub_food     sub_food_inc sub_trans sub_trans_inc sub_fam sub_fam_inc sub_edu sub_edu_inc /// subsidies
               prime_m      bonus_m      prime_serv_12m prime_xmas_12m    prime_vac_12m prime_travel_12m prime_acc_12m /// primes
               profit       profit_crop   /// profits
               job_hrs_reg  job_hrs_lastw /// work hours 
               firm_size    sector4d     sector2d     sector1d       sector3 /// firm
               wgt* /// weights
    
    compress           
    save "$data_temp\\`y'_geih_temp.dta", replace           
}

use "$data_temp\\2008_geih_temp.dta", clear
forvalues y = 2009/2016 {
    append using "$data_temp\\`y'_geih_temp.dta"
}
compress
save "$process\\geih\\workdata_temp.dta", replace
*/  
*--------------------------------------------
*NEW VARIABLES
*--------------------------------------------
use "$process\\geih\\workdata_temp.dta", clear

*minimum wages
*-------------
*daily
gen       min_wage_day = .
replace   min_wage_day = 14456.67 if year == 2007
replace   min_wage_day = 15383.33 if year == 2008
replace   min_wage_day = 16563.33 if year == 2009
replace   min_wage_day = 17166.67 if year == 2010
replace   min_wage_day = 17853.33 if year == 2011
replace   min_wage_day = 18890    if year == 2012
replace   min_wage_day = 19650    if year == 2013
replace   min_wage_day = 20533.33 if year == 2014
replace   min_wage_day = 21478.33 if year == 2015
replace   min_wage_day = 22981.83 if year == 2016
label var min_wage_day   "minimum daily wage LCU"

*monthly
gen       min_wage_month = .
replace   min_wage_month = 433700 if year == 2007
replace   min_wage_month = 461500 if year == 2008
replace   min_wage_month = 496900 if year == 2009
replace   min_wage_month = 515000 if year == 2010
replace   min_wage_month = 535600 if year == 2011
replace   min_wage_month = 566700 if year == 2012
replace   min_wage_month = 589500 if year == 2013
replace   min_wage_month = 616000 if year == 2014
replace   min_wage_month = 644350 if year == 2015
replace   min_wage_month = 689455 if year == 2016
label var min_wage_month "minimum monthly wage LCU"

*monthly
gen       min_wage_month_tr = .
replace   min_wage_month_tr = 433700 if year == 2008 & month == 1
replace   min_wage_month_tr = 461500 if year == 2008 & month >  1
replace   min_wage_month_tr = 461500 if year == 2009 & month == 1
replace   min_wage_month_tr = 496900 if year == 2009 & month >  1
replace   min_wage_month_tr = 496900 if year == 2010 & month == 1
replace   min_wage_month_tr = 515000 if year == 2010 & month >  1
replace   min_wage_month_tr = 515000 if year == 2011 & month == 1
replace   min_wage_month_tr = 535600 if year == 2011 & month >  1
replace   min_wage_month_tr = 535600 if year == 2012 & month == 1
replace   min_wage_month_tr = 566700 if year == 2012 & month >  1
replace   min_wage_month_tr = 566700 if year == 2013 & month == 1
replace   min_wage_month_tr = 589500 if year == 2013 & month >  1
replace   min_wage_month_tr = 589500 if year == 2014 & month == 1
replace   min_wage_month_tr = 616000 if year == 2014 & month >  1
replace   min_wage_month_tr = 616000 if year == 2015 & month == 1
replace   min_wage_month_tr = 644350 if year == 2015 & month >  1
replace   min_wage_month_tr = 644350 if year == 2016 & month == 1
replace   min_wage_month_tr = 689455 if year == 2016 & month >  1
label var min_wage_month_tr "minimum monthly wage LCU-Tax reform"

*year-month 
gen    year_m = ym(year,month)
format year_m %tm
label var year_m "Year-Month"

*year-semester
gen    year_s = yh(year,semester)
format year_s %th
label var year_s "Year-Semester"

*month dummies
xi i.month, noomit
forvalues m = 1/12 {
	rename _Imonth_`m' month_`m'
}

*city dummies
xi i.dep_cod, noomit
forvalues m = 1/24 {
	rename _Idep_cod_`m' dep_cod_`m'
}

*sector dummies
xi i.sector1d, noomit
forvalues m = 1/17 {
	rename _Isector1d_`m' sector1d_`m'
}

*firm size dummies
xi i.firm_size, noomit
forvalues m = 1/9 {
	rename _Ifirm_size_`m' firm_size_`m'
}

*CPI merge
merge m:1 year month using "$process\cpi" , nogen

*male
gen       male = .
replace   male = 0 if gender == 2
replace   male = 1 if gender == 1
label var male "=1 if male"

*marital status
gen          marital3 = .
replace      marital3 = 1 if marital == 6 | marital == 1 
replace      marital3 = 2 if marital == 2 | marital == 3 
replace      marital3 = 3 if marital == 4 | marital == 5
label var    marital3 "marital status"
label define marital3 1  "Single"   ///
                      2  "Married"  /// 
                      3  "Other"  ///

label values marital3 marital3

*broad age groups
gen     age_gr4 = .
replace age_gr4 = 1  if age >=15 & age <= 24
replace age_gr4 = 2  if age >=25 & age <= 39
replace age_gr4 = 3  if age >=40 & age <= 59
replace age_gr4 = 4  if age >=60 & age != .
label define age_gr4 1  "[15-24]"   ///
                     2  "[25-39]"  /// 
                     3  "[40-59]"  ///
                     4  "[60+]"  ///
					
label values age_gr4 age_gr4
label var    age_gr4 "4 age groups"
 
*urban
gen       urban = .
replace   urban = 0 if area == 2
replace   urban = 1 if area == 1
label var urban "=1 if urban"

*regions
*Región Caribe: Atlántico, Bolivar, Cesár,Córdoba,Sucre, Magdalena, La Guajira.
*Región Oriental: Norte de Santander, Santander, Boyacá, Cundinamarca, Meta.
*Región Central: Caldas,Risaralda, Quindío, Tolima, Huila, Caquetá, Antioquia.
*Región Pacífica: Chocó, Cauca, Nariño, Valle.
*Bogotá D.C.
gen          region = .
replace      region = 1 if dep_cod == 2  | dep_cod == 4  | dep_cod == 9  | dep_cod == 12 | dep_cod == 22 | dep_cod == 15 | dep_cod == 14
replace      region = 2 if dep_cod == 18 | dep_cod == 21 | dep_cod == 5  | dep_cod == 11 | dep_cod == 16
replace      region = 3 if dep_cod == 6  | dep_cod == 20 | dep_cod == 19 | dep_cod == 23 | dep_cod == 13 | dep_cod == 7 | dep_cod == 1
replace      region = 4 if dep_cod == 10 | dep_cod == 8  | dep_cod == 17 | dep_cod == 24
replace      region = 5 if dep_cod == 3
label define region 1  "Caribe"   ///
                    2  "Oriental"  ///
                    3  "Central"  ///
                    4  "Pacífica"  ///
                    5  "Bogotá"  ///

label values region region
label var    region "region"

*small firm dummy
gen       firm_small = .
replace   firm_small = 1 if firm_size <= 3
replace   firm_small = 0 if firm_size >= 4 & firm_size != .
label var firm_small "=1 if firm size 5 emp. or less"

*private workers
*labor_state
*1	Private employee
*2	Public employee
*3	Domestic employee
*4	Self-employed
*5	Employer
*6	Unpaid family worker
*7	Unpaid private worker
*8	Laborer or farmhand
*9	Other
gen     private_emp = .
replace private_emp = 0 if labor_state == 2 | labor_state == 4 | labor_state == 6 | labor_state == 9
replace private_emp = 1 if labor_state == 1 | labor_state == 3 | labor_state == 5 | labor_state == 7 | labor_state == 8
*private worker = private employee, domestic employee, employer, unpaid private worker, laborer or farmhand 

*formality
*---------
*social security (pension & health)
gen       informal_ss = .
replace   informal_ss = 1 if pension == 0 | health == 0 | health_type == 3
replace   informal_ss = 0 if pension == 1 & health_type <= 2 & health_who <= 4
label var informal_ss "Informal if not affiliated to Social Security"

*no pension
gen       no_pension = .
replace   no_pension = 1 if pension == 0
replace   no_pension = 0 if pension == 1
label var no_pension "=1 if not contributing to any pension fund"

*no health
gen       no_health = .
replace   no_health = 1 if health      == 0 | health_type == 3
replace   no_health = 0 if health_type <= 2 & health_who  <= 4
label var no_health "=1 if without health care or in sub. health"

*who pays health dummy
gen     health_pay = .
replace health_pay = 1 if health_who == 1 | health_who == 3 | health_who == 4
replace health_pay = 0 if health_type == 3

*who pays pension dummy
gen     pension_pay = .
replace pension_pay = 1 if pension_who >= 1 & health_who <= 3
replace pension_pay = 0 if pension == 0

*social security (kugler version)
gen       formal_ss_kug = .
replace   formal_ss_kug = 1 if health_pay == 1 & pension_pay == 1
replace   formal_ss_kug = 0 if health_pay == 0 | pension_pay == 0
label var formal_ss_kug "Informal Kugler ver."
gen       informal_ss_kug = 1 - formal_ss
label var informal_ss_kug "Informal Kugler ver."

*# of monthly minimum wages
gen       nr_mw_month = w_m_gross / min_wage_month_tr
replace   nr_mw_month = profit    / min_wage_month_tr if nr_mw_month == .
label var nr_mw_month "# of minimum wages from main occupation"

*type of health coverage
gen          health_type_all = .
replace      health_type_all = 1 if health == 0
replace      health_type_all = 2 if health_type == 3
replace      health_type_all = 3 if health_type == 1
replace      health_type_all = 4 if health_type == 2
label define health_type_all 1  "No health coverage"   ///
                             2  "Subsidized"  ///
                             3  "Contributive"  /// 
                             4  "Special"  ///
					
label values health_type_all health_type_all

*hourly gross wage
*-----------------
*La duración máxima legal de la jornada ordinaria de trabajo es de ocho (8) horas al día y cuarenta y ocho (48) a la semana
*48/8 = 6
gen       min_wage_hr  = min_wage_month_tr / 4 / 48
gen       aux1 = w_m_gross / 4
replace   aux1 = profit / 4 if aux1 == .
gen       w_m_gross_hr = aux1 / job_hrs_reg
drop aux*
gen       nr_mw_hr = w_m_gross_hr / min_wage_hr
label var nr_mw_hr "# of minimum hourly wages from main occupation"

*under MW
*monthly
gen     under_1mw_month = .
replace under_1mw_month = 1 if nr_mw_month >  0   & nr_mw_month < .99
replace under_1mw_month = 0 if nr_mw_month >= .99 & nr_mw_month != .
*hourly
gen     under_1mw_hr = .
replace under_1mw_hr = 1 if nr_mw_hr >  0   & nr_mw_hr < .99
replace under_1mw_hr = 0 if nr_mw_hr >= .99 & nr_mw_hr != . 

*INFORMALITY - social security & MWs
gen     informal_tr = .
replace informal_tr = 1 if (informal_ss == 1 | nr_mw_hr < .99 ) & ( labor_state <= 3 | labor_state == 8 )
replace informal_tr = 1 if  informal_ss == 1 & labor_state == 4
replace informal_tr = 0 if (informal_ss == 0 & nr_mw_hr >= .99 ) & ( labor_state <= 3 | labor_state == 8 )
replace informal_tr = 0 if  informal_ss == 0 & labor_state == 4

*real wages
*CPI January 2010 102.7
gen       w_month_real = ( w_m_gross / cpi ) * 102.7
replace   w_month_real = ( profit    / cpi ) * 102.7 if w_month_real == .
label var w_month_real "monthly wage from main occupation Jan2010 LCU"
gen       w_hr_real = ( w_m_gross_hr / cpi ) * 102.7 
label var w_hr_real "hourly wage from main occupation Jan2010 LCU"
 
corr nr_mw_month nr_mw_hr w_month_real w_hr_real
sum nr_mw_month nr_mw_hr w_month_real w_hr_real

*wages
*-----
*for employees
gen     w_main_employ = w_m_gross
sum     w_main_employ
replace w_main_employ = w_main_employ + w_overtime if w_overtime_inc == 0 & w_overtime != .
sum w_main_employ
foreach v in w_food w_rent w_transport w_in_kind {
	replace w_main_employ = w_main_employ + `v' if `v' != .
	sum w_main_employ
}
foreach v in sub_food sub_trans sub_fam sub_edu {
	replace w_main_employ = w_main_employ + `v' if `v'_inc == 0 & sub_food != .
	sum w_main_employ
} 

*indicator of microfirms sample
gen     me_dummy = .
replace me_dummy = 1 if sector2d == 15 & city_group <= 2 & firm_size <= 4
replace me_dummy = 1 if sector2d >= 17 & sector2d <= 37 & city_group <= 2 & firm_size <= 4
replace me_dummy = 1 if sector2d >= 50 & sector2d <= 55 & city_group <= 2 & firm_size <= 4
replace me_dummy = 1 if (sector2d == 61 | sector2d == 63 | sector2d == 64) & city_group <= 2 & firm_size <= 4
replace me_dummy = 1 if (sector2d == 65 | sector2d == 67) & city_group <= 2 & firm_size <= 4
replace me_dummy = 1 if sector2d >= 70 & sector2d <= 74 & city_group <= 2 & firm_size <= 4
replace me_dummy = 1 if sector2d >= 80 & sector2d <= 93 & city_group <= 2 & firm_size <= 4

gen     nr_mw = .
replace nr_mw = 1 if nr_mw_month >= 0 & nr_mw_month < 1
replace nr_mw = 2 if nr_mw_month >= 1 & nr_mw_month < 2
replace nr_mw = 3 if nr_mw_month >= 2 & nr_mw_month < 10
replace nr_mw = 4 if nr_mw_month >= 10 & nr_mw_month != .

*one or more minimum wage
gen     one_more_mw_month = .
replace one_more_mw_month = 0 if nr_mw_month < 1
replace one_more_mw_month = 1 if nr_mw_month >= 1 & nr_mw_month != .

gen     one_more_mw_hr = .
replace one_more_mw_hr = 0 if nr_mw_hr < 1
replace one_more_mw_hr = 1 if nr_mw_hr >= 1 & nr_mw_hr != .

*secondary sectors Jobs CCSA
gen          sector_jobs = .
replace      sector_jobs = 1  if sector1d == 1 | sector1d == 2
replace      sector_jobs = 2  if sector1d >= 3 & sector1d <= 4
replace      sector_jobs = 3  if sector1d == 5
replace      sector_jobs = 4  if sector1d == 6
replace      sector_jobs = 5  if sector1d >= 7 & sector1d <= 8
replace      sector_jobs = 6  if sector1d == 9
replace      sector_jobs = 7  if sector1d >= 10 & sector1d <= 11
replace      sector_jobs = 8  if sector1d == 12
replace      sector_jobs = 9  if sector1d >= 13 & sector1d <= 17
label define sector_jobs 1  "Agriculture, cattle and fishing"   ///
                         2  "Manufacture and mining"  ///
                         3  "Electricity, gas and water"  ///
                         4  "Construction"  ///
                         5  "Retail, restaurant and hotels"  ///
                         6  "Transport and communication"  ///
                         7  "Finance and real state"  ///
                         8  "Govt/public administration"  ///
                         9  "Other services"  ///

label values sector_jobs sector_jobs
label var    sector_jobs "secondary sectors Jobs CCSA"

/*
*Sector ISIC names
gen     sector4d_name = ""
replace sector4d_name = "Growing of cereals and other crops n.e.c." if sector4d == "0111"
replace sector4d_name = "Growing of vegetables, horticultural specialties and nursery products" if sector4d == "0112"
replace sector4d_name = "Growing of fruit, nuts, beverage and spice crops" if sector4d == "0113"
replace sector4d_name = "Growing of crops combined with farming of animals (mixed farming)" if sector4d == "0130"
replace sector4d_name = "Agricultural and animal husbandry service activities, except veterinary activities" if sector4d == "0140"
replace sector4d_name = "Hunting, trapping and game propagation including related service activities" if sector4d == "0150"
replace sector4d_name = "Forestry, logging and related service activities" if sector4d == "0200"
replace sector4d_name = "Fishing" if sector4d == "0501"
replace sector4d_name = "Aquaculture" if sector4d == "0502"
replace sector4d_name = "Mining and agglomeration of hard coal" if sector4d == "1010"
replace sector4d_name = "Mining and agglomeration of lignite" if sector4d == "1020"
replace sector4d_name = "Extraction and agglomeration of peat" if sector4d == "1030"
replace sector4d_name = "Extraction of crude petroleum and natural gas" if sector4d == "1110"
replace sector4d_name = "Service activities incidental to oil and gas extraction excluding surveying" if sector4d == "1120"
replace sector4d_name = "Mining of uranium and thorium ores" if sector4d == "1200"
replace sector4d_name = "Mining of iron ores" if sector4d == "1310"
replace sector4d_name = "Mining of non-ferrous metal ores, except uranium and thorium ores" if sector4d == "1320"
replace sector4d_name = "Quarrying of stone, sand and clay" if sector4d == "1410"
replace sector4d_name = "Mining of chemical and fertilizer minerals" if sector4d == "1421"
replace sector4d_name = "Extraction of salt" if sector4d == "1422"
replace sector4d_name = "Other mining and quarrying n.e.c." if sector4d == "1429"
replace sector4d_name = "Production, processing and preserving of meat and meat products" if sector4d == "1511"
replace sector4d_name = "Processing and preserving of fish and fish products" if sector4d == "1512"
replace sector4d_name = "Processing and preserving of fruit and vegetables" if sector4d == "1513"
replace sector4d_name = "Manufacture of vegetable and animal oils and fats" if sector4d == "1514"
replace sector4d_name = "Manufacture of dairy products" if sector4d == "1520"
replace sector4d_name = "Manufacture of grain mill products" if sector4d == "1531"
replace sector4d_name = "Manufacture of starches and starch products" if sector4d == "1532"
replace sector4d_name = "Manufacture of prepared animal feeds" if sector4d == "1533"
replace sector4d_name = "Manufacture of bakery products" if sector4d == "1541"
replace sector4d_name = "Manufacture of sugar" if sector4d == "1542"
replace sector4d_name = "Manufacture of cocoa, chocolate and sugar confectionery" if sector4d == "1543"
replace sector4d_name = "Manufacture of macaroni, noodles, couscous and similar farinaceous products" if sector4d == "1544"
replace sector4d_name = "Manufacture of other food products n.e.c." if sector4d == "1549"
replace sector4d_name = "Distilling, rectifying and blending of spirits; ethyl alcohol production from fermented materials" if sector4d == "1551"
replace sector4d_name = "Manufacture of wines" if sector4d == "1552"
replace sector4d_name = "Manufacture of malt liquors and malt" if sector4d == "1553"
replace sector4d_name = "Manufacture of soft drinks; production of mineral waters" if sector4d == "1554"
replace sector4d_name = "Manufacture of tobacco products" if sector4d == "1600"
replace sector4d_name = "Preparation and spinning of textile fibres; weaving of textiles" if sector4d == "1711"
replace sector4d_name = "Finishing of textiles" if sector4d == "1712"
replace sector4d_name = "Manufacture of made-up textile articles, except apparel" if sector4d == "1721"
replace sector4d_name = "Manufacture of carpets and rugs" if sector4d == "1722"
replace sector4d_name = "Manufacture of cordage, rope, twine and netting" if sector4d == "1723"
replace sector4d_name = "Manufacture of other textiles n.e.c." if sector4d == "1729"
replace sector4d_name = "Manufacture of knitted and crocheted fabrics and articles" if sector4d == "1730"
replace sector4d_name = "Manufacture of wearing apparel, except fur apparel" if sector4d == "1810"
replace sector4d_name = "Dressing and dyeing of fur; manufacture of articles of fur" if sector4d == "1820"
replace sector4d_name = "Tanning and dressing of leather" if sector4d == "1911"
replace sector4d_name = "Manufacture of luggage, handbags and the like, saddlery and harness" if sector4d == "1912"
replace sector4d_name = "Manufacture of footwear" if sector4d == "1920"
replace sector4d_name = "Sawmilling and planing of wood" if sector4d == "2010"
replace sector4d_name = "Manufacture of veneer sheets; manufacture of plywood, laminboard, particle board and other panels and boards" if sector4d == "2021"
replace sector4d_name = "Manufacture of builders' carpentry and joinery" if sector4d == "2022"
replace sector4d_name = "Manufacture of wooden containers" if sector4d == "2023"
replace sector4d_name = "Manufacture of other products of wood; manufacture of articles of cork, straw and plaiting materials" if sector4d == "2029"
replace sector4d_name = "Manufacture of pulp, paper and paperboard" if sector4d == "2101"
replace sector4d_name = "Manufacture of corrugated paper and paperboard and of containers of paper and paperboard" if sector4d == "2102"
replace sector4d_name = "Manufacture of other articles of paper and paperboard" if sector4d == "2109"
replace sector4d_name = "Publishing of books, brochures and other publications" if sector4d == "2211"
replace sector4d_name = "Publishing of newspapers, journals and periodicals" if sector4d == "2212"
replace sector4d_name = "Publishing of music" if sector4d == "2213"
replace sector4d_name = "Other publishing" if sector4d == "2219"
replace sector4d_name = "Printing" if sector4d == "2221"
replace sector4d_name = "Service activities related to printing" if sector4d == "2222"
replace sector4d_name = "Reproduction of recorded media" if sector4d == "2230"
replace sector4d_name = "Manufacture of coke oven products" if sector4d == "2310"
replace sector4d_name = "Manufacture of refined petroleum products" if sector4d == "2320"
replace sector4d_name = "Processing of nuclear fuel" if sector4d == "2330"
replace sector4d_name = "Manufacture of basic chemicals, except fertilizers and nitrogen compounds" if sector4d == "2411"
replace sector4d_name = "Manufacture of fertilizers and nitrogen compounds" if sector4d == "2412"
replace sector4d_name = "Manufacture of plastics in primary forms and of synthetic rubber" if sector4d == "2413"
replace sector4d_name = "Manufacture of pesticides and other agro-chemical products" if sector4d == "2421"
replace sector4d_name = "Manufacture of paints, varnishes and similar coatings, printing ink and mastics" if sector4d == "2422"
replace sector4d_name = "Manufacture of pharmaceuticals, medicinal chemicals and botanical products" if sector4d == "2423"
replace sector4d_name = "Manufacture of soap and detergents, cleaning and polishing preparations, perfumes and toilet preparations" if sector4d == "2424"
replace sector4d_name = "Manufacture of other chemical products n.e.c." if sector4d == "2429"
replace sector4d_name = "Manufacture of man-made fibres" if sector4d == "2430"
replace sector4d_name = "Manufacture of rubber tyres and tubes; retreading and rebuilding of rubber tyres" if sector4d == "2511"
replace sector4d_name = "Manufacture of other rubber products" if sector4d == "2519"
replace sector4d_name = "Manufacture of plastics products" if sector4d == "2520"
replace sector4d_name = "Manufacture of glass and glass products" if sector4d == "2610"
replace sector4d_name = "Manufacture of non-structural non-refractory ceramic ware" if sector4d == "2691"
replace sector4d_name = "Manufacture of refractory ceramic products" if sector4d == "2692"
replace sector4d_name = "Manufacture of structural non-refractory clay and ceramic products" if sector4d == "2693"
replace sector4d_name = "Manufacture of cement, lime and plaster" if sector4d == "2694"
replace sector4d_name = "Manufacture of articles of concrete, cement and plaster" if sector4d == "2695"
replace sector4d_name = "Cutting, shaping and finishing of stone" if sector4d == "2696"
replace sector4d_name = "Manufacture of other non-metallic mineral products n.e.c." if sector4d == "2699"
replace sector4d_name = "Manufacture of basic iron and steel" if sector4d == "2710"
replace sector4d_name = "Manufacture of basic precious and non-ferrous metals" if sector4d == "2720"
replace sector4d_name = "Casting of iron and steel" if sector4d == "2731"
replace sector4d_name = "Casting of non-ferrous metals" if sector4d == "2732"
replace sector4d_name = "Manufacture of structural metal products" if sector4d == "2811"
replace sector4d_name = "Manufacture of tanks, reservoirs and containers of metal" if sector4d == "2812"
replace sector4d_name = "Manufacture of steam generators, except central heating hot water  boilers" if sector4d == "2813"
replace sector4d_name = "Forging, pressing, stamping and roll-forming of metal; powder metallurgy" if sector4d == "2891"
replace sector4d_name = "Treatment and coating of metals; general mechanical engineering on a fee or contract basis" if sector4d == "2892"
replace sector4d_name = "Manufacture of cutlery, hand tools and general hardware" if sector4d == "2893"
replace sector4d_name = "Manufacture of other fabricated metal products n.e.c." if sector4d == "2899"
replace sector4d_name = "Manufacture of engines and turbines, except aircraft, vehicle and cycle engines" if sector4d == "2911"
replace sector4d_name = "Manufacture of pumps, compressors, taps and valves" if sector4d == "2912"
replace sector4d_name = "Manufacture of bearings, gears, gearing and driving elements" if sector4d == "2913"
replace sector4d_name = "Manufacture of ovens, furnaces and furnace burners" if sector4d == "2914"
replace sector4d_name = "Manufacture of lifting and handling equipment" if sector4d == "2915"
replace sector4d_name = "Manufacture of other general purpose machinery" if sector4d == "2919"
replace sector4d_name = "Manufacture of agricultural and forestry machinery" if sector4d == "2921"
replace sector4d_name = "Manufacture of machine-tools" if sector4d == "2922"
replace sector4d_name = "Manufacture of machinery for metallurgy" if sector4d == "2923"
replace sector4d_name = "Manufacture of machinery for mining, quarrying and construction" if sector4d == "2924"
replace sector4d_name = "Manufacture of machinery for food, beverage and tobacco processing" if sector4d == "2925"
replace sector4d_name = "Manufacture of machinery for textile, apparel and leather production" if sector4d == "2926"
replace sector4d_name = "Manufacture of weapons and ammunition" if sector4d == "2927"
replace sector4d_name = "Manufacture of other special purpose machinery" if sector4d == "2929"
replace sector4d_name = "Manufacture of domestic appliances n.e.c." if sector4d == "2930"
replace sector4d_name = "Manufacture of office, accounting and computing machinery" if sector4d == "3000"
replace sector4d_name = "Manufacture of electric motors, generators and transformers" if sector4d == "3110"
replace sector4d_name = "Manufacture of electricity distribution and control apparatus" if sector4d == "3120"
replace sector4d_name = "Manufacture of insulated wire and cable" if sector4d == "3130"
replace sector4d_name = "Manufacture of accumulators, primary cells and primary batteries" if sector4d == "3140"
replace sector4d_name = "Manufacture of electric lamps and lighting equipment" if sector4d == "3150"
replace sector4d_name = "Manufacture of other electrical equipment n.e.c." if sector4d == "3190"
replace sector4d_name = "Manufacture of electronic valves and tubes and other electronic components" if sector4d == "3210"
replace sector4d_name = "Manufacture of television and radio transmitters and apparatus for line telephony and line telegraphy" if sector4d == "3220"
replace sector4d_name = "Manufacture of television and radio receivers, sound or video recording or reproducing apparatus, and associated goods" if sector4d == "3230"
replace sector4d_name = "Manufacture of medical and surgical equipment and orthopedic appliances" if sector4d == "3311"
replace sector4d_name = "Manufacture of instruments and appliances for measuring, checking, testing, navigating and other purposes, except industrial process control equipment" if sector4d == "3312"
replace sector4d_name = "Manufacture of industrial process control equipment" if sector4d == "3313"
replace sector4d_name = "Manufacture of optical instruments and photographic equipment" if sector4d == "3320"
replace sector4d_name = "Manufacture of watches and clocks" if sector4d == "3330"
replace sector4d_name = "Manufacture of motor vehicles" if sector4d == "3410"
replace sector4d_name = "Manufacture of bodies (coachwork) for motor vehicles; manufacture of trailers and semi-trailers" if sector4d == "3420"
replace sector4d_name = "Manufacture of parts and accessories for motor vehicles and their engines" if sector4d == "3430"
replace sector4d_name = "Building and repairing of ships" if sector4d == "3511"
replace sector4d_name = "Building and repairing of pleasure and sporting boats" if sector4d == "3512"
replace sector4d_name = "Manufacture of railway and tramway locomotives and rolling stock" if sector4d == "3520"
replace sector4d_name = "Manufacture of aircraft and spacecraft" if sector4d == "3530"
replace sector4d_name = "Manufacture of motorcycles" if sector4d == "3591"
replace sector4d_name = "Manufacture of bicycles and invalid carriages" if sector4d == "3592"
replace sector4d_name = "Manufacture of other transport equipment n.e.c." if sector4d == "3599"
replace sector4d_name = "Manufacture of furniture" if sector4d == "3610"
replace sector4d_name = "Manufacture of jewellery and related articles" if sector4d == "3691"
replace sector4d_name = "Manufacture of musical instruments" if sector4d == "3692"
replace sector4d_name = "Manufacture of sports goods" if sector4d == "3693"
replace sector4d_name = "Manufacture of games and toys" if sector4d == "3694"
replace sector4d_name = "Other manufacturing n.e.c." if sector4d == "3699"
replace sector4d_name = "Recycling of metal waste and scrap" if sector4d == "3710"
replace sector4d_name = "Recycling of non-metal waste and scrap" if sector4d == "3720"
replace sector4d_name = "Production, transmission and distribution of electricity" if sector4d == "4010"
replace sector4d_name = "Manufacture of gas; distribution of gaseous fuels through mains" if sector4d == "4020"
replace sector4d_name = "Steam and hot water supply" if sector4d == "4030"
replace sector4d_name = "Collection, purification and distribution of water" if sector4d == "4100"
replace sector4d_name = "Site preparation" if sector4d == "4510"
replace sector4d_name = "Building of complete constructions or parts thereof; civil engineering" if sector4d == "4520"
replace sector4d_name = "Building installation" if sector4d == "4530"
replace sector4d_name = "Building completion" if sector4d == "4540"
replace sector4d_name = "Renting of construction or demolition equipment with operator" if sector4d == "4550"
replace sector4d_name = "Sale of motor vehicles" if sector4d == "5010"
replace sector4d_name = "Maintenance and repair of motor vehicles" if sector4d == "5020"
replace sector4d_name = "Sale of motor vehicle parts and accessories" if sector4d == "5030"
replace sector4d_name = "Sale, maintenance and repair of motorcycles and related parts and accessories" if sector4d == "5040"
replace sector4d_name = "Retail sale of automotive fuel" if sector4d == "5050"
replace sector4d_name = "Wholesale on a fee or contract basis" if sector4d == "5110"
replace sector4d_name = "Wholesale of agricultural raw materials and live animals" if sector4d == "5121"
replace sector4d_name = "Wholesale of food, beverages and tobacco" if sector4d == "5122"
replace sector4d_name = "Wholesale of textiles, clothing and footwear" if sector4d == "5131"
replace sector4d_name = "Wholesale of other household goods" if sector4d == "5139"
replace sector4d_name = "Wholesale of solid, liquid and gaseous fuels and related products" if sector4d == "5141"
replace sector4d_name = "Wholesale of metals and metal ores" if sector4d == "5142"
replace sector4d_name = "Wholesale of construction materials, hardware, plumbing and heating equipment and supplies" if sector4d == "5143"
replace sector4d_name = "Wholesale of other intermediate products, waste and scrap" if sector4d == "5149"
replace sector4d_name = "Wholesale of computers, computer peripheral equipment and software" if sector4d == "5151"
replace sector4d_name = "Wholesale of electronic and telecommunications parts and equipment" if sector4d == "5152"
replace sector4d_name = "Wholesale of other machinery, equipment and supplies" if sector4d == "5159"
replace sector4d_name = "Other wholesale" if sector4d == "5190"
replace sector4d_name = "Retail sale in non-specialized stores with food, beverages or tobacco predominating" if sector4d == "5211"
replace sector4d_name = "Other retail sale in non-specialized stores" if sector4d == "5219"
replace sector4d_name = "Retail sale of food, beverages and tobacco in specialized stores" if sector4d == "5220"
replace sector4d_name = "Retail sale of pharmaceutical and medical goods, cosmetic and toilet articles" if sector4d == "5231"
replace sector4d_name = "Retail sale of textiles, clothing, footwear and leather goods" if sector4d == "5232"
replace sector4d_name = "Retail sale of household appliances, articles and equipment" if sector4d == "5233"
replace sector4d_name = "Retail sale of hardware, paints and glass" if sector4d == "5234"
replace sector4d_name = "Other retail sale in specialized stores" if sector4d == "5239"
replace sector4d_name = "Retail sale of second-hand goods in stores" if sector4d == "5240"
replace sector4d_name = "Retail sale via mail order houses" if sector4d == "5251"
replace sector4d_name = "Retail sale via stalls and markets" if sector4d == "5252"
replace sector4d_name = "Other non-store retail sale" if sector4d == "5259"
replace sector4d_name = "Repair of personal and household goods" if sector4d == "5260"
replace sector4d_name = "Hotels; camping sites and other provision of short-stay accommodation" if sector4d == "5510"
replace sector4d_name = "Restaurants, bars and canteens" if sector4d == "5520"
replace sector4d_name = "Transport via railways" if sector4d == "6010"
replace sector4d_name = "Other scheduled passenger land transport" if sector4d == "6021"
replace sector4d_name = "Other non-scheduled passenger land transport" if sector4d == "6022"
replace sector4d_name = "Freight transport by road" if sector4d == "6023"
replace sector4d_name = "Transport via pipelines" if sector4d == "6030"
replace sector4d_name = "Sea and coastal water transport" if sector4d == "6110"
replace sector4d_name = "Inland water transport" if sector4d == "6120"
replace sector4d_name = "Scheduled air transport" if sector4d == "6210"
replace sector4d_name = "Non-scheduled air transport" if sector4d == "6220"
replace sector4d_name = "Cargo handling" if sector4d == "6301"
replace sector4d_name = "Storage and warehousing" if sector4d == "6302"
replace sector4d_name = "Other supporting transport activities" if sector4d == "6303"
replace sector4d_name = "Activities of travel agencies and tour operators; tourist assistance activities n.e.c." if sector4d == "6304"
replace sector4d_name = "Activities of other transport agencies" if sector4d == "6309"
replace sector4d_name = "National post activities" if sector4d == "6411"
replace sector4d_name = "Courier activities other than national post activities" if sector4d == "6412"
replace sector4d_name = "Telecommunications" if sector4d == "6420"
replace sector4d_name = "Central banking" if sector4d == "6511"
replace sector4d_name = "Other monetary intermediation" if sector4d == "6519"
replace sector4d_name = "Financial leasing" if sector4d == "6591"
replace sector4d_name = "Other credit granting" if sector4d == "6592"
replace sector4d_name = "Other financial intermediation n.e.c." if sector4d == "6599"
replace sector4d_name = "Life insurance" if sector4d == "6601"
replace sector4d_name = "Pension funding" if sector4d == "6602"
replace sector4d_name = "Non-life insurance" if sector4d == "6603"
replace sector4d_name = "Administration of financial markets" if sector4d == "6711"
replace sector4d_name = "Security dealing activities" if sector4d == "6712"
replace sector4d_name = "Activities auxiliary to financial intermediation n.e.c." if sector4d == "6719"
replace sector4d_name = "Activities auxiliary to insurance and pension funding" if sector4d == "6720"
replace sector4d_name = "Real estate activities with own or leased property" if sector4d == "7010"
replace sector4d_name = "Real estate activities on a fee or contract basis" if sector4d == "7020"
replace sector4d_name = "Renting of land transport equipment" if sector4d == "7111"
replace sector4d_name = "Renting of water transport equipment" if sector4d == "7112"
replace sector4d_name = "Renting of air transport equipment" if sector4d == "7113"
replace sector4d_name = "Renting of agricultural machinery and equipment" if sector4d == "7121"
replace sector4d_name = "Renting of construction and civil engineering machinery and equipment" if sector4d == "7122"
replace sector4d_name = "Renting of office machinery and equipment (including computers)" if sector4d == "7123"
replace sector4d_name = "Renting of other machinery and equipment n.e.c." if sector4d == "7129"
replace sector4d_name = "Renting of other machinery and equipment n.e.c." if sector4d == "7129"
replace sector4d_name = "Renting of personal and household goods n.e.c." if sector4d == "7130"
replace sector4d_name = "Hardware consultancy" if sector4d == "7210"
replace sector4d_name = "Software publishing" if sector4d == "7221"
replace sector4d_name = "Other software consultancy and supply" if sector4d == "7229"
replace sector4d_name = "Data processing" if sector4d == "7230"
replace sector4d_name = "Database activities and on-line distribution of electronic content" if sector4d == "7240"
replace sector4d_name = "Maintenance and repair of office, accounting and computing machinery" if sector4d == "7250"
replace sector4d_name = "Other computer related activities" if sector4d == "7290"
replace sector4d_name = "Research and experimental development on natural sciences and engineering (NSE)" if sector4d == "7310"
replace sector4d_name = "Research and experimental development on social sciences and humanities (SSH)" if sector4d == "7320"
replace sector4d_name = "Legal activities" if sector4d == "7411"
replace sector4d_name = "Accounting, book-keeping and auditing activities; tax consultancy" if sector4d == "7412"
replace sector4d_name = "Market research and public opinion polling" if sector4d == "7413"
replace sector4d_name = "Business and management consultancy activities" if sector4d == "7414"
replace sector4d_name = "Architectural and engineering activities and related technical consultancy" if sector4d == "7421"
replace sector4d_name = "Technical testing and analysis" if sector4d == "7422"
replace sector4d_name = "7430 Advertising" if sector4d == "743"
replace sector4d_name = "Labour recruitment and provision of personnel" if sector4d == "7491"
replace sector4d_name = "Investigation and security activities" if sector4d == "7492"
replace sector4d_name = "Building-cleaning and industrial-cleaning activities" if sector4d == "7493"
replace sector4d_name = "Photographic activities" if sector4d == "7494"
replace sector4d_name = "Packaging activities" if sector4d == "7495"
replace sector4d_name = "Other business activities n.e.c." if sector4d == "7499"
replace sector4d_name = "General (overall) public service activities" if sector4d == "7511"
replace sector4d_name = "Regulation of the activities of agencies that provide health care, education, cultural services and other social services, excluding social security" if sector4d == "7512"
replace sector4d_name = "Regulation of and contribution to more efficient operation of business" if sector4d == "7513"
replace sector4d_name = "Supporting service activities for the government as a whole" if sector4d == "7514"
replace sector4d_name = "Foreign affairs" if sector4d == "7521"
replace sector4d_name = "Defence activities" if sector4d == "7522"
replace sector4d_name = "Public order and safety activities" if sector4d == "7523"
replace sector4d_name = "Compulsory social security activities" if sector4d == "7530"
replace sector4d_name = "Primary education" if sector4d == "8010"
replace sector4d_name = "General secondary education" if sector4d == "8021"
replace sector4d_name = "Technical and vocational secondary education" if sector4d == "8022"
replace sector4d_name = "Higher education" if sector4d == "8030"
replace sector4d_name = "Other education" if sector4d == "8090"
replace sector4d_name = "Hospital activities" if sector4d == "8511"
replace sector4d_name = "Medical and dental practice activities" if sector4d == "8512"
replace sector4d_name = "Other human health activities" if sector4d == "8519"
replace sector4d_name = "Veterinary activities" if sector4d == "8520"
replace sector4d_name = "Social work activities with accommodation" if sector4d == "8531"
replace sector4d_name = "Social work activities without accommodation" if sector4d == "8532"
replace sector4d_name = "Sewage and refuse disposal, sanitation and similar activities" if sector4d == "9000"
replace sector4d_name = "Activities of business and employers organizations" if sector4d == "9111"
replace sector4d_name = "Activities of professional organizations" if sector4d == "9112"
replace sector4d_name = "Activities of trade unions" if sector4d == "9120"
replace sector4d_name = "Activities of religious organizations" if sector4d == "9191"
replace sector4d_name = "Activities of political organizations" if sector4d == "9192"
replace sector4d_name = "Activities of other membership organizations n.e.c." if sector4d == "9199"
replace sector4d_name = "Motion picture and video production and distribution" if sector4d == "9211"
replace sector4d_name = "Motion picture projection" if sector4d == "9212"
replace sector4d_name = "Radio and television activities" if sector4d == "9213"
replace sector4d_name = "Dramatic arts, music and other arts activities" if sector4d == "9214"
replace sector4d_name = "Other entertainment activities n.e.c." if sector4d == "9219"
replace sector4d_name = "News agency activities" if sector4d == "9220"
replace sector4d_name = "Library and archives activities" if sector4d == "9231"
replace sector4d_name = "Museums activities and preservation of historical sites and buildings" if sector4d == "9232"
replace sector4d_name = "Botanical and zoological gardens and nature reserves activities" if sector4d == "9233"
replace sector4d_name = "Sporting activities" if sector4d == "9241"
replace sector4d_name = "Other recreational activities" if sector4d == "9249"
replace sector4d_name = "Washing and (dry-) cleaning of textile and fur products" if sector4d == "9301"
replace sector4d_name = "Hairdressing and other beauty treatment" if sector4d == "9302"
replace sector4d_name = "Funeral and related activities" if sector4d == "9303"
replace sector4d_name = "Other service activities n.e.c." if sector4d == "9309"
replace sector4d_name = "Activities of private households as employers of domestic staff" if sector4d == "9500"
replace sector4d_name = "Undifferentiated goods-producing activities of private households for own use" if sector4d == "9600"
replace sector4d_name = "Undifferentiated service-producing activities of private households for own use" if sector4d == "9700"
replace sector4d_name = "Extra-territorial organizations and bodies" if sector4d == "9900"

tab sector4d_name
*/
*CIIU Rev 3 AC to ISIC Rev 3 international
*-----------------------------------
gen     isic_rev3 = sector4d
replace isic_rev3 = "0113" if sector4d == "0111"
replace isic_rev3 = "0112" if sector4d == "0112"
replace isic_rev3 = "0113" if sector4d == "0113"
replace isic_rev3 = "0111" if sector4d == "0114"
replace isic_rev3 = "0111" if sector4d == "0115"
replace isic_rev3 = "0112" if sector4d == "0116"
replace isic_rev3 = "0113" if sector4d == "0117"
replace isic_rev3 = "0111" if sector4d == "0118"
replace isic_rev3 = "0111" if sector4d == "0119"
replace isic_rev3 = "0121" if sector4d == "0121"
replace isic_rev3 = "0122" if sector4d == "0122"
replace isic_rev3 = "0122" if sector4d == "0123"
replace isic_rev3 = "0121" if sector4d == "0124"
replace isic_rev3 = "0122" if sector4d == "0125"
replace isic_rev3 = "0121" if sector4d == "0129"
replace isic_rev3 = "0200" if sector4d == "0201"
replace isic_rev3 = "0200" if sector4d == "0202"
replace isic_rev3 = "0500" if sector4d == "0501"
replace isic_rev3 = "0500" if sector4d == "0502"
replace isic_rev3 = "1320" if sector4d == "1331"
replace isic_rev3 = "1320" if sector4d == "1339"
replace isic_rev3 = "1410" if sector4d == "1411"
replace isic_rev3 = "1410" if sector4d == "1412"
replace isic_rev3 = "1410" if sector4d == "1413"
replace isic_rev3 = "1410" if sector4d == "1414"
replace isic_rev3 = "1410" if sector4d == "1415"
replace isic_rev3 = "1429" if sector4d == "1431"
replace isic_rev3 = "1429" if sector4d == "1432"
replace isic_rev3 = "1429" if sector4d == "1490"
replace isic_rev3 = "1513" if sector4d == "1521"
replace isic_rev3 = "1514" if sector4d == "1522"
replace isic_rev3 = "1520" if sector4d == "1530"
replace isic_rev3 = "1531" if sector4d == "1541"
replace isic_rev3 = "1532" if sector4d == "1542"
replace isic_rev3 = "1533" if sector4d == "1543"
replace isic_rev3 = "1541" if sector4d == "1551"
replace isic_rev3 = "1544" if sector4d == "1552"
replace isic_rev3 = "1549" if sector4d == "1561"
replace isic_rev3 = "1549" if sector4d == "1562"
replace isic_rev3 = "1549" if sector4d == "1563"
replace isic_rev3 = "1549" if sector4d == "1564"
replace isic_rev3 = "1542" if sector4d == "1571"
replace isic_rev3 = "1542" if sector4d == "1572"
replace isic_rev3 = "1543" if sector4d == "1581"
replace isic_rev3 = "1549" if sector4d == "1589"
replace isic_rev3 = "1551" if sector4d == "1591"
replace isic_rev3 = "1552" if sector4d == "1592"
replace isic_rev3 = "1553" if sector4d == "1593"
replace isic_rev3 = "1554" if sector4d == "1594"
replace isic_rev3 = "1711" if sector4d == "1710"
replace isic_rev3 = "1711" if sector4d == "1720"
replace isic_rev3 = "1712" if sector4d == "1730"
replace isic_rev3 = "1721" if sector4d == "1741"
replace isic_rev3 = "1722" if sector4d == "1742"
replace isic_rev3 = "1723" if sector4d == "1743"
replace isic_rev3 = "1729" if sector4d == "1749"
replace isic_rev3 = "1730" if sector4d == "1750"
replace isic_rev3 = "1911" if sector4d == "1910"
replace isic_rev3 = "1920" if sector4d == "1921"
replace isic_rev3 = "1920" if sector4d == "1922"
replace isic_rev3 = "1920" if sector4d == "1923"
replace isic_rev3 = "1920" if sector4d == "1924"
replace isic_rev3 = "1920" if sector4d == "1925"
replace isic_rev3 = "1920" if sector4d == "1926"
replace isic_rev3 = "1920" if sector4d == "1929"
replace isic_rev3 = "1912" if sector4d == "1931"
replace isic_rev3 = "1912" if sector4d == "1932"
replace isic_rev3 = "1912" if sector4d == "1939"
replace isic_rev3 = "2021" if sector4d == "2020"
replace isic_rev3 = "2022" if sector4d == "2030"
replace isic_rev3 = "2023" if sector4d == "2040"
replace isic_rev3 = "2029" if sector4d == "2090"
replace isic_rev3 = "2221" if sector4d == "2220"
replace isic_rev3 = "2222" if sector4d == "2231"
replace isic_rev3 = "2222" if sector4d == "2232"
replace isic_rev3 = "2222" if sector4d == "2233"
replace isic_rev3 = "2222" if sector4d == "2234"
replace isic_rev3 = "2222" if sector4d == "2239"
replace isic_rev3 = "2230" if sector4d == "2240"
replace isic_rev3 = "2310" if sector4d == "2310"
replace isic_rev3 = "2320" if sector4d == "2321"
replace isic_rev3 = "2320" if sector4d == "2322"
replace isic_rev3 = "2413" if sector4d == "2414"
replace isic_rev3 = "2511" if sector4d == "2512"
replace isic_rev3 = "2519" if sector4d == "2513"
replace isic_rev3 = "2520" if sector4d == "2521"
replace isic_rev3 = "2520" if sector4d == "2529"
replace isic_rev3 = "2720" if sector4d == "2721"
replace isic_rev3 = "2720" if sector4d == "2729"
replace isic_rev3 = "3610" if sector4d == "3611"
replace isic_rev3 = "3610" if sector4d == "3612"
replace isic_rev3 = "3610" if sector4d == "3613"
replace isic_rev3 = "3610" if sector4d == "3614"
replace isic_rev3 = "3610" if sector4d == "3619"
replace isic_rev3 = "4510" if sector4d == "4511"
replace isic_rev3 = "4510" if sector4d == "4512"
replace isic_rev3 = "4520" if sector4d == "4521"
replace isic_rev3 = "4520" if sector4d == "4522"
replace isic_rev3 = "4520" if sector4d == "4530"
replace isic_rev3 = "4530" if sector4d == "4541"
replace isic_rev3 = "4530" if sector4d == "4542"
replace isic_rev3 = "4530" if sector4d == "4543"
replace isic_rev3 = "4530" if sector4d == "4549"
replace isic_rev3 = "4540" if sector4d == "4551"
replace isic_rev3 = "4540" if sector4d == "4552"
replace isic_rev3 = "4540" if sector4d == "4559"
replace isic_rev3 = "4550" if sector4d == "4560"
replace isic_rev3 = "5010" if sector4d == "5011"
replace isic_rev3 = "5010" if sector4d == "5012"
replace isic_rev3 = "5050" if sector4d == "5051"
replace isic_rev3 = "5050" if sector4d == "5052"
replace isic_rev3 = "5110" if sector4d == "5111"
replace isic_rev3 = "5110" if sector4d == "5112"
replace isic_rev3 = "5110" if sector4d == "5113"
replace isic_rev3 = "5110" if sector4d == "5119"
replace isic_rev3 = "5121" if sector4d == "5121"
replace isic_rev3 = "5121" if sector4d == "5122"
replace isic_rev3 = "5121" if sector4d == "5123"
replace isic_rev3 = "5121" if sector4d == "5124"
replace isic_rev3 = "5122" if sector4d == "5125"
replace isic_rev3 = "5121" if sector4d == "5126"
replace isic_rev3 = "5122" if sector4d == "5127"
replace isic_rev3 = "5131" if sector4d == "5131"
replace isic_rev3 = "5131" if sector4d == "5132"
replace isic_rev3 = "5131" if sector4d == "5133"
replace isic_rev3 = "5139" if sector4d == "5134"
replace isic_rev3 = "5139" if sector4d == "5135"
replace isic_rev3 = "5139" if sector4d == "5136"
replace isic_rev3 = "5139" if sector4d == "5137"
replace isic_rev3 = "5139" if sector4d == "5139"
replace isic_rev3 = "5143" if sector4d == "5141"
replace isic_rev3 = "5143" if sector4d == "5142"
replace isic_rev3 = "5141" if sector4d == "5151"
replace isic_rev3 = "5142" if sector4d == "5152"
replace isic_rev3 = "5149" if sector4d == "5153"
replace isic_rev3 = "5149" if sector4d == "5154"
replace isic_rev3 = "5149" if sector4d == "5155"
replace isic_rev3 = "5149" if sector4d == "5159"
replace isic_rev3 = "5150" if sector4d == "5161"
replace isic_rev3 = "5150" if sector4d == "5162"
replace isic_rev3 = "5150" if sector4d == "5163"
replace isic_rev3 = "5150" if sector4d == "5169"
replace isic_rev3 = "5220" if sector4d == "5221"
replace isic_rev3 = "5220" if sector4d == "5222"
replace isic_rev3 = "5220" if sector4d == "5223"
replace isic_rev3 = "5220" if sector4d == "5224"
replace isic_rev3 = "5220" if sector4d == "5225"
replace isic_rev3 = "5220" if sector4d == "5229"
replace isic_rev3 = "5232" if sector4d == "5232"
replace isic_rev3 = "5232" if sector4d == "5233"
replace isic_rev3 = "5232" if sector4d == "5234"
replace isic_rev3 = "5233" if sector4d == "5235"
replace isic_rev3 = "5233" if sector4d == "5236"
replace isic_rev3 = "5233" if sector4d == "5237"
replace isic_rev3 = "5233" if sector4d == "5239"
replace isic_rev3 = "5234" if sector4d == "5241"
replace isic_rev3 = "5234" if sector4d == "5242"
replace isic_rev3 = "5239" if sector4d == "5243"
replace isic_rev3 = "5239" if sector4d == "5244"
replace isic_rev3 = "5239" if sector4d == "5245"
replace isic_rev3 = "5239" if sector4d == "5246"
replace isic_rev3 = "5239" if sector4d == "5249"
replace isic_rev3 = "5240" if sector4d == "5251"
replace isic_rev3 = "5240" if sector4d == "5252"
replace isic_rev3 = "5251" if sector4d == "5261"
replace isic_rev3 = "5252" if sector4d == "5262"
replace isic_rev3 = "5259" if sector4d == "5269"
replace isic_rev3 = "5260" if sector4d == "5271"
replace isic_rev3 = "5260" if sector4d == "5272"
replace isic_rev3 = "5510" if sector4d == "5211"
replace isic_rev3 = "5510" if sector4d == "5212"
replace isic_rev3 = "5510" if sector4d == "5213"
replace isic_rev3 = "5510" if sector4d == "5519"
replace isic_rev3 = "5520" if sector4d == "5521"
replace isic_rev3 = "5520" if sector4d == "5522"
replace isic_rev3 = "5520" if sector4d == "5523"
replace isic_rev3 = "5520" if sector4d == "5524"
replace isic_rev3 = "5520" if sector4d == "5529"
replace isic_rev3 = "5520" if sector4d == "5530"
replace isic_rev3 = "6010" if sector4d == "6021"
replace isic_rev3 = "6021" if sector4d == "6022"
replace isic_rev3 = "6021" if sector4d == "6023"
replace isic_rev3 = "6022" if sector4d == "6031"
replace isic_rev3 = "6022" if sector4d == "6032"
replace isic_rev3 = "6022" if sector4d == "6039"
replace isic_rev3 = "6023" if sector4d == "6041"
replace isic_rev3 = "6023" if sector4d == "6042"
replace isic_rev3 = "6023" if sector4d == "6043"
replace isic_rev3 = "6023" if sector4d == "6044"
replace isic_rev3 = "6030" if sector4d == "6050"
replace isic_rev3 = "6110" if sector4d == "6111"
replace isic_rev3 = "6110" if sector4d == "6112"
replace isic_rev3 = "6210" if sector4d == "6211"
replace isic_rev3 = "6210" if sector4d == "6212"
replace isic_rev3 = "6210" if sector4d == "6213"
replace isic_rev3 = "6210" if sector4d == "6214"
replace isic_rev3 = "6301" if sector4d == "6310"
replace isic_rev3 = "6302" if sector4d == "6320"
replace isic_rev3 = "6303" if sector4d == "6331"
replace isic_rev3 = "6303" if sector4d == "6332"
replace isic_rev3 = "6303" if sector4d == "6333"
replace isic_rev3 = "6303" if sector4d == "6339"
replace isic_rev3 = "6304" if sector4d == "6340"
replace isic_rev3 = "6309" if sector4d == "6390"
replace isic_rev3 = "6420" if sector4d == "6421"
replace isic_rev3 = "6420" if sector4d == "6422"
replace isic_rev3 = "6420" if sector4d == "6423"
replace isic_rev3 = "6420" if sector4d == "6424"
replace isic_rev3 = "6420" if sector4d == "6425"
replace isic_rev3 = "6420" if sector4d == "6426"
replace isic_rev3 = "6519" if sector4d == "6512"
replace isic_rev3 = "6519" if sector4d == "6513"
replace isic_rev3 = "6519" if sector4d == "6514"
replace isic_rev3 = "6519" if sector4d == "6515"
replace isic_rev3 = "6519" if sector4d == "6516"
replace isic_rev3 = "6519" if sector4d == "6519"
replace isic_rev3 = "6599" if sector4d == "6592"
replace isic_rev3 = "6592" if sector4d == "9593"
replace isic_rev3 = "6599" if sector4d == "9594"
replace isic_rev3 = "6599" if sector4d == "9595"
replace isic_rev3 = "6592" if sector4d == "9596"
replace isic_rev3 = "6599" if sector4d == "9599"
replace isic_rev3 = "6603" if sector4d == "6601"
replace isic_rev3 = "6603" if sector4d == "6601"
replace isic_rev3 = "6601" if sector4d == "6602"
replace isic_rev3 = "6603" if sector4d == "6603"
replace isic_rev3 = "6602" if sector4d == "6604"
replace isic_rev3 = "6712" if sector4d == "6713"
replace isic_rev3 = "6712" if sector4d == "6714"
replace isic_rev3 = "6712" if sector4d == "6715"
replace isic_rev3 = "6720" if sector4d == "6721"
replace isic_rev3 = "6720" if sector4d == "6722"
replace isic_rev3 = "7511" if sector4d == "7512"
replace isic_rev3 = "7512" if sector4d == "7513"
replace isic_rev3 = "7513" if sector4d == "7514"
replace isic_rev3 = "7514" if sector4d == "7515"
replace isic_rev3 = "7523" if sector4d == "7524"
replace isic_rev3 = "8010" if sector4d == "8011"
replace isic_rev3 = "8010" if sector4d == "8012"
replace isic_rev3 = "8022" if sector4d == "8021"
replace isic_rev3 = "8022" if sector4d == "8030"
replace isic_rev3 = "8030" if sector4d == "8050"
replace isic_rev3 = "8090" if sector4d == "8060"
replace isic_rev3 = "8512" if sector4d == "8513"
replace isic_rev3 = "8519" if sector4d == "8514"
replace isic_rev3 = "8519" if sector4d == "8515"
replace isic_rev3 = "9249" if sector4d == "9242"

/*
*Non-Profit organization variables
*---------------------------------
*NPO main type
gen     npo = ""
replace npo = "Cultura y recreación" if isic_rev3 == "2211"
replace npo = "Cultura y recreación" if isic_rev3 == "2212"
replace npo = "Cultura y recreación" if isic_rev3 == "2213"
replace npo = "Cultura y recreación" if isic_rev3 == "2219"
replace npo = "Cultura y recreación" if isic_rev3 == "9199"
replace npo = "Cultura y recreación" if isic_rev3 == "9211"
replace npo = "Cultura y recreación" if isic_rev3 == "9213"
replace npo = "Cultura y recreación" if isic_rev3 == "9214"
replace npo = "Cultura y recreación" if isic_rev3 == "9214"
replace npo = "Cultura y recreación" if isic_rev3 == "9231"
replace npo = "Cultura y recreación" if isic_rev3 == "9232"
replace npo = "Cultura y recreación" if isic_rev3 == "9233"
replace npo = "Cultura y recreación" if isic_rev3 == "9241"
replace npo = "Cultura y recreación" if isic_rev3 == "9199"
replace npo = "Cultura y recreación" if isic_rev3 == "9249"
replace npo = "Enseñanza e investigación" if isic_rev3 == "8010"
replace npo = "Enseñanza e investigación" if isic_rev3 == "8021"
replace npo = "Enseñanza e investigación" if isic_rev3 == "8030"
replace npo = "Enseñanza e investigación" if isic_rev3 == "8022"
replace npo = "Enseñanza e investigación" if isic_rev3 == "8090"
replace npo = "Enseñanza e investigación" if isic_rev3 == "7310"
replace npo = "Enseñanza e investigación" if isic_rev3 == "7320"
replace npo = "Salud" if isic_rev3 == "8511"
replace npo = "Salud" if isic_rev3 == "8519"
replace npo = "Salud" if isic_rev3 == "8511"
replace npo = "Salud" if isic_rev3 == "8512"
replace npo = "Salud" if isic_rev3 == "8519"
replace npo = "Salud" if isic_rev3 == "8532"
replace npo = "Salud" if isic_rev3 == "8512"
replace npo = "Salud" if isic_rev3 == "8519"
replace npo = "Salud" if isic_rev3 == "9000"
replace npo = "Servicios sociales" if isic_rev3 == "8531"
replace npo = "Servicios sociales" if isic_rev3 == "8532"
replace npo = "Servicios sociales" if isic_rev3 == "8532"
replace npo = "Servicios sociales" if isic_rev3 == "7523"
replace npo = "Servicios sociales" if isic_rev3 == "7524"
replace npo = "Servicios sociales" if isic_rev3 == "8532"
replace npo = "Medio ambiente" if isic_rev3 == "9000"
replace npo = "Medio ambiente" if isic_rev3 == "9199"
replace npo = "Medio ambiente" if isic_rev3 == "9233"
replace npo = "Medio ambiente" if isic_rev3 == "0140"
replace npo = "Medio ambiente" if isic_rev3 == "8520"
replace npo = "Medio ambiente" if isic_rev3 == "9233"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4520"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4530"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4540"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "6519"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "7414"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "7421"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "9199"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4510"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4520"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4530"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "4540"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "7010"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "7020"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "8532"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "8532"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "9199"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "8090"
replace npo = "Desarrollo y vivienda" if isic_rev3 == "8532"
replace npo = "Derecho, promoción y política" if isic_rev3 == "9199"
replace npo = "Derecho, promoción y política" if isic_rev3 == "7411"
replace npo = "Derecho, promoción y política" if isic_rev3 == "7523"
replace npo = "Derecho, promoción y política" if isic_rev3 == "8532"
replace npo = "Derecho, promoción y política" if isic_rev3 == "9192"
replace npo = "Intermediación filantrópica y promoción del voluntariado" if isic_rev3 == "6599"
replace npo = "Intermediación filantrópica y promoción del voluntariado" if isic_rev3 == "8532"
replace npo = "Intermediación filantrópica y promoción del voluntariado" if isic_rev3 == "7499"
replace npo = "Intermediación filantrópica y promoción del voluntariado" if isic_rev3 == "9199"
replace npo = "Intermediación filantrópica y promoción del voluntariado" if isic_rev3 == "9249"
replace npo = "Internacional" if isic_rev3 == "9199"
replace npo = "Religión" if isic_rev3 == "9191"
replace npo = "Asociaciones empresariales y profesionales, sindicatos" if isic_rev3 == "9111"
replace npo = "Asociaciones empresariales y profesionales, sindicatos" if isic_rev3 == "9112"
replace npo = "Asociaciones empresariales y profesionales, sindicatos" if isic_rev3 == "9120"

*NPO secondary type
gen npo_type = ""
replace npo_type = "Cultura y artes " if isic_rev3 == "2211"
replace npo_type = "Cultura y artes " if isic_rev3 == "2212"
replace npo_type = "Cultura y artes " if isic_rev3 == "2213"
replace npo_type = "Cultura y artes " if isic_rev3 == "2219"
replace npo_type = "Cultura y artes " if isic_rev3 == "9199"
replace npo_type = "Cultura y artes " if isic_rev3 == "9211"
replace npo_type = "Cultura y artes " if isic_rev3 == "9213"
replace npo_type = "Cultura y artes " if isic_rev3 == "9214"
replace npo_type = "Cultura y artes " if isic_rev3 == "9214"
replace npo_type = "Cultura y artes " if isic_rev3 == "9231"
replace npo_type = "Cultura y artes " if isic_rev3 == "9232"
replace npo_type = "Cultura y artes " if isic_rev3 == "9233"
replace npo_type = "Deportes " if isic_rev3 == "9241"
replace npo_type = "Otros clubes sociales y recreativos " if isic_rev3 == "9199"
replace npo_type = "Otros clubes sociales y recreativos " if isic_rev3 == "9249"
replace npo_type = "Enseñanza primaria y secundaria " if isic_rev3 == "8010"
replace npo_type = "Enseñanza primaria y secundaria " if isic_rev3 == "8021"
replace npo_type = "Enseñanza superior " if isic_rev3 == "8030"
replace npo_type = "Otros tipos de educación (escuelas profesionales y técnicas)" if isic_rev3 == "8022"
replace npo_type = "Otros tipos de educación (escuelas profesionales y técnicas)" if isic_rev3 == "8090"
replace npo_type = "Investigaciones (investigaciones médicas, ciencia y tecnología)" if isic_rev3 == "7310"
replace npo_type = "Investigaciones (investigaciones médicas, ciencia y tecnología)" if isic_rev3 == "7320"
replace npo_type = "Hospitales y rehabilitación " if isic_rev3 == "8511"
replace npo_type = "Casas de salud " if isic_rev3 == "8519"
replace npo_type = "Salud mental e intervención en crisis " if isic_rev3 == "8511"
replace npo_type = "Salud mental e intervención en crisis " if isic_rev3 == "8512"
replace npo_type = "Salud mental e intervención en crisis " if isic_rev3 == "8519"
replace npo_type = "Salud mental e intervención en crisis " if isic_rev3 == "8532"
replace npo_type = "Otros servicios de salud " if isic_rev3 == "8512"
replace npo_type = "Otros servicios de salud " if isic_rev3 == "8519"
replace npo_type = "Otros servicios de salud " if isic_rev3 == "9000"
replace npo_type = "Servicios sociales " if isic_rev3 == "8531"
replace npo_type = "Servicios sociales " if isic_rev3 == "8532"
replace npo_type = "Casos de emergencia y socorro " if isic_rev3 == "8532"
replace npo_type = "Casos de emergencia y socorro " if isic_rev3 == "7523"
replace npo_type = "Casos de emergencia y socorro " if isic_rev3 == "7524"
replace npo_type = "Apoyo en materia de ingresos y mantenimiento" if isic_rev3 == "8532"
replace npo_type = "Medio ambiente " if isic_rev3 == "9000"
replace npo_type = "Medio ambiente " if isic_rev3 == "9199"
replace npo_type = "Medio ambiente " if isic_rev3 == "9233"
replace npo_type = "Protección de animales " if isic_rev3 == "0140"
replace npo_type = "Protección de animales " if isic_rev3 == "8520"
replace npo_type = "Protección de animales " if isic_rev3 == "9233"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "4520"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "4530"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "4540"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "6519"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "7414"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "7421"
replace npo_type = "Desarrollo económico, social y comunitario" if isic_rev3 == "9199"
replace npo_type = "Vivienda " if isic_rev3 == "4510"
replace npo_type = "Vivienda " if isic_rev3 == "4520"
replace npo_type = "Vivienda " if isic_rev3 == "4530"
replace npo_type = "Vivienda " if isic_rev3 == "4540"
replace npo_type = "Vivienda " if isic_rev3 == "7010"
replace npo_type = "Vivienda " if isic_rev3 == "7020"
replace npo_type = "Vivienda " if isic_rev3 == "8532"
replace npo_type = "Vivienda " if isic_rev3 == "8532"
replace npo_type = "Vivienda " if isic_rev3 == "9199"
replace npo_type = "Empleo y capacitación " if isic_rev3 == "8090"
replace npo_type = "Empleo y capacitación " if isic_rev3 == "8532"
replace npo_type = "Organizaciones cívicas y de promoción " if isic_rev3 == "9199"
replace npo_type = "Derecho y servicios jurídicos " if isic_rev3 == "7411"
replace npo_type = "Derecho y servicios jurídicos " if isic_rev3 == "7523"
replace npo_type = "Derecho y servicios jurídicos " if isic_rev3 == "8532"
replace npo_type = "Organizaciones políticas " if isic_rev3 == "9192"
replace npo_type = "Fundaciones que otorgan subsidios " if isic_rev3 == "6599"
replace npo_type = "Otros tipos de intermediación filantrópica y promoción del voluntarismo" if isic_rev3 == "8532"
replace npo_type = "Otros tipos de intermediación filantrópica y promoción del voluntarismo" if isic_rev3 == "7499"
replace npo_type = "Otros tipos de intermediación filantrópica y promoción del voluntarismo" if isic_rev3 == "9199"
replace npo_type = "Otros tipos de intermediación filantrópica y promoción del voluntarismo" if isic_rev3 == "9249"
replace npo_type = "Actividades internacionales " if isic_rev3 == "9199"
replace npo_type = "Congregaciones y asociaciones religiosas" if isic_rev3 == "9191"
replace npo_type = "Asociaciones empresariales " if isic_rev3 == "9111"
replace npo_type = "Asociaciones profesionales " if isic_rev3 == "9112"
replace npo_type = "Sindicatos " if isic_rev3 == "9120"

*npo dummy
gen       npo_dummy = .
replace   npo_dummy = 0 if npo == "" & employed == 1
replace   npo_dummy = 1 if npo != "" & employed == 1
label var npo_dummy "=1 if in Non-profit firm"
gen       no_npo_dummy = .
replace   no_npo_dummy = 1 - npo_dummy
label var no_npo_dummy "=1 if in for profit firm"

*npo-year dummies
forvalues y = 2013/2016 {
    gen     no_npo_`y' = 0
    replace no_npo_`y' = 1 if year == `y' & no_npo_dummy == 1
}

*npo-semester dummies
forvalues y = 2013/2016 {
	forvalues s = 1/2 {
        gen     no_npo_`y'_s`s' = 0
        replace no_npo_`y'_s`s' = 1 if year == `y' & semester == `s' & no_npo_dummy == 1
    }
}

*npo-quarter dummies
forvalues y = 2010/2016 {
	forvalues q = 1/4 {
        gen     no_npo_`y'_q`q' = 0
        replace no_npo_`y'_q`q' = 1 if year == `y' & quarter == `q' & no_npo_dummy == 1
    }
}

*npo-monthly dummies
forvalues y = 2010/2016 {
	forvalues m = 1/12 {
        gen     no_npo_`y'_m`m' = 0
        replace no_npo_`y'_m`m' = 1 if year == `y' & month == `m' & no_npo_dummy == 1
    }
}

gen       no_npo_after = 0
replace   no_npo_after = 1 if after == 1 & no_npo_dummy == 1
label var no_npo_after "=1 if year 2013 and for profit"

*/
*before-after tax reform dummy
gen       after = 0
replace   after = 1 if year >= 2013
label var after "=1 if year 2013 or after"

*treated vs untreated
*--------------------
gen       tr_treated = .

*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated = 1 if labor_state == 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated = 1 if labor_state == 9 & nr_mw_month <=  10

*CONTROLS
*self-employed workers earning less than 10 MWs
replace   tr_treated = 0 if labor_state == 4 & nr_mw_month <=  10
replace tr_treated = . if sector_jobs == 8

*--------------------
*REPLICATION EXERCISE
*--------------------
*Kugler et al (2017)
*-------------------
*period of analysis
gen time_kug = 1 if year >= 2010 & year <= 2013

*treatment groups
gen     tr_treated_kug_10mw = .
replace tr_treated_kug_10mw = 1 if nr_mw_month <=  10
replace tr_treated_kug_10mw = 0 if nr_mw_month >   10 & nr_mw_month != .

gen     tr_treated_kug_self3 = .
replace tr_treated_kug_self3 = 1 if labor_state == 4 & firm_size >= 3 & firm_size != .
replace tr_treated_kug_self3 = 0 if labor_state != 4 & labor_state != .
replace tr_treated_kug_self3 = 0 if firm_size < 3
          
*Fernandez and Villar (2016)
*---------------------------
*informal definition
*use informal_ss

gen time_fv = 1 if year == 2012 | year == 2014

*gender+marital status
gen          female_marital = .
replace      female_marital = 0 if male == 1
replace      female_marital = 1 if male == 0 & rel_head == 2
replace      female_marital = 2 if male == 0 & rel_head != 2
label define female_marital 0  "Male"   ///
                            1  "Female spouse"  /// 
                            2  "Female other"  ///

label values female_marital female_marital
label var    female_marital "female+marital status"

*age
gen          age_gr3 = .
replace      age_gr3 = 1  if age < 25
replace      age_gr3 = 2  if age >=25 & age <= 49
replace      age_gr3 = 3  if age >=50 & age != .
label define age_gr3 1  "(-25)"   ///
                     2  "[25-39]"  /// 
                     3  "[50+]"  ///
					
label values age_gr3 age_gr3
label var    age_gr3 "4 age groups"

*education
*use edu_level 

*city
*use city_group

*urban/rural
*use urban

*months
gen     january = 0
replace january = 1 if month == 1
gen     february = 0
replace february = 1 if month == 2
gen     december = 0
replace december = 1 if month == 12
     
*treated vs untreated
*--------------------
gen       tr_treated_fv = 0 if employed == 1
*TREATED
replace   tr_treated_fv = 1 if nr_mw_month >= 1 & nr_mw_month <= 10 
                 
*CONTROL
replace   tr_treated_fv = 0 if labor_state == 4
replace   tr_treated_fv = 0 if firm_size   == 1

*excluded
replace tr_treated_fv = . if sector_jobs == 8
replace tr_treated_fv = . if nr_mw_month == .
                                    
*weights to string
foreach v in wgt wgt_year wgt_sem wgt_quarter {
	replace `v' = int(`v')
}

*treated vs untreated - # MWs as running var
*-------------------------------------------
*HOURLY MWS
*----------
gen       tr_treated_mw = . if employed == 1 & nr_mw_month <=  10
*Treated and Control groups have to earn less than 10 monthly MWs
*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated_mw = 1 if labor_state == 1 & nr_mw_hr >= 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated_mw = 1 if labor_state == 9 & nr_mw_hr >= 1 & nr_mw_month <=  10

*CONTROL
*private employees firm earning less than 10 MW
replace   tr_treated_mw = 0 if labor_state == 1 & nr_mw_hr < 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw = 0 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_hr < 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw = 0 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_hr < 1 & nr_mw_month <=  10
*all other workers firms earning less than 10 MWs
replace   tr_treated_mw = 0 if labor_state == 9 & nr_mw_hr < 1 & nr_mw_month <=  10

*discard government workers
replace tr_treated_mw = . if sector_jobs == 8

*MONTHLY MWS
*----------
gen       tr_treated_mw_month = . if employed == 1 & nr_mw_month <=  10
*Treated and Control groups have to earn less than 10 monthly MWs
*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated_mw_month = 1 if labor_state == 1 & nr_mw_month >= 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw_month = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_month >= 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw_month = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_month >= 1 & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated_mw_month = 1 if labor_state == 9 & nr_mw_month >= 1 & nr_mw_month <=  10

*CONTROL
*private employees firm earning less than 10 MW
replace   tr_treated_mw_month = 0 if labor_state == 1 & nr_mw_month < 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_mw_month = 0 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_month < 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_mw_month = 0 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_month < 1 & nr_mw_month <=  10
*all other workers firms earning less than 10 MWs
replace   tr_treated_mw_month = 0 if labor_state == 9 & nr_mw_month < 1 & nr_mw_month <=  10

*discard government workers
replace tr_treated_mw_month = . if sector_jobs == 8

*SELF-EMPLOYED
*-------------
gen       tr_treated_self = . 
*Treated and Control groups have to earn less than 10 monthly MWs
*TREATED
*private employees earning 1 or more hourly MW
replace   tr_treated_self = 1 if labor_state == 1 & nr_mw_hr >= 1 & nr_mw_month <=  10
*domestic employees with more than one employee earning less than 10 MW
replace   tr_treated_self = 1 if labor_state == 3 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*Laborer or farmhand with more than one employee earning less than 10 MW 
replace   tr_treated_self = 1 if labor_state == 8 & firm_size > 1 & firm_size != . & nr_mw_hr >= 1 & nr_mw_month <=  10
*all other workers in for-profit firms earning less than 10 MWs
replace   tr_treated_self = 1 if labor_state == 9 & nr_mw_hr >= 1 & nr_mw_month <=  10

*CONTROL
*self-employed earning less than 10 MW
replace   tr_treated_self = 0 if labor_state == 4

*discard government workers
replace tr_treated_self = . if sector_jobs == 8

*weights to string
foreach v in wgt wgt_year wgt_sem wgt_quarter {
	replace `v' = int(`v')
}

*different results variables
*---------------------------
gen     log_w_m_real = log(w_month_real)
gen     con_written = .
replace con_written = 0 if con_type == 1 | con_type == 3 | con_type == 4  
replace con_written = 1 if con_type == 2
gen     con_indef = .
replace con_indef = 0 if con_term == 2 | con_term == 3  
replace con_indef = 1 if con_term == 1
gen     health_0_1 = .
replace health_0_1 = 0 if health_type_all == 1 | health_type_all == 2  
replace health_0_1 = 1 if health_type_all == 3 | health_type_all == 4

*INFORMALITY - social security & MWs - residuals for seasonal adjust
*-------------------------------------------------------------------
*single regression
reg informal_tr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict inf_tr_resid1 if e(sample), resid
reg no_pension i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict no_pension_resid1 if e(sample), resid
reg no_health i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict no_health_resid1 if e(sample), resid
reg job_hrs_reg i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict hrs_resid1 if e(sample), resid

*separate regressions
*--------------------
*informality - tax reform
reg informal_tr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg informal_tr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     inf_tr_resid2 = .
replace inf_tr_resid2 = informal_tr_resid_0 if tr_treated == 0
replace inf_tr_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*informality - social security
reg informal_ss i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg informal_ss i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     inf_ss_resid2 = .
replace inf_ss_resid2 = informal_tr_resid_0 if tr_treated == 0
replace inf_ss_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*pensions
reg no_pension i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg no_pension i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     no_pension_resid2 = .
replace no_pension_resid2 = informal_tr_resid_0 if tr_treated == 0
replace no_pension_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*health
reg no_health i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg no_health i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     no_health_resid2 = .
replace no_health_resid2 = informal_tr_resid_0 if tr_treated == 0
replace no_health_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*hours of work
reg job_hrs_reg i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg job_hrs_reg i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     hrs_resid2 = .
replace hrs_resid2 = informal_tr_resid_0 if tr_treated == 0
replace hrs_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*hourly real wages
reg w_hr_real i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg w_hr_real i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     w_resid2 = .
replace w_resid2 = informal_tr_resid_0 if tr_treated == 0
replace w_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
*under 1 hourly MW
reg under_1mw_hr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 0 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_0 if e(sample), resid
reg under_1mw_hr i.month ///
      if employed == 1 & workage == 1 & nr_mw_hr > 0 & tr_treated == 1 [pw=wgt], ///
      robust cluster(isic_rev3)
predict informal_tr_resid_1 if e(sample), resid
gen     under_w_resid2 = .
replace under_w_resid2 = informal_tr_resid_0 if tr_treated == 0
replace under_w_resid2 = informal_tr_resid_1 if tr_treated == 1
drop informal_tr_resid_0 informal_tr_resid_1
 
*number of minimum wages
foreach v in hr month {
    gen          nr_mw_`v'_bins = .
    replace      nr_mw_`v'_bins = 1 if nr_mw_`v' >  0   & nr_mw_`v' < 0.2
    replace      nr_mw_`v'_bins = 2 if nr_mw_`v' >= 0.2 & nr_mw_`v' < 0.4
    replace      nr_mw_`v'_bins = 3 if nr_mw_`v' >= 0.4 & nr_mw_`v' < 0.6
    replace      nr_mw_`v'_bins = 4 if nr_mw_`v' >= 0.6 & nr_mw_`v' < 0.8
    replace      nr_mw_`v'_bins = 5 if nr_mw_`v' >= 0.8 & nr_mw_`v' < 1
    replace      nr_mw_`v'_bins = 6 if nr_mw_`v' >= 1   & nr_mw_`v' < 2
    replace      nr_mw_`v'_bins = 7 if nr_mw_`v' >= 2   & nr_mw_`v' < 3
    replace      nr_mw_`v'_bins = 8 if nr_mw_`v' >= 3   & nr_mw_`v' < 5
    replace      nr_mw_`v'_bins = 9 if nr_mw_`v' >= 5   & nr_mw_`v' != .
    label define nr_mw_`v'_bins 1  "(0-0.2)"   ///
                               2  "[0.2-0.4)"  ///
                               3  "[0.4-0.6)"  ///
                               4  "[0.6-0.8)"  ///
                               5  "[0.8-1)"  ///
                               6  "[1-2)"  ///
                               7  "[2-3)"  ///
                               8  "[3-5)"  ///
                               9  "5 or more"  ///
    					
    label values nr_mw_`v'_bins nr_mw_`v'_bins
    label var    nr_mw_`v'_bins "# `v' MW"
}

*number of minimum wages for # hourly MWs as running var
foreach v in hr month {
    gen          nr_mw_`v'_10bin = .
    replace      nr_mw_`v'_10bin = 1  if nr_mw_`v' >  0    & nr_mw_`v' < 0.2
    replace      nr_mw_`v'_10bin = 2  if nr_mw_`v' >= 0.2  & nr_mw_`v' < 0.4
    replace      nr_mw_`v'_10bin = 3  if nr_mw_`v' >= 0.4  & nr_mw_`v' < 0.6
    replace      nr_mw_`v'_10bin = 4  if nr_mw_`v' >= 0.6  & nr_mw_`v' < 0.8
    replace      nr_mw_`v'_10bin = 5  if nr_mw_`v' >= 0.8  & nr_mw_`v' < 1
    replace      nr_mw_`v'_10bin = 6  if nr_mw_`v' == 1
    replace      nr_mw_`v'_10bin = 7  if nr_mw_`v' >  1    & nr_mw_`v' < 1.2
    replace      nr_mw_`v'_10bin = 8  if nr_mw_`v' >= 1.2  & nr_mw_`v' < 1.4
    replace      nr_mw_`v'_10bin = 9  if nr_mw_`v' >= 1.4  & nr_mw_`v' < 1.6
    replace      nr_mw_`v'_10bin = 10 if nr_mw_`v' >= 1.6  & nr_mw_`v' < 1.8
    replace      nr_mw_`v'_10bin = 11 if nr_mw_`v' >= 1.8  & nr_mw_`v' < 2
    label define nr_mw_`v'_10bin 1  "(0.0-0.2)"   ///
                                 2  "[0.2-0.4)"  ///
                                 3  "[0.4-0.6)"  ///
                                 4  "[0.6-0.8)"  ///
                                 5  "[0.8-1.0)"  ///
                                 6  "[1]"  ///
                                 7  "(1.0-1.2)"  ///
                                 8  "[1.2-1.4)"  ///
                                 9  "[1.4-1.6)"  ///
                                 10 "[1.6-1.8)"  ///
                                 11 "[1.8-2.0)"  ///
    					
    label values nr_mw_`v'_10bin nr_mw_`v'_10bin
    label var    nr_mw_hr_10bin "# `v' MW"
}

*number of minimum wages for # hourly MWs as running var - SMOOTH
foreach v in hr month {
    gen     nr_mw_`v'_20bin = .
    forvalues b = 0(10)190 {
    	local i =  `b'     / 100
    	local j = (`b'+10) / 100           
    	replace      nr_mw_`v'_20bin = `b'  if nr_mw_`v' >= `i' & nr_mw_`v' < `j'
    	label define nr_mw_`v'_20bin   `b'  "[`i'-`j')", add
    }
    replace      nr_mw_`v'_20bin = .  if nr_mw_`v' == 0 
    label define nr_mw_`v'_20bin   0  "(0-0.10)", modify
    label values nr_mw_`v'_20bin nr_mw_`v'_20bin
}

*number of minimum wages for # hourly MWs as running var - SMOOTH
foreach v in hr month {
    gen     nr_mw_`v'_sbin = .
    forvalues b = 0(5)195 {
    	local i =  `b'    / 100
    	local j = (`b'+5) / 100
    	replace      nr_mw_`v'_sbin = `b'  if nr_mw_`v' >= `i' & nr_mw_`v' < `j'
    	label define nr_mw_`v'_sbin   `b'  "[`i'-`j')", add
    }
    replace      nr_mw_`v'_sbin = .  if nr_mw_`v' == 0 
    label define nr_mw_`v'_sbin   0  "(0-0.05)", modify
    label values nr_mw_`v'_sbin nr_mw_`v'_sbin
}

*around 1 MW
foreach v in hr month {
    gen          around_mw_`v' = .
    replace      around_mw_`v' = 1  if nr_mw_`v' >  0    & nr_mw_`v' < 1
    replace      around_mw_`v' = 2  if nr_mw_`v' >= 1    & nr_mw_`v' < 2
    label define around_mw_`v' 1 "(0-1)" ///
                               2 "[1-2)" ///
    					
    label values around_mw_`v' around_mw_`v'
    label var    around_mw_`v' "around `v' MW"
}

*merge macrodata
merge m:1 year month using "$process\macro_vars", nogen

*quick calculations var
gen quick = uniform()

*self-employed vs employee
gen          self_emp = .
replace      self_emp = 1 if labor_state == 1 | labor_state == 2 | labor_state == 3 
replace      self_emp = 2 if labor_state == 4
replace      self_emp = 3 if labor_state >  4 & labor_state != .
label define self_emp 1 "Employee" ///
                      2 "Self-employed" ///
                      3 "Other" ///

label values self_emp self_emp

*above1mw
gen          above1mw = .
replace      above1mw = 0 if nr_mw_month <  .99  
replace      above1mw = 1 if nr_mw_month >= .99 & nr_mw_month != .
label var above1mw "=1 if wage at or above 1 monthly MW"

*save dataset
compress
save "$process\\geih\\workdata.dta", replace

