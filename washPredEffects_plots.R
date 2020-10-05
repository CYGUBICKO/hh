#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(scales)
library(ggplot2)
theme_set(theme_bw() +
	theme(panel.spacing=grid::unit(0,"lines")))
library(ggpubr)

library(dplyr)
library(effects)
library(lme4)
library(splines)

source("funs/ggplot_theme.R"); ggtheme()
load("washPredEffects.rda")

### Plot effects
logist_format <- function() {
	function(x) round(plogis(x), 3)
}

plotEffects <- function(df, var, xlabs){
	pos <- position_dodge(0.5)
	p1 <- (ggplot(df, aes_string(x = var, y = "fit", group = "services"))
		+ scale_color_discrete(breaks = c("toilettype", "garbagedposal", "watersource"))
		+ scale_y_continuous(labels = logist_format(), breaks = breaks_pretty(4))
		+ labs(x = xlabs
			, y = "Probability of\nimproved service"
			, colour = "Services"
		)
		+ guides(colour = FALSE)
		+ theme(legend.position = "bottom")
	)
	if (grepl("numeric|integer", class(df[[var]]))){
		p2 <- (p1
			+ geom_smooth(aes(ymin = lower, ymax = upper, fill = services, colour = services)
				, stat = "identity"
				, size = 0.5
			)
			+ guides(fill = FALSE)
			+ facet_wrap(~services, scales = "free_y")
#			+ facet_theme
		)
	} else {
		p2 <- (p1 + geom_point(size = 0.6)
			+ geom_line(aes(colour = services))
			+ geom_errorbar(aes(ymin = lower, ymax = upper, colour = services), width = 0)
#			+ coord_flip()
			+ facet_wrap(~services, scales = "free_y")
#			+ facet_theme
		)
#		p2 <- (ggplot(df %>% rename(xvar = var), aes(y = xvar, x = fit, colour = services))
#			+ geom_point(position = pos)
#			+ scale_x_continuous(labels = logist_format())
#			+ ggstance::geom_linerangeh(aes(xmin = lower, xmax = upper)
#				, size = 2/5
#				, position = pos
#			)
#			+ coord_flip()
#			+ labs(y = xlabs
#				, x = "Probability of\nimproved service"
#				, colour = "Services"
#			)
#			+ facet_wrap(~services)
#			+ facet_theme
#		)
	}
	return(p2)
}


## Previous year model
### Service level
pyrservice_plot <- (ggplot(pyrservice_effect_df, aes(x = services, y = fit))
	+ geom_errorbar(aes(ymin = lower, ymax = upper), width = 0, colour = "steelblue3")
	+ geom_point(colour = "blue")
	+ scale_x_discrete(limits = c("toilettype", "garbagedposal", "watersource"))
	+ scale_y_continuous(labels = logist_format(), breaks = breaks_pretty(4))
#	+ scale_y_continuous(limits = c(0.1, 1), breaks = seq(0.1, 1, 0.1))
	+ labs(x = "Service"
		, y = "Probability of\nimproved service"
	)
)
print(pyrservice_plot)

### Other remaining predictors
pred_vars <- names(pyrmod_effect_df)[!names(pyrmod_effect_df) %in% "services"]

pyrpred_effect_plots <- lapply(pred_vars, function(x){
	plotEffects(pyrmod_effect_df[[x]], x, grep(x, pred_vars, value = TRUE))
})

print(pyrpred_effect_plots)

save(file = "washPredEffects_plots.rda"
	, pyrservice_plot
	, pyrpred_effect_plots
)

