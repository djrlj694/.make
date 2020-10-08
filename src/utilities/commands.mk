#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: commands.mk
#
# PURPOSE:
# To reduce shell command verbosity via constants representing prefixes to
# such commands.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-26
# REVISED: 2020-10-08
# =========================================================================== #


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Commands -- #

# Command prefix for transferring data.
CURL := curl $(S) --location --fail --show-error
ifeq ($(VERBOSE),0)
CURL += --output /dev/null
endif

# Command prefix for creating directores.
MKDIR := mkdir $(V) -p

# Command prefix for removing directores/files.
RM := rm $(V) -rf

# -- Command Options -- #

ifeq ($(VERBOSE),0)
Q := --quiet
S := --silent
endif

ifneq ($(VERBOSE),0)
V := -v
endif
