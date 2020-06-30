#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(ggplot2)
library(caret)
library(logisticPCA)

## Use complete dataset
load("analysisData.rda")

## Shocks/problems data
problems_df <- (working_df_complete
	%>% select(!!problems_group_vars)
	%>% mutate_all(function(x){as.numeric(as.character(x))})
	%>% mutate(shocks = rowSums(., na.rm = TRUE))
)
str(problems_df)
sapply(problems_df, table)

problems_index <- drop(problems_df[["shocks"]])
summary(problems_index)

save(file = "problems_index.rda"
	, problems_index
)
