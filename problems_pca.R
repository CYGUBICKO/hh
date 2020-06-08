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
)

## Create dummy indicators
mod_mad <- model.matrix(~., problems_df)[, -1]
problems_df <- data.frame(mod_mad)

problems_pca <- logisticPCA(problems_df, k = 1, m = 0, main_effects = FALSE)
problems_pca
problems_index <- drop(problems_pca$PCs[,1])

save(file = "problems_pca.rda"
	, problems_index
)
