#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Subtask: BRMS model ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Oct 03 (Sat) ----

library(brms)

load("washModelfit_brms.rda")

brms_cond_df <- conditional_effects(brms_model)

save(file = "washPredEffects_brms.rda", brms_cond_df)

