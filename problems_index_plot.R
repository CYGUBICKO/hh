#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(ggplot2)
library(dplyr)

load("problems_index.rda")

prob_df <- data.frame(prob = problems_index)
problems_index_plot <- (ggplot(prob_df, aes(x = prob))
   + geom_histogram()
   + labs(x = "Shcok/problems", y = "Count")
)
print(problems_index_plot)


save(file = "problems_index_plot.rda"
	, problems_index_plot
)
