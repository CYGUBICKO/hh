#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(ggplot2)
library(dplyr)

load("expenditure_index.rda")

expend_df <- data.frame(expend = total_expenditure)
total_expenditure_index_plot <- (ggplot(expend_df, aes(x = expend))
   + geom_histogram()
   + labs(x = "Total expenditure", y = "Count")
)
print(total_expenditure_index_plot)


save(file = "expenditure_index_plot.rda"
	, total_expenditure_index_plot
)
