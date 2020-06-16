
library(openxlsx)
library(dplyr)

load("missingCategory_summary.rda")
load("cleaning.rda")

miss_df <- (miss_category_summary
	%>% select(variable, description)
	%>% right_join(.
			, (all_tabs[["miss_df"]] %>% mutate(variable = gsub("\\_new", "", variable))
		)
	)
)

save(file = "overall_missing_tables.rda"
	, miss_df
)
