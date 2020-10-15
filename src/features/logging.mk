#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: logging.mk
#
# PURPOSE:
# To facilitate logging for makefile projects.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-09-25
# REVISED: 2020-10-15
# =========================================================================== #


# =========================================================================== #
# EXTERNAL CONSTANTS
# =========================================================================== #


# -- Logging -- #

# 0 = false, 1 = true
LOGGING ?= false


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Filesystem -- #

LOG := make.log

# -- Logging -- #

ifneq ($(VERBOSE),0)
STDOUT = >$(LOG) 2>&1
endif


# =========================================================================== #
# USER-DEFINED FUNCTIONS
# =========================================================================== #


# -- Logging -- #

# $(call log-str,log-type,msg)
# Prints a log message of a specified type:
# 1. FATAL
# 2. ERROR
# 3. WARN
# 4. INFO
# 5. DEBUG
# 6. TRACE
define log-str
	echo "$(date +%Y-%m-%dT%H:%M:%S%z)|$1|$2"
endef

# $(call mark-start)
# Prints an informational log message marking the start of a target.
define mark-start
	$(LOGGING) && $(call log-str,INFO,Start of target $@.)
endef

# $(call mark-end)
# Prints an informational log message marking the end of a target.
define mark-end
	$(LOGGING) && $(call log-str,INFO,End of target $@.)
endef



# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Main Targets -- #

.PHONY: log

## log: Shows the most recently generated log.
log: $(LOG)
	@echo "Showing log $(prereq_var):"
	@echo
	@cat $(LOG)


# =========================================================================== #
# INTERMEDIATE TARGETS
# =========================================================================== #


.INTERMEDIATE: $(LOG)

# Makes a temporary file capturring a shell command error.
$(LOG):
	@touch $@
