FROM ubuntu:20.04

LABEL maintainer="Júlio César <julio.souzam@gmail.com>"

RUN mkdir -p /home/steam

RUN groupadd -r steam && \
  useradd -r -g steam -d /home/steam -s /sbin/nologin -c "Steam User" steam

ENV HOME=/home/steam

WORKDIR $HOME
RUN chown -R steam:steam $HOME

RUN set -uex; \
  apt update && apt upgrade -y; \
  apt -y install \
  wget \
  software-properties-common \
  dirmngr \
  apt-transport-https \
  lsb-release \
  ca-certificates; \
  add-apt-repository multiverse; \
  dpkg --add-architecture i386; \
  apt update; \
  apt install lib32gcc1 -y; \
  apt-get install -y \
  libstdc++6:i386 \
  libgcc1:i386 \
  libcurl4-gnutls-dev:i386; \
  rm -rf /var/lib/apt/lists/* 

USER steam

RUN set -uex; \
  mkdir -p .klei/DoNotStarveTogether/;\
  mkdir steamcmd;\
  cd steamcmd;\
  wget "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"; \
  ls -la; \
  tar -xvzf steamcmd_linux.tar.gz; \
  rm  steamcmd_linux.tar.gz;

COPY --chown=steam:steam MyDediServer .klei/DoNotStarveTogether/MyDediServer

RUN set -uex; \
  wget "https://accounts.klei.com/assets/gamesetup/linux/run_dedicated_servers.sh"; \
  chmod +x run_dedicated_servers.sh;

ENTRYPOINT [ "./run_dedicated_servers.sh" ]