# Github Action to Mirror a Repository to Gitlab

This github action mirrors branch creation, pushes, and deletions to a gitlab mirror, for the purposes of triggering CI/CD tasks within gitlab.

Example workflow file to use this action:

```yaml
name: Mirror to Gitlab

on: [create, push, delete]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1
    - name: Mirror
      uses: xometry/gitlab-mirror-action
      env:
        GITLAB_REPOSITORY: "https://gitlab.ci.dev.xometry.net/xometry/myrepo.git"
        GITLAB_USERNAME: "gitlab-username"
        GITLAB_PASSWORD: ${{ secrets.GITLAB_PASSWORD }} # https://gitlab.com/profile/personal_access_tokens
```
