#!/bin/sh

set -euo pipefail

echo "GITHUB_ACTION: ${GITHUB_ACTION}"
echo "GITHUB_WORKFLOW: ${GITHUB_WORKFLOW}"

echo "running git status"
git status
echo "done running git status"

git config --global credential.username $GITLAB_USERNAME
git config --global credential.helper cache
git remote add mirror ${GITLAB_REPOSITORY}
