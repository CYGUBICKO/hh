#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(openxlsx)

load("mergeWash.rda")

## Save tables to excel

tabs <- c(water_tabs, garbage_tabs, toilet_tabs)
xlstarget <- paste0("compareCalculations", ".xlsx")

write.xlsx(tabs, file = xlstarget, row.names = FALSE)

