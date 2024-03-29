FROM public.ecr.aws/bitnami/git:2.42.0-debian-11-r43

LABEL "com.github.actions.name"="Mirror to GitLab"
LABEL "com.github.actions.description"="Mirror branch and tag pushes to GitLab."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="blue"

COPY mirror.sh /mirror.sh
COPY get-password.sh /get-password.sh
ENTRYPOINT ["/bin/bash", "/mirror.sh"]
