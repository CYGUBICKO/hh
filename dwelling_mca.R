#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(FactoMineR)
library(dplyr)

## Use complete dataset
load("cleanData.rda")

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
	%>% mutate_all(as.factor)
	%>% data.frame()
)

dwelling_mca <- MCA(dwelling_df, graph = FALSE)
dwelling_pc_df <- dwelling_mca$ind$coord
dwelling_index <- drop(dwelling_pc_df[,1])

save(file = "dwelling_mca.rda"
	, dwelling_index
	, dwelling_mca
)
