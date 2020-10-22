#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: custom.mk
#
# PURPOSE:
# To decouple dependency inclusion from the main makefile.  Note that these
# dependencies must proceed in the order specified below.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-10-22
# REVISED: 2020-10-22
# =========================================================================== #


# =========================================================================== #
# DEPENDENCIES
# =========================================================================== #


-include $(MAKE_DIR)src/features/debugging.mk
-include $(MAKE_DIR)src/features/formatting.mk
-include $(MAKE_DIR)src/features/helping.mk
-include $(MAKE_DIR)src/features/logging.mk

-include $(MAKE_DIR)src/utilities/commands.mk
-include $(MAKE_DIR)src/utilities/messages.mk

-include $(MAKE_DIR)src/platforms/Git.mk
-include $(MAKE_DIR)src/platforms/GitHub.mk
-include $(MAKE_DIR)src/platforms/Python.mk
