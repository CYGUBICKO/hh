#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Fit switch data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 Dec 24 (Tue) ----

library(dplyr)
library(tidyr)
library(tibble)

load("washdataStatusPcats.rda")
load("longDFunc.rda")

## Input files:
### 1. wash_df: Original dataset
### 2. wash_consec_df - Assumes all interviews were done consecitvely for all the years in all HH

## Restructured data
long_df <- longDFunc(wash_consec_df)

## All years incorporating previous status category status 
prev_df <- (long_df[["prev_df"]]
	%>% mutate_at("statusP", as.factor)
)
model_df <- model.frame(
	status ~ services
	+ slumarea
	+ gender
	+ age
	+ year
	+ year_scaled
	+ income
	+ foodeaten
	+ hhsize
	+ hhsize_scaled
	+ selfrating
	+ materials
	+ lighting
	+ ownhere
	+ ownelse
	+ shocks
	+ expenditure
	+ hhid
	+ statusP
	, data = prev_df, na.action = na.exclude, drop.unused.levels = TRUE
)

save(file = "washModeldata.rda"
	, model_df
	, scale_mean
	, scale_scale
	, base_year
)

