FROM alpine
RUN apk add --no-cache python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip
CMD tail -f /dev/null
