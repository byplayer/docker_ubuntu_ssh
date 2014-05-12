FROM ubuntu:14.04

MAINTAINER YUKIO GOTO byplayer

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/
RUN apt-get install -y openssh-server

# EXPOSE 22

ENV DEBIAN_FRONTEND dialog
