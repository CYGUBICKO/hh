#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("labelEplots.rda")
load("garbage_tmb.rda")

d1 <- Anova(garbage_tmb_model, type = anova_type)
garbage_anova <- data.frame(d1)
garbage_anova$vars <- rownames(garbage_anova)
rownames(garbage_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(garbage_anova))
garbage_anova$vars <- rownames(garbage_anova)
garbage_anova$model <- "garbage"

print(garbage_anova)

save(file = "garbage_anova.rda"
	, garbage_anova
)

