#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit glm to one outcome (Previous status)----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(splines)

load("washdataStatusPcats.rda")

## Input files: wash_consec_df - previous status added
head(wash_consec_df)

## Model formula
fixed_effects <- paste0(c("ns(age, 3)"
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
		, "garbagedposalP"
	)
	, collapse = "+"
)
model_form <- as.formula(paste0("garbagedposal ~ ", fixed_effects))

## Fit glm model
garbageP_glm_model <- glm(model_form
	, data = wash_consec_df
	, family = binomial(link = "logit")
)

save(file = "garbageP_glm.rda"
	, garbageP_glm_model
	, wash_consec_df
	, model_form
	, scale_mean
	, scale_scale
	, base_year
)

