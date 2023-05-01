# GitHub.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
# Facilitate GitHub-hosted remote Git repository ("repo") initialization,
# setup, and cleanup.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


# =========================================================================== #
# EXTERNAL VARIABLES
# =========================================================================== #


# -- Accounts -- #

GH_USER ?= $(shell whoami)
GH_PASSWORD ?= $()

# -- Source Code Management (SCM) -- #

# GitHub API v3
GH_PROJECT_DESCRIPTION ?= This is a mock project.
GH_LICENSE_TEMPLATE ?= mit
GH_REPO_NAME ?= mock
GH_PRIVATE ?= true


# ============================================================================ #
# INTERNAL VARIABLES
# ============================================================================ #


# -- Source Code Management (SCM) -- #

# GitHub
GH_REPO_PATH := $(GH_USER)/$(GH_REPO_NAME)
GH_ORIGIN_URL := https://github.com/$(GH_REPO_PATH).git
GH_RAW_URL := https://raw.githubusercontent.com/$(GH_REPO_PATH)/master/%7B%7Bcookiecutter.project_name%7D%7D

# GitHub API v3
GH_API_URL := https://api.github.com/user/repos
GH_DATA := "name": "$(GH_REPO_NAME)"
GH_DATA += , "description": "$(GH_PROJECT_DESCRIPTION)"
GH_DATA += , "private": "$(GH_PRIVATE)"
ifeq ($(GH_LICENSE_TEMPLATE),)
GH_DATA += , "license_template": "$(GH_LICENSE_TEMPLATE)"
endif


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Prerequisites for "clean" Target -- #

.PHONY: clean-github clean-docs-github

## clean-github: Completes all GitHub cleanup activities.
clean-github: clean-docs-github
	@$(call recipe-start-msg)
	@$(call recipe-end-msg)

## clean-docs-github: Completes all GitHub Markdown cleanup activities.
clean-docs-github: | $(LOG)
	@$(call recipe-start-msg)
	@$(RM) .github $(STDOUT); \
	$(call cmd-msg,Removing GitHub documents)
	@$(call recipe-end-msg)

# -- Prerequisite for "docs" Target -- #

.PHONY: docs-github

## docs-github: Completes all GitHub document generation activites.
docs-github: $(GITHUB_FILES)
	@$(call recipe-start-msg)
	@$(call recipe-end-msg)

# -- Prerequisites for "init" Target -- #

.PHONY: init-github

## init-github: Completes all initial Github setup activites.
init-github:
	@$(call recipe-start-msg)
	@$(CURL) --user $(GH_USER) --data '{$(GH_DATA)}' $(GH_API_URL); \
	$(call cmd-msg,Initializing GitHub repository)
	@$(call recipe-end-msg)
