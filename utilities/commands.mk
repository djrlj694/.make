# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: constants.mk
# AUTHORS: Robert (Bob) L. Jones
# CREATED: 26SEP2020
# REVISED: 29SEP2020
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
