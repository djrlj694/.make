#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: logging.mk
#
# PURPOSE:
# To facilitate logging for makefile projects.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-25
# REVISED: 2020-09-30
# =========================================================================== #


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Filesystem -- #

LOG := make.log


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Main Targets -- #

.PHONY: log

## log: Shows the most recently generated log.
log: $(LOG)
	@echo "Showing log $(prereq_var):"
	@echo
	@cat $(LOG)


# =========================================================================== #
# INTERMEDIATE TARGETS
# =========================================================================== #


.INTERMEDIATE: $(LOG)

# Makes a temporary file capturring a shell command error.
$(LOG):
	@touch $@
