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

## Year 1 data
year1_df <- (long_df[["year1_df"]]
	%>% group_by(hhid)
	%>% filter(year == min(year))
	%>% ungroup()
)

year1modData <- model.frame(
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
	+ dwelling_index
	+ ownership_index
	+ shocks_index
	+ total_expenditure
	+ hhid
	, data = year1_df, na.action = na.exclude, drop.unused.levels = TRUE
)

## All years incorporating previous status category status 
prev_df <- (long_df[["prev_df"]]
	%>% mutate_at("statusP", as.factor)
)

prevyearmodData <- model.frame(
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
	+ dwelling_index
	+ ownership_index
	+ shocks_index
	+ total_expenditure
	+ hhid
	+ statusP
	, data = prev_df, na.action = na.exclude, drop.unused.levels = TRUE
)

save(file = "washModeldata.rda"
	, year1modData
	, prevyearmodData
	, scale_mean
	, scale_scale
	, base_year
)

