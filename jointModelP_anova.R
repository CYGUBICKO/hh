#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Perform anova ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(glmmTMB)
library(splines)
library(car)

load("jointModelP_tmb.rda")
d1 <- Anova(jointP_tmb_model, type = "III")
jointModelP_anova <- data.frame(d1)
rownames(jointModelP_anova) <- gsub(".*\\:|.*\\(|\\,.*|\\).*", "", rownames(jointModelP_anova))

print(jointModelP_anova)

save(file = "jointModelP_anova.rda"
	, jointModelP_anova
)

