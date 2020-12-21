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

base_year <- min(as.numeric(as.character(wash_df$intvwyear)))-1
print(base_year)

wash_df <- (wash_df
	%>% setnames(names(.), gsub(".*_hh|.*hhd|_anon|is|intvw|years|drink", "", names(.)))
	%>% setnames(old = c("numpeople_total", "toilet_5plusyrs", "inc30days_total", "foodeaten30days")
		, new = c("hhsize", "toilettype", "income", "foodeaten")
	)
	%>% mutate(year = as.numeric(as.character(year)) - base_year
		, hhsize_scaled = drop(scale(hhsize))
		, log_hhsize = log(hhsize)
		, year_scaled = drop(scale(year))
		, age_scaled = drop(scale(age))
		, selfrating_scaled = drop(scale(selfrating))
		, shocks_scaled = drop(scale(shocks))
		, expenditure_scaled = drop(scale(expenditure))
		, indid = 1:n()
	)
	%>% mutate_at(c("watersource", "toilettype", "garbagedposal"), function(x){
		as.numeric(ifelse(x=="Improved", 1, ifelse(x=="Unimproved", 0, x)))
	})
)
sapply(wash_df[,c("watersource", "toilettype", "garbagedposal")], table)
head(wash_df)
max(wash_df$indid)


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
	, base_year
)
