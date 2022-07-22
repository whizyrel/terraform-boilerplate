#!/bin/bash

set -ex

./tf-files.sh
./init-git-hooks.sh

rm main.sh tf-files.sh init-git-hooks.sh README.md

cat << EOF > README.md
# Your Terraform Project

Hello World!
EOF
