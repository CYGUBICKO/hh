#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(dplyr)
library(scales)
library(expss)
library(DT)
library(tibble)
library(tidyr)

load("shortData.rda")
## load("loadData.rda")
load("globalFunctions.rda")

#### ---- Filter completed interviews ----

## Interview termination vars

working_df <- (working_df
	%>% filter(intvwresult=="completed")
)

#### ---- Key variables ----

## ID vars
all_varnames <- names(working_df)
id_vars <- grep("_anon$", all_varnames, value = TRUE) # hhid_anon, individualid_anon
print(id_vars)

## Wash vars

### Water source
water_vars <- "drinkwatersource"
table(working_df[, water_vars], useNA = "always")

#### Create new water services variable based on improved/unproved definition
patterns <- c("buy from\\: taps|piped\\:|rainwater"
	, "buy from\\: tanks|well\\:|surface water\\:|other|hawkers"
	, "NIU|miss|don"
)
replacements <- c(1, 0, NA)
working_df <- (working_df
	%>% recodeLabs(water_vars, patterns, replacements, insert = TRUE)
)
table(working_df[, "drinkwatersource_new"], useNA = "always")
prop.table(table(working_df[, "drinkwatersource_new"]))

### Toilet type
toilet_vars <- grep("^toilet_", all_varnames, value = TRUE)
print(toilet_vars)

sapply(working_df[, toilet_vars], function(x)table(x, useNA = "always"))

#### Recode toilet types to binary
patterns <- c("own|flush trench toilet|other\\:disposable|other\\:pottie|other\\:diapers"
	, "shared|toilet without pit/flush|bush|flying toilet|other\\:on paper|other$|other\\:specific"
	, "NIU|miss|don|refused|no members aged"
)
replacements <- c(1, 0, NA)
working_df <- (working_df
	%>% recodeLabs(toilet_vars, patterns, replacements, insert = TRUE)
)

sapply(working_df[, paste0(toilet_vars, "_new")], function(x)table(x, useNA = "always"))

prop.table(table(working_df[, "toilet_5plusyrs_new"]))

### Garbage disposal
garbage_vars <- "garbagedisposal"

table(working_df[, garbage_vars], useNA = "always")

#### Create binary garbage disposal variable
patterns <- c("garbage dump|in private pits|in public pits|garbage disposal services|other\\:national"
	, "in the river|on the road|in drainage/trench/sewage|vacant/abandoned house/plot/field/quarry|no designated place/all over|other\\:railway|other\\:street|other$|burning"
	, "NIU|miss|don"
)
replacements <- c(1, 0, NA)
working_df <- (working_df
	%>% recodeLabs(garbage_vars, patterns, replacements, insert = TRUE)
)

with(working_df, {
	table(garbagedisposal, garbagedisposal_new)
	table(drinkwatersource, drinkwatersource_new)
	table(toilet_5plusyrs, toilet_5plusyrs_new)
})

save(file = "cleaning.rda"
	, working_df
)
