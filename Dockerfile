ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta
ENV LANG=C.UTF-8

# ==========================================
# 1. INSTALL PACKAGES
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
    bash \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && mkdir -p /run/sshd /root/.ssh \
    && chmod 700 /root/.ssh \
    && rm -rf /var/lib/apt/lists/*

# ==========================================
# 2. SSH CONFIGURATION
# ==========================================
RUN rm -f /etc/ssh/sshd_config.d/*.conf \
    && cat > /etc/ssh/sshd_config << 'EOF'
Port 2222
AddressFamily any
ListenAddress 0.0.0.0
PermitRootLogin yes
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
# 3. COPY BANNER & SETUP
# ==========================================
# Copy banner.sh dari folder lokal ke dalam container
COPY banner.sh /usr/local/bin/vps

# Beri permission execute
RUN chmod 755 /usr/local/bin/vps \
    && echo 'if [ -t 1 ]; then /usr/local/bin/vps; fi' >> /root/.bashrc

# ==========================================
# 4. STARTUP SCRIPT
# ==========================================
RUN cat > /usr/local/bin/start-vps << 'EOF'
#!/bin/bash
set -e

echo "========================================"
echo " OMDUTA CLOUD VPS STARTING"
echo "========================================"

# Siapkan direktori SSH
mkdir -p /run/sshd /root/.ssh
chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Injeksi SSH Public Key dari Environment Variable Railway
if [ -n "$SSH_PUBLIC_KEY" ]; then
    echo "$SSH_PUBLIC_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    echo "[+] SSH Public Key injected successfully"
else
    echo "[!] WARNING: SSH_PUBLIC_KEY tidak diset di Environment Variable!"
    echo "[!] User tidak akan bisa login tanpa SSH Key."
fi

# Generate host keys jika belum ada
ssh-keygen -A

# Test konfigurasi SSH sebelum dijalankan
if /usr/sbin/sshd -t; then
    echo "[+] SSH Configuration Valid"
else
    echo "[-] SSH Configuration Invalid! Cek sshd_config."
    exit 1
fi

echo "[+] Listening on port 2222"
echo "[+] Starting SSH Daemon..."

# Jalankan SSH Daemon di foreground
exec /usr/sbin/sshd -D -e
EOF

RUN chmod 755 /usr/local/bin/start-vps

WORKDIR /root
EXPOSE 2222
CMD ["/usr/local/bin/start-vps"]