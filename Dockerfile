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
# BANNER (AMAN - tidak pakai regex rumit)
# ==========================================
RUN cat > /usr/local/bin/vps << 'EOF'
#!/bin/bash
set +e

P='\033[38;5;213m'
V='\033[38;5;183m'
Y='\033[38;5;222m'
G='\033[38;5;114m'
C='\033[38;5;117m'
D='\033[38;5;245m'
W='\033[1;37m'
N='\033[0m'

HOST=$(hostname 2>/dev/null || echo "OMDUTA-VPS")
OS="Ubuntu 22.04"
KERNEL=$(uname -r 2>/dev/null || echo "Unknown")
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
CPU=$(nproc 2>/dev/null || echo "?")
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")
IP=$(hostname -I 2>/dev/null | awk '{print $1}')
IP=${IP:-Private}

RAM_TOTAL=$(free -m 2>/dev/null | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m 2>/dev/null | awk '/Mem:/ {print $3}')
RAM_TOTAL=${RAM_TOTAL:-0}
RAM_USED=${RAM_USED:-0}

if [ "$RAM_TOTAL" -gt 0 ]; then
  RAM_PERCENT=$((RAM_USED * 100 / RAM_TOTAL))
else
  RAM_PERCENT=0
fi

DISK_TOTAL=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
DISK_PERCENT=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')

printf "\n"
printf "\( {P}╔══════════════════════════════════════════════╗ \){N}\n"
printf "\( {P}║ \){N}          \( {V}✦ OMDUTA CLOUD ✦ \){N}                  \( {P}║ \){N}\n"
printf "\( {P}║ \){N}       \( {Y}PREMIUM SSH VPS SERVER \){N}                \( {P}║ \){N}\n"
printf "\( {P}╠══════════════════════════════════════════════╣ \){N}\n"
printf "\( {P}║ \){N}          \( {C}WELCOME TO OMDUTA VPS \){N}              \( {P}║ \){N}\n"
printf "\( {P}║ \){D}══════════════════════════════════════════════\( {P}║ \){N}\n"
printf "\( {P}║ \){N} Hostname    : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$HOST"
printf "\( {P}║ \){N} Operating   : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$OS"
printf "\( {P}║ \){N} Kernel      : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$KERNEL"
printf "\( {P}║ \){N} Arch        : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$ARCH"
printf "\( {P}║ \){N} CPU Cores   : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$CPU"
printf "\( {P}║ \){N} Uptime      : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$UPTIME"
printf "\( {P}║ \){N} IP Address  : \( {W}%-29s \){N}\( {P}║ \){N}\n" "$IP"
printf "\( {P}║ \){N} SSH Port    : \( {W}%-29s \){N}\( {P}║ \){N}\n" "2222"
printf "\( {P}║ \){D}══════════════════════════════════════════════\( {P}║ \){N}\n"
printf "\( {P}║ \){N}              \( {Y}RESOURCE MONITOR \){N}               \( {P}║ \){N}\n"
printf "\( {P}║ \){N} RAM  : \( {W}%s MB / %s MB (%s%%) \){N}\n" "$RAM_USED" "$RAM_TOTAL" "$RAM_PERCENT"
printf "\( {P}║ \){N} DISK : \( {W}%s / %s (%s) \){N}\n" "$DISK_USED" "$DISK_TOTAL" "$DISK_PERCENT"
printf "\( {P}║ \){D}══════════════════════════════════════════════\( {P}║ \){N}\n"
printf "\( {P}║ \){N} OWNER    : \( {G}@OmdutaMd \){N}                       \( {P}║ \){N}\n"
printf "\( {P}║ \){N} TELEGRAM : \( {C}https://t.me/OmdutaMd \){N}       \( {P}║ \){N}\n"
printf "\( {P}║ \){D}══════════════════════════════════════════════\( {P}║ \){N}\n"
printf "\( {P}║ \){N}          \( {V}✦ THANK YOU FOR USING ✦ \){N}            \( {P}║ \){N}\n"
printf "\( {P}║ \){N}              \( {W}OMDUTA CLOUD \){N}                    \( {P}║ \){N}\n"
printf "\( {P}╚══════════════════════════════════════════════╝ \){N}\n"
printf "\n"
EOF

RUN chmod 755 /usr/local/bin/vps \
    && echo 'if [ -t 1 ]; then /usr/local/bin/vps; fi' >> /root/.bashrc

# ==========================================
# STARTUP
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

/usr/local/bin/vps

echo "[+] Starting SSH Daemon..."
exec /usr/sbin/sshd -D -e
EOF

RUN chmod 755 /usr/local/bin/start-vps

WORKDIR /root
EXPOSE 2222
CMD ["/usr/local/bin/start-vps"]