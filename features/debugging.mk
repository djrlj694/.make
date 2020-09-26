# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: debugging.mk
# AUTHORS: Robert (Bob) L. Jones
# CREATED: 25SEP2020
# REVISED: 26SEP2020
# =========================================================================== #


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Debugging & Error Capture -- #

# A list of makefile variables to show when testing/debugging.
VARIABLES_TO_SHOW := MAKE_DIR MAKEFILE MAKEFILE_DIR MAKEFILE_LIST
VARIABLES_TO_SHOW += PWD

# -- Result Strings -- #

# Color-formatted outcome statuses, each of which is based on the return code
# ($$?) of having run a shell command.
DONE := $(FG_GREEN)done$(RESET).\n
FAILED := $(FG_RED)failed$(RESET).\n
IGNORE := $(FG_YELLOW)ignore$(RESET).\n
PASSED := $(FG_GREEN)passed$(RESET).\n


# =========================================================================== #
# INTERNAL VARIABLES
# =========================================================================== #


# -- Debugging & Error Capture -- #

status_result = $(call result,$(DONE))
test_result = $(call result,$(PASSED))


# =========================================================================== #
# USER-DEFINED FUNCTIONS
# =========================================================================== #


# -- Debugging & Error Capture -- #

# $(call result,formatted-string)
# Prints a success string ($DONE or $PASSED) if the most recent return code
# ($$?) value equals 0; otherwise, prints a failure string ($FAILED) and the
# associated error message.
define result
	([ $$? -eq 0 ] && printf "$1") || \
	(printf "$(FAILED)\n" && cat $(LOG) && echo)
endef


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Main Targets -- #

.PHONY: debug

## debug: Completes all debugging activities.
debug: debug-vars-some debug-dirs-tree

# -- Prerequisites for "debug" Target -- #

.PHONY: debug-dirs-ll debug-dirs-tree debug-vars-all debug-vars-some

## debug-dirs-ll: Shows the contents of directories in a "long listing" format.
debug-dirs-ll:
	ls -alR $(MAKEFILE_DIR)

## debug-dirs-tree: Shows the contents of directories in a tree-like format.
debug-dirs-tree:
	tree -a $(MAKEFILE_DIR)

## debug-vars-all: Shows all makefile variables (i.e., built-in and custom).
debug-vars-all:
	@echo
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))

## debug-vars-some: Shows only some custom makefile variables.
debug-vars-some:
	@echo
	$(foreach v, $(VARIABLES_TO_SHOW), $(info $(v) = $($(v))))
