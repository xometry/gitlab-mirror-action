#!/bin/bash

set -euo pipefail

echo "Event Type: ""$GITHUB_EVENT_NAME"

git config --global credential.username $GITLAB_USERNAME
git config --global core.askPass /get-password.sh
git config --global credential.helper cache
git config --global --add safe.directory /github/workspace

if test "$GITHUB_EVENT_NAME" == "create"; then
    # Do nothing. Every "create" event *also* publishes a *push* event, even tags/branches created from github UI.
    # Duplicate events would race and sometimes cause spurious errors.
    echo "Ignoring create event, because the push event will handle updates."
elif test "$GITHUB_EVENT_NAME" == "push"; then
  git remote add mirror ${GITLAB_REPOSITORY}
  git push mirror ${GITHUB_REF}:${GITHUB_REF} --force
  git remote remove mirror
elif test "$GITHUB_EVENT_NAME" == "workflow_run"; then
  git remote add mirror ${GITLAB_REPOSITORY}
  git push mirror ${GITHUB_REF}:${GITHUB_REF} --force
  git remote remove mirror
elif test "$GITHUB_EVENT_NAME" == "workflow_dispatch"; then
  git remote add mirror ${GITLAB_REPOSITORY}
  git push mirror ${GITHUB_REF}:${GITHUB_REF} --force
  git remote remove mirror
elif test "$GITHUB_EVENT_NAME" == "delete"; then
  if test "$DELETED_REF_TYPE" == "tag"; then
    FULL_DELETED_REF="refs/tags/$DELETED_REF"
  elif test "$DELETED_REF_TYPE" == "branch"; then
    FULL_DELETED_REF="refs/heads/$DELETED_REF"
  else
    echo "Unexpected DELETED_REF_TYPE=$DELETED_REF_TYPE, expected 'branch' or 'tag'"
    exit 1
  fi
  git remote add mirror ${GITLAB_REPOSITORY}
  git push mirror :${FULL_DELETED_REF}
  git remote remove mirror
else
  echo "Got unexpected GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
  exit 1
fi

echo "Done"
