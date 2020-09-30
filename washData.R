#### ---- Project: APHRC HH Data ----
#### ---- Task: Create new WaSH data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(data.table)
library(dplyr)

## Use complete dataset
load("cleanData.rda")
load("dwelling_pca.rda")
load("ownership_gpca.rda")
load("problems_index.rda")	# Renamed to shocks moving forward
load("expenditure_index.rda")

## Key variables
response_vars <- c("drinkwatersource_new", "toilet_5plusyrs_new", "garbagedisposal_new")
demographic_vars <- c("hhid_anon_new", "intvwyear_new"
	, "slumarea_new", "gender_new", "ageyears_new", "numpeople_total_new"
)
other_vars <- c("inc30days_total_new", "foodeaten30days_new", "selfrating_new")
indices_vars <- c("materials", "lighting", "ownhere", "ownelse", "shocks", "expenditure")
temp_vars <- c(demographic_vars, response_vars, other_vars)

## Select variables for analysis
wash_df <- (working_df_complete
	%>% select(!!temp_vars)
	%>% mutate(materials = drop(dwelling_index[, 1])
		, lighting = drop(dwelling_index[, 2])
		, ownhere = drop(ownership_index[,1])
		, ownelse = drop(ownership_index[,2])
		, shocks = problems_index
		, expenditure = total_expenditure
	)
	%>% setnames(., old = temp_vars, new = gsub("\\_new", "", temp_vars))
	%>% ungroup()
	%>% data.frame()
)

head(wash_df)


save(file = "washData.rda"
	, wash_df
)
