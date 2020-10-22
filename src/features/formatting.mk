#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: formatting.mk
#
# PURPOSE:
# To facilitate string formatting.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-25
# REVISED: 2020-10-21
# =========================================================================== #


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Special Characters -- #

# C-style octal code representing an ASCII escape character.
ESC := \033

# Whitespace.
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

# -- ANSI Escape Sequences -- #

# Text intensity/emphasis of STDOUT.
RESET := $(ESC)[0m
BOLD := $(ESC)[1m
DIM := $(ESC)[2m

# Text color of STDOUT.
FG_CYAN := $(ESC)[0;36m
FG_GREEN := $(ESC)[0;32m
FG_RED := $(ESC)[0;31m
FG_YELLOW := $(ESC)[1;33m

# -- Formatted Strings -- #

# Color-formatted outcome statuses, each of which is based on the return code
# ($$?) of having run a shell command.
DONE := $(FG_GREEN)done$(RESET).
FAILED := $(FG_RED)failed$(RESET).
IGNORE := $(FG_YELLOW)ignore$(RESET).
PASSED := $(FG_GREEN)passed$(RESET).


# =========================================================================== #
# INTERNAL VARIABLES
# =========================================================================== #


# -- Formatted Strings -- #

# Color-formatted names of filesystem paths.
dir_var = $(FG_CYAN)$(@D)$(RESET)
file_var = $(FG_CYAN)$(@F)$(RESET)
subdir_var = $(FG_CYAN)$(shell basename $(@D))$(RESET)

# Color-formatted names of makefile automatic variables.
prereq_var = $(FG_CYAN)$<$(RESET)
target_var = $(FG_CYAN)$@$(RESET)
