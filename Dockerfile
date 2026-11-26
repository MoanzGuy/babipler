FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server bash ca-certificates curl wget nano \
    iproute2 net-tools procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd /root/.ssh /etc/profile.d \
    && chmod 700 /root/.ssh

RUN printf '%s\n' \
    'Port 22' \
    'PermitRootLogin yes' \
    'PasswordAuthentication yes' \
    'KbdInteractiveAuthentication no' \
    'UsePAM yes' \
    'PrintMotd no' \
    'Subsystem sftp /usr/lib/openssh/sftp-server' \
    > /etc/ssh/sshd_config

COPY banner.sh /etc/profile.d/00-omduta-banner.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod 644 /etc/profile.d/00-omduta-banner.sh \
    && chmod 755 /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]