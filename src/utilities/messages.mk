#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: messages.mk
#
# PURPOSE:
# To standardize how status/test/log messages are formatted.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-10-21
# REVISED: 2020-10-22
# =========================================================================== #


# =========================================================================== #
# USER-DEFINED FUNCTIONS
# =========================================================================== #


# -- Error Capture -- #

# $(call rc-msg,msg)
# Prints messages, based on the return code ($1) from the previously executed
# command.
define rc-msg
export RC=$$?; \
$(call rc-log-msg,$$RC,$1); \
$(call rc-status-msg,$$RC,$1.)
endef

# $(call rc-log-msg,rc,msg)
# Prints a log-oriented message, based on the return code ($1) from the
# previously executed command.
define rc-log-msg
[ $1 -eq 0 ] && $(call log-msg,INFO,$2) || $(call log-msg,ERROR,$2)
endef

# $(call rc-status-msg,rc,msg)
# Prints a status-orient message, based on the return code ($1) from the
# previously executed command.
define rc-status-msg
[ $1 -eq 0 ] && echo "$2...$(DONE)" || echo "$2...$(FAILED)"
endef

# $(call rc-test-msg,rc,msg)
# Prints a test-oriented message, based on the return code ($1) from the
# previously executed.
define rc-test-msg
[ $1 -eq 0 ] && echo "$2...$(PASS)" || echo "$2...$(FAILED)"
endef

# -- Logging -- #

# $(call log-msg,log-type,msg)
# Prints a log message of a specified type:
# 1. FATAL
# 2. ERROR
# 3. WARN
# 4. INFO
# 5. DEBUG
# 6. TRACE
define log-msg
($(LOGGING) && echo "$$(date +%Y-%m-%dT%H:%M:%S%z)|$1|$2")
endef

# $(call recipe-end-msg)
# Prints an informational log message marking the end of a target's recipe.
define recipe-end-msg
$(call log-msg,INFO,End of recipe for target $@.)
endef

# $(call recipe-start-msg)
# Prints an informational log message marking the start of a target's recipe.
define recipe-start-msg
$(call log-msg,INFO,Start of recipe for target $@.)
endef
