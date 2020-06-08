#### ---- Project: APHRC HH Data ----
#### ---- Task: Perform logistic PCA ----
#### ---- By: Steve and Jonathan ----
#### ---- Date: 2020 May 31 (Sun) ----

library(dplyr)
library(ggplot2)
# library(caret)
library(logisticPCA)

## Use complete dataset
load("analysisData.rda")

## Dwelling data
dwelling_df <- (working_df_complete
	%>% select(!!dwelling_group_vars)
)

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
