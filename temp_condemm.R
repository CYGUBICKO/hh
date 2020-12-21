#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(dplyr)
library(emmeans)
library(glmmTMB)

load("garbage_tmb.rda")

## garbage glm model
mod <- garbage_tmb_model

## emmeans function
empredfun <- function(mod, spec, at, cov.keep, model, vvfun=NULL){
	if (is.null(vvfun)){
		pred <- emmeans(mod, spec, at = at
			, cov.keep=cov.keep, CIs=TRUE
		)
	} else {
		pred <- emmeans(mod, spec, at = at
			, cov.keep = cov.keep, CIs = TRUE
			, vcov. = vvfun
		)
	}
	pred <- as.data.frame(pred)
	pred$x <- at[[cov.keep]]
	pred$model <- model
	return(pred)
}

# Marginal effect of age

## Unzeroed vcov
age_at <- seq(min(wash_df$age_scaled), max(wash_df$age_scaled), length.out=50)
age_em_nzero <- empredfun(mod, spec = ~age_scaled
	, at = list(age_scaled = age_at), cov.keep = "age_scaled"
	, model = "em_nzero"
)
head(age_em_nzero)

## Zeroed non-focal vv
age_em_zero <- empredfun(mod, spec = ~age_scaled
	, at = list(age_scaled = age_at), cov.keep = "age_scaled"
	, model = "em_zero"
	, vvfun = zero_vcov(mod, "age_scaled")
)
head(age_em_zero)

## Combine the predictions
predict_age_em <- (list(age_em_zero, age_em_nzero)
	%>% bind_rows()
	%>% setnames(old = c("emmean", "lower.CL", "upper.CL"), new = c("fit", "lwr", "upr"))
	%>% select(!!c("fit", "lwr", "upr", "x", "model"))
)
head(predict_age_em)

save(file = "temp_condemm.rda"
	, predict_age_em
)


