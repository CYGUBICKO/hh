#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(tibble)
library(tidyr)
library(missForest)
library(doMC)
registerDoMC()

load("analysisData.rda")

# Ownership variables
ownership_df <- (working_df_complete
	%>% select(!!ownership_group_vars)
	%>% mutate_at(colnames(.), function(x)na_if(x, "missing:impute"))
	%>% droplevels()
	%>% data.frame()
)

head(ownership_df)

## Impute missing values using random forest

ownership_missForest <- missForest(ownership_df, parallelize = "variables")
ownership_imputed_df <- ownership_missForest$ximp

save(file = "ownership_imputeMCA.rda"
	, ownership_imputed_df
	, ownership_df
	, ownership_missForest
)
