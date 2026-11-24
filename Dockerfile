ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
ENV LANG=C.UTF-8

# ==========================================
# INSTALL PACKAGES
# ==========================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    curl \
    wget \
    git \
    nano \
    vim \
    sudo \
    ca-certificates \
    procps \
    hostname \
    iproute2 \
    net-tools \
    dnsutils \
    tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && mkdir -p /run/sshd /root/.ssh \
    && chmod 700 /root/.ssh \
    && rm -rf /var/lib/apt/lists/*

# ==========================================
# SSH CONFIG
# ==========================================
RUN rm -f /etc/ssh/sshd_config.d/*.conf \
    && cat > /etc/ssh/sshd_config << 'EOF'
Port 2222
AddressFamily any
ListenAddress 0.0.0.0
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
AuthorizedKeysFile .ssh/authorized_keys
UsePAM yes
PrintMotd no
ClientAliveInterval 60
ClientAliveCountMax 3
X11Forwarding no
AllowTcpForwarding yes
PermitTunnel yes
Subsystem sftp /usr/lib/openssh/sftp-server
EOF

# ==========================================
# BANNER
# ==========================================
COPY banner.sh /usr/local/bin/vps
RUN chmod 755 /usr/local/bin/vps \
    && echo 'if [[ $- == *i* ]]; then /usr/local/bin/vps; fi' >> /root/.bashrc \
    && echo '[ -t 1 ] && /usr/local/bin/vps' > /etc/profile.d/omduta-banner.sh \
    && chmod 644 /etc/profile.d/omduta-banner.sh

# ==========================================
# STARTUP SCRIPT
# ==========================================
RUN cat > /usr/local/bin/start-vps << 'EOF'
#!/bin/bash
set -e

echo "========================================"
echo " OMDUTA CLOUD VPS STARTING"
echo "========================================"

mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Inject SSH Public Key
if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    echo "[+] SSH Public Key injected"
else
    echo "[!] WARNING: SSH_PUBLIC_KEY tidak diset"
fi

ssh-keygen -A
/usr/sbin/sshd -t
echo "[+] SSH Configuration Valid"
echo "[+] Listening on port 2222"

# Tampilkan banner saat start
/usr/local/bin/vps

echo "[+] Starting SSH Daemon..."
exec /usr/sbin/sshd -D -e
EOF

RUN chmod 755 /usr/local/bin/start-vps

WORKDIR /root
EXPOSE 2222

CMD ["/usr/local/bin/start-vps"]