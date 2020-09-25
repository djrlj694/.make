# .make

[![version](https://img.shields.io/badge/version-0.1.0-yellow.svg)](https://semver.org)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

An integrated set of sharable, reusable makefiles for building software projects.

## Introduction

[`make`](https://en.wikipedia.org/wiki/Make_(software)) is a command-line utility for maintaining groups of software files, typically source code files. Originally created in 1976 as a software build automation tool for Unix environments, it can be used more broadly "[to describe any task where files must be updated automatically from others whenever the others change](https://linux.die.net/man/1/make)". This automation is facilitated via so-called [*makefiles*](https://en.wikipedia.org/wiki/Makefile), script-like description files that [declaratively](https://en.wikipedia.org/wiki/Declarative_programming) specify via variable definitions and build rules:

1. A software project's file components;
2. The [dependency graph](https://en.wikipedia.org/wiki/Dependency_graph) of these components (i.e., their interrelationships);
3. The sequence of commands for creating or updating each component.

*Makefile projects*, integrated sets of makefiles, provide a blueprint for a software project's source code base and its maintenance. In addition, together with the `make` command, makefile projects serve as the scaffolding for build activities and more within a software project's development process.

The makefile project presented here, .make, defines variable definitions and build rules for popular software project platforms (Python, Swift, etc).  Its makefiles are stored in a special folder, conveniently named `.make` that can be stored in a user's home folder or within the software project itself.


## Getting Started

TODO: *Guide users through getting your code up and running on their own system. In this section you can talk about:*

## System Requirements

.make supports 2 major operating systems:

* [Linux](https://www.linuxfoundation.org)
* [macOS](https://www.apple.com/macos/)

It can indirectly support the [Windows](https://www.microsoft.com/en-us/windows) operating system if used with Microsoft's native [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/about) or a 3rd-party emulator like Git BASH (part of [Git for Windows](https://gitforwindows.org))

### Installation

.make can be installed in 3 easy steps.

1. Navigate to the target folder (typically a user's home folder) to which .make will be installed.

    ```bash
    $ cd ~
    ```

2. Clone .make within the target folder.

    ```bash
    $ git clone https://github.com/djrlj694/.make.git
    ```

3. Complete final setup activities, such as:
    1. Copying the sample main makefile (`Makefile.sample`) to a renamed version (`Makefile`) just above the project folder;
    2. Removing all non-essential, leftover artifacts from cloning this project.

    ```bash
    $ bash .make/setup.sh
    ```

TODO: *Alternatively, if Cookiecutter is installed on your local host, you can run the following command to more conveniently and flexibly install .make:*

```bash
$ cookiecutter gh:djrlj694/cookiecutter-make
```

### Usage

TODO: *Using the latest API, Demo one or more examples of syntax and associated output, if any.*

## Builds and Testing

TODO: *Describe and show how to build artifacts and run tests.*

## Documentation

Documentation for the project is pending but eventually will be found [here](https://djrlj694.github.io/.make/).

## Known Issues

Currently, there are no known issues.  If you discover any, please kindly submit a [pull request](CONTRIBUTING.md).

## Contributing

Code and codeless (documentation, donations, etc.) contributions are welcome. To contribute yours, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

.make is released under the [MIT License](LICENSE).

## References

API documentation, tutorials, and other online references and made portions of this project possible.  See [REFERENCES.md](REFERENCES.md) for a list of some.
