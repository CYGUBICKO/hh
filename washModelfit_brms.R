#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Subtask: BRMS model ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Sep 22 (Tue) ----

library(splines)
library(brms)

load("washdataStatusPcats.rda")

## Input files: wash_consec_df dataset restructured to capture previous status
model_df <- model.frame(
	~ watersource
	+ toilettype
	+ garbagedposal
	+ hhid
	+ year
	+ slumarea
	+ gender
	+ hhsize
	+ income
	+ foodeaten
	+ age
	+ selfrating
	+ materials
	+ lighting
	+ ownhere
	+ ownelse
	+ shocks
	+ expenditure
	+ watersourceP
	+ toilettypeP
	+ garbagedposalP
	, data = wash_consec_df, na.action = na.exclude, drop.unused.levels = TRUE
)

## Model formula
water_form <- bf(watersource ~ -1 + ns(age, 3) + log(hhsize) + year + gender 
	+ slumarea + selfrating + materials + lighting + ownhere + ownelse 
	+ shocks + expenditure	+ income + foodeaten + watersourceP 
#	+ (1|hhid)
)

toilet_form <- bf(toilettype ~ -1 + ns(age, 3) + log(hhsize) + year + gender 
	+ slumarea + selfrating + materials + lighting + ownhere + ownelse 
	+ shocks + expenditure	+ income + foodeaten + toilettypeP
#	+ (1|hhid)
)

garbage_form <- bf(garbagedposal ~ -1 + ns(age, 3) + log(hhsize) + year + gender 
	+ slumarea + selfrating + materials + lighting + ownhere + ownelse 
	+ shocks + expenditure	+ income + foodeaten + garbagedposalP
#	+ (1|hhid)
)

## Fit brms model
brms_model <- brm(water_form + toilet_form + garbage_form
	, data = model_df
	, family = list(bernoulli(link = "logit"), bernoulli(link = "logit"), bernoulli(link = "logit")) 
	, warmup = 1e3
	, iter = 4e3
	, chains = 2
	, cores = 4
	, control = list(adapt_delta = 0.95)
)

save(file = "washModelfit_brms.rda"
	, brms_model
	, model_df
	, water_form
	, garbage_form
	, toilet_form
	, scale_mean
	, scale_scale
	, base_year
)

