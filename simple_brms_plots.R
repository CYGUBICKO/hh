library(ggplot2)
source("funs/ggplot_theme.R"); ggtheme()
library(brms)

load("simple_brms.rda")

cond_df <- conditional_effects(brms_model)

plot(cond_df)
