FROM alpine:3.9
# 阿里源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update \
    && apk upgrade \
    && apk add \
    tzdata \
    mongodb \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

VOLUME ["/data"]

EXPOSE 27017
EXPOSE 28017

CMD ["/startup.sh"]