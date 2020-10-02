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
# USER-DEFINED FUNCTIONS
# =========================================================================== #


# -- Source Code Management (SCM) -- #

# $(call commit,file,type,scope,description)
# Commits a file to Git.
define commit
	git add $1; \
	git commit -m "$2($3): $4"
endef

# $(call commit-modified,file,type,scope)
# Commits a modified (i.e., existing) file to Git.
define commit-modified
	$(call commit,$1,$2,$3,Update $1)
endef

# $(call commit-unstaged,file,type,scope)
# Commits an unstaged (i.e., new) file to Git.
define commit-unstaged
	$(call commit,$1,$2,$3,Create $1)
endef

# $(call release-finish,tag,message)
# Finalizes a Git release branch.
# Equivalent to `git flow release finish $1`
# (except for `-m` option for the `git tag` command).
define release-finish
	git checkout master; \
	git merge --no-ff release/$1; \
	git tag -a $1 -m "$2"; \
	git checkout develop; \
	git merge --no-ff release/$1; \
	git branch -d release/$1
endef

# $(call release-finish-major,tag,message)
# Finalizes a major Git release branch.
define release-finish-major
	$(call release-finish,$1,Major release $1 | $2)
endef

# $(call release-finish-minor,tag,message)
# Finalizes a minor Git release branch.
define release-finish-minor
	$(call release-finish,$1,Minor release $1 | $2)
endef


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Prerequisite for "clean" Target -- #

#.PHONY: clean-git release-git
.PHONY: clean-git

## clean-git: Completes all git cleanup activities.
clean-git: | $(LOG)
	@printf "Removing git setup..."
	@${RM} .git* >$(LOG) 2>&1; \
	$(status_result)

# -- Prerequisite for "git" Target -- #

.PHONY: git-% git-dot-files

git-dot-files: .gitattributes .gitignore
	@git flow feature start $@
	@$(foreach f,$^,$(call commit-unstaged,$(f),feat,git);)
	@git flow feature finish $@

# Commits an unstaged file to Git.
git-%: %
	@git add $<
	@git commit -m "feat(git): Create $<"

# -- Prerequisite for "init" Target -- #

.PHONY: init-git init-git-dot-files init-git-flow

## init-git: Completes all initial Git setup activities.
init-git: .git init-git-flow git-dot-files
	@git flow release start 0.1.0
	@$(call release-finish-minor,0.1.0,Initial project setup)
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

git-dot-files: .gitattributes .gitignore
	@git flow feature start $@
	@$(foreach f,$^,$(call commit-unstaged,$(f),feat,git);)
	@git flow feature finish $@

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
