#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(data.table)

## Use complete dataset
load("cleanData.rda")

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
	%>% mutate_all(as.numeric)
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% setnames(., old = dwelling_group_vars, gsub("\\_new", "", dwelling_group_vars))
	%>% data.frame()
)

dwelling_pca <- prcomp(dwelling_df, center = TRUE, scale. = TRUE)
dwelling_pc_df <- summary(dwelling_pca)$x
dwelling_index <- drop(dwelling_pc_df[,1:2])
head(dwelling_index)

save(file = "dwelling_pca.rda"
	, dwelling_index
	, dwelling_pca
)
