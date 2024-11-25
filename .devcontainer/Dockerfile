FROM ubuntu:noble

LABEL maintainer="Bob Tanner <tanner@real-time.com>"

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=${TZ}

# Make sure "remoteUser" has the same value as the below USERNAME
#
ARG WORKSPACE_FOLDER=/workspace/
ARG USERNAME=vscode
ARG USER_UID=2000
ARG USER_GID=$USER_UID
ARG TZ=America/Chicago

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
#
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes \
    && apt-get update -qq  \
    && apt-get install -qq --no-install-recommends \
    git \
    gitleaks\
    curl \
    openssh-client \
    pre-commit \
    less \
    sudo \
    php \
    php-cli \
    && apt-get autoremove \
    && apt-get clean

RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME && \
    (getent group $USER_GID || groupadd --gid $USER_GID $USERNAME) && \
    (id -u $USERNAME || useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash)

WORKDIR /workspace/
