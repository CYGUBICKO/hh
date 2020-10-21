#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(ggplot2)
library(caret)
library(logisticPCA)

## Use complete dataset
load("cleanData.rda")

## Shocks/problems data
problems_ever_df <- (working_df_complete
	%>% select(!!problems_ever_group_vars, shocks_ever)
)
sapply(problems_ever_df, table)

problems_ever_index <- drop(problems_ever_df[["shocks_ever"]])
summary(problems_ever_index)

save(file = "problems_ever_index.rda"
	, problems_ever_index
)
