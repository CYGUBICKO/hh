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
Ignore += data docs


######################################################################

# Define all important R-functions in one file
globalFunctions.Rout: globalFunctions.R

# Read raw data
## loadData.rda: loadData.R
loadData.Rout: data/NUHDSS_hhamenitiescharacteristics_anon.dta loadData.R

# Some cleaning
cleaning.Rout: cleaning.R

cleaning_plots.Rout: cleaning_plots.R


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

