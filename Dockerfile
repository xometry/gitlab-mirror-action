FROM 694713800774.dkr.ecr.us-east-2.amazonaws.com/golden/glibc-dynamic:15.1.0-dev AS dev
USER 0
RUN apk update && apk add --no-cache bash busybox git ca-certificates
RUN mkdir -p /out && apk --update-cache --no-cache --root /out --initdb \
  --keys-dir /etc/apk/keys \
  --repositories-file /etc/apk/repositories \
  add bash busybox git ca-certificates


FROM 694713800774.dkr.ecr.us-east-2.amazonaws.com/golden/glibc-dynamic:15.2.0

LABEL "com.github.actions.name"="Mirror to GitLab"
LABEL "com.github.actions.description"="Mirror branch and tag pushes to GitLab."
LABEL "com.github.actions.icon"="git-commit"
LABEL "com.github.actions.color"="blue"

USER 0
COPY --from=dev /out/ /
COPY mirror.sh /mirror.sh
COPY get-password.sh /get-password.sh
RUN chmod +x /mirror.sh /get-password.sh
# user 1001 is the runner user that GHA uses to run actions. As long as the container runs scripts as this user we wont have any permissions issues
USER 1001
ENTRYPOINT ["/bin/bash", "/mirror.sh"]
