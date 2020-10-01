#!/usr/bin/make -f
# =========================================================================== #
# Copyright © 2020 djrlj694.dev. All rights reserved.
# =========================================================================== #
# PROGRAM: Git.mk
#
# PURPOSE:
# To facilitate local Git repository ("repo") initialization, setup, and
# cleanup.
#
# AUTHORS:
# 1. Robert (Bob) L. Jones
#
# CREATED: 2020-10-01
# REVISED: 2020-10-01
# =========================================================================== #


# =========================================================================== #
# EXTERNAL CONSTANTS
# =========================================================================== #


# OSes, IDEs, or programming languagses
TOOLCHAIN ?= dropbox,macos,vim,visualstudiocode,windows


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Prerequisite for "clean" Target -- #

#.PHONY: clean-git release-git
.PHONY: clean-git

## clean-git: Completes all git cleanup activities.
clean-git: | $(LOG)
	@printf "Removing git setup..."
	@${RM} .git .gitignore >$(LOG) 2>&1; \
	$(status_result)

# -- Prerequisite for "init" Target -- #

.PHONY: init-git init-git-dot-files init-git-flow

## init-git: Completes all initial Git setup activities.
init-git: .git init-git-flow .gitattributes .gitignore
	@git flow feature start git-dot-files
	@git add .gitattributes
	@git commit -m "feat(git): Create .gitattributes"
	@git add .gitignore
	@git commit -m "feat(git): Create .gitignore"
	@git flow feature finish git-dot-files
	@git flow release start 0.1.0
	@git flow release finish 0.1.0
	@printf "Committing file changes ..."

#init-git: .gitignore .git | $(LOG)
#	@printf "Committing the initial project to the master branch..."
#	@git checkout -b master >$(LOG) 2>&1; \
#	$(status_result)
#	@printf "Syncing the initial project with the origin..."
#	@git remote add origin $(GH_ORIGIN_URL) >$(LOG) 2>&1; \
#	git pull origin master >$(LOG) 2>&1; \
#	git push -u origin master >$(LOG) 2>&1; \
#	$(status_result)

init-git-dot-files: .gitattributes .gitignore


## init-git-flow: Initializes git-flow setup.
init-git-flow: | $(LOG)
	@printf "Initializing git-flow branching strategy..."
	@git flow init -d >$(LOG) 2>&1; \
	$(status_result)


# =========================================================================== #
# DIRECTORY TARGETS
# =========================================================================== #


## .git: Makes a Git repository.
.git: | $(LOG)
ifeq ($(GH_ORIGIN_URL),)
	@git init >$(LOG) 2>&1; \
	$(call step,Initializing Git repository,$(DONE))
else
	@git clone $(GH_ORIGIN_URL) >$(LOG) 2>&1; \
	$(call step,Cloning Git repository from '$(GH_ORIGIN_URL)',$(DONE))
endif


# =========================================================================== #
# FILE TARGETS
# =========================================================================== #


## .gitattributes: Makes a .gitattributes file.
.gitattributes:
	@echo "# Auto detect text files and perform LF normalization" >$@; \
	echo "* text=auto" >>$@; \
	$(call step,Making file $(target_var),$(DONE))

## .gitignore: Makes a .gitignore file.
.gitignore:
	$(eval base_url = https://www.toptal.com)
	$(eval path = /developers/gitignore/api/)
	$(eval url = $(base_url)$(path)$(TOOLCHAIN))
	@$(CURL) $(url) --output $@ >$@; \
	$(call step,Downloading file $(target_var),$(DONE))

# Makes a special empty file for marking that a directory tree has been generated.
%/.gitkeep:
	@printf "Making missing directories in the path of marker file $(target_var)..."
	@MKDIR $(@D); \
	$(status_result)
	@printf "Making marker file $(target_var)..."
	@touch $@; \
	$(status_result)


# =========================================================================== #
# SECOND EXPANSION TARGETS
# =========================================================================== #


.SECONDEXPANSION:
# Make a directory tree.
#$(PREFIX)/%.gitkeep: $$(@D)/.gitkeep | $$(@D)/.
