<!--
SPDX-FileCopyrightText: Silicon Laboratories Inc. <https://www.silabs.com>
SPDX-FileCopyrightText: Z-Wave-Alliance <https://z-wavealliance.org>

SPDX-License-Identifier: BSD-3-Clause
-->

# z-wave-stack-docker
Offers a Docker image for building Z-Wave

## How to download a prebuilt image

### Authenticate to GitHub Container registry
A. Unix:
```bash
export CR_PAT=<YOUR_TOKEN>
echo $CR_PAT | docker login ghcr.io -u <USERNAME> --password-stdin
```
B. Windows:
1. Add your GitHub token as a user environment variable `CR_PAT`.
2. Logout / login to your Windows account.
3. Login to docker with your GitHub username as follows:
   ```bash
   echo $env:CR_PAT | docker login ghcr.io -u <USERNAME> --password-stdin
   ```
> Note: Follow [this link](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic) for details.

### Download image
```bash
docker pull ghcr.io/z-wave-alliance/z-wave-stack-docker:v1.5.0
```

## How to build image locally
```bash
docker build . -t IMAGE_NAME:IMAGE_TAG
```

## How to run image
```bash
docker run --rm -it IMAGE_NAME:IMAGE_TAG
```
