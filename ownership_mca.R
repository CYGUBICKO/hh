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
ownership_df <- (working_df
	%>% select(!!ownership_group_vars)
)
head(ownership_df)

ownership_mca <- MCA(ownership_df, graph = FALSE)
head(ownership_mca$eig)

ownership_plot <- fviz_screeplot(ownership_mca, addlabels = TRUE)
print(ownership_plot)

save(file = "ownership_mca.rda"
	, ownership_mca
)
