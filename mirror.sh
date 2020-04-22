#!/bin/sh

set -euo pipefail

git config --global credential.username $GITLAB_USERNAME
git config --global core.askPass /get-password.sh
git config --global credential.helper cache
git remote add mirror ${GITLAB_REPOSITORY}

if test "$GITHUB_EVENT_NAME" == "push" -o "$GITHUB_EVENT_NAME" == "create"; then
  git push mirror ${GITHUB_REF}:${GITHUB_REF} --force
elif test "$GITHUB_EVENT_NAME" == "delete"; then
  if test "$DELETED_REF_TYPE" == "tag"; then
    FULL_DELETED_REF="refs/tags/$DELETED_REF"
  elif test "$DELETED_REF_TYPE" == "branch"; then
    FULL_DELETED_REF="refs/heads/$DELETED_REF"
  else
    echo "Unexpected DELETED_REF_TYPE=$DELETED_REF_TYPE, expected 'branch' or 'tag'"
    exit 1
  fi
  git push mirror :${FULL_DELETED_REF}
else
  echo "Got unexpected GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
  exit 1
fi

echo "Done"
