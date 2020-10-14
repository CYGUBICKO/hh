#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(data.table)

## Use complete dataset
load("cleanData.rda")

## It looks like rentorown should not be part of the dwelling index!
## FIX this upstream and get rid of

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
	%>% mutate_all(as.numeric)
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
	%>% setnames(., old = dwelling_group_vars, gsub("\\_new", "", dwelling_group_vars))
	%>% select(-rentorown)
	%>% data.frame()
)

dwelling_pca <- prcomp(dwelling_df, center = TRUE, scale. = TRUE)
loadings <- dwelling_pca$rotation[, 1]
if(min(sign(loadings)) != max(sign(loadings))){
	stop("PC1 is not a positively signed index")
}

dwelling_index <- dwelling_pca$x[, 1]*max(sign(loadings))

summary(dwelling_index)
cor.test(dwelling_index, dwelling_df$wallmaterial)

save(file = "dwelling_pca.rda"
	, dwelling_index
	, dwelling_pca
)
