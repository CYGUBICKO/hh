#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(data.table)
library(dplyr)
library(logisticPCA)

## Use complete dataset
load("cleanData.rda")

## Ownership data
ownership_df <- (working_df_complete
	%>% select(!!ownership_group_vars)
	%>% mutate_at(colnames(.), function(x){
		x = ifelse(x=="yes", 1, ifelse(x=="no", 0, x))
	})
	%>% setnames(., old = ownership_group_vars, gsub("\\_new", "", ownership_group_vars))
	%>% data.frame()
)
print(sapply(ownership_df, table))

## Create dummy indicators
ownership_df <- data.frame(ownership_df)

ownership_pca <- logisticPCA(ownership_df, k = 2, m = 0)
ownership_pca
ownership_index <- drop(ownership_pca$PCs[,1])

save(file = "ownership_lpca.rda"
	, ownership_index
	, ownership_pca
)
