#!/bin/bash
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: setup.sh
#
# PURPOSE:
# 1. To copy the main makefile sample to a renamed target above the current
#    directory, where it will become the main makefile;
# 2. To remove non-essential, leftover artifacts from cloning this project.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-25
# REVISED: 2020-09-30
# =========================================================================== #


# =========================================================================== #
# MAIN EXECUTION
# =========================================================================== #


cp -p Makefile.sample ../Makefile
rm -rf .git
