library(dplyr)
library(ggplot2); theme_set(theme_bw())

load("temp_condemm.rda")
load("temp_condjd.rda")

# age marginal effects
pred_age <- bind_rows(predict_age_em, predict_age_jd)

age_plot <- (ggplot(pred_age, aes(x = x))
	+ geom_line(aes(y = fit), alpha = 0.7)
	+ geom_ribbon(aes(ymin = lwr, ymax = upr)
		, colour = NA, alpha = 0.7
	)
	+ labs(x = "age", y = "Predictions")
	+ facet_wrap(~model, scales = "free_x")
)
print(age_plot)

