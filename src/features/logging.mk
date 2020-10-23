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
# REVISED: 2020-10-23
# =========================================================================== #


# =========================================================================== #
# EXTERNAL CONSTANTS
# =========================================================================== #

# -- Filesystem -- #

# Conditionally set the name of the log file.
LOG := make.log

# -- Logging -- #

# Conditionally set the flag for logging: true or false.
LOGGING ?= false

# Conditionally set where to direct standard output/error.
STDOUT ?= >>$(LOG) 2>&1


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


#.INTERMEDIATE: $(LOG)

# Makes a temporary file capturring a shell command error.
$(LOG):
	@touch $@
