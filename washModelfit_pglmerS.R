#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit switch data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(dplyr)
library(lme4)

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
		, "(age"
		, "hhsize"
		, "year"
		, "gender"
		, "slumarea"
		, "selfrating"
		, "dwelling_index"
		, "ownership_index"
		, "shocks_index"
		, "expenditure_index"
		, "income"
		, "foodeaten"
		, "statusP):services"
	)
	, collapse = "+"
)
rand_effects <- "(services-1|hhid)"
model_form <- as.formula(paste0("status ~ ", fixed_effects, " + ", rand_effects))

## Fit glmer model
pglmer_scaled <- glmer(model_form
	, data = pyearmodData_scaled
	, family = binomial(link = "logit")
	, control = glmerControl(optimizer="bobyqa")
)

save(file = "washModelfit_pglmerS.rda"
	, pglmer_scaled
	, pyearmodData_scaled
	, model_form
	, scale_mean
	, scale_scale
	, base_year
)

