#!/usr/bin/env bash

set -euo pipefail

CHEF_VERSION="12.19"
wget https://omnitruck.chef.io/install.sh -O install.sh && sudo bash ./install.sh -v "$CHEF_VERSION" && rm install.sh
