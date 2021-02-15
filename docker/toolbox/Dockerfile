FROM alpine
RUN apk add python3 py3-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
CMD tail -f /dev/null
