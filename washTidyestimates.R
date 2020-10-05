#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Tidy Model estimates ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(dplyr)
library(tidyr)
library(tibble)
library(purrr)
library(broom.mixed)

library(data.table)
library(splines)
library(glmmTMB)
library(brms)

load("globalFunctions.rda")

## BRMS model
load("washModelfit_brms.rda")
brms_model <- brms_model
brms_df <- model_df

## glmmTMB
load("washModelfit_tmbS.rda")
tmb_model <- tmb_scaled
tmb_df <- model_df

### Extract coefficients
#### BRMS
brms_coef_df <- (map(list(brms = brms_model)
		, tidyMCMC
		, conf.int = TRUE
	)
	%>% bind_rows(.id = "model")
#	%>% dotwhisker::by_2sd(brms_df)
	%>% mutate(parameter = gsub(".*\\_", "", term)
		, term = gsub("(\\_..*?)\\_.*", "\\1", term)
		, term = gsub(".*\\_", "", term)
		, parameter = gsub("watersource|toilettype|garbagedposal", "status", parameter)
		, parameter = ifelse(grepl("(^ns..*?)\\d$", parameter)
				, paste0("ns(",  gsub(".*ns|\\d+$", "", parameter), ", "
				, substr(gsub("[^0-9]", "", parameter), 1, 1), ")"
				, substr(gsub("[^0-9]", "", parameter), 2, 2)
			)
			, parameter
		)
		, parameter = ifelse(grepl("^log", parameter)
		, paste0("log(", gsub("log", "", parameter), ")")
		, parameter
		)
	)
)

#### Other models
others_coef_df <- (map(list(tmb = tmb_model)
		, tidy
		, conf.int = TRUE
	)
	%>% bind_rows(.id = "model")
	%>% mutate(term = factor(term, levels = unique(term))
		, term = gsub("services", "", term)
		, parameter = ifelse(!grepl("\\:|\\.|^cor|^sd", term), "Service gain", term)
		, parameter = ifelse(grepl("^cor|^sd", parameter)
			, paste0(gsub("\\_\\_.*", "", parameter), "_", group)
			, gsub(".*\\:", "", parameter)
		)
		, term = gsub("\\:.*|\\.hhid|\\.year|.*\\_\\_", "", term)
		, parameter = ifelse(!grepl("\\(", parameter), gsub(" ", "", parameter), parameter)
	)
	%>% filter(term != "(Intercept)")
	%>% mutate(term = reorder(term, estimate))
)

## Cleam variable names
pred_vars <- attr(terms(model_form), "term.labels")
pred_vars <- pred_vars[!grepl("\\|", pred_vars)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*|\\).*", "", pred_vars)
pred_vars <- pred_vars[!pred_vars %in% "services"]
d1 <- genlabsCodes(others_coef_df, "parameter", pred_vars, pred_vars) 

extract_coefs_df <- (brms_coef_df
	%>% bind_rows(others_coef_df)
	%>% left_join(d1, by = "parameter")
	%>% filter(!is.na(parameter_new))
)

print(extract_coefs_df, n = Inf, width = Inf)

save(file = "washTidyestimates.rda"
	, extract_coefs_df
)
