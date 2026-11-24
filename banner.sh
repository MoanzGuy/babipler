#!/bin/bash

# Warna ANSI
P='\033[38;5;213m'
V='\033[38;5;183m'
Y='\033[38;5;222m'
G='\033[38;5;114m'
C='\033[38;5;117m'
D='\033[38;5;245m'
W='\033[1;37m'
N='\033[0m'

# Ambil Data Sistem
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

# Cetak Banner (Aman dari error)
printf "\n"
printf "${P}╔══════════════════════════════════════════════╗${N}\n"
printf "${P}║${N}          ${V}✦ OMDUTA CLOUD ✦${N}                  ${P}║${N}\n"
printf "${P}║${N}       ${Y}PREMIUM SSH VPS SERVER${N}                ${P}║${N}\n"
printf "${P}╠══════════════════════════════════════════════╣${N}\n"
printf "${P}║${N}          ${C}WELCOME TO OMDUTA VPS${N}              ${P}║${N}\n"
printf "${P}║${D}══════════════════════════════════════════════${P}║${N}\n"
printf "${P}║${N} Hostname    : ${W}%-29s${N}${P}║${N}\n" "$HOST"
printf "${P}║${N} Operating   : ${W}%-29s${N}${P}║${N}\n" "$OS"
printf "${P}║${N} Kernel      : ${W}%-29s${N}${P}║${N}\n" "$KERNEL"
printf "${P}║${N} Arch        : ${W}%-29s${N}${P}║${N}\n" "$ARCH"
printf "${P}║${N} CPU Cores   : ${W}%-29s${N}${P}║${N}\n" "$CPU"
printf "${P}║${N} Uptime      : ${W}%-29s${N}${P}║${N}\n" "$UPTIME"
printf "${P}║${N} IP Address  : ${W}%-29s${N}${P}║${N}\n" "$IP"
printf "${P}║${N} SSH Port    : ${W}%-29s${N}${P}║${N}\n" "2222"
printf "${P}║${D}══════════════════════════════════════════════${P}║${N}\n"
printf "${P}║${N}              ${Y}RESOURCE MONITOR${N}               ${P}║${N}\n"
printf "${P}║${N} RAM  : ${W}%s MB / %s MB (%s%%)${N}\n" "$RAM_USED" "$RAM_TOTAL" "$RAM_PERCENT"
printf "${P}║${N} DISK : ${W}%s / %s (%s)${N}\n" "$DISK_USED" "$DISK_TOTAL" "$DISK_PERCENT"
printf "${P}║${D}══════════════════════════════════════════════${P}║${N}\n"
printf "${P}║${N} OWNER    : ${G}@OmdutaMd${N}                       ${P}║${N}\n"
printf "${P}║${N} TELEGRAM : ${C}https://t.me/OmdutaMd${N}       ${P}║${N}\n"
printf "${P}║${D}══════════════════════════════════════════════${P}║${N}\n"
printf "${P}║${N}          ${V}✦ THANK YOU FOR USING ✦${N}            ${P}║${N}\n"
printf "${P}║${N}              ${W}OMDUTA CLOUD${N}                    ${P}║${N}\n"
printf "${P}╚══════════════════════════════════════════════╝${N}\n"
printf "\n"