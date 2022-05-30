FROM debian:11

ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive

RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime

RUN apt-get update && \
    apt-get install  -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        ssh && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable" && \
    apt-get update && \
        apt-get install  -y \
        docker-ce-cli && \
    apt-get install --no-install-recommends -y \
        wget \
        vim \
        zip \
        sudo \
        git \
        ca-certificates \
        libgtk2.0-0 \
        libgtk-3-0 \
        libnotify-dev \
        libgconf-2-4 \
        libgbm-dev \
        libnss3 \
        libxss1 \
        libasound2 \
        libxtst6 \
        xauth \
        xvfb \
        fonts-arphic-bkai00mp \
        fonts-arphic-bsmi00lp \
        fonts-arphic-gbsn00lp \
        fonts-arphic-gkai00mp \
        fonts-arphic-ukai \
        fonts-arphic-uming \
        ttf-wqy-zenhei \
        ttf-wqy-microhei \
        xfonts-wqy \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/docker \
    && groupadd -r docker -g ${GID} \
    && useradd -u ${UID} -r -g docker -d /home/docker -s /bin/bash -c "Docker user" docker \
    && echo "docker:docker" | chpasswd \
    && mkdir -p /home/docker/.cache \
    && chown -R docker:docker /home/docker \
    && adduser docker sudo \
    && echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


COPY --chown=docker:docker bashrc /home/docker/.bashrc
COPY --chown=docker:docker profile /home/docker/.profile

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

USER docker
WORKDIR /home/docker

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

ENV BASH_ENV "/home/docker/.bashrc"

#copy --chown=docker:docker Cypress /home/docker/.cache/Cypress
