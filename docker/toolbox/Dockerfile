FROM alpine
RUN apk add --no-cache curl wget busybox-extras netcat-openbsd python3 py3-pip postgresql-client&& \
    pip install awscli boto3
RUN apk --purge -v del py3-pip
CMD tail -f /dev/null
