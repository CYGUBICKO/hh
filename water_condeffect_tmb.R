#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(splines)
library(effects)
library(glmmTMB)

load("water_tmb.rda")

## Which scale to plot the predictions
### See ?plot.effects
linearpredictor <- TRUE

## water glm model
mod <- water_tmb_model

### Conditionaled on all other predictors
pred_vars <- attr(terms(model_form), "term.labels")
pred_vars <- pred_vars[!grepl("\\|", pred_vars)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
names(pred_vars) <- pred_vars
pred_vars

## Code below can extract all the effects but too slow and requires more memory. Use for loop instead
# effect_df <- predictorEffects(mod)

effect_df <- lapply(pred_vars, function(x){
	mod <- Effect(x, xlevels = 50, mod = mod, latent = TRUE)
	if(linearpredictor){
		mod_df <- data.frame(mod$x, fit = mod$fit, lower = mod$lower, upper = mod$upper)
		mod_df$method <- "effects"
	} else {
		mod_df <- as.data.frame(mod)
		mod_df$method <- "effects"
	}
	return(mod_df)
})

save(file = "water_condeffect_tmb.rda"
	, effect_df
	, scale_mean
	, scale_scale
	, base_year
)
