#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)

## Use complete dataset
load("analysisData.rda")

## Dwelling data
ownership_df <- (working_df_complete
	%>% select(!!ownership_group_vars)
	%>% mutate_all(as.numeric)
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% data.frame()
)

ownership_pca <- prcomp(ownership_df, center = TRUE, scale. = TRUE)
ownership_pc_df <- summary(ownership_pca)$x
ownership_index <- drop(ownership_pc_df[,1])

save(file = "ownership_gpca.rda"
	, ownership_index
	, ownership_pca
)
