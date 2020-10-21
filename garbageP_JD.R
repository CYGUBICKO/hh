#### ---- Project: APHRC Wash Data ----
#### ---- Effect plots by JD ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Oct 16 (Fri) ----

library(dplyr)
library(tidyr)
library(tibble)
library(splines)

load("garbageP_glm.rda")
load("eplotsFuns.rda")
load("ordFuns.rda")

## All cats have to be factors otherwise error?
model_df <- wash_consec_df %>% select(-year_scaled)
mod <- garbageP_glm_model
model_df$slumarea <- as.factor(model_df$slumarea)
model_df$garbagedposalP <- as.factor(model_df$garbagedposalP)

predNames <- c("year")
isoList <- lapply(predNames, function(n){
  ordpred(mod = mod, n, modAns = model_df)
})

quit()
catNames <- c("slumarea")
catNames <- c("garbagedposalP")
print(varPlot(isoList[[1]], ylab=""))

print(varPlot(isoList[[2]], ylab="years"))

print(varPlot(isoList[[3]], ylab="xm"))


