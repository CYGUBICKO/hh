#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(dplyr)
library(glmmTMB)

source("jdeffects.R")
load("garbage_tmb.rda")

## garbage glm model
mod <- garbage_tmb_model

## jd varpred
varpredfun <- function(mod, focal, at, vcmat = NULL, model){
	if (is.null(vcmat)){
		pred <- varpred(mod, focal, at = at)
	} else {
		pred <- varpred(mod, focal, at = at, vcmat = vcmat)
	}
	pred$model <- model
	pred$x <- at
	return(pred)
}


# Marginal effect of age

## Unzeroed vcov
age_at <- seq(min(wash_df$age_scaled), max(wash_df$age_scaled), length.out=50)
age_jd_nzero <- varpredfun(mod, focal = "age_scaled"
	, at = age_at
	, model = "jd_nzero"
)
head(age_jd_nzero)

## Zeroed non-focal vv
age_jd_zero <- varpredfun(mod, focal = "age_scaled"
	, at = age_at
	, model = "jd_zero"
	, vcmat = zero_vcov(mod, "age_scaled")
)
head(age_jd_zero)

## Combine the predictions
predict_age_jd <- (list(age_jd_zero, age_jd_nzero)
	%>% bind_rows()
	%>% select(!!c("fit", "lwr", "upr", "x", "model"))
)
head(predict_age_jd)

save(file = "temp_condjd.rda"
	, predict_age_jd
)


