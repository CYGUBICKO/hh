#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("labelEplots.rda")
load("garbageP_tmb.rda")

d1 <- Anova(garbageP_tmb_model, type = anova_type)
garbageP_anova <- data.frame(d1)
rownames(garbageP_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(garbageP_anova))
garbageP_anova$vars <- rownames(garbageP_anova)
garbageP_anova$model <- "garbageP"

print(garbageP_anova)

save(file = "garbageP_anova.rda"
	, garbageP_anova
)

