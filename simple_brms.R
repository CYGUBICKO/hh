#### --- Trying to understand joint model ----
#### --- Date: 2020 Oct 06 (Tue) ----
library(brms)

load("simple_sim.rda")

## Fit model
y1_form <- bf(y1 ~ x)
y2_form <- bf(y2 ~ x)

get_prior(
	y1_form + y2_form
		, data = sim_df
		, family = list(bernoulli(link = "logit"), bernoulli(link = "logit"))
)

## Fit brms model
priors <- c(prior(normal(0, 2), class = b, coef = x, resp = y1)
	, prior(normal(0, 2), class = b, coef = x, resp = y2)
	, prior(normal(0, 2), class = Intercept, resp = y1)
	, prior(normal(0, 2), class = Intercept, resp = y2)
)

brms_model <- brm(y1_form + y2_form
	, data = sim_df
	, family = list(bernoulli(link = "logit"), bernoulli(link = "logit")) 
	, prior = priors
	, warmup = 1e3
	, iter = 4e3
	, chains = 2
	, cores = 4
	, control = list(adapt_delta = 0.95)
)
summary(brms_model)

## glm
glm1_model <- glm(y1 ~ x, data = sim_df, family = binomial)
print(glm1_model)

glm2_model <- glm(y2 ~ x, data = sim_df, family = binomial)
print(glm2_model)

## True params
print(parm_list)

save(file = "simple_brms.rda"
	, brms_model
	, parm_list
	, sim_df
	, glm1_model
	, glm2_model
)
