This directory is set up so that making existing targets should Just Work.

If you ask for a target, it should get the R scripts .csv or .tex files it needs from the parent directory. .Rout scripts are made by emulating wrapR (because wrap_makeR is set).

If you want to work on a script, you should convert it to makeR style by:

* moving the rule for it from rdeps.mk (an automatically made file with rules made by stepR) to the Makefile
* adding a recipe line to the rule saying $(makeR) -- see cleanData.Rout in the Makefile
* copying text from makestuff/makeRex.R to make a non-automatic wrapper.

Hopefully this means we can have a smooth transition. You shouldn't need to change anything until you're ready.
