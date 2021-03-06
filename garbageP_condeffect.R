#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(splines)
library(effects)

load("garbageP_glm.rda")

## Which scale to plot the predictions
### See ?plot.effects
linearpredictor <- TRUE

## garbage glm model
gab <- garbageP_glm_model

### Conditionaled on all other predictors
pred_vars <- attr(terms(model_form), "term.labels")
pred_vars <- pred_vars[!grepl("\\|", pred_vars)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
names(pred_vars) <- pred_vars
pred_vars

## Code below can extract all the effects but too slow and requires more memory. Use for loop instead
# effect_df <- predictorEffects(gab)

effect_df <- lapply(pred_vars, function(x){
	mod <- Effect(x, xlevels = 50, mod = gab)
	if(linearpredictor){
		mod_df <- data.frame(mod$x, fit = mod$fit, lower = mod$lower, upper = mod$upper)
	} else {
		mod_df <- as.data.frame(mod)
	}
	return(mod_df)
})

save(file = "garbageP_condeffect.rda"
	, effect_df
	, scale_mean
	, scale_scale
	, base_year
)
