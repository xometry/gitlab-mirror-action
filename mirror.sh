#!/bin/sh

set -euo pipefail

echo "env"
env
echo "done env"

git config --global credential.username $GITLAB_USERNAME
git config --global credential.helper cache
git remote add mirror ${GITLAB_REPOSITORY}
