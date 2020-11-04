#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(scales)
library(ggplot2)

library(dplyr)
library(effects)
library(lme4)
library(splines)

source("funs/ggplot_theme.R"); ggtheme()
load("jointModelP_condeffect_tmb.rda")
load("labelEplots.rda")
load("jointModelP_anova.rda")

### Plot all predictors
pred_vars <- names(effect_df)

pred_effect_plots <- lapply(pred_vars, function(x){
	plotEffects(effect_df[[x]], x, sigName(jointModelP_anova, x))
})

print(pred_effect_plots)

save(file = "jointModelP_condeffect_plots_tmb.rda"
	, pred_effect_plots
)

