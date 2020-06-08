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

## Ownership data
ownership_df <- (working_df_complete
	%>% select(!!ownership_group_vars)
)

## Create dummy indicators
mod_mad <- model.matrix(~., ownership_df)[, -1]
ownership_df <- data.frame(mod_mad)

ownership_pca <- logisticPCA(ownership_df, k = 1, m = 0, main_effects = FALSE)
ownership_pca
ownership_index <- drop(ownership_pca$PCs)

save(file = "ownership_pca.rda"
	, ownership_index
)
