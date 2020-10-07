library(brms)
library(tidybayes)
library(dplyr)
library(tidyr)
library(ggplot2)
source("funs/ggplot_theme.R"); ggtheme()

load("simple_brms.rda")

x <- sim_df$x
head(x)
brms_draws <- (brms_model
	%>% spread_draws(b_y1_Intercept, b_y2_Intercept, b_y1_x, b_y2_x)
	%>% mutate(x = list(x))
	%>% unnest(x)
)

## Compute predction on linear scale and prob scale

predict_df <- (brms_draws
	%>% mutate(y1lin = b_y1_Intercept + b_y1_x * x
		, y2lin = b_y2_Intercept + b_y2_x * x
		, y1prob = plogis(y1lin)
		, y2prob = plogis(y2lin)
	)
	%>% group_by(x)
	%>% summarise(y1lin_m = mean(y1lin, na.rm = TRUE)
		, y2lin_m = mean(y2lin, na.rm = TRUE)
		, y1prob_m = mean(y1prob, na.rm = TRUE)
		, y2prob_m = mean(y2prob, na.rm = TRUE)
		, y1lin_l = quantile(y1lin, prob = 0.025)
		, y2lin_l = quantile(y2lin, prob = 0.025)
		, y1prob_l = quantile(y1prob, prob = 0.025)
		, y2probm_l = quantile(y2prob, prob = 0.025)
		, y1lin_u = quantile(y1lin, prob = 0.975)
		, y2lin_u = quantile(y2lin, prob = 0.975)
		, y1prob_u = quantile(y1prob, prob = 0.975)
		, y2probm_u = quantile(y2prob, prob = 0.975)
	)
)

print(predict_df, width = Inf, N = 10)

## Plottings

base_plot <- ggplot(predict_df, aes(x = x))

## Plot: linear scale predictions 
y1lin_plot <- (base_plot
	+ geom_line(aes(y = y1lin_m))
	+ geom_ribbon(aes(ymin = y1lin_l, ymax = y1lin_u), alpha = 0.2)
	+ labs(y = "Linear pred", title = "Linear predictions")
)
print(y1lin_plot)

## Labeled on response scale

logist_format <- function() {
	function(x) round(plogis(x), 3)
}
print(y1lin_plot
	+ scale_y_continuous(labels = logist_format()
#		, breaks = breaks_pretty(4)
	)
	+ labs(y = "Predicted prob", title = "Linear pred labeled by prob")
)

## Predictions on response scale
y1prob_plot <- (base_plot
	+ geom_line(aes(y = y1prob_m))
	+ geom_ribbon(aes(ymin = y1prob_l, ymax = y1prob_u), alpha = 0.2)
	+ labs(y = "Predicted prob", title = "Prediction on response scale")
)
print(y1prob_plot)
