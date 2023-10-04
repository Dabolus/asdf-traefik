<div align="center">

# asdf-traefik [![Build](https://github.com/Dabolus/asdf-traefik/actions/workflows/build.yml/badge.svg)](https://github.com/Dabolus/asdf-traefik/actions/workflows/build.yml) [![Lint](https://github.com/Dabolus/asdf-traefik/actions/workflows/lint.yml/badge.svg)](https://github.com/Dabolus/asdf-traefik/actions/workflows/lint.yml)

[traefik](https://doc.traefik.io/traefik/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add traefik
# or
asdf plugin add traefik https://github.com/Dabolus/asdf-traefik.git
```

traefik:

```shell
# Show all installable versions
asdf list-all traefik

# Install specific version
asdf install traefik latest

# Set a version globally (on your ~/.tool-versions file)
asdf global traefik latest

# Now traefik commands are available
traefik --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Dabolus/asdf-traefik/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Giorgio Garasto](https://github.com/Dabolus/)
