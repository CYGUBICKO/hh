#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform MCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(ggplot2); source("funs/ggplot_theme.R"); ggtheme()
library(ggplot2)
library(dplyr)

load("problems_ever_index.rda")

prob_df <- data.frame(prob = problems_ever_index)
summary(problems_ever_index)
problems_ever_index_plot <- (ggplot(prob_df, aes(x = as.numeric(prob)))
   + geom_histogram(binwidth = 1)
#	+ xlim(limits = range(problems_index, na.rm = TRUE))
   + labs(x = "Shcok/problems ever experienced", y = "Count")
)
print(problems_ever_index_plot)


save(file = "problems_ever_index_plot.rda"
	, problems_ever_index_plot
)
