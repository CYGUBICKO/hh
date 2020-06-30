#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(factoextra)
library(ggplot2)
source("funs/ggplot_theme.R"); ggtheme()

## Use complete dataset
load("analysisData.rda")
load("dwelling_mca.rda")

## Variance explained plot
dwelling_explained_plot <- fviz_screeplot(dwelling_mca, addlabels = TRUE)
dwelling_explained_plot

dwelling_pc_var_plot <- fviz_mca_var(dwelling_mca, repel = TRUE)
dwelling_pc_var_plot

save(file = "dwelling_mca_plot.rda"
	, dwelling_explained_plot
	, dwelling_pc_var_plot
)
