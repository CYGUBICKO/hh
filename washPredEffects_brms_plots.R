#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Subtask: BRMS model ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Oct 03 (Sat) ----

library(brms)
library(ggplot2)
source("funs/ggplot_theme.R"); ggtheme()

load("washPredEffects_brms.rda")
plot(brms_cond_df)
