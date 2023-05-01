# logging.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# Facilitate logging for makefile projects.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


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
