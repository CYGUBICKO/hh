#### ---- Project: APHRC Wash Data ----
#### ---- Task: Data reshaping ----
#### ---- Fit switch data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jun 05 (Fri) ----

library(dplyr)
library(tidyr)
library(data.table)
library(tibble)

load("globalFunctions.rda")
load("washData.rda")

## Input files: cleaned wash_df

### Additional variable names cleaning

base_year <- 2005
wash_df <- (wash_df
	%>% setnames(names(.), gsub(".*_hh|.*hhd|_anon|is|intvw|years|drink", "", names(.)))
	%>% setnames(old = c("numpeople_total", "toilet_5plusyrs", "inc30days_total", "foodeaten30days")
		, new = c("hhsize", "toilettype", "income", "foodeaten")
	)
	%>% mutate(year = as.numeric(as.character(year)) - base_year
		, hhsize_scaled = hhsize
		, year_scaled = year
	)
	%>% mutate_at(c("watersource", "toilettype", "garbagedposal"), function(x){
		ifelse(x=="Improved", 1, 0)
	})
)
head(wash_df)


## Scale numeric variables
scale_vars <- c("year_scaled"
	, "age"
	, "hhsize_scaled"
	, "selfrating"
	, "shocks"
	, "expenditure"
)

scaled_df <- scale(wash_df[, scale_vars])
scaled_df_temp <- (drop(scaled_df)
	%>% data.frame()
	%>% mutate(hhid = wash_df$hhid
		, year = wash_df$year
	)
)

### Mean and scale used for scaling
scale_mean <- attr(scaled_df, "scaled:center")
scale_scale <- attr(scaled_df, "scaled:scale")

## Merge scaled variables to the main dataset
temp_vars <- colnames(wash_df)[!colnames(wash_df) %in% scale_vars]
wash_df <- (wash_df
	%>% select(!!temp_vars)
	%>% left_join(., scaled_df_temp, by = c("hhid", "year"))
)

## Restructure the data to have the services in current and previous year in a row per hhid

### Case 1: Adjust for missing consecutive interviews
prevdat <- (wash_df
	%>% transmute(hhid = hhid
		, year = year + 1
		, watersourceP = watersource
		, toilettypeP = toilettype
		, garbagedposalP = garbagedposal
	)
)

wash_consec_df <- (wash_df
	%>% left_join(prevdat, by = c("hhid", "year"))
	%>% group_by(hhid)
	%>% mutate(n = n()
		, nprev_miss1 = sum(is.na(watersourceP))
	)
	%>% ungroup()
	%>% mutate(hhid = as.factor(hhid))
	%>% data.frame()
)
head(wash_consec_df, n = 50)

save(file = "washdataInspect.rda"
	, wash_consec_df
	, wash_df
	, scale_mean
	, scale_scale
	, base_year
)
