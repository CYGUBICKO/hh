library(ggplot2)
source("funs/ggplot_theme.R"); ggtheme()
library(effects)

load("simple_brms.rda")

p1 <- Effect(mod = glm1_model, focal.predictors="x")
plot(p1)

p2 <- Effect(mod = glm2_model, focal.predictors="x")
plot(p2)
