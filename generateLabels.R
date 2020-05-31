#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(openxlsx)

# load("shortData.rda")
load("loadData.rda")

### ---- Generate labels codebook ----

## oldpatterns: exact old label or grep-like pattern within each group. Similar cats are separated by | 
## Details: oldpatterns and newlabs are in the same order

genlabsCodes <- function(df, var, oldpatterns, newlabs){
	lab_df <- data.frame(oldlabs = unique(df[[var]]), newlabs = unique(df[[var]]))
	for (p in seq_along(oldpatterns)){
		lab_df[["newlabs"]] <- ifelse(grepl(oldpatterns[[p]],  lab_df[["oldlabs"]])
			, newlabs[[p]]
			, as.character(lab_df[["newlabs"]])
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

### Main material of the floor
floor_vars <- "floormaterial"
oldpatterns <- c("^natural\\:"
	, "^rudimentary\\:"
	, "^finished\\:"
	, "^other"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("Natural", "Rudimentary", "Finished", "Other", NA)

floor_labs <- genlabsCodes(df = working_df
	, var = floor_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Main material of the roof
roof_vars <- "roofmaterial"
oldpatterns <- c("^natural\\:"
	, "^rudimentary\\:"
	, "^finished\\:"
	, "^other"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("Natural", "Rudimentary", "Finished", "Other", NA)

roof_labs <- genlabsCodes(df = working_df
	, var = roof_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Main material of the wall
wall_vars <- "wallmaterial"
oldpatterns <- c("^natural\\:"
	, "^rudimentary\\:"
	, "^finished\\:"
	, "^other"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("Natural", "Rudimentary", "Finished", "Other", NA)

wall_labs <- genlabsCodes(df = working_df
	, var = wall_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Main source of cooking fuel
cook_vars <- "cookingfuel"
oldpatterns <- c("^electricity\\:"
	, "charcoal"
	, "^animal|^crop"
	, "^other"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("electricity", "charcoal", "animal/crop residue", "others", NA)

cook_labs <- genlabsCodes(df = working_df
	, var = cook_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Main source of lighting
light_vars <- "lighting"
oldpatterns <- c("^electricity\\:"
	, "charcoal|firewood"
	, "^other"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("electricity", "charcoal/firewood", "others", NA)

light_labs <- genlabsCodes(df = working_df
	, var = light_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Dwelling/rentals
rent_vars <- "rentorown"
oldpatterns <- c("^owned\\:"
	, "^renting from\\:"
	, "^free of charge"
	, "^other"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("Owned", "Rental", "Free", "Others", NA)

rent_labs <- genlabsCodes(df = working_df
	, var = rent_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Household income
inc30days_vars <- "inc30days_total"
oldpatterns <- c("^NIU|^miss|refused|^don")
newlabs <- c(NA)

inc30days_labs <- genlabsCodes(df = working_df
	, var = inc30days_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Grow crops
grewcrops_vars <- "grewcrops"
oldpatterns <- c("^NIU|^miss|refused|^don")
newlabs <- c(NA)

grewcrops_labs <- genlabsCodes(df = working_df
	, var = grewcrops_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### 5.11: Food in the last 30 days
foodeaten30days_vars <- "foodeaten30days"
oldpatterns <- c("^had enough"
	, "^didn\\'t have enough"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("Had enough", "Didn't have enough", NA)

foodeaten30days_labs <- genlabsCodes(df = working_df
	, var = foodeaten30days_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### 5.12: HH gone hungry because no money to buy food
hh30days_nofoodmoney_vars <- "30days_nofoodmoney"
oldpatterns <- c("^often|^sometimes"
	, "^never"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("Yes", "No", NA)

hh30days_nofoodmoney_labs <- genlabsCodes(df = working_df
	, var = hh30days_nofoodmoney_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Respondent ladder
selfrating_vars <- "selfrating"
oldpatterns <- c("^very poor"
	, "^very rich"
	, "^NIU|^miss|refused|^don"
)
newlabs <- c("1", "10", NA)

selfrating_labs <- genlabsCodes(df = working_df
	, var = selfrating_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

## Save .xlsx file for all
all_labs <- list(water_labs = water_labs
	, garbage_labs = garbage_labs
	, toilet_labs = toilet_labs
	, floor_labs = floor_labs
	, roof_labs = roof_labs
	, wall_labs = wall_labs
	, cook_labs = cook_labs
	, light_labs = light_labs
	, rent_labs = rent_labs
	, inc30days_labs = inc30days_labs
	, grewcrops_labs = grewcrops_labs
	, foodeaten30days_labs = foodeaten30days_labs
	, hh30days_nofoodmoney_labs = hh30days_nofoodmoney_labs
	, selfrating_labs = selfrating_labs
)
write.xlsx(all_labs, file = "generateLabels.xlsx", row.names = FALSE)

save(file = "generateLabels.rda"
	, water_labs
	, garbage_labs
	, toilet_labs
	, floor_labs
	, roof_labs
	, wall_labs
	, cook_labs
	, light_labs
	, rent_labs
	, inc30days_labs
	, grewcrops_labs
	, foodeaten30days_labs
	, hh30days_nofoodmoney_labs
	, selfrating_labs
)
