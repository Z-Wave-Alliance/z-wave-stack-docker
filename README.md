<!--
SPDX-FileCopyrightText: Silicon Laboratories Inc. <https://www.silabs.com>
SPDX-FileCopyrightText: Z-Wave-Alliance <https://z-wavealliance.org>

SPDX-License-Identifier: BSD-3-Clause
-->

# z-wave-stack-docker
Offers a Docker image for building [Z-Wave](https://github.com/Z-Wave-Alliance/z-wave-stack).

## How to download a prebuilt image

### Authenticate to GitHub Container registry
> Note: Follow [this link](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic) for details.

**A. Unix:**
```bash
export CR_PAT=YOUR_TOKEN
echo $CR_PAT | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```
**B. Windows:**
```bash
$env:CR_PAT="YOUR_TOKEN"
echo $env:CR_PAT | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

### Download/Pull the latest image
```bash
docker pull ghcr.io/z-wave-alliance/z-wave-stack-docker:main
```

## How to build an image locally
```bash
docker build . -t <image name>
```

## How to run an image (on Ubuntu)
```bash
docker run -it --rm -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) -v $PWD:/z-wave-open-source <image name>:latest bash
```
