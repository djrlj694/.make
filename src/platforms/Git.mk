# Git.mk
# .make
#
# Copyright © 2023 djrlj694.dev. All rights reserved.
#
#
# Facilitate local Git repository ("repo") initialization, setup, and cleanup.
#
# REFERENCES:
# 1. https://www.gnu.org/prep/standards/html_node/Makefile-Conventions.html
# 2. https://www.gnu.org/software/make/


# =========================================================================== #
# EXTERNAL VARIABLES
# =========================================================================== #


# -- Source Code Management (SCM) -- #

# Default branch.  (Historically, this was `master` but is now `main`.)
DEFUALT_BRANCH ?= $(shell git symbolic-ref --short HEAD)

# OSes, IDEs, or programming languagses
TOOLCHAIN ?= dropbox,macos,vim,visualstudiocode,windows


# =========================================================================== #
# INTERNAL VARIABLES
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
	@$(call recipe-start-msg)
	@${RM} .git* $(STDOUT); \
	$(call cmd-msg,Removing Git setup)
	@$(call recipe-end-msg)

# -- Prerequisite for "git" Target -- #

.PHONY: git-% git-dot-files

git-dot-files: .gitattributes .gitignore
	@$(call recipe-start-msg)
	@$(call git-flow-feature-start,$@)
	@$(foreach f,$^,$(call git-commit-unstaged,$(f),feat,git);)
	@$(call git-flow-feature-finish,$@)
	@$(call recipe-end-msg)

# -- Prerequisite for "init" Target -- #

.PHONY: init-git init-git-dot-files init-git-flow

## init-git: Completes all initial Git setup activities.
init-git: .git init-git-flow git-dot-files | $(LOG)
	@$(call recipe-start-msg)
	$(eval release_tag = 0.1.0)
	$(eval release_tag_cyan = $(FG_CYAN)$(release_tag)$(RESET))
	$(eval release_msg = Initial project setup)
	$(eval rc_msg = Releasing initial project as version $(release_tag_cyan))
	@$(call git-flow-release-start,$(release_tag)); \
	$(call git-flow-release-finish-minor,$(release_tag),$(release_msg)); \
	$(call cmd-msg,Releasing initial project as version $(release_tag_cyan))
ifneq ($(GH_ORIGIN_URL),)
	@$(GIT_PUSH) --all -u origin $(STDOUT); \
	$(call cmd-msg,Syncing initial project with origin)
endif
	@$(call recipe-end-msg)

## init-git-flow: Initializes git-flow setup.
init-git-flow: | $(LOG)
	@$(call recipe-start-msg)
	@$(call git-flow-init) $(STDOUT); \
	$(call cmd-msg,Initializing git-flow branching strategy)
	@$(call recipe-end-msg)


# =========================================================================== #
# DIRECTORY TARGETS
# =========================================================================== #


## .git: Makes a Git repository.
.git: | $(LOG)
	@$(call recipe-start-msg)
ifeq ($(GH_ORIGIN_URL),)
	@$(GIT_INIT) $(STDOUT); \
	$(call cmd-msg,Initializing Git repository)
else
	@$(GIT_CLONE) $(GH_ORIGIN_URL) $(STDOUT); \
	$(call cmd-msg,Cloning Git repository from '$(GH_ORIGIN_URL)')
endif
	@$(call recipe-end-msg)


# =========================================================================== #
# FILE TARGETS
# =========================================================================== #


## .gitattributes: Makes a .gitattributes file.
.gitattributes:
	@$(call recipe-start-msg)
	@echo "# Auto detect text files and perform LF normalization" >$@; \
	echo "* text=auto" >>$@; \
	$(call cmd-msg,Making file $(target_var))
	@$(call recipe-end-msg)

## .gitignore: Makes a .gitignore file.
.gitignore:
	@$(call recipe-start-msg)
	$(eval base_url = https://www.toptal.com)
	$(eval path = /developers/gitignore/api/)
	$(eval url = $(base_url)$(path)$(TOOLCHAIN))
	@$(CURL) $(url) --output $@ >$@; \
	$(call cmd-msg,Downloading file $(target_var))
	@$(call recipe-end-msg)

## ~/.gitconfig: Makes a .gitattributes file.
~/.gitconfig:
	@$(call recipe-start-msg)
	@git config --global user.name
	$(call cmd-msg,Making file $(target_var))
	@$(call recipe-end-msg)

# Makes a special empty file for marking that a directory tree has been generated.
%/.gitkeep:
	@$(call recipe-start-msg)
	@MKDIR $(@D); \
	$(call cmd-msg,Making missing directories in the path of marker file $(target_var))
	@touch $@; \
	$(call cmd-msg,Making marker file $(target_var))
	@$(call recipe-end-msg)


# =========================================================================== #
# SECOND EXPANSION TARGETS
# =========================================================================== #


.SECONDEXPANSION:
# Make a directory tree.
#$(MAKEFILE_DIR)/%.gitkeep: $$(@D)/.gitkeep | $$(@D)/.
