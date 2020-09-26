# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: logging.mk
# AUTHORS: Robert (Bob) L. Jones
# CREATED: 25SEP2020
# REVISED: 25SEP2020
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
