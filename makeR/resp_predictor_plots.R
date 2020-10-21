#### ---- Project: APHRC HH Data ----
#### ---- Task: Plot response - predictors ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Oct 20 (Tue) ----

library(data.table)
library(dplyr)
library(scales)
library(ggplot2); theme_set(theme_bw())

## Use complete dataset


summaryFunc <- function(resp_var, pred_var){
	summary_df <- (wash_df
		%>% select(!!c(resp_var, pred_var))
		%>% rename("resp" = resp_var, "pred" = pred_var)
		%>% mutate(resp = ifelse(resp=="Improved", 1, 0))
		%>% group_by(pred)
		%>% summarise(prop = mean(resp, na.rm = TRUE))
		%>% ungroup()
		%>% mutate(services = resp_var)
	)
	return(summary_df)	
}

summaryPlot <- function(pred_var, xlab = ""){
	df <- lapply(c("drinkwatersource", "garbagedisposal", "toilet_5plusyrs"), summaryFunc, pred_var)
	df <- (bind_rows(df)	
		%>% mutate(services = gsub("drink|\\_new", "", services)
			, services = ifelse(grepl("toilet\\_", services), "toilettype", services)
		)
	)
	## Plot
	prop_plot <- (ggplot(df, aes_string(x = "pred", y = "prop", colour = "services", group = "services"))
		+ geom_point()
		+ geom_line()
		+ labs(x = xlab, y = "Proportions of\nimproved services"
			, colour = "Services"
		)
		+ scale_y_continuous(labels = percent, limits = c(0,1))
		+ scale_colour_discrete(breaks = c("watersource"
				, "garbagedisposal"
				, "toilettype"
			)
		)
		+ theme(legend.position = "bottom"
			, plot.title = element_text(hjust = 0.5)
		)
	)
	return(prop_plot)
}

## HH size
summaryPlot("numpeople_total", "HHsize")

## Age
summaryPlot("ageyears", "Age")

## Self rating
summaryPlot("selfrating", "Selfrating")

## Shocks
summaryPlot("shocks", "Total shocks")

## Shocks
summaryPlot("shocks_ever", "Ever experienced any shock (total)")

## Income
summaryPlot("inc30days_total", "Income")

## Expenditure
summaryPlot("expenditure", "Expenditure")

## materials
summaryPlot("materials", "Materials")

## Ownhere
summaryPlot("ownhere", "Ownhere")

## Ownhere
summaryPlot("ownelse", "Ownelse")

