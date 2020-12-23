#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(effects)
library(glmmTMB)

source("jdeffects.R")
load("garbage_tmb.rda")

## Which scale to plot the predictions
### See ?plot.effects
linearpredictor <- TRUE

## garbage glm model
mod <- garbage_tmb_model

## Clean predictor names
Terms <- attr(terms(model_form), "term.labels")
print(Terms)
pred_vars <- Terms[!grepl("\\|", Terms)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
names(pred_vars) <- pred_vars
print(pred_vars)

## Code below can extract all the effects but too slow and requires more memory. Use for loop instead
# effect_df <- predictorEffects(mod)

effect_df <- lapply(pred_vars, function(x){
	focal_var <- grep(x, Terms, value=TRUE)
	vv <- zero_vcov(mod, focal_var)
	mod <- Effect(x, xlevels = 50, mod = mod, vcov. = vv, latent = TRUE)
	if(linearpredictor){
		mod_df <- data.frame(mod$x, fit = mod$fit, lower = mod$lower, upper = mod$upper)
		mod_df$method <- "effects"
	} else {
		mod_df <- as.data.frame(mod)
		mod_df$method <- "effects"
	}
	return(mod_df)
})

save(file = "garbage_condeffect_tmb.rda"
	, effect_df
	, base_year
)
