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
./run
```

The `run` script can take extra arguments, which are passed to the script
starting the container.

## Building

- Podman:

  ```shell
  podman build -t bitbake-setup:latest .
  ```

- Docker:

  ```shell
  docker build -t bitbake-setup:latest .
  ```
