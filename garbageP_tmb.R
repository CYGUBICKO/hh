#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit glm to one outcome ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(glmmTMB)

load("washdataStatusPcats.rda")

## Input files: wash_consec_df
head(wash_consec_df)

## Model formula
fixed_effects <- paste0(c("age_scaled"
		, "log_hhsize"
		, "year"
		, "gender"
		, "slumarea"
		, "selfrating_scaled"
		, "shocks_ever_bin"
		, "materials"
		, "ownhere"
		, "ownelse"
		, "expenditure_scaled"
		, "income"
		, "foodeaten"
		, "rentorown"
		, "garbagedposalP"
	)
	, collapse = "+"
)
rand_effects <- "(1|indid) + (1|hhid) + (1|year)" 
model_form <- as.formula(paste0("garbagedposal ~ ", fixed_effects, "+", rand_effects))

## Fit glmtmb model
garbageP_tmb_model <- glmmTMB(model_form
	, data = wash_consec_df
	, family = binomial(link = "logit")
)

save(file = "garbageP_tmb.rda"
	, garbageP_tmb_model
	, wash_consec_df
	, model_form
	, base_year
)

