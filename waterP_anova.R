#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("labelEplots.rda")
load("waterP_tmb.rda")

d1 <- Anova(waterP_tmb_model, type = anova_type)
waterP_anova <- data.frame(d1)
rownames(waterP_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(waterP_anova))

print(waterP_anova)

save(file = "waterP_anova.rda"
	, waterP_anova
)

