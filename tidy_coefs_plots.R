#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Plot model efffect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Feb 12 (Wed) ----

library(ggplot2)
library(dplyr)

source("funs/ggplot_theme.R"); ggtheme()

load("tidy_coefs.rda")

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

extract_coefs_df <- (extract_coefs_df 
	%>% filter(effect != "ran_pars")
	%>% mutate(vars = ifelse(grepl("StatusP", term), "StatusP", as.character(parameter)))
)

## All effect plots
pred_names <- unique(extract_coefs_df$vars)
names(pred_names) <- pred_names

pyreffectsize_plots <- lapply(pred_names, function(x){
	dd <- (extract_coefs_df
		%>% filter(vars == x)
	)
	effectsizeFunc(dd, x)
})
pyreffectsize_plots

save(file = "tidy_coefs_plots.rda"
	, pyreffectsize_plots
)
