# Household characteristics data
## Examining WASH raw data

### Hooks for the editor to set the default target
## https:cygubicko.github.io/hh

current: target
-include target.mk

######################################################################

ms = makestuff
Sources += $(wildcard *.R *.rmd *.md)
Sources += Makefile rmd.mk

pullup: funs.pull

######################################################################

now: git_push/descriptive_stats.Rout.pdf git_push/combineservicesP_plots.Rout.pdf git_push/combineservices_plots.Rout.pdf 

## Latex plot example

Sources += plots.tex
plots.pdf: plots.tex

plots.Rout: plots.R

######################################################################


## Loading data and defining some important functions
## ln -s ~/Dropbox/aphrc/hh_amen_xtics/data/ data ##
## ln -s ~/Dropbox/aphrc/hh_amen_xtics/docs/ docs ##
## ln -s ~/Dropbox/aphrc/wash/data washdata ##
Ignore += data docs washdata

## cygufuns
Makefile: funs

funs:
	git clone https://github.com/cygubicko/funs.git

Ignore += funs
alldirs += funs

######################################################################

test.Rout: test.R

## Why do you need this?
# Define all important R-functions in one file
globalFunctions.Rout: globalFunctions.R
simplePlotsRuncs.Rout: simplePlotsRuncs.R

# Read raw data
## loadData.rda: loadData.R
loadData.Rout: data/NUHDSS_hhamenitiescharacteristics_anon.dta loadData.R

## A short data set for experiments that don't take too long
shortData.Rout: shortData.R

## SPLIT missingCategory_summary into two different files, please 2020 Oct 29 (Thu)
## Remove early years, and multiple interviews in the same year (keep last interview in a given year)
filter_interviews.Rout: filter_interviews.R
## Summarize missing cases (and examine types of missingness)
missingCategory_summary.Rout: missingCategory_summary.R

# Generate files to recode labels
Ignore += generateLabels.xlsx cleaning_tables.xlsx analysis_variables.xlsx
generateLabels.Rout: generateLabels.R
## generateLabels.xlsx: generateLabels.Rout;
materials_tables.Rout: materials_tables.R

# Some cleaning
cleaning.Rout: cleaning.R
cleaning_tables.Rout: cleaning_tables.R
# cleaning_tables.xlsx: cleaning_tables.Rout;
overall_missing_tables.Rout: overall_missing_tables.R

## mergeWash may not be necessary, since hh data seems to have the derived variables
## Or maybe we can play _just_ with washdata?
## See notes
mergeWash.Rout: washdata/NUHDSS_Wash.dta mergeWash.R

## compare Steve-calculated with aphrc-calculated variables

### Wash data specific
compareCalculations.Rout: compareCalculations.R
compareCalculations.xlsx: compareCalculations.Rout;

### HH - WASH comparison
hhWashcompare.Rout: hhWashcompare.R
hhWashcompare.xlsx: hhWashcompare.Rout;

# Compare HH and WASH proportions
cleaning_plots.Rout: cleaning_plots.R

# Select variables to be used for analysis only
missing_after_cleaning.Rout: missing_after_cleaning.R
analysisData.Rout: analysisData.R
analysis_variables.Rout: analysis_variables.R
## analysis_variables.xlsx: analysis_variables.Rout;

# Drop cases with outliers
cleanData.Rout: cleanData.R

# Descriptive statistics
descriptive_stats.Rout: descriptive_stats.R


# PCA

## Dwelling index
dwelling_pca.Rout: dwelling_pca.R
dwelling_pca_plot.Rout: dwelling_pca_plot.R

# Gaussian PCA
ownership_gpca.Rout: ownership_gpca.R
ownership_gpca_plot.Rout: ownership_gpca_plot.R

# Count
## Shocks/problems index: Summation of total number of chocks
problems_index.Rout: problems_index.R
problems_index_plot.Rout: problems_index_plot.R

## Shocks/problems ever: summation of whether a HH has ever experience a shock
problems_ever_index.Rout: problems_ever_index.R
problems_ever_index_plot.Rout: problems_ever_index_plot.R

# Count
## Expenditure index
expenditure_index.Rout: expenditure_index.R
expenditure_index_plot.Rout: expenditure_index_plot.R

## HH size after droping outliers
hhsize_plot.Rout: hhsize_plot.R

# Select variables to be used in analysis and add indices variables - New wash data
washData.Rout: washData.R

## Vizualize response ~ predictors
resp_predictor_plots.Rout: resp_predictor_plots.R


######################################################################

# WASH Analysis

## Data reshaping incorporating previous year as a variable
washdataInspect.Rout: washdataInspect.R
washdataInspect_plots.Rout: washdataInspect_plots.R

## Recategorise previous status variables (*P$)
washdataStatusPcats.Rout: washdataStatusPcats.R

## Restructured data for hhid-year-services
longDFunc.Rout: longDFunc.R
washLongdata.Rout: washLongdata.R



######################################################################

## Separate models
#### GARBAGE

######################################################################

## GLM
### No previous status
garbage_glm.Rout: garbage_glm.R

### With previous status
garbageP_glm.Rout: garbageP_glm.R

### Coefficient plots 
garbage_tidy.Rout: garbage_tidy.R
garbage_tidy_plots.Rout: garbage_tidy_plots.R

### Conditional effects
#### No previous status
garbage_condeffect.Rout: garbage_condeffect.R
garbage_condeffect_plots.Rout: garbage_condeffect_plots.R

#### With previous status
garbageP_condeffect.Rout: garbageP_condeffect.R
garbageP_condeffect_plots.Rout: garbageP_condeffect_plots.R

#### emmeans
## garbageP_emmeans.Rout: garbageP_emmeans.R

######################################################################

## Effect plot functions
### Label effect plots
###  Customized conditional effect plots for effects library
labelEplots.Rout: labelEplots.R

## GLMER using TMB
### No previous status
garbage_tmb.Rout: garbage_tmb.R

#### Anova
garbage_anova.Rout: garbage_anova.R

#### Conditional effects
#### effects
garbage_condeffect_tmb.Rout: garbage_condeffect_tmb.R
##### emmeans
garbage_condemm_tmb.Rout: garbage_condemm_tmb.R
garbage_condeffect_plots_tmb.Rout: garbage_condeffect_plots_tmb.R

#### Previous status included 
garbageP_tmb.Rout: garbageP_tmb.R

#### Anova
garbageP_anova.Rout: garbageP_anova.R

#### Conditional effects
##### effects
garbageP_condeffect_tmb.Rout: garbageP_condeffect_tmb.R
##### emmeans
garbageP_condemm_tmb.Rout: garbageP_condemm_tmb.R
garbageP_condeffect_plots_tmb.Rout: garbageP_condeffect_plots_tmb.R

######################################################################

#### WATER SOURCES

######################################################################

## GLMER using TMB
### No previous status
water_tmb.Rout: water_tmb.R

#### Anova
water_anova.Rout: water_anova.R

#### Conditional effects
##### effects
water_condeffect_tmb.Rout: water_condeffect_tmb.R
##### emmeans
water_condemm_tmb.Rout: water_condemm_tmb.R
water_condeffect_plots_tmb.Rout: water_condeffect_plots_tmb.R

#### Previous status included 
waterP_tmb.Rout: waterP_tmb.R

#### Anova
waterP_anova.Rout: waterP_anova.R

#### Conditional effects
##### effects 
waterP_condeffect_tmb.Rout: waterP_condeffect_tmb.R
##### emmeans
waterP_condemm_tmb.Rout: waterP_condemm_tmb.R
waterP_condeffect_plots_tmb.Rout: waterP_condeffect_plots_tmb.R


######################################################################

#### TOILET FACILITIES

######################################################################

## GLMER using TMB
### No previous status
toilet_tmb.Rout: toilet_tmb.R

#### Anova
toilet_anova.Rout: toilet_anova.R

#### Conditional effects
##### effects
toilet_condeffect_tmb.Rout: toilet_condeffect_tmb.R
##### emmeans
toilet_condemm_tmb.Rout: toilet_condemm_tmb.R
toilet_condeffect_plots_tmb.Rout: toilet_condeffect_plots_tmb.R

#### Previous status included 
toiletP_tmb.Rout: toiletP_tmb.R

#### Anova
toiletP_anova.Rout: toiletP_anova.R

#### Conditional effects
##### effects
toiletP_condeffect_tmb.Rout: toiletP_condeffect_tmb.R
##### emmeans
toiletP_condemm_tmb.Rout: toiletP_condemm_tmb.R
toiletP_condeffect_plots_tmb.Rout: toiletP_condeffect_plots_tmb.R

######################################################################

#### Combined plots

######################################################################

# Anova tables
combineanova_tabs.Rout: combineanova_tabs.R

# Conditional predictions
## Plot all the three services side by side
### No previous status
combineservices_plots.Rout: combineservices_plots.R

### Previous status included
combineservicesP_plots.Rout: combineservicesP_plots.R

# Effect plots
tidy_coefs.Rout: tidy_coefs.R
tidy_coefs_plots.Rout: tidy_coefs_plots.R

######################################################################

## Joint models
### glmmTMB

######################################################################

## Previous status included
jointModelP_tmb.Rout: jointModelP_tmb.R

## Anova
jointModelP_anova.Rout: jointModelP_anova.R

## Conditional effects
jointModelP_condeffect_tmb.Rout: jointModelP_condeffect_tmb.R
jointModelP_condeffect_plots_tmb.Rout: jointModelP_condeffect_plots_tmb.R

######################################################################

#### Other checks

######################################################################

## simple simulation to check why predictions aren't working
simple_sim.Rout: simple_sim.R
simple_brms.Rout: simple_brms.R
simple_brms_plots.Rout: simple_brms_plots.R
simple_glm_plots.Rout: simple_glm_plots.R

### Own code for conditional prediction
simple_predict_brms.Rout: simple_predict_brms.R

######################################################################

## Data documentation
## dataprep_doc.html.gp: dataprep_doc.rmd
## missing_data_report.html.gp: missing_data_report.rmd

Ignore += predictors_report.html
predictors_report.html: predictors_report.rmd


######################################################################

clean: 
	rm -f *Rout.*  *.Rout .*.RData .*.Rout.* .*.wrapR.* .*.Rlog *.RData *.wrapR.* *.Rlog

######################################################################

### Makestuff

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

include rmd.mk
-include makestuff/os.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
-include makestuff/texdeps.mk
-include makestuff/pandoc.mk
-include makestuff/stepR.mk
-include makestuff/git.mk

