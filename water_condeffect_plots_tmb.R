#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(scales)
library(ggplot2)

library(dplyr)
library(effects)
library(lme4)
library(splines)

source("funs/ggplot_theme.R"); ggtheme()
load("water_condeffect_tmb.rda")
load("water_anova.rda")
load("labelEplots.rda")

### Plot all predictors
pred_vars <- names(effect_df)

### Set resp_scale in labelEplots.R

pred_effect_plots <- lapply(pred_vars, function(x){
	plotEffects(effect_df[[x]], x, sigName(water_anova, x), scale = resp_scale)
})

print(pred_effect_plots)

save(file = "water_condeffect_plots_tmb.rda"
	, pred_effect_plots
)

