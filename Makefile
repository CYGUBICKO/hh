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

## Loading data and defining some important functions
## ln -s ~/Dropbox/aphrc/hh_amen_xtics/data/ data ##
## ln -s ~/Dropbox/aphrc/hh_amen_xtics/docs/ docs ##
## ln -s ~/Dropbox/aphrc/wash/data washdata ##
Ignore += data docs

######################################################################

# Define all important R-functions in one file
globalFunctions.Rout: globalFunctions.R

# Read raw data
## loadData.rda: loadData.R
loadData.Rout: data/NUHDSS_hhamenitiescharacteristics_anon.dta loadData.R

shortData.Rout: shortData.R

# Generate files to recode labels (JD way)
generateLabels.Rout: generateLabels.R
## generateLabels.xlsx: generateLabels.Rout;

# Some cleaning (using shortData temporarily)
cleaning.Rout: cleaning.R
cleaning_tables.Rout: cleaning_tables.R
# cleaning_tables.xlsx: cleaning_tables.Rout;

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
analysisData.Rout: analysisData.R
analysis_variables.Rout: analysis_variables.R
# analysis_variables.xlsx: analysis_variables.Rout;

# Logestic PCA

## Dwelling index
dwelling_pca.Rout: dwelling_pca.R

## Assets ownership index
ownership_pca.Rout: ownership_pca.R

## Shocks/problems index
problems_pca.Rout: problems_pca.R

# PCA
## Expenditure index
expenditure_pca.Rout: expenditure_pca.R

# Select variables to be used in analysis and add indices variables - New wash data
washData.Rout: washData.R


######################################################################

# WASH Analysis

## Data reshaping incorporating previous year as a variable
washdataInspect.Rout: washdataInspect.R
washdataInspect_plots.Rout: washdataInspect_plots.R

## Recategorise previous status variables (*P$)
washdataStatusPcats.Rout: washdataStatusPcats.R

## Data documentation
dataprep_doc.html: dataprep_doc.rmd

## Restructured data for hhid-year-services
longDFunc.Rout: longDFunc.R
washModeldata.Rout: washModeldata.R

## Previous year model
### Scaled variable (hhsize and year)
washModelfit_pglmerS.Rout: washModelfit_pglmerS.R

washModelfit_tmbS.Rout: washModelfit_tmbS.R


## Tidy model estimates
washTidyestimates.Rout: washTidyestimates.R

## Effect size plots
washEffectsize_plots.Rout: washEffectsize_plots.R

### Wash predictor effects
washPredEffects.Rout: washPredEffects.R
washPredEffects_plots.Rout: washPredEffects_plots.R


# ../wash/washdataAnalysis_report.rmd

# temp_files/cleaning.R

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

