#!/bin/sh

set -euo pipefail

git config --global credential.username $GITLAB_USERNAME
git config --global credential.helper cache
git remote add mirror ${GITLAB_REPOSITORY}

if test "$GITHUB_EVENT_NAME" == "push" -o "$GITHUB_EVENT_NAME" == "create"; then
  git push mirror ${GITHUB_REF}:${GITHUB_REF}
elif test "$GITHUB_EVENT_NAME" == "delete"; then
  git push mirror :${GITHUB_REF}
else
  echo "Got unexpected GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
  exit 1
fi

echo "Done"
