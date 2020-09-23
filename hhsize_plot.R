#### ---- Project: APHRC HH Data ----
#### ---- Task: HH size after dropping outliers ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----


library(ggplot2); source("funs/ggplot_theme.R"); ggtheme()
library(dplyr)

load("cleanData.rda")

hhsize_plot <- (ggplot(working_df_complete, aes(x = numpeople_total_new))
   + geom_histogram()
   + labs(x = "HH size", y = "Count")
)
print(hhsize_plot)


save(file = "hhsize_plot.rda"
	, hhsize_plot
)
