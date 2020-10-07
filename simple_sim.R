#### ---- Project: APHRC Wash Data ----
#### ---- Task: Simulation ----
#### ---- Sub-task: Simulate multivariate gausian responses ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2019 May 28 (Tue) ----

library(mvtnorm)
library(data.table)
library(dplyr)
options(dplyr.width = Inf)

library(tidyr)
library(tibble)

set.seed(7902)

people <- 500 # Number of simulations to run

# Predictor
x <- seq(1, 9, length.out = people)
summary(x)


# Beta values
y1_beta0 <- 0.3
y2_beta0 <- 0.2

y1_beta1 <- 0.1 
y2_beta1 <- 0.4

U1_beta <- 0.5
U2_beta <- 0.7

# Sd
U_sd <- 0.4

## Latent variables
U <- rnorm(people, 0, U_sd)

## Error terms
y1_eps <- rnorm(people)
y2_eps <- rnorm(people)

## Linear predictor
XB <- data.frame(x = x
	, U = U
	, pred1 = y1_beta0 + y1_beta1 * x + y1_eps#+ U1_beta * U
	, pred2 = y2_beta0 + y2_beta1 * x + y2_eps#+ U2_beta * U
)

sim_df <- (XB
	%>% mutate(
		y1 = rbinom(people, 1, plogis(pred1))
		, y2 = rbinom(people, 1, plogis(pred2))
	)
)

parm_list <- list(y1_beta0 = y1_beta0
	, y2_beta0 = y2_beta0
	, y1_beta1 = y1_beta1 
	, y2_beta1 = y2_beta1 
	, U1_beta = U1_beta 
	, U2_beta = U2_beta 
	, U_sd <- U_sd
)

# Sd
save(file = "simple_sim.rda"
	, sim_df
	, parm_list
)
