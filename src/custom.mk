# custom.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# Decouples dependency inclusion from the main makefile.  Note that these
# dependencies must proceed in the order specified below.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


# =========================================================================== #
# INCLUDES
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
