# Household characteristics data
## Examining WASH raw data

### Hooks for the editor to set the default target
## https:cygubicko.github.io/projects

current: target
-include target.mk

######################################################################

ms = makestuff
Sources += $(wildcard *.R *.Rmd)
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
Ignore += analysis_variables.xlsx
analysis_variables.xlsx: analysis_variables.Rout;

# MCA
## Ownership
ownership_impute.Rout: ownership_impute.R
ownership_mca.Rout: ownership_mca.R

## Shocks/problems
problems_mca.Rout: problems_mca.R

# PCA
## Expenditure
expenditure_pca.Rout: expenditure_pca.R

## Data documentation
dataprep_doc.html: dataprep_doc.rmd

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

