ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server curl procps iproute2 net-tools dnsutils sudo nano vim git \
    && mkdir -p /run/sshd /root/.ssh \
    && rm -rf /var/lib/apt/lists/*

# Set Port ke 2222
RUN rm -f /etc/ssh/sshd_config.d/*.conf \
    && cat > /etc/ssh/sshd_config << 'EOF'
Port 2222
PermitRootLogin yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
UsePAM yes
PrintMotd no
EOF

COPY banner.sh /usr/local/bin/vps
RUN chmod 755 /usr/local/bin/vps \
    && echo 'if [ -t 1 ]; then /usr/local/bin/vps; fi' >> /root/.bashrc

# Script Startup: Baca password dari bot, jika tidak ada pakai fallback
RUN cat > /usr/local/bin/start-vps << 'EOF'
#!/bin/bash
set -e
mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh

if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo "[+] SUKSES: Password root di-set dari bot"
else
    echo "root:Omduta123" | chpasswd
    echo "[!] PERINGATAN: ROOT_PASSWORD kosong, pakai fallback: Omduta123"
fi

ssh-keygen -A
echo "[+] Starting SSH Daemon on port 2222..."
exec /usr/sbin/sshd -D -e
EOF
RUN chmod +x /usr/local/bin/start-vps

WORKDIR /root
EXPOSE 2222
CMD ["/usr/local/bin/start-vps"]