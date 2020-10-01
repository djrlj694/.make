#!/bin/bash
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: setup.sh
#
# PURPOSE:
# 1. To copy the main makefile sample to a renamed target above the makefile
#    project root, where it will become the main makefile;
# 2. To remove non-essential, leftover artifacts from cloning this project
#    (e.g., the local Git repo).
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


# The local Git repo removal flag.
# ${REMOVE_GIT} = 0 (default): keep
# ${REMOVE_GIT} = 1: remove
REMOVE_GIT="${REMOVE_GIT:-0}"


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

# Conditionally remove the local Git repo.
# Example 1 (keep repo):   $ ./bin/setup.sh
# Example 2 (keep repo):   $ REMOVE_GIT=0 ./bin/setup.sh
# Example 3 (remove repo): $ REMOVE_GIT=1 ./bin/setup.sh
[ ${REMOVE_GIT} = 1 ] && rm -rf "${PROJROOT}/.git"
