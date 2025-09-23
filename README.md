# bitbake-setup-container

This repository contains files to generate a Podman or Docker image capable of
initializing builds with [`bitbake-setup`](https://git.openembedded.org/bitbake).

## Features

- [zsh](https://www.zsh.org) shell
- [oh-my-zsh](https://ohmyz.sh) integrations
- [zsh-bitbake](https://github.com/antznin/zsh-bitbake) plugin for bitbake completions
- [QEMU](https://www.qemu.org)-ready

## How to use

Start the container:

```shell
$ ./run
```

The `run` script can take extra arguments, which are passed to the container
command. For example, to pass the current working directory as a volume:

```shell
$ ./run --volume "$PWD":"$PWD" --workdir "$PWD"
```

> [!TIP]
> The default container engine can be changes by exporting the `CONTAINERCMD`
> variable:
>
> ```shell
> export CONTAINERCMD=docker
> ```
>
> The default is to use Podman.

`bitbake-setup` will be part of the `$PATH`, meaning you can run `bitbake-setup`
directly from the container:

```shell
$ bitbake-setup init
```

## Configuration

The `./run` script can be tweaked with environment variables:

| Variable       | Description                | Default                                | Supported values                                                          |
|----------------|----------------------------|----------------------------------------|---------------------------------------------------------------------------|
| `CONTAINERCMD` | Command use for containers | `podman`                               | `podman` or `docker`                                                      |
| `CONTAINERURI` | URI of the container image | `ghcr.io/antznin/bitbake-setup:latest` | Any valid URI.<br>For a local container: `localhost/bitbake-setup:latest` |

## Building

- Podman:

  ```shell
  podman build -t bitbake-setup:latest .
  ```

- Docker:

  ```shell
  docker build -t bitbake-setup:latest .
  ```
