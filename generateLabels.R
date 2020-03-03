#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(openxlsx)

load("shortData.rda")
## load("loadData.rda")

### ---- Generate labels codebook ----

## oldpatterns: exact old label or grep-like pattern within each group. Similar cats are separated by | 
## Details: oldpatterns and newlabs are in the same order

genlabsCodes <- function(df, var, oldpatterns, newlabs){
	lab_df <- data.frame(oldlabs = unique(df[[var]]), newlabs = unique(df[[var]]))
	for (p in seq_along(oldpatterns)){
		lab_df[["newlabs"]] <- ifelse(grepl(oldpatterns[[p]],  lab_df[["oldlabs"]])
			, newlabs[[p]]
			, lab_df[["newlabs"]]
		)
	}
	colnames(lab_df) <- c(var, paste0(var, "_new"))
	return(lab_df)
}

#### ---- Key variables ----

### Water source
water_vars <- "drinkwatersource"
oldpatterns <- c("buy from\\: taps|piped\\:"
	, "buy from\\: tanks|well\\:|surface water\\:|other|hawkers|rainwater|^don"
	, "NIU|miss"
)
newlabs <- c("Improved", "Unimproved", NA)

water_labs <- genlabsCodes(df = working_df
	, var = water_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Garbage disposal
garbage_vars <- "garbagedisposal"
oldpatterns <- c("garbage dump|private pits|public pits|disposal services|\\:national"
	, "the river|the road|in drainage|vacant/abandoned|no designated place|other\\:railway|other\\:street|other$|burning|^don"
	, "NIU|miss"
)
newlabs <- c("Improved", "Unimproved", NA)

garbage_labs <- genlabsCodes(df = working_df
	, var = garbage_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Toilet facilities
toilet_vars <- "toilet_5plusyrs"
oldpatterns <- c("flush\\:|ventilated|other\\:disposable"
	, "^traditional|flush trench|toilet without|bush|flying toilet|other\\:pottie|other\\:on |other$|^don"
	, "NIU|miss|refused"
)
newlabs <- c("Improved", "Unimproved", NA)

toilet_labs <- genlabsCodes(df = working_df
	, var = toilet_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

all_labs <- list(water_labs = water_labs
	, garbage_labs = garbage_labs
	, toilet_labs = toilet_labs
)
write.xlsx(all_labs, file = "generateLabels.xlsx", row.names = FALSE)

save(file = "generateLabels.rda"
	, water_labs
	, garbage_labs
	, toilet_labs
)
