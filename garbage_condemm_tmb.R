#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(data.table)
library(emmeans)
library(splines)
library(glmmTMB)

load("garbage_tmb.rda")

## garbage glm model
mod <- garbage_tmb_model

pred_vars <- attr(terms(model_form), "term.labels")
pred_vars <- pred_vars[!grepl("\\|", pred_vars)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
names(pred_vars) <- pred_vars
pred_vars

emmeans_df <- lapply(pred_vars, function(x){
	predictor <- wash_df[[x]]
	pred_class <- class(predictor)
	pred_form <- as.formula(paste0("~", x))
	if(pred_class %in% c("numeric", "integer")){
		new_x <- list(seq(min(predictor), max(predictor), length.out = 50))
		names(new_x) <- x
		mod_df <- emmip(mod, pred_form, at = new_x, cov.keep = x, CI = TRUE, plotit = FALSE, bias.adjust = TRUE)
		mod_df <- data.frame(mod_df)
		mod_df <- setnames(mod_df, c("yvar", "LCL", "UCL"), c("fit", "lower", "upper"))
		mod_df$method <- "emmeans"
	} else {
		mod_df <- emmeans(mod, pred_form, cov.keep = x, CI = TRUE, plotit = FALSE, bias.adjust = TRUE)
		mod_df <- data.frame(mod_df)
		mod_df <- setnames(mod_df, c("emmean", "lower.CL", "upper.CL"), c("fit", "lower", "upper"))
		mod_df$method <- "emmeans"
	}
	return(mod_df)
})

save(file = "garbage_condemm_tmb.rda"
	, emmeans_df
	, base_year
)
