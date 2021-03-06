#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(dplyr)
library(scales)
library(DT)
library(tibble)
library(tidyr)

load("globalFunctions.rda")
load("missingCategory_summary.rda")
load("generateLabels.rda")

#### ---- Key variables ----

## ID vars
all_varnames <- names(working_df)
id_vars <- grep("_anon$", all_varnames, value = TRUE) # hhid_anon, individualid_anon
print(id_vars)

## Demographic variables
working_df <- (working_df
	%>% mutate(hhid_anon_new = hhid_anon
		, intvwyear_new = intvwyear
		, slumarea_new = slumarea
		, ageyears_new = ifelse(grepl("^don|^NIU|^missing|^refuse", ageyears), NA, as.numeric(as.character(ageyears))) 
		, gender_new = ifelse(grepl("^don|^NIU|^missing|^refuse", gender), NA, as.character(gender)) 
		, numpeople_total_new = ifelse(grepl("^don|^NIU|^missing|^refuse", numpeople_total), NA, as.numeric(as.character(numpeople_total))) 
	)
)

## Wash vars
### Merge the labs df with the main df

#### Water source
working_df <- left_join(working_df
	, water_labs
	, by = "drinkwatersource"
)

#### Toilet type
working_df <- left_join(working_df
	, toilet_labs
	, by = "toilet_5plusyrs"
)

#### Garbage disposal
working_df <- left_join(working_df
	, garbage_labs
	, by = "garbagedisposal"
)

#### Drop cases with missing WaSH vars
working_df <- (working_df
	%>% filter(!is.na(drinkwatersource_new) & !is.na(toilet_5plusyrs_new) & !is.na(garbagedisposal_new))
)

##### WASH tabs
tab_vars <- paste0(c("drinkwatersource", "toilet_5plusyrs", "garbagedisposal"), "_new")
wash_tabs <- t(sapply(working_df[, tab_vars], function(x){table(x, useNA = "always")}))
wash_tabs <- data.frame(wash_tabs)

#### Material of the floor
working_df <- (left_join(working_df
		, floor_labs
		, by = "floormaterial"
	)
	%>% mutate(floormaterial_new = as.factor(floormaterial_new))
)

##### Floor tabs
tab_vars <- "floormaterial_new"
floor_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
floor_tabs <- data.frame(floor_tabs)

#### Material of the roof
working_df <- (left_join(working_df
		, roof_labs
		, by = "roofmaterial"
	)
	%>% mutate_at("roofmaterial_new", as.factor)
)

##### Roof tabs
tab_vars <- "roofmaterial_new"
roof_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
roof_tabs <- data.frame(roof_tabs)

#### Material of the wall
working_df <- (left_join(working_df
		, wall_labs
		, by = "wallmaterial"
	)
	%>% mutate_at("wallmaterial_new", as.factor)
)
##### Wall tabs
tab_vars <- "wallmaterial_new"
wall_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
wall_tabs <- data.frame(wall_tabs)


#### Main source of cooking fuel
working_df <- (left_join(working_df
		, cook_labs
		, by = "cookingfuel"
	)
	%>% mutate_at("cookingfuel_new", as.factor)
)

##### Cooking tabs
tab_vars <- "cookingfuel_new"
cooking_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
cooking_tabs <- data.frame(cooking_tabs)

#### Main source of lighting
working_df <- (left_join(working_df
		, light_labs
		, by = "lighting"
	)
	%>% mutate_at("lighting_new", as.factor)
)

##### Lighting tabs
tab_vars <- "lighting_new"
lighting_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
lighting_tabs <- data.frame(lighting_tabs)

#### Main Dwelling/rentals
working_df <- (left_join(working_df
		, rent_labs
		, by = "rentorown"
	)
	%>% mutate_at("rentorown_new", as.factor)
)

##### Dwelling tabs
tab_vars <- "rentorown_new"
rentorown_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
rentorown_tabs <- data.frame(rentorown_tabs)

#### Household possessions
hhposes_vars <- grep("^own", colnames(working_df), value = TRUE)
working_df <- (working_df
	%>% mutate_at(hhposes_vars, .funs = list(new = function(x){
			ifelse(grepl("^don|^refuse", x), NA, as.character(x))
		})
	)
)

## Recode NIU in livestock ownership follow-up questions to "no"
hhposes_vars_livestock <- grep("\\_new$", grep("^own\\_", colnames(working_df), value = TRUE), value = TRUE)
working_df <- (working_df
	%>% mutate(own_cattle_new = ifelse(ownlivestock_new == "no" & grepl("^NIU", own_cattle_new), "no", own_cattle_new)
		, own_goatsheep_new = ifelse(ownlivestock_new == "no" & grepl("^NIU", own_goatsheep_new), "no", own_goatsheep_new)
		, own_pig_new = ifelse(ownlivestock_new == "no" & grepl("^NIU", own_pig_new), "no", own_pig_new)
		, own_chicken_new = ifelse(ownlivestock_new == "no" & grepl("^NIU", own_chicken_new), "no", own_chicken_new)
		, own_donkey_new = ifelse(ownlivestock_new == "no" & grepl("^NIU", own_donkey_new), "no", own_donkey_new)
		, own_other_new = ifelse(ownlivestock_new == "no" & grepl("^NIU", own_other_new), "no", own_other_new)
	)
)

#### Household posession tabs
tab_vars <- paste0(hhposes_vars, "_new")
hhposes_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){as.data.frame(table(x, useNA = "always"))}
	, simplify = FALSE
)

#### Household income
working_df <- (left_join(working_df
		, inc30days_labs
		, by = "inc30days_total"
	)
	%>% mutate_at("inc30days_total_new", function(x){
		ifelse(grepl("^miss", x), 9999995, as.numeric(x))
	})
)

#working_df <- (left_join(working_df
#		, inc30days_labs
#		, by = "inc30days_total"
#	)
#	%>% mutate_at("inc30days_total_new", function(x){
#		factor(x
#			, levels = c("<KES 1,000", "KES 1,000-2,499", "KES 2,500-4,999", "KES 5,000-7,499", "KES 7,500-9,999", "KES 10,000-14,999", "KES 15,000-19,999", "KES 20,000+", "missing:impute")
#			, labels = c("<1,000", "1,000-2,499", "2,500-4,999", "5,000-7,499", "7,500-9,999", "10,000-14,999", "15,000-19,999", "20,000+", "missing:impute")
##			, ordered = TRUE
#		)
#	})
#)


#### Household income tabs
tab_vars <- paste0("inc30days_total", "_new")
inc30days_total_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
inc30days_total_tabs <- data.frame(inc30days_total_tabs)

#### Household expenditure in KES
hhexpense_vars <- grep("^expend\\_", colnames(working_df), value = TRUE)
working_df <- (working_df
	%>% mutate_at(hhexpense_vars, .funs = list(new = function(x){
			ifelse(grepl("^other", x), NA
				, ifelse(grepl("^NIU|^don|^refuse", x), 0
					,	ifelse(grepl("^miss",x) , 9999995, as.numeric(as.character(x))))
			)
		})
	)
)

#### Household expenditure tabs
tab_vars <- paste0(hhexpense_vars, "_new")
hhexpense_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){as.data.frame(table(x, useNA = "always"))}
	, simplify = FALSE
)

#### Grow crops
working_df <- left_join(working_df
	, grewcrops_labs
	, by = "grewcrops"
)

#### Grew crops tabs
tab_vars <- paste0("grewcrops", "_new")
grewcrops_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
grewcrops_tabs <- data.frame(grewcrops_tabs)

#### No. of meals served in 2 days
b4special_vars <- "b4specevent2days_meals"
working_df <- (working_df
	%>% mutate(b4specevent2days_meals_new = ifelse(grepl("^don|^NIU|^refuse", b4specevent2days_meals), NA
			, ifelse(grepl("^miss", b4specevent2days_meals), 9999995, as.numeric(as.character(b4specevent2days_meals)))
		)
	)
)

#### Meals served tabs
tab_vars <- paste0("b4specevent2days_meals", "_new")
b4specevent2days_meals_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
b4specevent2days_meals_tabs <- data.frame(b4specevent2days_meals_tabs)

#### 5.11: Food in the last 30 days
working_df <- left_join(working_df
	, foodeaten30days_labs
	, by = "foodeaten30days"
)

#### 5.11: Food tabs
tab_vars <- paste0("foodeaten30days", "_new")
foodeaten30days_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
foodeaten30days_tabs <- data.frame(foodeaten30days_tabs)

#### 5.12: HH gone hungry because no money to buy food
working_df <- left_join(working_df
	, hh30days_nofoodmoney_labs
	, by = "30days_nofoodmoney"
)

#### 5.12: Hunger tabs
tab_vars <- paste0("30days_nofoodmoney", "_new")
hh30days_nofoodmoney_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})
hh30days_nofoodmoney_tabs <- data.frame(hh30days_nofoodmoney_tabs)

#### 6.0: Household shocks experienced
prob_vars <- grep("^prob\\_", colnames(working_df), value = TRUE)
working_df <- (working_df
	%>% mutate_at(prob_vars, .funs = list(new = function(x){
			ifelse(grepl("^don|^NIU|^refuse", x), NA, as.character(x))
		})
	)
)

#### 6.0: HH shocks tabs
tab_vars <- paste0(prob_vars, "_new")
prob_tabs <- t(sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")}))
prob_tabs <- data.frame(prob_tabs)

#### Household number of problems
numprob_vars <- grep("^numprob\\_", colnames(working_df), value = TRUE)
working_df <- (working_df
	%>% mutate_at(numprob_vars, .funs = list(new = function(x){
			ifelse(grepl("^don|^refuse", x), NA
				, ifelse(grepl("^miss", x), 9999995, as.character(x))
			)
		})
	)
)

### Recode NIU in numprobs if problem == "no"
working_df <- (working_df
	%>% mutate(numprob_fire_new = ifelse(grepl("^NIU", numprob_fire_new) & prob_fire_new=="no", 0, as.numeric(as.character(numprob_fire_new)))
		, numprob_flood_new = ifelse(grepl("^NIU", numprob_flood_new) & prob_flood_new=="no", 0, as.numeric(as.character(numprob_flood_new)))
		, numprob_mugging_new = ifelse(grepl("^NIU", numprob_mugging_new) & prob_mugging_new=="no", 0, as.numeric(as.character(numprob_mugging_new)))
		, numprob_theft_new = ifelse(grepl("^NIU", numprob_theft_new) & prob_theft_new=="no", 0, as.numeric(as.character(numprob_theft_new)))
		, numprob_eviction_new = ifelse(grepl("^NIU", numprob_eviction_new) & prob_eviction_new=="no", 0, as.numeric(as.character(numprob_eviction_new)))
		, numprob_demolition_new = ifelse(grepl("^NIU", numprob_demolition_new) & prob_demolition_new=="no", 0, as.numeric(as.character(numprob_demolition_new)))
		, numprob_illness_new = ifelse(grepl("^NIU", numprob_illness_new) & prob_illness_new=="no", 0, as.numeric(as.character(numprob_illness_new)))
		, numprob_death_new = ifelse(grepl("^NIU", numprob_death_new) & prob_death_new=="no", 0, as.numeric(as.character(numprob_death_new)))
		, numprob_rape_new = ifelse(grepl("^NIU", numprob_rape_new) & prob_rape_new=="no", 0, as.numeric(as.character(numprob_rape_new)))
		, numprob_stabbing_new = ifelse(grepl("^NIU", numprob_stabbing_new) & prob_stabbing_new=="no", 0, as.numeric(as.character(numprob_stabbing_new)))
		, numprob_layoff_new = ifelse(grepl("^NIU", numprob_layoff_new) & prob_layoff_new=="no", 0, as.numeric(as.character(numprob_layoff_new)))

	
	)
)

#### HH number of problems tabs
tab_vars <- paste0(numprob_vars, "_new")
numprob_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){as.data.frame(table(x, useNA = "always"))}
	, simplify = FALSE
)

numprob_tabs

### Respondent ladder
working_df <- (left_join(working_df
		, selfrating_labs
		, by = "selfrating"
	)
	%>% mutate(selfrating_new = as.numeric(selfrating_new))
)

#### HH self-rating tabs
tab_vars <- paste0("selfrating", "_new")
selfrating_tabs <- sapply(working_df[, tab_vars, drop = FALSE], function(x){table(x, useNA = "always")})


### Missing proportion for the cleaned variables
clean_vars <- grep("\\_new$", colnames(working_df), value = TRUE)
miss_df_temp <- missPropFunc(working_df[, clean_vars])
miss_df <- (miss_df_temp
	%>% arrange(desc(miss_count))
	%>% droplevels()
)

### Summary tables
all_tabs <- list(miss_df = miss_df
	, wash_tabs = wash_tabs
	, floor_tabs = floor_tabs 
	, roof_tabs = roof_tabs
	, wall_tabs = wall_tabs
	, cooking_tabs = cooking_tabs
	, lighting_tabs = lighting_tabs
	, rentorown_tabs = rentorown_tabs
#	, hhposes_tabs = hhposes_tabs 
	, inc30days_total_tabs = inc30days_total_tabs
#	, hhexpense_tabs = hhexpense_tabs
	, grewcrops_tabs = grewcrops_tabs
	, b4specevent2days_meals_tabs = b4specevent2days_meals_tabs
	, foodeaten30days_tabs = foodeaten30days_tabs
	, hh30days_nofoodmoney_tabs = hh30days_nofoodmoney_tabs
#	, prob_tabs = prob_tabs
#	, numprob_tabs = numprob_tabs
	, selfrating_tabs = selfrating_tabs
)

all_tabs <- c(all_tabs, hhposes_tabs, hhexpense_tabs, prob_tabs, numprob_tabs)

save(file = "cleaning.rda"
	, working_df
	, miss_category_summary # Missing summary per missing category
	, all_tabs
	, miss_df_temp
	, tab_intperyear
)
