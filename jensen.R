p0 <- 0.9
q0 <- qlogis(0.9) ## logit
set.seed(101)
q_xx <- rnorm(1000,mean=q0,sd=2) ## logit_normal
p_xx <- plogis(q_xx)  ## back-transform to probabilities

plogis(quantile(q_xx,c(0.05,0.95)))  ## 0.27 to 0.99

hist(q_xx,col="gray",breaks=100)
hist(p_xx,col="gray",breaks=100)

## plogis(mean of marginal posterior distribution of log-odds) !=
## mean of marginal posterior distribution of probabilities

plogis(mean(q_xx)) ## 0.899
mean(p_xx)  ## 0.794
