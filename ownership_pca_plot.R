#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(logisticPCA)
library(ggplot2)
source("../funs/ggplot_theme.R"); ggtheme()

## Use complete dataset
load("analysisData.rda")
load("ownership_pca.rda")

## Water
water <- working_df_complete$drinkwatersource_new

ownership_water_load_plot <- (plot(ownership_pca, type = "loadings") 
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
	+ scale_colour_manual(name = "Water", values = "blue")
)
print(ownership_water_load_plot)

ownership_water_pc_plot <- (plot(ownership_pca, type = "scores") 
	+ geom_point(aes(colour = water), alpha = 0.2)
	+ scale_colour_manual(name = "Water", values = c("blue", "red"))
)
print(ownership_water_pc_plot)

save(file = "ownership_pca_plot.rda"
	, ownership_water_pc_plot
	, ownership_water_load_plot
)
