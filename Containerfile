FROM debian:bookworm-slim

LABEL maintainer="Antonin Godard <antoningodard@protonmail.com>"

RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      chrpath \
      cpio \
      curl \
      debianutils \
      diffstat \
      direnv \
      iproute2 \
      iptables \
      exa \
      file \
      gawk \
      gcc \
      git \
      iputils-ping \
      less \
      libacl1 \
      liblz4-tool \
      locales \
      neovim \
      openssh-client \
      python3 \
      python3-git \
      python3-jinja2 \
      python3-pexpect \
      python3-pip \
      python3-subunit \
      python3-websockets \
      socat \
      sudo \
      texinfo \
      tmux \
      unzip \
      wget \
      xz-utils \
      zsh \
      zstd \
  && apt-get -y autoremove --purge \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && echo -n "UTC" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata \
  && apt-get -y purge locales-all \
  && dpkg-reconfigure -f noninteractive locales \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && echo "en_US.UTF-8 UTF-8" > /etc/default/locale \
  && locale-gen en_US.UTF-8 \
  && update-locale

RUN useradd -m builder && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir /work && chown builder:builder /work

RUN git clone https://git.openembedded.org/bitbake -b master-next /bitbake \
  && chown -R builder:builder /bitbake

RUN mkdir /tmp/qemu-tap-locks && chown builder:builder /tmp/qemu-tap-locks

RUN pip3 install --break-system-packages --no-cache-dir kas==4.7

USER builder

RUN mkdir /home/builder/.ssh \
    && echo  "PubkeyAcceptedKeyTypes +ssh-rsa" >> /home/builder/.ssh/config \
    && echo "ServerAliveInterval 5" >> /home/builder/.ssh/config \
    && echo "UpdateHostKeys yes" >> /home/builder/.ssh/config \
    && echo "StrictHostKeyChecking no" >> /home/builder/.ssh/config \
    && chmod 600 /home/builder/.ssh/config

RUN mkdir /home/builder/.config

RUN mkdir -p ~/.local/bin \
  && echo "#!/usr/bin/env sh\n/bitbake/bin/bitbake-setup \$*" > ~/.local/bin/bitbake-setup \
  && chmod u+x ~/.local/bin/bitbake-setup

RUN git clone --branch main https://github.com/antznin/dotfiles ~/dotfiles \
  && cp ~/dotfiles/.config/zsh/tiny.zsh ~/.zshrc \
  && rm -rf ~/dotfiles

# Install oh-my-zsh
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > /tmp/install.sh \
  && chmod +x /tmp/install.sh \
  && /tmp/install.sh --skip-chsh --unattended --keep-zshrc \
  && rm /tmp/install.sh \
  && sed -i "s/➜//g" "$HOME/.oh-my-zsh/themes/robbyrussell.zsh-theme" \ 
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
  && git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions \
  && git clone https://github.com/antznin/zsh-bitbake $HOME/.oh-my-zsh/custom/plugins/zsh-bitbake

COPY ./entrypoint /entrypoint

WORKDIR /work

CMD ["/entrypoint"]
