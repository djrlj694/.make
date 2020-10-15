#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: debugging.mk
#
# PURPOSE:
# To facilitate the debugging of makefile projects.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-25
# REVISED: 2020-10-15
# =========================================================================== #


# =========================================================================== #
# EXTERNAL CONSTANTS
# =========================================================================== #


# -- Debugging -- #

# 0 = false, 1 = true
VERBOSE ?= 0


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Debugging -- #

# A list of makefile variables to show when testing/debugging.
VARIABLES_TO_SHOW := MAKE_DIR MAKEFILE MAKEFILE_DIR MAKEFILE_LIST
VARIABLES_TO_SHOW += PWD VERBOSE


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Main Targets -- #

.PHONY: debug

## debug: Completes all debugging activities.
debug: debug-vars-some debug-dirs-tree

# -- Prerequisites for "debug" Target -- #

.PHONY: debug-dirs-ll debug-dirs-tree debug-vars-all debug-vars-some

## debug-dirs-ll: Shows the contents of directories in a "long listing" format.
debug-dirs-ll:
	ls -alR $(MAKEFILE_DIR)

## debug-dirs-tree: Shows the contents of directories in a tree-like format.
debug-dirs-tree:
	tree -a $(MAKEFILE_DIR)

## debug-vars-all: Shows all makefile variables (i.e., built-in and custom).
debug-vars-all:
	@echo
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))

## debug-vars-some: Shows only some custom makefile variables.
debug-vars-some:
	@echo
	$(foreach v, $(VARIABLES_TO_SHOW), $(info $(v) = $($(v))))
