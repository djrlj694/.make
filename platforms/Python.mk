#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: Python.mk
#
# PURPOSE:
# To facilitate Python project initialization, setup, and cleanup.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-30
# REVISED: 2020-09-30
# =========================================================================== #


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Prerequisites for "clean" Target -- #

.PHONY: clean-python clean-python-build clean-python-pyc

## clean-python: Completes all Python cleanup activities.
clean-python: clean-python-build clean-python-pyc

# Cleans Python files that are always created in the project's root directory.
clean-python-build:
	@echo
	$(RM) *.egg-info

# Cleans Python files that could be created anywhere in the project.
clean-python-pyc:
	@echo
	find . -name '*.pyc' -exec $(RM) {} +
	find . -name '*.pyo' -exec $(RM) {} +
	find . -name '*~' -exec $(RM)  {} +
