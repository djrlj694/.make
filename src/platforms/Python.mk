# Python.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# Facilitate Python project initialization, setup, and cleanup.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


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
