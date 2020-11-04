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

library(splines)

load("garbage_tmb.rda")
garbage <- garbage_tmb_model

load("garbageP_tmb.rda")
garbageP <- garbageP_tmb_model

load("water_tmb.rda")
water <- water_tmb_model

load("waterP_tmb.rda")
waterP <- waterP_tmb_model

load("toilet_tmb.rda")
toilet <- toilet_tmb_model

load("toiletP_tmb.rda")
toiletP <- toiletP_tmb_model

### Extract coefficients
#### No previous status
coefs_df1 <- (map(list(water = water, garbage = garbage, toilet = toilet)
		, tidy
		, conf.int = TRUE
	)
	%>% bind_rows(.id = "model")
	%>% dotwhisker::by_2sd(wash_df)
	%>% mutate(term = factor(term, levels = unique(term))
		, parameter = term
		, parameter = gsub(".*\\(|\\).*|\\,.*", "", parameter)
		, parameter_new = ifelse(parameter == "Intercept", "Intercept", "Coefs")
	)
	%>% mutate(term = reorder(term, estimate))
)

#### With previous status
##### we can't use the same tidy because the data format is slightly different
coefs_df2 <- (map(list(waterP = waterP, garbageP = garbageP, toiletP = toiletP)
		, tidy
		, conf.int = TRUE
	)
	%>% bind_rows(.id = "model")
	%>% dotwhisker::by_2sd(wash_consec_df)
	%>% mutate(term = factor(term, levels = unique(term))
		, parameter = term
		, parameter = gsub(".*\\(|\\).*|\\,.*", "", parameter)
		, parameter_new = ifelse(parameter == "Intercept", "Intercept", "Coefs")
	)
	%>% mutate(term = reorder(term, estimate))
)

### Combine 
extract_coefs_df <- (coefs_df1
	%>% bind_rows(coefs_df2)
)
print(extract_coefs_df, n = Inf, width = Inf)

save(file = "garbage_tidy.rda"
	, extract_coefs_df
)
