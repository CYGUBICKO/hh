#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(dplyr)
library(tidyr)

load("loadData.rda")

set.seed(9122)

#### ---- Filter completed interviews ----

household <- (working_df 
	%>% select(hhid_anon)
	%>% distinct()
	%>% sample_n(1000)
)

summary(household)

working_df <- left_join(household, working_df)

save(file="shortData.rda"
	, working_df, codebook
)
