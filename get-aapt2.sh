#!/bin/bash

#
# Copyright 2024 Barin Banerjee
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

set -euo pipefail

# Verify working directory is empty
# test -n "$(ls -A .)" && echo 'Working directory not empty, aborting.' && exit 1

# Update signing keys
echo 'Checking for updated signing keys…'
curl -sS -O 'https://dl.google.com/linux/linux_signing_key.pub';
gpg --import-options merge-only --import linux_signing_key.pub;

# Download metadata
echo 'Retrieving aapt2 repository metadata…'
metadata_url='https://dl.google.com/android/maven2/com/android/tools/build/aapt2/maven-metadata.xml'
curl -sS --remote-name-all "$metadata_url" "$metadata_url.sha512"
echo "$(cat maven-metadata.xml.sha512)" 'maven-metadata.xml' | sha512sum -c --quiet --strict

# Identify latest stable
version="$(xq-python -r '.metadata.versioning.versions.version | map(select(contains("alpha") or contains("beta") or contains("rc") | not)) | sort[-1]' maven-metadata.xml)"

# Download and extract aapt2
echo "Fetching aapt2 version $version…"
jar_url='https://dl.google.com/android/maven2/com/android/tools/build/aapt2/'"$version"'/aapt2-'"$version"'-linux.jar'
curl -sS "$jar_url" -o 'aapt2.jar' "$jar_url.asc" -o 'aapt2.jar.asc'
gpg --verify aapt2.jar.asc aapt2.jar
bsdunzip -q aapt2.jar aapt2

echo 'Done'
