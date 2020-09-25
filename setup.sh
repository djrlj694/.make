#!/bin/bash
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: setup.sh
#
# PURPOSE:
# 1. To copy and rename the main makefile above the `.make` directory;
# 2. To remove non-essential, leftover artifacts from cloning this project.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: Nov 21, 2019
# REVISED: Apr 16, 2020
# =========================================================================== #


# =========================================================================== #
# MAIN EXECUTION
# =========================================================================== #


cp -p Makefile.sample ../Makefile
rm -rf .git
