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

# $(call rc-msg,msg,success-str)
# Echos a message, followed by a success string ($DONE or $PASSED) or failure
# string ($FAILED), depending on the return code ($$?) from the previously
# executed command.
define rc-msg
	[ $$? -eq 0 ] && echo "$1...$2" || echo "$1...$(FAILED)"
endef

# $(call status-msg,msg)
# Echos a message, followed by a success string ($DONE) or failure string
# ($FAILED), depending on the return code ($$?) from the previously executed
# command.  Intended for communicating the outcome status of a non-test target
# rule.
define status-msg
	$(call rc-msg,$1,$(DONE))
endef

# $(call status-msg,msg)
# Echos a message, followed by a success string ($PASS) or failure string
# ($FAILED), depending on the return code ($$?) from the previously executed
# command.  Intended for communicating the outcome status of a test target rule.
define test-msg
	$(call test-msg,$1,$(PASS))
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
	$(LOGGING) && echo "$$(date +%Y-%m-%dT%H:%M:%S%z)|$1|$2"
endef

# $(call recipe-end-msg)
# Prints an informational log message marking the end of a target.
define recipe-end-msg
	$(call log-msg,INFO,End of target $@.)
endef

# $(call recipe-start-msg)
# Prints an informational log message marking the start of a target.
define recipe-start-msg
	$(call log-msg,INFO,Start of target $@.)
endef
