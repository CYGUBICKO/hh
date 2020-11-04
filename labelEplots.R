# label effect plots functions
source("funs/labelEplots.R")

# Plot conditional effect plots
source("funs/condEplots.R")

# Response scale: either "response" or "log-odds"
resp_scale <- "response"

# Anova type for Anova: 2 or 3
anova_type <- 2

ls()
save.image("labelEplots.rda")
