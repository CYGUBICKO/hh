#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(purrr)
library(dplyr)
library(tibble)
library(tidyr)

load("overall_missing_tables.rda")
load("globalFunctions.rda")
load("cleaning.rda")

#### Variables to be used for analysis
new_vars <- grep("\\_new$", colnames(working_df), value  = TRUE)
temp_df <- (working_df
	%>% select(!!new_vars)
)

#### ---- Missing per missing value indicator ----
miss_pattern <- list(miss_impute = "^missing\\:impute|9999995"
	, NIU = "^NIU|999999$"
)
miss_after_category_summary <- lapply(seq_along(miss_pattern), function(x){
	tab <- missPattern(temp_df, miss_pattern[[x]])
	tab <- (tab
		%>% select(-miss_count)
		%>% arrange(desc(miss_prop))
	)
	colnames(tab) <- c("variable", names(miss_pattern)[[x]])
	return(tab)
})

## NAs: Don't know and refused
na_tab <- (temp_df
	%>% NAProps(.)
	%>% select(-miss_count)
	%>% arrange(desc(miss_prop))
	%>% rename(dontknow_refused = miss_prop)
)
miss_after_category_summary[["dontknow_refused"]] <- na_tab

miss_after_category_summary <- (miss_after_category_summary 
	%>% reduce(full_join, by = "variable")
	%>% mutate(NIU_dontknow_refused = NIU + dontknow_refused
		, Total = miss_impute + NIU_dontknow_refused
	)
	%>% select(-NIU, -dontknow_refused)
	%>% arrange(desc(Total))
	%>% data.frame()
)

miss_after_category_summary <- (miss_category_summary
	%>% data.frame()
	%>% select(variable, description)
	%>% right_join(., (miss_after_category_summary %>% mutate(variable = gsub("\\_new", "", variable)))
		, by = "variable"
	)
	%>% data.frame()
)
miss_after_category_summary

save(file = "missing_after_cleaning.rda"
	, miss_after_category_summary
)
