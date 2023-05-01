# commands.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# Reduces shell command verbosity via constants representing prefixes to such
# commands.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


# =========================================================================== #
# INTERNAL VARIABLES
# =========================================================================== #


# -- Commands -- #

# Command options for no verbosity.
ifeq ($(VERBOSE),0)
Q := --quiet
S := --silent
endif

# Command options for verbosity.
ifneq ($(VERBOSE),0)
V := -v
endif

# Command prefix for transferring data.
CURL := curl $(S) --location --fail --show-error
ifeq ($(VERBOSE),0)
CURL += --output /dev/null
endif

# Command prefix for creating directores.
MKDIR := mkdir $(V) -p

# Command prefix for removing directores/files.
RM := rm $(V) -rf
