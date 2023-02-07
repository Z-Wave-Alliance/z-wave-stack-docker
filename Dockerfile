FROM ubuntu:22.04

ARG UID=1000
ARG GID=1000

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Copenhagen

RUN deps='sudo curl bzip2 ca-certificates wget zip unzip tzdata flex bison graphviz make libc6-dev patch python3 python3-pip python3-virtualenv python3-build cmake git gcc g++ gcc-multilib g++-multilib libboost-log1.74.0 dos2unix' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $deps \
    && rm -rf /var/lib/apt/lists/*

# Fetch and install Doxygen
RUN curl -L https://github.com/doxygen/doxygen/archive/Release_1_9_2.zip --output /tmp/doxygen.zip \
    && cd /tmp/ \
    && echo e9a3901d7e90f2e8a6bbae34809a8df4c191565c8c91919fbb3018285c0d647d5924528445895e86727550eff7cdcf890e1d470347c3fe0838d4ae109035965f doxygen.zip > /tmp/doxygen.zip.sha512 \
    && sha512sum -c doxygen.zip.sha512 \
    && unzip doxygen.zip \
    && cd /tmp/doxygen*/ \
    && mkdir build && cd build \
    && cmake .. \
    && N_CPU_CORES=`cat /proc/cpuinfo | grep processor | wc -l` \
    && make -j $N_CPU_CORES && make install \
    && rm -rf /tmp/doxygen*

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN groupadd -g $GID -o build
RUN useradd -m -u $UID -g $GID -G sudo -p -o -s /bin/bash build
USER build
WORKDIR /z-wave-open-source
