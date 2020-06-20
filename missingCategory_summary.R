#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(purrr)
library(dplyr)
library(tibble)
library(tidyr)

load("globalFunctions.rda")
# load("shortData.rda")
load("loadData.rda")


#### ---- Filter completed interviews ----

## Interview termination vars
years_drop <- c("2002", "2003", "2004", "2005")
working_df <- (working_df
	%>% filter(intvwresult=="completed" & (!intvwyear %in% years_drop))
	%>% group_by(hhid_anon, intvwyear)
	%>% mutate(nn = n()
		, intvwdate = as.Date(intvwdate)
		, keep = ifelse(nn==1|intvwdate==max(intvwdate), 1, 0)
	)
	%>% ungroup()
)

## More than 1 HH interview per year
tab_intperyear <- as.data.frame(table(working_df$nn))
print(tab_intperyear)

## Keep latest interview per HH per year
working_df <- (working_df
	%>% filter(keep==1)
	%>% select(-nn, -keep)
)

#### ---- Missing per missing value indicator ----
miss_pattern <- list(miss_impute = "^missing\\:impute"
	, refused = "^refused"
	, dont_know = "^Don\\'t know"
	, NIU = "^NIU"
)
miss_category_summary <- lapply(seq_along(miss_pattern), function(x){
	tab <- missPattern(working_df, miss_pattern[[x]])
	tab <- (tab
		%>% select(-miss_count)
		%>% arrange(desc(miss_prop))
	)
	colnames(tab) <- c("variable", names(miss_pattern)[[x]])
	return(tab)
})

## NAs
na_tab <- (working_df 
	%>% NAProps(.)
	%>% select(-miss_count)
	%>% arrange(desc(miss_prop))
	%>% rename(NAs = miss_prop)
)
miss_category_summary[["NAs"]] <- na_tab

miss_category_summary <- (miss_category_summary 
	%>% reduce(full_join, by = "variable")
)
miss_category_summary <- (codebook
	%>% full_join(miss_category_summary, by = "variable")
	%>% rowwise()
	%>% mutate(Total = sum(miss_impute, refused, dont_know, NIU, NAs, na.rm = TRUE))
	%>% arrange(desc(Total))
)
miss_category_summary

save(file = "missingCategory_summary.rda"
	, working_df
	, tab_intperyear
	, miss_category_summary
)
