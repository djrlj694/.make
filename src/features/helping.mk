# helping.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# To facilitate command-line interface (CLI) for makefile projects.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


# =========================================================================== #
# INTERNAL VARIABLES
# =========================================================================== #

# -- Help Strings -- #

# Argument syntax for the "make" command.
MAKE_ARGS := [$(FG_CYAN)<target>$(RESET)]

# "Targets" section line item of the "make" command's online help.
target_help = $(FG_CYAN)%-17s$(RESET) %s


# =========================================================================== #
# MACROS
# =========================================================================== #

# -- Help Strings -- #

# "Targets" section header of the "make" command's online help.
define targets_help

Targets:

endef
export targets_help

# "Usage" section of the "make" command's online help.
define usage_help

Usage:
  make $(FG_CYAN)<target>$(RESET) $(MAKE_ARGS)

endef
export usage_help


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #

# -- Main Targets -- #

.PHONY: help

## help: Shows the "make" command's online help.
help:
	@printf "$$usage_help"
	@printf "$$targets_help"
# Use the makefile project as a data source for displaying a lexicographically
# sorted, color-formatted list of targets.
#
# Note:
# 1. "cat" handles $MAKEFILE_LIST, a space-delimited list of makefiles that
#    includes Makefile and makefiles with the extension ".mk".
# 2. "egrep" filters for makefile lines with:
#    a. "## " starting at column 1;
#    b. The name of of the target preceding a colon, followed by a space.
	@cat $(MAKEFILE_LIST) | \
	egrep '^## [a-zA-Z_-]+: ' | \
	sed -e 's/## //' | sort -d | \
	awk 'BEGIN {FS = ": "}; {printf "  $(target_help)\n", $$1, $$2}'
	@echo ""
