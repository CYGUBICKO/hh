#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(openxlsx)

# load("shortData.rda")
load("loadData.rda")
load("globalFunctions.rda")

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
#oldpatterns <- c("^natural\\:earth\\/mud\\/dung\\/sand"
#	, "^rudimentary\\:gunny bags:"
#	, "^rudimentary\\:woven mat \\(sisal\\/nylon\\)"
#	, "^rudimentary\\:carton\\/plastic sheets"
#	, "^rudimentary\\:wood planks"
#	, "^finished\\:vinyl \\(PVC\\)\\/asphalt strips"
#	, "^finished\\:asbestos sheet"
#	, "^finished\\:cement\\/concrete \\(tiles\\/slab\\)"
#	, "^finished\\:polished wood\\/tiles\\/carpet"
#	, "^NIU|refused|^don|^other"
#)
#newlabs <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", NA)
oldpatterns <- c("^natural\\:"
	, "^rudimentary\\:"
	, "^finished\\:"
	, "^NIU|refused|^don|^other"
)
newlabs <- c("1", "2", "3", NA)

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
	, "^NIU|refused|^don|^other"
)
newlabs <- c("1", "2", "3", NA)

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
	, "^NIU|refused|^don|^other"
)
newlabs <- c("1", "2", "3", NA)

wall_labs <- genlabsCodes(df = working_df
	, var = wall_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Main source of cooking fuel
cook_vars <- "cookingfuel"
oldpatterns <- c("^crop|^animal|^other\\:|^firewood"
	, "^kerosene\\/paraffin|^charcoal|^briquettes"
	, "electricity\\:|gas"
	, "^NIU|refused|^don|other$"
)
newlabs <- c("1", "2", "3", NA)

cook_labs <- genlabsCodes(df = working_df
	, var = cook_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Main source of lighting
light_vars <- "lighting"
oldpatterns <- c("^other\\:|^firewood"
	, "^kerosene\\/paraffin|^charcoal|^candles"
	, "electricity\\:|gas"
	, "^NIU|refused|^don|other$"
)
newlabs <- c("1", "2", "3", NA)

light_labs <- genlabsCodes(df = working_df
	, var = light_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Dwelling/rentals
rent_vars <- "rentorown"
oldpatterns <- c("^free of charge\\:|^other\\:|free of charge"
	, "^renting from\\:"
	, "^owned"
	, "^NIU|refused|^don|other$"
)
newlabs <- c("1", "2", "3", NA)

rent_labs <- genlabsCodes(df = working_df
	, var = rent_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Household income
inc30days_vars <- "inc30days_total"
oldpatterns <- c("<KES 1,000"
	, "KES 1,000-2,499"
	, "KES 2,500-4,999"
	, "KES 5,000-7,499"
	, "KES 7,500-9,999"
	, "KES 10,000-14,999"
	, "KES 15,000-19,999"
	, "KES 20,000+"
	, "^NIU|refused|^don"
)
newlabs <- c("1", "2", "3", "4", "5", "6", "7", "8", NA)

inc30days_labs <- genlabsCodes(df = working_df
	, var = inc30days_vars
	, oldpatterns = oldpatterns
	, newlabs = newlabs
)

### Grow crops
grewcrops_vars <- "grewcrops"
oldpatterns <- c("^NIU|refused|^don")
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
	, "^NIU|refused|^don"
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
	, "^NIU|refused|^don"
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
	, "^miss"
	, "^NIU|refused|^don"
)
newlabs <- c("1", "10", "9999995", NA)

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
