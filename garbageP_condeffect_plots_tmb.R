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
load("garbageP_condeffect_tmb.rda")
load("garbageP_anova.rda")
load("labelEplots.rda")

### Plot all predictors
pred_vars <- names(effect_df)

# resp_scale: set in labelEplots.R

pred_effect_plots <- lapply(pred_vars, function(x){
	plotEffects(effect_df[[x]], x, sigName(garbageP_anova, x), scale = resp_scale)
})

print(pred_effect_plots)

save(file = "garbageP_condeffect_plots_tmb.rda"
	, pred_effect_plots
)

