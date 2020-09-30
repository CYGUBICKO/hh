#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(splines)
library(effects)
library(glmmTMB)

load("washModelfit_tmbS.rda")

## Which scale to plot the predictions
### See ?plot.effects
linearpredictor <- TRUE

## Previous year model
pyrmod <- tmb_scaled

### Service level predictions
mod <- Effect("services", mod = pyrmod)
head(mod)

if(linearpredictor){
	pyrservice_effect_df <- data.frame(mod$x, fit = mod$fit, lower = mod$lower, upper = mod$upper)
} else {
	pyrservice_effect_df <- as.data.frame(mod)
}

### Conditionaled on all other predictors
pred_vars <- attr(terms(model_form), "term.labels")
pred_vars <- pred_vars[!grepl("\\|", pred_vars)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
pred_vars <- pred_vars[!pred_vars %in% "services"]
names(pred_vars) <- pred_vars
pred_vars

## Code below can extract all the effects but too slow and requires more memory. Use for loop instead
# pyrmod_effect_df <- predictorEffects(pyrmod)

pyrmod_effect_df <- lapply(pred_vars, function(x){
	mod <- Effect(c("services", x), xlevels = 50, mod = pyrmod)
	if(linearpredictor){
		mod_df <- data.frame(mod$x, fit = mod$fit, lower = mod$lower, upper = mod$upper)
	} else {
		mod_df <- as.data.frame(mod)
	}
	return(mod_df)
})

save(file = "washPredEffects.rda"
	, pyrservice_effect_df
	, pyrmod_effect_df
	, scale_mean
	, scale_scale
	, base_year
)
