ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server curl procps iproute2 net-tools dnsutils \
    && mkdir -p /run/sshd /root/.ssh \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/ssh/sshd_config.d/*.conf \
    && cat > /etc/ssh/sshd_config << 'EOF'
Port 22
PermitRootLogin yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
UsePAM yes
PrintMotd no
EOF

COPY banner.sh /usr/local/bin/vps
RUN chmod 755 /usr/local/bin/vps \
    && echo 'if [ -t 1 ]; then /usr/local/bin/vps; fi' >> /root/.bashrc

# ✅ STARTUP: set password DARI ENV ROOT_PASSWORD (bukan build time!)
RUN cat > /usr/local/bin/start-vps << 'EOF'
#!/bin/bash
set -e
mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh

if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo "[+] Password root diset dari ROOT_PASSWORD env"
else
    echo 'root:Omduta123' | chpasswd
    echo "[!] ROOT_PASSWORD kosong, pakai default Omduta123"
fi

ssh-keygen -A
exec /usr/sbin/sshd -D -e
EOF
RUN chmod 755 /usr/local/bin/start-vps

WORKDIR /root
EXPOSE 22
CMD ["/usr/local/bin/start-vps"]