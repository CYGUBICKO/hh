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

load("mergeWash.rda")

summaryFunc <- function(var){
	summary_df <- (full_df
		%>% filter(grepl("^improve|^unimprove", .data[[var]], ignore.case = TRUE))
		%>% mutate(intvwyear = as.numeric(intvwyear))
		%>% mutate_at(var, function(x)ifelse(grepl("^improve", x, ignore.case = TRUE), 1, 0))
		%>% select(var, intvwyear)
		%>% rename("temp_var" = var)
		%>% group_by(intvwyear)
		%>% summarise(prop = mean(temp_var, na.rm = TRUE))
		%>% mutate(services = var, overall = mean(prop))
	)
	return(summary_df)
}

#### ---- Overall service proportion per year ----

## Wash
wash_prop <- lapply(c("cat_hhwatersource", "cat_hhgarbagedisposal", "cat_hhtoilettype"), summaryFunc)
wash_prop_df <- (bind_rows(wash_prop)
	%>% mutate(services = gsub("cat\\_hh", "", services)
		, df = "wash"
	)
)

## HH
hh_prop <- lapply(c("drinkwatersource_new", "garbagedisposal_new", "toilet_5plusyrs_new"), summaryFunc)
hh_prop_df <- (bind_rows(hh_prop)
	%>% mutate(services = gsub("drink|\\_new", "", services)
		, services = ifelse(grepl("toilet\\_", services), "toilettype", services)
		, df = "hh"
	)
)


### Combine wash and HH
prop_df <- bind_rows(wash_prop_df, hh_prop_df)
prop_df

## SB -> JD: Should the denominator be the number of HH?

prop_plot <- (ggplot(prop_df, aes(x = intvwyear, y = prop, colour = services, lty=df))
	+ geom_point()
	+ geom_line()
	+ geom_hline(aes(yintercept = overall, colour = services, lty = df))
#	+ geom_text(aes(x = max(intvwyear)-1, y = overall, label = paste0("Overall = ", scales::percent(overall)))
#		, vjust = -1.5
#		, show.legend = FALSE
#	)
	+ labs(x = "Years"
		, y = "Proportions of\nimproved services"
		, colour = "Services"
	)
	+ scale_y_continuous(labels = percent, limits = c(0,1))
	+ scale_colour_discrete(breaks = c("watersource"
			, "garbagedisposal"
			, "toilettype"
		)
	)
#	+ facet_wrap(~df)
	+ theme(legend.position = "bottom"
		, plot.title = element_text(hjust = 0.5)
	)
)
print(prop_plot)


