FROM public.ecr.aws/m7u4n3p6/alpine/git:latest

LABEL "com.github.actions.name"="Mirror to GitLab"
LABEL "com.github.actions.description"="Mirror branch and tag pushes to GitLab."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="blue"

COPY mirror.sh /mirror.sh
COPY get-password.sh /get-password.sh
ENTRYPOINT ["/bin/sh", "/mirror.sh"]
