library(openxlsx)

load("analysisData.rda")

write.xlsx(var_groups_df, file = "analysis_variables.xlsx", row.names = FALSE)

save(file = "analysis_variables.rda"
	, miss_percase_df
	, miss_peryear_df
	, tab_intperyear
	, miss_category_summary_df
	, var_groups_df
)
