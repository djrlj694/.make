#!/bin/bash
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: setup.sh
#
# PURPOSE:
# 1. To copy the main makefile sample to a renamed target above the makefile
#    project root, where it will become the main makefile;
# 2. To remove non-essential artifacts.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-25
# REVISED: 2020-10-01
# =========================================================================== #


# =========================================================================== #
# EXTERNAL CONSTANTS
# =========================================================================== #


# The artifacts removal flag.
# ${CLEAN} = 0 (default): keep
# ${CLEAN} = 1: remove
CLEAN="${CLEAN:-0}"


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# This project's root directory.
# Example: ~/.make/bin/..
PROJROOT="$(dirname "$0")/.."


# =========================================================================== #
# MAIN EXECUTION
# =========================================================================== #

# Copy tthe main makefile sample to a renamed target above the current
cp -p "${PROJROOT}/etc/Makefile.sample" "${PROJROOT}/../Makefile"

# Conditionally remove non-essential artifacts.
# Example 1 (keep artifacts):   $ ./bin/setup.sh
# Example 2 (keep artifacts):   $ CLEAN=0 ./bin/setup.sh
# Example 3 (remove artifacts): $ CLEAN=1 ./bin/setup.sh
if [ ${CLEAN} = 1 ]; then
    rm -rf "${PROJROOT}/.git"
    rm -rf "${PROJROOT}/.gitattributes"
    rm -rf "${PROJROOT}/.gitignore"
    rm -rf "${PROJROOT}/.pre-commit-config.yaml"
    rm -rf "${PROJROOT}/CODE_OF_CONDUCT.md"
    rm -rf "${PROJROOT}/CONTRIBUTING.md"
fi
