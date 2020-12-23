#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(data.table)
library(emmeans)
library(glmmTMB)

source("jdeffects.R")
load("garbage_tmb.rda")

## garbage glm model
mod <- garbage_tmb_model

## Clean predictor names
Terms <- attr(terms(model_form), "term.labels")
print(Terms)
pred_vars <- Terms[!grepl("\\|", Terms)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
names(pred_vars) <- pred_vars
print(pred_vars)

grep("age_scaled", Terms, value = TRUE)

## Get names for all variables with specified knots
# all_knots <- ls(pattern="\\_knots$")

emmeans_df <- lapply(pred_vars, function(x){
	predictor <- wash_df[[x]]
	pred_class <- class(predictor)
	pred_form <- as.formula(paste0("~", x))
	# Zero out non-focal vv
	focal_var <- grep(x, Terms, value=TRUE)
	vv <- zero_vcov(mod, focal_var)
	if(pred_class %in% c("numeric", "integer")){
		new_x <- list(seq(min(predictor), max(predictor), length.out = 50))
		names(new_x) <- x
		mod_df <- emmeans(mod, pred_form, at = new_x #, params = all_knots
			, cov.keep = x, CIs = TRUE, vcov. = vv, plotit = FALSE
			, nesting=NULL
		)
		mod_df <- data.frame(mod_df)
		mod_df <- setnames(mod_df, c("emmean", "lower.CL", "upper.CL"), c("fit", "lower", "upper"))
		mod_df$method <- "emmeans"
	} else {
		mod_df <- emmeans(mod, pred_form, cov.keep = x #, params = all_knots
			, CIs = TRUE, vcov. = vv, plotit = FALSE, nesting=NULL
		)
		mod_df <- data.frame(mod_df)
		mod_df <- setnames(mod_df, c("emmean", "lower.CL", "upper.CL"), c("fit", "lower", "upper"))
		mod_df$method <- "emmeans"
	}
	return(mod_df)
})

emmeans_df[[1]]

save(file = "garbage_condemm_tmb.rda"
	, emmeans_df
	, base_year
)
