#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)

load("cleanData.rda")

## Expenditure
expenditure_df <- (working_df_complete
	%>% select(!!expenditure_group_vars, total_expenditure)
)
str(expenditure_df)

total_expenditure <- drop(expenditure_df[["total_expenditure"]])
summary(total_expenditure)

save(file = "expenditure_index.rda"
	, total_expenditure
	, total_expend_drop_lower
	, total_expend_drop_upper
)
