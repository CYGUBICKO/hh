library(emmeans)
library(ggplot2)

## two models, with and without scaled/centered focal predictor
## (centering is the important part here ...)
m1 <- lm(mpg~disp+wt,data=mtcars)
m2 <- lm(mpg~scale(disp)+scale(wt),data=mtcars)

## by default we get a plot that predicts at discrete values of disp
plot(e1 <- emmeans(m1, ~disp, cov.keep="disp", CIs=TRUE))
## we can do it by hand; don't know if there is a shortcut for this or not ...
d1 <- as.data.frame(e1)
print(g1 <- ggplot(d1, aes(disp, emmean))
    + geom_line()
    + geom_ribbon(aes(ymin=lower.CL, ymax=upper.CL),
                  colour=NA, alpha=0.1)
    )

## zero out all but focal effects
zero_vcov <- function(m, focal_params) {
    v <- vcov(m)
    focal_var <- v[focal_params,focal_params]
    v[] <- 0 ## set all to zero, preserving dims/names
    v[focal_params, focal_params] <- focal_var
    return(v)
}

zero_vcov(m1,"disp")
zero_vcov(m1,c("disp","wt"))

plot(e2 <- emmeans(m1, ~disp, cov.keep="disp", CIs=TRUE,
                   vcov. = zero_vcov(m1, "disp")))
## works, but disappointing because disp isn't centered
g1 %+% as.data.frame(e2)

## do it with the scaled-disp model instead
plot(e3 <- emmeans(m2, ~disp, cov.keep="disp", CIs=TRUE,
                   vcov. = zero_vcov(m2, "scale(disp)")))
g1 %+% as.data.frame(e3)

## identical results here because wt is zero at the model center/reference point
plot(e4 <- emmeans(m2, ~disp, cov.keep="disp", CIs=TRUE,
                   vcov. = zero_vcov(m2, c("scale(disp)","scale(wt)"))))
g1 %+% as.data.frame(e4)


## Not sure on how to extract parameter level variable names
extract_assign <- function(mod, intercept = TRUE){
	mat <- model.matrix(mod)
	xnames <- colnames(mat)
	mod_term <- terms(mod)
	mod_form <- formula(delete.response(mod_term))
	var_labs <- all.vars(mod_form)
	assign <- attr(mat, "assign")
	if(intercept) {
		var_labs <- c("(Intercept)", var_labs)
		assign <- assign + 1
	}
	assign <- setNames(var_labs[assign], xnames)
	return(assign)
}

zero_vcov2 <- function(m, focal_params, intercept = TRUE) {
	assign <- extract_assign(m, intercept)
	focal_params <- names(assign)[assign %in% focal_params]
	v <- vcov(m)
	if(inherits(m, "glmmTMB")){
		v <- v$cond
	}
	focal_var <- v[focal_params,focal_params]
	v[] <- 0 ## set all to zero, preserving dims/names
	v[focal_params, focal_params] <- focal_var
	return(v)
}

d1 <- as.data.frame(p2)
print(g2 <- ggplot(d1, aes(age, emmean))
    + geom_line()
    + geom_ribbon(aes(ymin=lower.CL, ymax=upper.CL),
                  colour=NA, alpha=0.1)
    )
