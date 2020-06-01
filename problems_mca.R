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

# Ownership variables
problems_df <- (working_df
	%>% select(!!problems_group_vars)
)
head(problems_df)

problems_mca <- MCA(problems_df, graph = FALSE)
head(problems_mca$eig)

problems_plot <- fviz_screeplot(problems_mca, addlabels = TRUE)
print(problems_plot)

save(file = "problems_mca.rda"
	, problems_mca
)
