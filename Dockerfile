FROM ubuntu:14.04

MAINTAINER YUKIO GOTO byplayer

ENV DEBIAN_FRONTEND noninteractive

RUN echo "Asia/Singapore" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openssh-server supervisor
# RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

# supervisord
ADD res/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# user
RUN useradd -d /home/yukio -m -s /bin/bash yukio
RUN echo yukio:yukio | chpasswd
RUN gpasswd -a yukio sudo
RUN mkdir -m 700 /home/yukio/.ssh && chown yukio:yukio /home/yukio/.ssh
ADD ./res/authorized_keys /home/yukio/.ssh/authorized_keys
RUN chmod 600 /home/yukio/.ssh/authorized_keys
RUN chown yukio:yukio /home/yukio/.ssh/authorized_keys

# workaround for ubuntu 13.10 ssh disconnection
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd

ENV DEBIAN_FRONTEND dialog

EXPOSE 22

CMD ["/usr/bin/supervisord"]
