#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Combine all anova tables ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Nov 03 (Tue) ----

library(dplyr)

load("garbage_anova.rda")
load("garbageP_anova.rda")
load("water_anova.rda")
load("waterP_anova.rda")
load("toilet_anova.rda")
load("toiletP_anova.rda")

anova_tabs <- list(garbage_anova, garbageP_anova
	, water_anova, waterP_anova
	, toilet_anova, toiletP_anova
)
anova_tabs <- (bind_rows(anova_tabs)
	%>% mutate(vars = gsub("watersourceP|garbagedposalP|toilettypeP", "StatusP", vars))
)
head(anova_tabs)

save(file = "combineanova_tabs.rda"
	, anova_tabs
)
