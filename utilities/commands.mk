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
CURL := curl --silent --fail --show-error --location --output /dev/null

# Command prefix for creating directores.
MKDIR := mkdir -p

# Command prefix for removing directores/files.
RM := rm -rf
