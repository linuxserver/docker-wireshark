FROM ghcr.io/linuxserver/baseimage-rdesktop-web:alpine

# set version label
ARG BUILD_DATE
ARG VERSION
ARG WIRESHARK_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Wireshark

RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    wireshark && \
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
EXPOSE 3000
VOLUME /config
