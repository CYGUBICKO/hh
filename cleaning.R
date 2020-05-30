#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(dplyr)
library(scales)
library(expss)
library(DT)
library(tibble)
library(tidyr)

#load("loadData.rda")
load("globalFunctions.rda")
load("shortData.rda")
load("generateLabels.rda")

#### ---- Filter completed interviews ----

## Interview termination vars

working_df <- (working_df
	%>% filter(intvwresult=="completed")
)

#### ---- Key variables ----

## ID vars
all_varnames <- names(working_df)
id_vars <- grep("_anon$", all_varnames, value = TRUE) # hhid_anon, individualid_anon
print(id_vars)

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

#### Material of the floor
working_df <- left_join(working_df
	, floor_labs
	, by = "floormaterial"
)

#### Material of the roof
working_df <- left_join(working_df
	, roof_labs
	, by = "roofmaterial"
)

#### Material of the wall
working_df <- left_join(working_df
	, wall_labs
	, by = "wallmaterial"
)

#### Main source of cooking fuel
working_df <- left_join(working_df
	, cook_labs
	, by = "cookingfuel"
)

#### Main source of lighting
working_df <- left_join(working_df
	, light_labs
	, by = "lighting"
)

#### Main Dwelling/rentals
working_df <- left_join(working_df
	, rent_labs
	, by = "rentorown"
)

#### Household possessions
hhposes_vars <- grep("^own", colnames(working_df), value = TRUE)
working_df <- (working_df
	%>% mutate_at(hhposes_vars, .funs = list(new = function(x){
			ifelse(grepl("^don|^NIU|^missing", x), NA, as.character(x))
		})
	)
)

#### Household income
working_df <- left_join(working_df
	, inc30days_labs
	, by = "inc30days_total"
)

#### Household expenditure in KES
hhexpense_vars <- grep("^expend\\_", colnames(working_df), value = TRUE)
working_df <- (working_df
	%>% mutate_at(hhexpense_vars, .funs = list(new = function(x){
			ifelse(grepl("^don|^NIU|^missing", x), NA, factorsNum(x))
		})
	)
)

#### Grow crops
working_df <- left_join(working_df
	, grewcrops_labs
	, by = "grewcrops"
)

warnings()
#### Tabs
with(working_df, {
	table(lighting, useNA = "always")
})

with(working_df, {
	table(lighting_new, useNA = "always")
})
save(file = "cleaning.rda"
	, working_df
)
