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
# REVISED: 2020-10-08
# =========================================================================== #


# =========================================================================== #
# EXTERNAL CONSTANTS
# =========================================================================== #


# -- Source Code Management (SCM) -- #

# Default branch.  (Historically, this was `master` but is now `main`.)
DEFUALT_BRANCH ?= $(shell git symbolic-ref --short HEAD)

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
	git commit $(Q) -m "$2($3): $4"
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

# $(call gf-feature-finish,feature)
# Finalizes a Git feature branch.
# Equivalent to `git flow feature finish $1`, except for:
# 1. The `--no-edit` option for the `git merge` command.
define gf-feature-finish
	git checkout $(Q) develop; \
	git merge $(Q) --no-edit --no-ff feature/$1; \
	git branch $(Q) --delete feature/$1
endef

# $(call gf-feature-publish,feature)
# Shares a Git feature branch.
# Equivalent to `git flow feature publish $1`.
define gf-feature-publish
	git checkout $(Q) feature/$1; \
	git push $(Q) origin feature/$1
endef

# $(call gf-feature-pull,feature)
# Gets the latest changes for a feature branch.
# Equivalent to `git flow feature pull origin $1`.
define gf-feature-pull
	git checkout $(Q) feature/$1; \
	git pull $(Q) --rebase origin feature/$1
endef

# $(call gf-feature-start,feature)
# Creates a Git feature branch.
# Equivalent to `git flow feature start $1`.
define gf-feature-start
	git checkout $(Q) -b feature/$1 develop
endef

# $(call gf-init,msg)
# Initializes a Git branching strategy.
# Equivalent to `git flow init`, except for:
# 1. The value of the commit message.
define gf-init
	git init $(Q); \
	git commit $(Q) --allow-empty -m "feat(git): $1"; \
	git checkout $(Q) -b develop $(DEFUALT_BRANCH)
endef

# $(call gf-release-finish,tag,message)
# Finalizes a Git release branch.
# Equivalent to `git flow release finish $1`, except for:
# 1. The `-m` option for the `git tag` command;
# 2. The `--no-edit` option for the `git merge` command.
define gf-release-finish
	git checkout $(Q) $(DEFUALT_BRANCH); \
	git merge $(Q) --no-edit --no-ff --quiet release/$1; \
	git tag --annotate $1 -m "$2"; \
	git checkout $(Q) develop; \
	git merge $(Q) --no-edit --no-ff --quiet release/$1; \
	git branch $(Q) --delete release/$1
endef

# $(call gf-release-finish-major,tag,message)
# Finalizes a major Git release branch.
define gf-release-finish-major
	$(call release-finish,$1,Major release $1 | $2)
endef

# $(call gf-release-finish-minor,tag,message)
# Finalizes a minor Git release branch.
define gf-release-finish-minor
	$(call release-finish,$1,Minor release $1 | $2)
endef

# $(call gf-release-publish,tag)
# Shares a Git release branch.
# Equivalent to `git flow release publish $1`.
define gf-release-publish
	git checkout $(Q) release/$1;
	git push $(Q) origin release/$1
endef

# $(call gf-release-pull,tag)
# Gets the latest changes for a Git release branch.
# Has no equivalent `git flow` command.
define gf-release-pull
	git checkout $(Q) release/$1;
	git pull $(Q) --rebase origin release/$1
endef

# $(call gf-release-start,tag)
# Creates a Git release branch.
# Equivalent to `git flow release start $1`.
define gf-release-start
	git checkout $(Q) -b release/$1 develop
endef


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Prerequisite for "clean" Target -- #

#.PHONY: clean-git release-git
.PHONY: clean-git

## clean-git: Completes all git cleanup activities.
clean-git: | $(LOG)
	@${RM} .git* >$(LOG) 2>&1; \
	$(call step,Removing Git setup,$(DONE))

# -- Prerequisite for "git" Target -- #

.PHONY: git-% git-dot-files

git-dot-files: .gitattributes .gitignore
	@$(call gf-feature-start,$@)
	@$(foreach f,$^,$(call commit-unstaged,$(f),feat,git);)
	@$(call gf-feature-finish,$@)

# -- Prerequisite for "init" Target -- #

.PHONY: init-git init-git-dot-files init-git-flow

## init-git: Completes all initial Git setup activities.
init-git: .git init-git-flow git-dot-files
	@$(call gf-release-start,0.1.0); \
	$(call gf-release-finish-minor,0.1.0,Initial project setup)

#init-git: .gitignore .git | $(LOG)
#	@printf "Committing the initial project to the $(DEFUALT_BRANCH) branch..."
#	@git checkout -b $(DEFUALT_BRANCH) >$(LOG) 2>&1; \
#	$(status_result)
#	@printf "Syncing the initial project with the origin..."
#	@git remote add origin $(GH_ORIGIN_URL) >$(LOG) 2>&1; \
#	git pull origin $(DEFUALT_BRANCH) >$(LOG) 2>&1; \
#	git push -u origin $(DEFUALT_BRANCH) >$(LOG) 2>&1; \
#	$(status_result)

## init-git-flow: Initializes git-flow setup.
init-git-flow: | $(LOG)
	@git flow init -d >$(LOG) 2>&1; \
	$(call step,Initializing git-flow branching strategy,$(DONE))


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

## ~/.gitconfig: Makes a .gitattributes file.
~/.gitconfig:
	@git config --global user.name
	$(call step,Making file $(target_var),$(DONE))

# Makes a special empty file for marking that a directory tree has been generated.
%/.gitkeep:
	@MKDIR $(@D); \
	$(call step,Making missing directories in the path of marker file $(target_var),$(DONE))
	@touch $@; \
	$(call step,Making marker file $(target_var),$(DONE))


# =========================================================================== #
# SECOND EXPANSION TARGETS
# =========================================================================== #


.SECONDEXPANSION:
# Make a directory tree.
#$(MAKEFILE_DIR)/%.gitkeep: $$(@D)/.gitkeep | $$(@D)/.
