#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit switch data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(dplyr)
library(splines)
library(glmmTMB)

load("washModeldata.rda")

## Input files: modData data frame for fitting model and wash original data
model_df <- (model_df
	%>% select(-year_scaled, -hhsize_scaled)
)

## Model formula
fixed_effects <- paste0(c("-1"
		, "services" 
		, "(ns(age,3)"
		, "log(hhsize)"
		, "year"
		, "gender"
		, "slumarea"
		, "selfrating"
		, "materials"
		, "lighting"
		, "ownhere"
		, "ownelse"
		, "shocks"
		, "expenditure"
		, "income"
		, "foodeaten"
		, "statusP):services"
	)
	, collapse = "+"
)
rand_effects <- "(services-1|hhid)"
model_form <- as.formula(paste0("status ~ ", fixed_effects, " + ", rand_effects))

## Fit glmer model
tmb_scaled <- glmmTMB(model_form
	, data = model_df
	, family = binomial(link = "logit")
)

save(file = "washModelfit_tmbS.rda"
	, tmb_scaled
	, model_df
	, model_form
	, scale_mean
	, scale_scale
	, base_year
)

