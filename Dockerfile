FROM debian:bookworm

ARG UID=1000
ARG GID=1000

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Copenhagen

# Add backports channel for recent applications
RUN echo 'deb http://deb.debian.org/debian bookworm-backports main' \
  > /etc/apt/sources.list.d/backports.list

# Install gpg by itself as it needs recommended packages (at least dirmngr).
RUN deps='gdb sudo curl bzip2 ca-certificates wget zip unzip tzdata flex bison graphviz make libc6-dev patch python3 python3-pip python3-virtualenv python3-build gcovr git gcc g++ gcc-multilib g++-multilib libboost-log1.74.0 dos2unix ruby ruby-dev clang libc6-dbg:i386 valgrind texlive-bibtex-extra default-jre nodejs python3-yaml\
 cmake/bookworm-backports cmake-data/bookworm-backports\
 doxygen\
 ' \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends $deps \
    && apt-get install -y gpg \
    && rm -rf /var/lib/apt/lists/*

# Plantuml
# TODO: https://bugs.debian.org/1004135
ENV PLANTUML_JAR_PATH=/usr/local/share/plantuml/plantuml.jar
RUN mkdir -p /usr/local/share/plantuml \
  && curl -L https://github.com/plantuml/plantuml/releases/download/v1.2022.0/plantuml-1.2022.0.jar \
    --output ${PLANTUML_JAR_PATH} \
  && sha256sum ${PLANTUML_JAR_PATH} | grep '^f1070c42b20e6a38015e52c10821a9db13bedca6b5d5bc6a6192fcab6e612691 '

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN groupadd -g $GID -o build
RUN useradd -m -u $UID -g $GID -G sudo -p -o -s /bin/bash build
USER build
WORKDIR /z-wave-open-source
