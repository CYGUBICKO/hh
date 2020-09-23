#### ---- Project: APHRC HH Data ----
#### ---- Task: Drop cases with outliers ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Sep 15 (Tue) ----

library(dplyr)

## Use complete dataset
load("analysisData.rda")

# Cases to drop

## HH size > 40
hhsize_drop <- 30
## Total HH expenditure >= 100K
total_expend_drop_lower <- 100
total_expend_drop_upper <- 30000
## HH Shocks
shocks_drop <- 10

nrow(working_df_complete)

working_df_complete <- (working_df_complete
	%>% mutate_at(problems_group_vars, function(x){as.numeric(as.character(x))})
	%>% mutate(total_expenditure = rowSums(select(., !!expenditure_group_vars), na.rm = TRUE)
		, shocks = rowSums(select(., !!problems_group_vars), na.rm = TRUE)
	)
	%>% filter(numpeople_total_new <= hhsize_drop 
		& total_expenditure >= total_expend_drop_lower
		& total_expenditure < total_expend_drop_upper
		& shocks < shocks_drop
	)
)
nrow(working_df_complete)
head(sort(working_df_complete$total_expenditure, decreasing = FALSE), 100)

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
	, total_expend_drop_lower
	, total_expend_drop_upper
)
