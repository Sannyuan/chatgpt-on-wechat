FROM python:3.9-alpine

LABEL maintainer="yuanyi@qq.com"
ARG TZ='Asia/Shanghai'

ENV BUILD_GITHUB_TAG=latest

ENV BUILD_PREFIX=/app

RUN apk add --no-cache \
        bash \
        curl \
    && /usr/local/bin/python -m pip install --no-cache --upgrade pip

WORKDIR ${BUILD_PREFIX}

# 复制本地项目文件到容器的 /app 目录下
COPY . /app

RUN pip install --proxy=http://10.0.24.14:7890 --no-cache -r requirements.txt --extra-index-url https://alpine-wheels.github.io/index\
    && pip install --proxy=http://10.0.24.14:7890 --no-cache -r requirements-optional.txt --extra-index-url https://alpine-wheels.github.io/index

RUN chmod +x /app/docker/entrypoint.sh \
    && adduser -D -h /home/noroot -u 1000 -s /bin/bash noroot \
    && chown -R noroot:noroot ${BUILD_PREFIX}

USER noroot

# 指定 entrypoint.sh 的路径
ENTRYPOINT ["/app/docker/entrypoint.sh"]