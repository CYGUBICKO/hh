#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(tibble)
library(tidyr)
library(FactoMineR)
library(factoextra)
library(ggplot2)

load("analysisData.rda")

## Expenditure
expenditure_df <- (working_df
	%>% select(!!expenditure_group_vars)
	%>% na.omit()
)
nrow(working_df)
nrow(expenditure_df)

expenditure_pca <- prcomp(expenditure_df, scale. = TRUE)
summary(expenditure_pca)

expenditure_plot <- fviz_screeplot(expenditure_pca, addlabels = TRUE)
print(expenditure_plot)

save(file = "expenditure_pca.rda"
	, expenditure_pca
)
