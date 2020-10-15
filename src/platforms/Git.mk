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
# REVISED: 2020-10-15
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
# INTERNAL CONSTANTS
# =========================================================================== #


# -- Commands -- #

# Command prefix for listing, creating, or deleting branches.
GIT_BRANCH := git branch $(Q) $(V)

# Command prefix for switching branches or restoring working tree files.
GIT_CHECKOUT := git checkout $(Q)

# Command prefix for cloning a repository into a new directory.
GIT_CLONE := git clone $(Q) $(V)

# Command prefix for committing record changes to the repository.
GIT_COMMIT := git commit $(Q) $(V)

# Command prefix for creating an empty Git repository or reinitializing an
# existing one.
GIT_INIT := git init $(Q)

# Command prefix for joining two or more development histories together.
GIT_MERGE := git merge $(Q) $(V)

# Command prefix for fetching from and integrating with another repository or
# a local branch.
GIT_PULL := git pull $(Q) $(V)

# Command prefix for updating remote refs along with associated objects.
GIT_PUSH := git push $(Q) $(V)

# Command prefix for managing set of tracked repositories.
GIT_REMOTE := git remote $(V)


# =========================================================================== #
# USER-DEFINED FUNCTIONS
# =========================================================================== #


# -- Source Code Management (SCM) -- #

# $(call git-commit,file,type,scope,description)
# Commits a file to Git.
define git-commit
	git add $1; \
	$(GIT_COMMIT) -m "$2($3): $4"
endef

# $(call git-commit-modified,file,type,scope)
# Commits a modified (i.e., existing) file to Git.
define git-commit-modified
	$(call git-commit,$1,$2,$3,Update $1)
endef

# $(call git-commit-unstaged,file,type,scope)
# Commits an unstaged (i.e., new) file to Git.
define git-commit-unstaged
	$(call git-commit,$1,$2,$3,Create $1)
endef

# $(call git-flow-feature-finish,feature)
# Finalizes a Git feature branch.
# Equivalent to `git flow feature finish $1`, except for:
# 1. The `--no-edit` option for the `git merge` command.
define git-flow-feature-finish
	$(GIT_CHECKOUT) develop; \
	$(GIT_MERGE) --no-edit --no-ff feature/$1; \
	$(GIT_BRANCH) --delete feature/$1
endef

# $(call git-flow-feature-publish,feature)
# Shares a Git feature branch.
# Equivalent to `git flow feature publish $1`.
define git-flow-feature-publish
	$(GIT_CHECKOUT) feature/$1; \
	$(GIT_PUSH) origin feature/$1
endef

# $(call git-flow-feature-pull,feature)
# Gets the latest changes for a feature branch.
# Equivalent to `git flow feature pull origin $1`.
define git-flow-feature-pull
	$(GIT_CHECKOUT) feature/$1; \
	$(GIT_PULL) --rebase origin feature/$1
endef

# $(call git-flow-feature-start,feature)
# Creates a Git feature branch.
# Equivalent to `git flow feature start $1`.
define git-flow-feature-start
	$(GIT_CHECKOUT) -b feature/$1 develop
endef

# $(call git-flow-init)
# (Re)initializes a Git repository and branching strategy.
# Equivalent to `git flow init -d`, except for:
# 1. The value of the commit message.
define git-flow-init
	$(GIT_INIT); \
	$(GIT_COMMIT) --allow-empty -m "feat(git): Initial repo setup"; \
	$(GIT_CHECKOUT) -b develop $(DEFUALT_BRANCH)
endef

# $(call git-flow-release-finish,tag,message)
# Finalizes a Git release branch.
# Equivalent to `git flow release finish $1`, except for:
# 1. The `-m` option for the `git tag` command;
# 2. The `--no-edit` option for the `git merge` command.
define git-flow-release-finish
	$(GIT_CHECKOUT) $(DEFUALT_BRANCH); \
	$(GIT_MERGE) --no-edit --no-ff release/$1; \
	git tag --annotate $1 -m "$2"; \
	$(GIT_CHECKOUT) develop; \
	$(GIT_MERGE) --no-edit --no-ff release/$1; \
	$(GIT_BRANCH) --delete release/$1
endef

# $(call git-flow-release-finish-major,tag,message)
# Finalizes a major Git release branch.
define git-flow-release-finish-major
	$(call git-flow-release-finish,$1,Major release $1 | $2)
endef

# $(call git-flow-release-finish-minor,tag,message)
# Finalizes a minor Git release branch.
define git-flow-release-finish-minor
	$(call git-flow-release-finish,$1,Minor release $1 | $2)
endef

# $(call git-flow-release-publish,tag)
# Shares a Git release branch.
# Equivalent to `git flow release publish $1`.
define git-flow-release-publish
	$(GIT_CHECKOUT) release/$1; \
	$(GIT_PUSH) origin release/$1
endef

# $(call git-flow-release-pull,tag)
# Gets the latest changes for a Git release branch.
# Has no equivalent `git flow` command.
define git-flow-release-pull
	$(GIT_CHECKOUT) release/$1; \
	$(GIT_PULL) --rebase origin release/$1
endef

# $(call git-flow-release-start,tag)
# Creates a Git release branch.
# Equivalent to `git flow release start $1`.
define git-flow-release-start
	$(GIT_CHECKOUT) -b release/$1 develop
endef


# =========================================================================== #
# PHONY TARGETS
# =========================================================================== #


# -- Prerequisite for "clean" Target -- #

#.PHONY: clean-git release-git
.PHONY: clean-git

## clean-git: Completes all git cleanup activities.
clean-git: | $(LOG)
	@${RM} .git* $(STDOUT); \
	$(call status-msg,Removing Git setup)

# -- Prerequisite for "git" Target -- #

.PHONY: git-% git-dot-files

git-dot-files: .gitattributes .gitignore
	@$(call git-flow-feature-start,$@)
	@$(foreach f,$^,$(call git-commit-unstaged,$(f),feat,git);)
	@$(call git-flow-feature-finish,$@)

# -- Prerequisite for "init" Target -- #

.PHONY: init-git init-git-dot-files init-git-flow

## init-git: Completes all initial Git setup activities.
init-git: .git init-git-flow git-dot-files | $(LOG)
	$(eval release_tag = 0.1.0)
	$(eval release_tag_cyan = $(FG_CYAN)$(release_tag)$(RESET))
	$(eval release_msg = Initial project setup)
	@$(call git-flow-release-start,$(release_tag)); \
	$(call git-flow-release-finish-minor,$(release_tag),$(release_msg)); \
	$(call status-msg,Releasing initial project as version $(release_tag_cyan))
ifneq ($(GH_ORIGIN_URL),)
	@$(GIT_PUSH) --all -u origin $(STDOUT); \
	$(call status-msg,Syncing initial project with origin)
endif

## init-git-flow: Initializes git-flow setup.
init-git-flow: | $(LOG)
	@$(call git-flow-init) $(STDOUT); \
	$(call status-msg,Initializing git-flow branching strategy)


# =========================================================================== #
# DIRECTORY TARGETS
# =========================================================================== #


## .git: Makes a Git repository.
.git: | $(LOG)
ifeq ($(GH_ORIGIN_URL),)
	@$(GIT_INIT) $(STDOUT); \
	$(call status-msg,Initializing Git repository)
else
	@$(GIT_CLONE) $(GH_ORIGIN_URL) $(STDOUT); \
	$(call status-msg,Cloning Git repository from '$(GH_ORIGIN_URL)')
endif


# =========================================================================== #
# FILE TARGETS
# =========================================================================== #


## .gitattributes: Makes a .gitattributes file.
.gitattributes:
	@echo "# Auto detect text files and perform LF normalization" >$@; \
	echo "* text=auto" >>$@; \
	$(call status-msg,Making file $(target_var))

## .gitignore: Makes a .gitignore file.
.gitignore:
	$(eval base_url = https://www.toptal.com)
	$(eval path = /developers/gitignore/api/)
	$(eval url = $(base_url)$(path)$(TOOLCHAIN))
	@$(CURL) $(url) --output $@ >$@; \
	$(call status-msg,Downloading file $(target_var))

## ~/.gitconfig: Makes a .gitattributes file.
~/.gitconfig:
	@git config --global user.name
	$(call status-msg,Making file $(target_var))

# Makes a special empty file for marking that a directory tree has been generated.
%/.gitkeep:
	@MKDIR $(@D); \
	$(call status-msg,Making missing directories in the path of marker file $(target_var))
	@touch $@; \
	$(call status-msg,Making marker file $(target_var))


# =========================================================================== #
# SECOND EXPANSION TARGETS
# =========================================================================== #


.SECONDEXPANSION:
# Make a directory tree.
#$(MAKEFILE_DIR)/%.gitkeep: $$(@D)/.gitkeep | $$(@D)/.
