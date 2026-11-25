#!/bin/bash

# ─── OMDUTA CLOUD - Premium SSH Banner v2 ───

# Warna ANSI
C='\033[0;36m'
G='\033[0;32m'
Y='\033[1;33m'
W='\033[1;37m'
B='\033[0;34m'
D='\033[0;38;5;240m'
N='\033[0m'

# ─── Data Sistem (dengan fallback aman) ───
HOST=$(hostname 2>/dev/null || echo "omduta-vps")

# OS: pakai cara portable (bukan grep -oP)
if [ -f /etc/os-release ]; then
    OS=$(awk -F'"' '/^PRETTY_NAME=/ {print $2}' /etc/os-release 2>/dev/null)
    [ -z "$OS" ] && OS="Ubuntu Linux"
else
    OS="Ubuntu Linux"
fi

KERNEL=$(uname -r 2>/dev/null || echo "Unknown")
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
CPU=$(nproc 2>/dev/null || echo "?")
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")

# IP: coba public dulu, fallback ke lokal
IP=$(curl -s --connect-timeout 2 --max-time 3 ifconfig.me 2>/dev/null)
[ -z "$IP" ] && IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP" ] && IP="Private"

# RAM
RAM_LINE=$(free -m 2>/dev/null | awk '/Mem:/ {print $3, $2}')
read -r RAM_USED RAM_TOTAL <<< "$RAM_LINE"
RAM_TOTAL=${RAM_TOTAL:-0}
RAM_USED=${RAM_USED:-0}
if [ "$RAM_TOTAL" -gt 0 ]; then
    RAM_PCT=$((RAM_USED * 100 / RAM_TOTAL))
    RAM_STR="${RAM_USED}MB / ${RAM_TOTAL}MB (${RAM_PCT}%)"
else
    RAM_STR="N/A"
fi

# Disk
DISK_STR=$(df -h / 2>/dev/null | awk 'NR==2 {printf "%s / %s (%s)", $3, $2, $5}')
[ -z "$DISK_STR" ] && DISK_STR="N/A"

# SSH Port (baca dari config)
SSH_PORT=$(awk '/^Port[[:space:]]/ {print $2; exit}' /etc/ssh/sshd_config 2>/dev/null)
[ -z "$SSH_PORT" ] && SSH_PORT="2222"

# Session aktif
ACTIVE=$(who 2>/dev/null | wc -l | tr -d ' ')
[ -z "$ACTIVE" ] && ACTIVE="0"

# ─── Fungsi Pad dengan TRUNCATE (biar bingkai gak geser) ───
pad() {
    local txt="$1"
    local max=30
    # Truncate kalau terlalu panjang
    if [ ${#txt} -gt $max ]; then
        txt="${txt:0:$((max-2))}.."
    fi
    printf "%-${max}s" "$txt"
}

# ─── Cetak Banner ───
echo ""
printf "${C}╔══════════════════════════════════════════════════╗${N}\n"
printf "${C}║${N}            ${Y}✦ WELCOME TO OMDUTA CLOUD ✦${N}            ${C}║${N}\n"
printf "${C}╠══════════════════════════════════════════════════╣${N}\n"
printf "${C}║${N} 🖥️  Host    : ${W}$(pad "$HOST")${N}${C}║${N}\n"
printf "${C}║${N} 🐧  OS      : ${W}$(pad "$OS")${N}${C}║${N}\n"
printf "${C}║${N} ⚙️  Kernel  : ${W}$(pad "$KERNEL")${N}${C}║${N}\n"
printf "${C}║${N} 🏗️  Arch    : ${W}$(pad "$ARCH")${N}${C}║${N}\n"
printf "${C}║${N} 🧠  CPU     : ${W}$(pad "${CPU} Core(s)")${N}${C}║${N}\n"
printf "${C}║${N} ⏱️  Uptime  : ${W}$(pad "$UPTIME")${N}${C}║${N}\n"
printf "${C}╠══════════════════════════════════════════════════╣${N}\n"
printf "${C}║${N} 💾  RAM     : ${G}$(pad "$RAM_STR")${N}${C}║${N}\n"
printf "${C}║${N} 💿  Disk    : ${Y}$(pad "$DISK_STR")${N}${C}║${N}\n"
printf "${C}╠══════════════════════════════════════════════════╣${N}\n"
printf "${C}║${N} 🌐  IP Addr : ${W}$(pad "$IP")${N}${C}║${N}\n"
printf "${C}║${N} 🔌  SSH Port: ${W}$(pad "$SSH_PORT")${N}${C}║${N}\n"
printf "${C}║${N} 👥  Active  : ${W}$(pad "${ACTIVE} Session(s)")${N}${C}║${N}\n"
printf "${C}╠══════════════════════════════════════════════════╣${N}\n"
printf "${C}║${N} 👑  Owner   : ${G}$(pad "@OmdutaMd")${N}${C}║${N}\n"
printf "${C}║${N} ✈️  Telegram: ${B}$(pad "t.me/OmdutaMd")${N}${C}║${N}\n"
printf "${C}╚══════════════════════════════════════════════════╝${N}\n"
echo ""