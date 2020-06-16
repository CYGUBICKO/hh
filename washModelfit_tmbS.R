#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit switch data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(dplyr)
library(glmmTMB)

load("washModeldata.rda")

## Input files: modData data frame for fitting model and wash original data

## Scaled year
pyearmodData_scaled <- (prevyearmodData
	%>% mutate(year = year_scaled
		, hhsize = hhsize_scaled
	)
	%>% select(-year_scaled, -hhsize_scaled)
)

## Model formula
fixed_effects <- paste0(c("-1"
		, "services" 
		, "(poly(age, degree=2, raw=TRUE)"
		, "hhsize"
		, "year"
		, "selfrating"
		, "dwelling_index"
		, "ownership_index"
		, "shocks_index"
		, "total_expenditure"
		, "gender"
		, "slumarea"
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
	, data = pyearmodData_scaled
	, family = binomial(link = "logit")
)

save(file = "washModelfit_tmbS.rda"
	, tmb_scaled
	, pyearmodData_scaled
	, model_form
	, scale_mean
	, scale_scale
	, base_year
)

