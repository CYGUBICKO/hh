#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("labelEplots.rda")
load("toiletP_tmb.rda")

d1 <- Anova(toiletP_tmb_model, type = anova_type)
toiletP_anova <- data.frame(d1)
rownames(toiletP_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(toiletP_anova))
toiletP_anova$vars <- rownames(toiletP_anova)
toiletP_anova$model <- "toiletP"

print(toiletP_anova)

save(file = "toiletP_anova.rda"
	, toiletP_anova
)

