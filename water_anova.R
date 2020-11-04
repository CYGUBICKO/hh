#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("water_tmb.rda")
d1 <- Anova(water_tmb_model, type = "III")
water_anova <- data.frame(d1)
rownames(water_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(water_anova))

print(water_anova)

save(file = "water_anova.rda"
	, water_anova
)

