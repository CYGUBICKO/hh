library(data.table)
library(openxlsx)
library(dplyr)


miss_over30percent <- 30

miss_df <- (miss_category_summary
	%>% select(-Total)
	%>% right_join(.
			, (all_tabs[["miss_df"]] %>% mutate(variable = gsub("\\_new", "", variable))
		)
	)
	%>% setnames(c("miss_count", "miss_prop"), c("total_count", "total_prop"))
	%>% mutate(miss_over30percent = ifelse(total_prop >= miss_over30percent, "Yes", "No"))
)
save(file = "overall_missing_tables.rda"
	, miss_df
)
