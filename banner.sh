#!/bin/bash
C='\033[0;36m'; Y='\033[1;33m'; W='\033[1;37m'; G='\033[0;32m'; B='\033[0;34m'; N='\033[0m'

HOST=$(hostname 2>/dev/null || echo "omduta-vps")
OS=$(awk -F'"' '/^PRETTY_NAME=/ {print $2}' /etc/os-release 2>/dev/null || echo "Ubuntu Linux")
KERNEL=$(uname -r 2>/dev/null || echo "Unknown")
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
CPU=$(nproc 2>/dev/null || echo "?")
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")

pad() { local t="$1"; [ ${#t} -gt 30 ] && t="${t:0:28}.."; printf "%-30s" "$t"; }

echo ""
echo -e "${C}╔══════════════════════════════════════════════════╗${N}"
echo -e "${C}║${N}            ${Y}✦ WELCOME TO OMDUTA CLOUD ✦${N}            ${C}║${N}"
echo -e "${C}╠══════════════════════════════════════════════════╣${N}"
echo -e "${C}║${N} Host    : ${W}$(pad "$HOST")${N}${C}║${N}"
echo -e "${C}║${N} OS      : ${W}$(pad "$OS")${N}${C}║${N}"
echo -e "${C}║${N} Kernel  : ${W}$(pad "$KERNEL")${N}${C}║${N}"
echo -e "${C}║${N} Arch    : ${W}$(pad "$ARCH")${N}${C}║${N}"
echo -e "${C}║${N} CPU     : ${W}$(pad "${CPU} Core(s)")${N}${C}║${N}"
echo -e "${C}║${N} Uptime  : ${W}$(pad "$UPTIME")${N}${C}║${N}"
echo -e "${C}╠══════════════════════════════════════════════════╣${N}"
echo -e "${C}║${N} Owner   : ${G}$(pad "@OmdutaMd")${N}${C}║${N}"
echo -e "${C}║${N} Telegram: ${B}$(pad "t.me/OmdutaMd")${N}${C}║${N}"
echo -e "${C}╚══════════════════════════════════════════════════╝${N}"
echo ""