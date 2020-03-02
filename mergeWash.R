# This script uses the loadData function to generate .rds file.

library(data.table)
library(haven)
library(reshape2)
library(dplyr)
library(tibble)
library(tidyr)

load("globalFunctions.rda")
load("cleaning.rda")
names(working_df)
## load("loadData.rda")

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
summary(wash_df)

with(wash_df, {
	table(garbagedisposal, cat_hhgarbagedisposal)
})

### SB: Next confirm that the hh and wash files are consistent
#### Merge washdata file with hh datafile
#### Merge _on_ hh so we can take advantage of short pathway

names(wash_df)
names(working_df)
print(intersect(
	names(wash_df)
	, names(working_df)
))

## full_df means full width; sometimes we will use the short version because of time
full_df <- left_join(working_df, wash_df
	, by = c("hhid_anon", "intvwyear")
	, suffix = c(".hh", ".wash")
)

summary(full_df)

## SB: Finally, do calculations (either on merged or just on hh data whichever appropriate)
