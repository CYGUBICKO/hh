#### ---- Project: APHRC HH Data ----
#### ---- Task: Data cleaning and preparation ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 29 (Sat) ----

library(openxlsx)

load("mergeWash.rda")

## Save tables to excel
xlstarget <- paste0("hhWashcompare", ".xlsx")
write.xlsx(hh_wash_tabs, file = xlstarget, row.names = FALSE)

