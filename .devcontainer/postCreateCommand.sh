#!/bin/bash

set -e

timezone_setup() {
    local TZ=${TZ:-"America/Los_Angeles"}
    echo "==> Setting timezone to: $TZ"
    sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
    sudo dpkg-reconfigure -f noninteractive tzdata
}

echo "==> Working directory: $(pwd)"

# Load environment variables from .env file
#
echo "==> Load environment variables from .env file"
if [ -f ".env" ]; then
    set -o allexport
    source .env
    set +o allexport
fi

echo "=> Customize git user configuration"
git config --global core.eol lf
git config --global core.autocrlf false
git config --global http.sslVerify false
git config --global core.editor "code --wait"
git config --global --add safe.directory /workspace
git config --global --add safe.directory /workspace/IMathAS
git config pull.rebase true

# Customize git user configuration on your branch
#
echo "=> Setting git 'user.name' ${GIT_USER_EMAIL} and 'user.email' ${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "${GIT_USER_NAME}"

# Timezone setup
#
timezone_setup

chown -R www-data:www-data /workspace/IMathAS > /dev/null 2>&1 || true
