#### ---- Project: APHRC HH Data ----
#### ---- Task: Drop cases with outliers ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Sep 15 (Tue) ----

library(dplyr)

## Use complete dataset
load("analysisData.rda")

# Cases to drop

## HH size > 40
hhsize_drop <- 40
## Total HH expenditure >= 100K
total_expend_drop <- 100000
## HH Shocks
shocks_drop <- 50

nrow(working_df_complete)

working_df_complete <- (working_df_complete
	%>% mutate_at(problems_group_vars, function(x){as.numeric(as.character(x))})
	%>% mutate(total_expenditure = rowSums(select(., !!expenditure_group_vars), na.rm = TRUE)
		, shocks = rowSums(select(., !!problems_group_vars), na.rm = TRUE)
	)
	%>% filter(numpeople_total_new <= hhsize_drop 
		& total_expenditure < total_expend_drop 
		& shocks < shocks_drop
	)
)
nrow(working_df_complete)

save(file = "cleanData.rda"
	, var_groups_df
	, working_df
	, working_df_complete
	, dwelling_group_vars
	, ownership_group_vars
	, expenditure_group_vars
	, problems_group_vars
	, miss_percase_df
	, miss_peryear_df
	, impute_na
	, tab_intperyear
	, miss_category_summary_df
)
