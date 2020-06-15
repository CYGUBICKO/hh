#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(factoextra)
library(ggplot2)
library(ggfortify)

## Use complete dataset
load("analysisData.rda")

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
	%>% mutate_all(as.numeric)
	%>% data.frame()
)
sapply(dwelling_df, function(x){
	table(x, useNA = "always")
})

dwelling_pca <- prcomp(dwelling_df, center = TRUE, scale. = TRUE)
dwelling_pc_df <- summary(dwelling_pca)$x
dwelling_index <- drop(dwelling_pc_df[,1])

dwelling_pca_plot1 <- fviz_screeplot(dwelling_pca, addlabels = TRUE)
print(dwelling_pca_plot1)

dwelling_pca_plot2 <- (autoplot(dwelling_pca
		, data = working_df_complete
		, colour = "drinkwatersource_new"
		, shape = "drinkwatersource_new"
		, alpha = 0.5
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, scale = 0
	)
	+ scale_colour_manual(values = c("#00AFBB", "#ff5500"))
#	+ geom_point(data = wdbc_pca_preds, aes(x = PC1, y = PC2, shape = test))
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
print(dwelling_pca_plot2)


dwelling_pca_plot2 <- (autoplot(dwelling_pca
		, data = working_df_complete
		, colour = "garbagedisposal_new"
		, shape = "garbagedisposal_new"
		, alpha = 0.5
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, scale = 0
	)
	+ scale_colour_manual(values = c("#00AFBB", "#ff5500"))
#	+ geom_point(data = wdbc_pca_preds, aes(x = PC1, y = PC2, shape = test))
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
print(dwelling_pca_plot2)

dwelling_pca_plot2 <- (autoplot(dwelling_pca
		, data = working_df_complete
		, colour = "toilet_5plusyrs_new"
		, shape = "toilet_5plusyrs_new"
		, alpha = 0.5
		, frame = TRUE
		, frame.type = 'norm'
		, frame.alpha = 0.1
		, scale = 0
	)
	+ scale_colour_manual(values = c("#00AFBB", "#ff5500"))
#	+ geom_point(data = wdbc_pca_preds, aes(x = PC1, y = PC2, shape = test))
	+ geom_vline(xintercept = 0, lty = 2, colour = "gray")
	+ geom_hline(yintercept = 0, lty = 2, colour = "gray")
)
print(dwelling_pca_plot2)
quit()
## Create dummy for all the categorical variables

# dummy_df <- dummyVars(~., data = dwelling_df)
# dwelling_df <- predict(dummy_df, dwelling_df)

mod_mad <- model.matrix(~., dwelling_df)[, -1]
dwelling_df <- data.frame(mod_mad)
head(dwelling_df)

## Perform logistic PCA
# logpca_cv = cv.lpca(dwelling_df, ks = 1, ms = c(5,6,10)) # Takes time, m = 6
# plot(logpca_cv)

dwelling_pca <- logisticPCA(dwelling_df, k = 1, m = 0, main_effects = FALSE)
dwelling_pca
dwelling_index <- drop(dwelling_pca$PCs)

save(file = "dwelling_pca.rda"
	, dwelling_index
)
