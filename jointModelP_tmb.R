#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit glmmTMB  ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(dplyr)
library(splines)
library(glmmTMB)

load("washLongdata.rda")

## Input files: modData data frame for fitting model and wash original data
head(model_df)

fixed_effects <- paste0(c("-1"
		, "services" 
		, "(ns(age,3)"
		, "log(hhsize)"
		, "ns(year, 3)"
		, "gender"
		, "slumarea"
		, "ns(selfrating, 3)"
		, "shocks_ever_bin"
		, "materials"
		, "ownhere"
		, "ownelse"
		, "expenditure"
		, "income"
		, "foodeaten"
		, "rentorown"
		, "statusP):services"
	)
	, collapse = "+"
)
rand_effects <- "(services-1|hhid) + (services-1|year)" 
model_form <- as.formula(paste0("status ~ ", fixed_effects, "+", rand_effects))

## Fit glmer model
jointP_tmb_model <- glmmTMB(model_form
	, data = model_df
	, family = binomial(link = "logit")
)
summary(jointP_tmb_model)

save(file = "jointModelP_tmb.rda"
	, jointP_tmb_model
	, model_df
	, model_form
	, scale_mean
	, scale_scale
	, base_year
)

