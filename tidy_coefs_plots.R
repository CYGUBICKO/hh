#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Plot model efffect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 12 (Wed) ----

library(ggplot2)
library(dplyr)

source("funs/ggplot_theme.R"); ggtheme()

load("tidy_coefs.rda")
load("combineanova_tabs.rda")

### Function to plot for different model classes i.e., glm and glmer
effectsizeFunc <- function(df, col_lab = ""){
	estimates_df <- df
	parameters <- pull(estimates_df, parameter) %>% unique()
	estimates_df <- (estimates_df
		%>% mutate(parameter = factor(parameter, levels = parameters, labels = parameters)
#			, parameter = gsub(parameter_new, "", parameter)
		)
	)
	
	pos <- ggstance::position_dodgev(height=0.5)

	p1 <- (ggplot(estimates_df, aes(x = estimate, y = model, colour = parameter))
		+ geom_point(position = pos)
		+ ggstance::geom_linerangeh(aes(xmin = conf.low, xmax = conf.high), position = pos)
		+ scale_colour_brewer(palette="Dark2"
			, guide = guide_legend(reverse = TRUE)
		)
		+ geom_vline(xintercept=0,lty=2)
		+ labs(x = "Estimate"
			, y = ""
			, colour = col_lab
		)
		+ facet_wrap(~term, scale = "free_x")
		+ theme(legend.position = "bottom")
	)
	return(p1)
}

## Combine anova data with coefs for variable p-value
var_pattern <- unique(anova_tabs$vars)
var_pattern <- paste0(var_pattern, collapse = "|")
var_pattern

extract_coefs_df <- (extract_coefs_df 
	%>% filter(effect != "ran_pars")
	%>% mutate(term2 = ifelse(grepl("StatusP", term), "StatusP", as.character(parameter))
		, vars1 = gsub(".*\\:|.*\\(|\\,.*|\\).*", "", term)
		, vars = gsub(var_pattern, "", vars1)
		, vars = ifelse(vars=="", vars1, stringr::str_remove(term2, vars))
	)
	%>% left_join(anova_tabs, by = c("model", "vars"))
	%>% mutate(ll = sprintf("(P=%5.3f)", `Pr..Chisq.`)
		, ll = sub("=0.000", "<0.001", ll)
		, ll = paste(model, ll)
		, ll = ifelse(`Pr..Chisq.` < 0.05, paste(ll, "*", sep="")
			, ifelse(`Pr..Chisq.` < 0.01, paste(ll, "*", sep="")
				, ll
			)
		)
		, model = ifelse(!is.na(ll), ll, model) 
	)
	%>% select(-vars1, -ll)
	%>% data.frame()
)
head(extract_coefs_df)

## All effect plots
pred_names <- unique(extract_coefs_df$term2)
names(pred_names) <- pred_names

pyreffectsize_plots <- lapply(pred_names, function(x){
	dd <- (extract_coefs_df
		%>% filter(term2 == x)
	)
	effectsizeFunc(dd, x)
})
pyreffectsize_plots

save(file = "tidy_coefs_plots.rda"
	, pyreffectsize_plots
)
