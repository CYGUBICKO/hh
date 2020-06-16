#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
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

ownership_pca <- logisticPCA(ownership_df, k = 2, m = 0)
ownership_pca
ownership_index <- drop(ownership_pca$PCs[,1])

save(file = "ownership_pca.rda"
	, ownership_index
	, ownership_pca
)
