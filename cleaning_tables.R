library(openxlsx)
load("cleaning.rda")

write.xlsx(all_tabs, file = "cleaning_tables.xlsx", row.names = FALSE)

