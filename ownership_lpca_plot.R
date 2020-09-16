#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(logisticPCA)
library(ggplot2)
source("funs/ggplot_theme.R"); ggtheme()

## Use complete dataset
load("cleanData.rda")
load("ownership_lpca.rda")

## Water
water <- working_df_complete$drinkwatersource_new

print(ownership_pca$U)

ownership_plot_df <- data.frame(vars = gsub("_new", "", ownership_group_vars)
		, PC1 = drop(ownership_pca$U[,1])
		, PC2 = drop(ownership_pca$U[,2])
)
head(ownership_plot_df)
ownership_water_load_plot <- (ggplot(ownership_plot_df, aes(x = PC1, y = PC2))
	+ geom_text(alpha = .4, size = 3, aes(label = vars))
	+ geom_segment(aes(x=0,y=0,xend=PC1,yend=PC2), arrow=arrow(length=unit(0.1,"cm")), color = "#DCDCDC")
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
print(ownership_water_load_plot)

save(file = "ownership_lpca_plot.rda"
	, ownership_water_load_plot
#	, ownership_water_pc_plot
)
