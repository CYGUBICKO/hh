#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(scales)
library(ggplot2)

library(dplyr)
library(effects)
library(lme4)
library(splines)

source("funs/ggplot_theme.R"); ggtheme()
load("garbage_condeffect_tmb.rda")

### Plot effects
logist_format <- function() {
	function(x) round(plogis(x), 3)
}

plotEffects <- function(df, var, xlabs){
	pos <- position_dodge(0.5)
	p1 <- (ggplot(df, aes_string(x = var, y = "fit"))
		+ scale_y_continuous(labels = logist_format(), breaks = breaks_pretty(5))
		+ labs(x = xlabs
			, y = "Probability of\nimproved service"
		)
		+ guides(colour = FALSE)
		+ theme(legend.position = "bottom")
	)
	if (grepl("numeric|integer", class(df[[var]]))){
		p2 <- (p1
			+ geom_smooth(aes(ymin = lower, ymax = upper)
				, stat = "identity"
				, size = 0.5
			)
			+ guides(fill = FALSE)
		)
	} else {
		p2 <- (p1 + geom_point(size = 0.6)
			+ geom_line()
			+ geom_errorbar(aes(ymin = lower, ymax = upper), width = 0)
		)
	}
	return(p2)
}


### Plot all predictors
pred_vars <- names(effect_df)

pred_effect_plots <- lapply(pred_vars, function(x){
	plotEffects(effect_df[[x]], x, grep(x, pred_vars, value = TRUE))
})

print(pred_effect_plots)

save(file = "garbage_condeffect_plots_tmb.rda"
	, pred_effect_plots
)

