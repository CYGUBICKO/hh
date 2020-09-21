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

######################################################################

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

shortData.Rout: shortData.R

## Summary number of missing cases per missing value indicator
missingCategory_summary.Rout: missingCategory_summary.R

# Generate files to recode labels (JD way)
Ignore += generateLabels.xlsx cleaning_tables.xlsx analysis_variables.xlsx
generateLabels.Rout: generateLabels.R
## generateLabels.xlsx: generateLabels.Rout;
materials_tables.Rout: materials_tables.R

# Some cleaning (using shortData temporarily)
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
# analysis_variables.xlsx: analysis_variables.Rout;

# Descriptive statistics
descriptive_stats.Rout: descriptive_stats.R

# Drop cases with outliers
cleanData.Rout: cleanData.R

# PCA

## Dwelling index
dwelling_pca.Rout: dwelling_pca.R
dwelling_pca_plot.Rout: dwelling_pca_plot.R

# Logistic PCA

## Assets ownership index
ownership_lpca.Rout: ownership_lpca.R
ownership_lpca_plot.Rout: ownership_lpca_plot.R

# Gaussian PCA
ownership_gpca.Rout: ownership_gpca.R
ownership_gpca_plot.Rout: ownership_gpca_plot.R

# Count
## Shocks/problems index
problems_index.Rout: problems_index.R
problems_index_plot.Rout: problems_index_plot.R

# Count
## Expenditure index
expenditure_index.Rout: expenditure_index.R
expenditure_index_plot.Rout: expenditure_index_plot.R

# Select variables to be used in analysis and add indices variables - New wash data
washData.Rout: washData.R


######################################################################

# WASH Analysis

## Data reshaping incorporating previous year as a variable
washdataInspect.Rout: washdataInspect.R
washdataInspect_plots.Rout: washdataInspect_plots.R

## Recategorise previous status variables (*P$)
washdataStatusPcats.Rout: washdataStatusPcats.R

## Restructured data for hhid-year-services
longDFunc.Rout: longDFunc.R
washModeldata.Rout: washModeldata.R

## Previous year model
### Scaled variable (hhsize and year)

#### LME4: Too slow
washModelfit_pglmerS.Rout: washModelfit_pglmerS.R

#### GLMMTMB
washModelfit_tmbS.Rout: washModelfit_tmbS.R

### Trying polynomial age and expenditure index
# washModelfit_poly_tmbS.Rout: washModelfit_poly_tmbS.R


## Tidy model estimates
washTidyestimates.Rout: washTidyestimates.R

## Effect size plots
washEffectsize_plots.Rout: washEffectsize_plots.R

### Wash predictor effects - predictor scale
washPredEffects.Rout: washPredEffects.R
washPredEffects_plots.Rout.pdf.gp: washPredEffects_plots.R

### Wash predictor effects - response scale
washPredEffects_Resp.Rout: washPredEffects_Resp.R
washPredEffects_Resp_plots.Rout.pdf.gp: washPredEffects_Resp_plots.R

## Data documentation
## dataprep_doc.html.gp: dataprep_doc.rmd
## missing_data_report.html.gp: missing_data_report.rmd

Ignore += predictors_report.html
predictors_report.html: predictors_report.rmd

#### Create word report
#%.rmd.docx : %.rmd
#	pandoc $< -o $@


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

