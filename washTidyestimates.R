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

load("globalFunctions.rda")
load("washModelfit_tmbS.rda")

tmbScaled <- tmb_scaled

extract_coefs_df <- (map(list(tmbScaled = tmbScaled)
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
	)
	%>% filter(term != "(Intercept)")
	%>% mutate(term = reorder(term, estimate)
#		, parameter = ifelse(grepl("glmSc|glmUn", model)
#			, gsub("gain", "level", parameter)
#			, parameter
#		) 
	)
)

## Cleam variable names
pred_vars <- attr(terms(model_form), "term.labels")
pred_vars <- pred_vars[!grepl("\\|", pred_vars)]
pred_vars <-  gsub(".*\\:|.*\\(|\\,.*", "", pred_vars)
pred_vars <- pred_vars[!pred_vars %in% "services"]
d1 <- genlabsCodes(extract_coefs_df, "parameter", pred_vars, pred_vars) 

extract_coefs_df <- (extract_coefs_df
	%>% left_join(d1, by = "parameter")
)

print(extract_coefs_df, n = Inf, width = Inf)

save(file = "washTidyestimates.rda"
	, extract_coefs_df
)
