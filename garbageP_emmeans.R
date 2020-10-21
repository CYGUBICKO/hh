#### ---- Project: APHRC Wash Data ----
#### ---- Task: Modeling real data ----
#### ---- Extract predicted effect sizes ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 Jan 11 (Sat) ----

library(tibble)
library(dplyr)
library(ggplot2)
library(splines)
library(emmeans)

load("garbageP_glm.rda")

## Observed means
overall_df <- data.frame(overall = 1, prob = mean(wash_consec_df$garbagedposal))

### marginal means for previous status
d1 <- with(wash_consec_df, tapply(garbagedposal, garbagedposalP, mean))
marg_df <- (data.frame(prob = d1)
	%>% rownames_to_column("garbagedposalP")
)

## Overall
emm_overall <- emmeans(garbageP_glm_model, ~1
	, type = "response"
)
print(plot(emm_overall)
	+ geom_point(data = overall_df, aes(x = prob, y = overall), col = "red")
	+ coord_flip()
)

## Previous service
emm_prev <- emmeans(garbageP_glm_model, ~garbagedposalP
	, type = "response"
)
print(plot(emm_prev)
	+ geom_point(data = marg_df, aes(x = prob, y = garbagedposalP), col = "red")
	+ coord_flip()
)
save(file = "garbageP_emmeans.rda"
	, emm_prev
)
