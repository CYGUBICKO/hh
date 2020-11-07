#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Plot all the three services side by side (P) ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----
source("funs/ggplot_theme.R"); ggtheme()

library(ggplot2)
library(patchwork)

## garbage
load("garbage_condeffect_plots_tmb.rda")
garbage_eplots <- pred_effect_plots

## water
load("water_condeffect_plots_tmb.rda")
water_eplots <- pred_effect_plots

## toilet
load("toilet_condeffect_plots_tmb.rda")
toilet_eplots <- pred_effect_plots

nplots <- length(garbage_eplots)
all_plots <- lapply(1:nplots, function(i){
	p <- ((garbage_eplots[[i]] + labs(title = "garbage") + theme(legend.position = "none")) 
		+ (water_eplots[[i]] + labs(title = "water")) 
		+ (toilet_eplots[[i]] + labs(y = "", title = "toilet") + theme(legend.position = "none")) 
		+ plot_layout(nrow = 2, byrow = FALSE)
	)
	return(p)
})
print(all_plots)
