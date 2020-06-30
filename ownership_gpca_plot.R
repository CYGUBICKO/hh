#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(factoextra)
library(ggplot2)
library(ggfortify)
source("../funs/ggplot_theme.R"); ggtheme()

## Use complete dataset
load("analysisData.rda")
load("ownership_gpca.rda")

## Variance explained plot
ownership_explained_plot <- fviz_screeplot(ownership_pca, addlabels = TRUE)
print(ownership_explained_plot)

## PC plots
### Drinking water
ownership_water_pc_plot <- (autoplot(ownership_pca
		, data = working_df_complete
		, colour = "drinkwatersource_new"
		, alpha = 0.2
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
print(ownership_water_pc_plot)

### Garbage disposal
ownership_garbage_pc_plot <- (autoplot(ownership_pca
		, data = working_df_complete
		, colour = "garbagedisposal_new"
		, alpha = 0.2
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
#print(ownership_garbage_pc_plot)

### Garbage disposal
ownership_toilet_pc_plot <- (autoplot(ownership_pca
		, data = working_df_complete
		, colour = "toilet_5plusyrs_new"
		, alpha = 0.2
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
#print(ownership_toilet_pc_plot)

save(file = "ownership_gpca_plot.rda"
	, ownership_explained_plot
	, ownership_water_pc_plot
	, ownership_garbage_pc_plot
	, ownership_toilet_pc_plot
)
