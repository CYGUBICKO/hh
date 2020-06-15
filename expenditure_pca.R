#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(factoextra)
library(ggplot2)

load("analysisData.rda")

## Expenditure
expenditure_df <- (working_df_complete
	%>% select(!!expenditure_group_vars)
	%>% mutate_at(colnames(.), function(x){drop(scale(x))})
)

expenditure_pca <- prcomp(expenditure_df, center = TRUE, scale. = TRUE)
expenditure_pc_df <- summary(expenditure_pca)$x
expenditure_index <- drop(expenditure_pc_df[,1])

expenditure_plot <- fviz_screeplot(expenditure_pca, addlabels = TRUE)
print(expenditure_plot)

save(file = "expenditure_pca.rda"
	, expenditure_index
)
