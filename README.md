# Headwind-MDM

![Build, scan & push](https://github.com/Polarix-Containers/headwind-mdm/actions/workflows/build.yml/badge.svg)

### Features & usage
- Rebases [official image](https://github.com/h-mdm/hmdm-docker) to the latest Tomcat 9 image, to be used as a drop-in replacement.
- Fixes shellcheck warnings.
- Adds `arm64` support.
- ⚠️ This container is based on Ubuntu LTS, does not include `hardened_malloc`, and may have more vulnerabilities compared to Alpine or UBI containers. In other words, while this container may improve security over the upstream container, it is not up to Polarix Containers' usual standard.

### Licensing
- ⚠️ Headwind-MDM is licensed under the Apache License, although the code for the hmdm-docker repository is [unclear](https://github.com/h-mdm/hmdm-docker/issues/30). If the license is indeed Apache, you may treat all of the changes in this repository as Apache, and submit them upstream.
- Any image built by Polarix Containers is provided under the combination of license terms resulting from the use of individual packages.
