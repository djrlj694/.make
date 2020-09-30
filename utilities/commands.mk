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
# REVISED: 2020-09-30
# =========================================================================== #


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Commands -- #

# Command prefix for transferring data.
CURL := curl --location --fail --show-error
ifeq ($(VERBOSE),0)
CURL += --silent --output /dev/null
endif


# Command prefix for creating directores.
MKDIR := mkdir -p
ifneq ($(VERBOSE),0)
MKDIR += -v
endif

# Command prefix for removing directores/files.
RM := rm -rf
ifneq ($(VERBOSE),0)
RM += -v
endif
