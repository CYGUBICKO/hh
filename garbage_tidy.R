#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Tidy Model estimates ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(dplyr)
library(tidyr)
library(tibble)
library(purrr)
library(broom)

library(splines)

## No previous status
load("garbage_glm.rda")
garbage_model <- garbage_glm_model

## With previous status
load("garbageP_glm.rda")
garbageP_model <- garbageP_glm_model

### Extract coefficients
#### No previous status
coefs_df1 <- (map(list(gab = garbage_model)
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
coefs_df2 <- (map(list(gabP = garbageP_model)
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
