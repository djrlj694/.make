# messages.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# To standardize how messages to standard out (STDOUT) / error (STDERR) are
# formatted.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


# =========================================================================== #
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Formatted Strings -- #

# Color-formatted log types.
ERROR := $(FG_RED)ERROR$(RESET)
FATAL := $(FG_RED)FATAL$(RESET)
INFO := $(FG_GREEN)INFO$(RESET)
WARN := $(FG_YELLOW)WARN$(RESET)

# Color-formatted outcome statuses.
DONE := $(FG_GREEN)done$(RESET)
FAILED := $(FG_RED)failed$(RESET)
IGNORE := $(FG_YELLOW)ignore$(RESET)
PASSED := $(FG_GREEN)passed$(RESET)


# =========================================================================== #
# USER-DEFINED FUNCTIONS
# =========================================================================== #


# -- Logging -- #

# $(call log-msg,log-type,msg)
# Prints a specially formattted message for logging purposes.  Log message
# types, ranked by severity frrom highest to lowest, are as follows:
# 1. FATAL
# 2. ERROR
# 3. WARN
# 4. INFO
# 5. DEBUG
# 6. TRACE
define log-msg
($(LOGGING) && echo "$$(date +%Y-%m-%dT%H:%M:%S%z)|$1|$2." $(STDOUT))
endef

# $(call recipe-end-msg)
# Prints a trace log message marking the end of a target's recipe.
define recipe-end-msg
$(call log-msg,TRACE,End of recipe for target $(target_var))
endef

# $(call recipe-start-msg)
# Prints a trace log message marking the start of a target's recipe.
define recipe-start-msg
$(call log-msg,TRACE,Start of recipe for target $(target_var))
endef

# -- User Interface (UI) -- #

# $(call user-msg,outcome-status,msg)
# Prints a specially formatted message for user communication purposes.  User
# messages show the outcome status of a command or test.
define user-msg
echo "$2...$1."
endef

# -- Error Capture -- #

# $(call cmd-msg,msg)
# Prints messages, based on the return code ($?) from a previously run
# command.
define cmd-msg
if [ $$? -eq 0 ]; then \
$(call log-msg,$(INFO),$1); $(call user-msg,$(DONE),$1); \
else \
$(call log-msg,$(ERROR),$1); $(call user-msg,$(FAILED),$1); \
fi
endef

# $(call test-msg,msg)
# Prints messages, based on the return code ($?) from a previously run test.
# command or test.
define test-msg
if [ $$? -eq 0 ]; then \
$(call log-msg,$(INFO),$1); $(call user-msg,$(PASSED),$1); \
else \
$(call log-msg,$(WARN),$1); $(call user-msg,$(FAILED),$1); \
fi
endef
