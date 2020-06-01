library(openxlsx)
load("analysisData.rda")

write.xlsx(var_groups_df, file = "analysis_variables.xlsx", row.names = FALSE)
