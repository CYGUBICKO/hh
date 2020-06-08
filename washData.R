#### ---- Project: APHRC HH Data ----
#### ---- Task: Create new WaSH data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(data.table)
library(dplyr)

## Use complete dataset
load("analysisData.rda")
load("dwelling_pca.rda")
load("ownership_pca.rda")
load("problems_pca.rda")	# Renamed to shocks moving forward
load("expenditure_pca.rda")

## Key variables
response_vars <- c("drinkwatersource_new", "toilet_5plusyrs_new", "garbagedisposal_new")
demographic_vars <- c("hhid_anon_new", "intvwyear_new"
	, "slumarea_new", "gender_new", "ageyears_new", "numpeople_total_new"
)
other_vars <- c("inc30days_total_new", "foodeaten30days_new", "selfrating_new")
indices_vars <- c("dwelling_index", "ownership_index", "shocks_index", "expenditure_index")
temp_vars <- c(demographic_vars, response_vars, other_vars)

## Select variables for analysis
wash_df <- (working_df_complete
	%>% select(!!temp_vars)
	%>% mutate(dwelling_index = dwelling_index
		, ownership_index = ownership_index
		, shocks_index = problems_index
		, expenditure_index = expenditure_index
	)
	%>% setnames(., old = temp_vars, new = gsub("\\_new", "", temp_vars))
	%>% ungroup()
	%>% data.frame()
)

head(wash_df)


save(file = "washData.rda"
	, wash_df
)
