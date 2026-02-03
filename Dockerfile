# SPDX-FileCopyrightText: Silicon Laboratories Inc. <https://www.silabs.com/>
# SPDX-FileCopyrightText: Z-Wave Alliance <https://z-wavealliance.org/>
#
# SPDX-License-Identifier: BSD-3-Clause

FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Copenhagen

# Install gpg by itself as it needs recommended packages (at least dirmngr).
RUN deps='gdb \
  sudo \
  curl \
  bzip2 \
  ca-certificates \
  wget \
  zip \
  unzip \
  tzdata \
  flex \
  bison \
  graphviz \
  make \
  libc6-dev \
  patch \
  python3 \
  python3-pip \
  python3-virtualenv \
  python3-build \
  python3-yaml \
  pipx \
  gcovr \
  git \
  gcc \
  g++ \
  gcc-multilib \
  g++-multilib \
  libboost-log1.88.0 \
  dos2unix \
  ruby \
  ruby-dev \
  clang \
  libc6-dbg:i386 \
  openssh-client \
  valgrind \
  texlive-bibtex-extra \
  default-jre \
  nodejs \
  cmake \
  cmake-data \
  doxygen \
  uncrustify \
  gosu \
  bash-completion \
  ' \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends $deps \
    && apt-get install -y gpg \
    && rm -rf /var/lib/apt/lists/*

# Plantuml
# TODO: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1004135#53 (Last-Update: 20250219)
ENV PLANTUML_JAR_PATH=/usr/local/share/plantuml/plantuml.jar
RUN mkdir -p /usr/local/share/plantuml \
  && curl -L https://github.com/plantuml/plantuml/releases/download/v1.2022.0/plantuml-1.2022.0.jar \
    --output ${PLANTUML_JAR_PATH} \
  && sha256sum ${PLANTUML_JAR_PATH} | grep '^f1070c42b20e6a38015e52c10821a9db13bedca6b5d5bc6a6192fcab6e612691 '

# Fetch and install kaitai-compiler until maintained by distro
# TODO: https://bugs.debian.org/919693
ARG KAITAI_URL=https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/0.10/kaitai-struct-compiler_0.10_all.deb
ARG KAITAI_SHA=2d8d9a4f72fa348bfff6f85a1b01802485bf20003f03e254ae37ffa362fdd398
RUN mkdir -p /tmp/kaitai/ && \
    cd /tmp/kaitai/ && \
    wget -q $KAITAI_URL -O kaitai-compiler.deb && \
    echo "2d8d9a4f72fa348bfff6f85a1b01802485bf20003f03e254ae37ffa362fdd398 *kaitai-compiler.deb" > checksum.txt && \
    sha256sum --check checksum.txt && \
    apt-get install -y ./kaitai-compiler.deb && \
    rm -rf /tmp/kaitai/

# Github client
# TODO: https://tracker.debian.org/pkg/gh# (wait v2.51+)
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
RUN \
  sudo mkdir -p -m 755 /etc/apt/keyrings \
  && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y \
  && sudo apt clean \
  && rm -rf /var/lib/apt/lists/*

# Reuse 5.1+
RUN \
  echo "TODO: https://bugs.debian.org/1116303#2025" \
  && pipx install reuse \
  && sudo install -d /usr/local/bin \
  && sudo ln -fs "${HOME}/.local/bin/reuse" /usr/local/bin

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 700 /usr/local/bin/entrypoint.sh

WORKDIR /z-wave-open-source

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
