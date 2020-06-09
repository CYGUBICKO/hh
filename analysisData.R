#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(tibble)
library(tidyr)

load("cleaning.rda")
load("globalFunctions.rda")


#### Proportion of missingness to drop variables
drop_miss <- 30	# Drop all variables with more than 30% missing
drop_vars <- c(miss_df_temp$variable[miss_df_temp$miss_prop>=drop_miss], "expend_total_USD_per_new")

#### Variables to be used for analysis
new_vars <- grep("\\_new$", colnames(working_df), value  = TRUE)
working_df <- (working_df
	%>% select(!!new_vars)
	%>% select(-!!drop_vars)
)

# Variable groups
all_vars <- colnames(working_df)

## Dwelling
dwelling_group_vars <- c("floormaterial", "roofmaterial"
	, "wallmaterial", "cookingfuel", "lighting", "rentorown"
)
dwelling_group_vars <- paste0(dwelling_group_vars, "_new")

## Ownership
ownership_group_vars <- grep("^ownhere\\_|^ownelse\\_|^ownlivestock|^grewcrops\\_", all_vars, value = TRUE)

## Expenditure
expenditure_group_vars <- grep("^expend\\_", all_vars, value = TRUE)

## Problems experienced
problems_group_vars <- grep("^prob\\_", all_vars, value = TRUE)


# Summary of groups
var_groups_df <- (data.frame(variables = colnames(working_df))
	%>% mutate(group = ifelse(variables %in% ownership_group_vars, "Ownership"
			, ifelse(variables %in% expenditure_group_vars, "Expenditure"
				, ifelse(variables %in% problems_group_vars, "Shocks/problems"
					, as.character(variables)
				)
			)
		)
	)
)
head(var_groups_df)

## Factor the binary variables and count the number of NAs per case
working_df <- (working_df
	%>% mutate_at(c(ownership_group_vars, problems_group_vars), as.factor)
	%>% mutate(totalNA = round(rowSums(is.na(.)|.=="missing:impute"|.==999999)/ncol(.) * 100, 3))
)

miss_percase_df <- as.data.frame(table(working_df$totalNA))
head(miss_percase_df)

miss_peryear_df <- table(working_df$totalNA, working_df$intvwyear_new)
head(miss_peryear_df)

#### Compare complete cases with all cases
working_df_complete <- (working_df
	%>% na.omit()
)

### Number of cases to impute missing
impute_na <- nrow(working_df) - nrow(working_df_complete)

## Create indicator for cases to drop based on don't know, NIU and refused
working_df_complete <- (working_df_complete
	%>% mutate(impute_cases = ifelse(imputeCase(., patterns = "missing:impute"), 1, 0))
   %>% mutate_at(colnames(.), function(x)na_if(x, "missing:impute"))
   %>% mutate_at(colnames(.), function(x)na_if(x, "999999"))
   %>% droplevels()
	%>% na.omit()
	%>% data.frame()
)

save(file = "analysisData.rda"
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
)
