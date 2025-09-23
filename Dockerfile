# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:alpine322

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WIRESHARK_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Wireshark

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/wireshark-icon.png && \
  echo "**** install packages ****" && \
  if [ -z ${WIRESHARK_VERSION+x} ]; then \
    WIRESHARK_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.22/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
    && awk '/^P:wireshark$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache \
    libcap-utils \
    wireshark==${WIRESHARK_VERSION} && \
  echo "**** permissions ****" && \
  setcap \
    'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' \
    /usr/bin/dumpcap && \
  usermod -a -G wireshark abc && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001

VOLUME /config
