#### ---- Project: APHRC Wash Data ----
#### ---- Task: Cleaning raw data ----
#### ---- Fit switch data ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Mar 01 (Sun) ----

library(data.table)
library(dplyr)
library(tidyr)
library(tibble)

library(ggplot2)
theme_set(theme_bw() +
	theme(panel.spacing=grid::unit(0,"lines")))
library(scales)

load("cleaning.rda")

summaryFunc <- function(var){
	summary_df <- (working_df
		%>% mutate(intvwyear = as.numeric(intvwyear))
		%>% mutate_at(var, as.numeric)
		%>% select(var, intvwyear)
		%>% rename("temp_var" = var)
		%>% group_by(intvwyear)
		%>% summarise(prop = mean(temp_var, na.rm = TRUE))
		%>% mutate(services = var, overall = mean(prop))
	)
	return(summary_df)
}

#### ---- Overall service proportion per year ----

service_props <- lapply(c("drinkwatersource_new", "garbagedisposal_new", "toilet_5plusyrs_new"), summaryFunc)
service_props_df <- do.call(rbind, service_props)

prop_plot <- (ggplot(service_props_df, aes(x = factor(intvwyear, levels = 1:14, labels = 2002:2015), y = prop, group = services, colour = services))
	+ geom_point()
	+ geom_line()
	+ geom_hline(aes(yintercept = overall, group = services, colour = services), linetype = "dashed")
	+ geom_text(aes(x = max(intvwyear)-1, y = overall, group = services, label = paste0("Overall = ", scales::percent(overall)))
		, vjust = -1.5
		, show.legend = FALSE
	)
	+ labs(x = "Years"
		, y = "Proportions of\nimproved services"
		, colour = "Services"
	)
	+ scale_y_continuous(labels = percent, limits = c(0,1))
	+ scale_colour_discrete(breaks = c("drinkwatersource_new"
			, "garbagedisposal_new"
			, "toilet_5plusyrs_new"
		)
	)
	+ theme(legend.position = "bottom"
		, plot.title = element_text(hjust = 0.5)
	)
)
print(prop_plot)


