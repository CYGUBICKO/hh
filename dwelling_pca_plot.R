#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(factoextra)
library(ggplot2)
library(ggfortify)
source("funs/ggplot_theme.R"); ggtheme()

## Use complete dataset
load("cleanData.rda")
load("dwelling_pca.rda")

## Variance explained plot
dwelling_explained_plot <- fviz_screeplot(dwelling_pca, addlabels = TRUE)
print(dwelling_explained_plot)

## PC plots
### Drinking water
dwelling_water_pc_plot <- (autoplot(dwelling_pca
		, data = working_df_complete
		, colour = "drinkwatersource_new"
		, alpha = 0.2
		, shape = FALSE
		, label = FALSE
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, show.legend = FALSE
		, loadings = TRUE
		, loadings.label = TRUE
	)
	+ scale_colour_manual(name = "Water", values = c("blue", "red"))
	+ scale_fill_manual(name = "Water", values = c("blue", "red"))
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
print(dwelling_water_pc_plot)

### Garbage disposal
dwelling_garbage_pc_plot <- (autoplot(dwelling_pca
		, data = working_df_complete
		, colour = "garbagedisposal_new"
		, alpha = 0.2
		, shape = FALSE
		, label = FALSE
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, show.legend = FALSE
		, loadings = TRUE
		, loadings.label = TRUE
	)
	+ scale_colour_manual(name = "Garbage disposal", values = c("blue", "red"))
	+ scale_fill_manual(name = "Garbage disposal", values = c("blue", "red"))
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
# print(dwelling_garbage_pc_plot)

### Garbage disposal
dwelling_toilet_pc_plot <- (autoplot(dwelling_pca
		, data = working_df_complete
		, colour = "toilet_5plusyrs_new"
		, alpha = 0.2
		, shape = FALSE
		, label = FALSE
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, show.legend = FALSE
		, loadings = TRUE
		, loadings.label = TRUE
	)
	+ scale_colour_manual(name = "Toilet facilities", values = c("blue", "red"))
	+ scale_fill_manual(name = "Toilet facilities", values = c("blue", "red"))
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
# print(dwelling_toilet_pc_plot)

save(file = "dwelling_pca_plot.rda"
	, dwelling_explained_plot
	, dwelling_water_pc_plot
	, dwelling_garbage_pc_plot
	, dwelling_toilet_pc_plot
)
