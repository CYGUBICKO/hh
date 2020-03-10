# This script uses the loadData function to generate .rds file.

library(data.table)
library(haven)
library(reshape2)
library(dplyr)
library(tibble)
library(tidyr)

load("globalFunctions.rda")
load("cleaning.rda")
# load("loadData.rda")

df_name <- "NUHDSS_Wash"
file_extension <- "dta"
df_folder <- "washdata"
df_outname <- "wash_df"

load_df <- loadData(df_name
	, file_extension
  	, df_folder
  	, df_outname
)

wash_df <- load_df[["working_df"]]
washbook <- load_df[["codebook"]]

#### ---- 1. Shorten variable names ----
## Remove hha_*

old_names <- colnames(wash_df)
new_names <- gsub("(?!.^hhid.$)(hhh_*|hha_*)", "", old_names, perl = TRUE)
wash_df <- (wash_df
	%>% setnames(old_names, new_names)
)

washbook <- (washbook
	%>% mutate(variable = gsub("(?!.^hhid.$)(hhh_*|hha_*)", "", variable, perl = TRUE))
)

## SB: Move this code back to wash, and check all of the simple things there

## Each of the wash variables have 3 variables, i.e., one with all categories in 
## the questionnaire, one with shortened categories and the binary one

### Water source

water_all_short <- with(wash_df, {
	table(drinkwatersource, hhwatersource)
})

water_all_cat <- with(wash_df, {
	table(drinkwatersource, cat_hhwatersource)
})

water_short_cat <- with(wash_df, {
	table(hhwatersource, cat_hhwatersource)
})

water_tabs <- list(water_all_short = water_all_short
	, water_all_cat = water_all_cat
	, water_short_cat = water_short_cat
)

### Garbage disposal

garbage_all_short <- with(wash_df, {
	table(garbagedisposal, hhgarbagedisposal)
})

garbage_all_cat <- with(wash_df, {
	table(garbagedisposal, cat_hhgarbagedisposal)
})

garbage_short_cat <- with(wash_df, {
	table(hhgarbagedisposal, cat_hhgarbagedisposal)
})

garbage_tabs <- list(garbage_all_short = garbage_all_short
	, garbage_all_cat = garbage_all_cat
	, garbage_short_cat = garbage_short_cat
)

### Toilet facilities

toilet_all_short <- with(wash_df, {
	table(toilet_5plusyrs, hhtoilettype)
})

toilet_all_cat <- with(wash_df, {
	table(toilet_5plusyrs, cat_hhtoilettype)
})

toilet_short_cat <- with(wash_df, {
	table(hhtoilettype, cat_hhtoilettype)
})

toilet_tabs <- list(toilet_all_short = toilet_all_short
	, toilet_all_cat = toilet_all_cat
	, toilet_short_cat = toilet_short_cat
)

### SB: Next confirm that the hh and wash files are consistent
#### Merge washdata file with hh datafile
#### Merge _on_ hh so we can take advantage of short pathway

## full_df means full width; sometimes we will use the short version because of time
full_df <- left_join(working_df, wash_df
	, by = c("hhid_anon", "intvwyear")
	, suffix = c(".hh", ".wash")
)

## SB: Finally, do calculations (either on merged or just on hh data whichever appropriate)
### Compare hh raw services data to the wash

#### Water services
water_hh_wash <- with(full_df, {
	table(drinkwatersource.hh, drinkwatersource.wash)
})

#### Toilet facilities
toilet_hh_wash <- with(full_df, {
	table(toilet_5plusyrs.hh, toilet_5plusyrs.wash)
})

#### Garbage disposal
garbage_hh_wash <- with(full_df, {
	table(garbagedisposal.hh, garbagedisposal.wash)
})

water_hh_wash_bin <- with(full_df, {
	table(drinkwatersource_new, cat_hhwatersource)
})
water_hh_wash_bin

### Count the number of interviews with different entries for observed vars
full_df <- (full_df
	%>% mutate_at(grep("\\.hh$|\\.wash$", names(.), value = TRUE), as.character)
	%>% mutate(water_diff = ifelse(drinkwatersource.hh == drinkwatersource.wash, 0, 1)
		, toilet_diff = ifelse(toilet_5plusyrs.hh == toilet_5plusyrs.wash, 0, 1)
		, garbage_diff = ifelse(garbagedisposal.hh == garbagedisposal.wash, 0, 1)
	)
)
allcat_diff_tab <- (full_df
	%>% select(grep("\\_diff$", names(.), value = TRUE))
	%>% summarise_all(function(x)sum(x, na.rm = TRUE))
)
allcat_diff_tab

#### Preview some cases with differences
water_int_diff <- (full_df
	%>% filter(water_diff==1)
	%>% select(hhid_anon, drinkwatersource.hh, drinkwatersource.wash, water_diff)
)

### Count the number of interviews with different entries in improved vs unimproved vars 
### for hh and wash
full_df <- (full_df
	%>% mutate_at(grep("\\_new$|^cat\\_", names(.), value = TRUE)
		, function(x){ifelse(grepl("^improved", x, ignore.case = TRUE), "Improved"
			, ifelse(grepl("^unimprove", x, ignore.case = TRUE), "Unimproved", as.character(x))
		)
	})
	%>% mutate(water_diff_bin = ifelse(drinkwatersource_new == cat_hhwatersource, 0, 1)
		, toilet_diff_bin = ifelse(toilet_5plusyrs_new == cat_hhtoilettype, 0, 1)
		, garbage_diff_bin = ifelse(garbagedisposal_new == cat_hhgarbagedisposal, 0, 1)
	)
)
bincat_diff_tab <- (full_df
	%>% select(grep("\\_diff\\_bin$", names(.), value = TRUE))
	%>% summarise_all(function(x)sum(x, na.rm = TRUE))
)
bincat_diff_tab

## Binary

### Water sources
water_hh_wash_bin <- with(full_df, {
	table(drinkwatersource_new, cat_hhwatersource)
})
water_hh_wash_bin

### Toilet facilities
toilet_hh_wash_bin <- with(full_df, {
	table(toilet_5plusyrs_new, cat_hhtoilettype)
})
toilet_hh_wash_bin

### Garbage disposal
garbage_hh_wash_bin <- with(full_df, {
	table(garbagedisposal_new, cat_hhgarbagedisposal)
})
garbage_hh_wash_bin

## Put all the tabs together to export
hh_wash_tabs <- list(allcat_diff_tab = allcat_diff_tab
	, water_hh_wash = water_hh_wash
	, toilet_hh_wash = toilet_hh_wash
	, garbage_hh_wash = garbage_hh_wash
	, water_int_diff = water_int_diff
	, bincat_diff_tab = bincat_diff_tab
	, water_hh_wash_bin = water_hh_wash_bin
	, toilet_hh_wash_bin = toilet_hh_wash_bin
	, garbage_hh_wash_bin = garbage_hh_wash_bin
)

## Wealth index

wealthindex_summary <- (full_df
	%>% select(wealthindex.hh, wealthindex.wash)
	%>% mutate_at(names(.), as.numeric)
	%>% summarise_all(list(~ min(., na.rm = TRUE), ~ median(., na.rm = TRUE), ~max(., na.rm = TRUE)))
	%>% data.frame()
)
wealthindex_summary


save(file = "mergeWash.rda" 
	, water_tabs
	, garbage_tabs
	, toilet_tabs
	, hh_wash_tabs
	, full_df
)
