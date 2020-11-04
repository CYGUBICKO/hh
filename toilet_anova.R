#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("labelEplots.rda")
load("toilet_tmb.rda")

d1 <- Anova(toilet_tmb_model, type = anova_type)
toilet_anova <- data.frame(d1)
rownames(toilet_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(toilet_anova))

print(toilet_anova)

save(file = "toilet_anova.rda"
	, toilet_anova
)

