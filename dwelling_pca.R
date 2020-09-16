#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)

## Use complete dataset
load("cleanData.rda")

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
	%>% mutate_all(as.numeric)
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% data.frame()
)

dwelling_pca <- prcomp(dwelling_df, center = TRUE, scale. = TRUE)
dwelling_pc_df <- summary(dwelling_pca)$x
dwelling_index <- drop(dwelling_pc_df[,1])

save(file = "dwelling_pca.rda"
	, dwelling_index
	, dwelling_pca
)
