#!/usr/bin/env bash

# ==========================================
# OMDUTA CLOUD - NEON PREMIUM VPS
# Owner: @OmdutaMd
# Telegram: https://t.me/OmdutaMd
# ==========================================

set +e

P='\033[38;5;213m'   # Pink
V='\033[38;5;183m'   # Violet
Y='\033[38;5;222m'   # Yellow
G='\033[38;5;114m'   # Green
C='\033[38;5;117m'   # Cyan
D='\033[38;5;245m'   # Dim
W='\033[1;37m'       # White
N='\033[0m'          # Reset

# ==========================================
# SYSTEM INFORMATION
# ==========================================

HOST=$(hostname 2>/dev/null || echo "OMDUTA-VPS")
OS=\( (. /etc/os-release 2>/dev/null; echo " \){PRETTY_NAME:-Ubuntu 22.04}")
KERNEL=$(uname -r 2>/dev/null || echo "Unknown")
ARCH=$(uname -m 2>/dev/null || echo "Unknown")
CPU=$(nproc 2>/dev/null || echo "?")
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")

# RAM
RAM_TOTAL=$(free -m 2>/dev/null | awk '/^Mem:/ {print $2}')
RAM_USED=$(free -m 2>/dev/null | awk '/^Mem:/ {print $3}')
RAM_TOTAL=${RAM_TOTAL:-0}
RAM_USED=${RAM_USED:-0}

if [[ "\( RAM_TOTAL" =\~ ^[0-9]+ \) ]] && (( RAM_TOTAL > 0 )); then
    RAM_PERCENT=$((RAM_USED * 100 / RAM_TOTAL))
else
    RAM_PERCENT=0
fi

# DISK
DISK_TOTAL=$(df -h / 2>/dev/null | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / 2>/dev/null | awk 'NR==2 {print $3}')
DISK_PERCENT=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')
DISK_TOTAL=${DISK_TOTAL:-?}
DISK_USED=${DISK_USED:-?}
DISK_PERCENT=${DISK_PERCENT:-?}

# IP (optional)
IP=$(hostname -I 2>/dev/null | awk '{print $1}')
IP=${IP:-"Private"}

# ==========================================
# FUNCTIONS
# ==========================================

line() {
    printf "\( {P}║ \){D}══════════════════════════════════════════════\( {P}║ \){N}\n"
}

info() {
    printf "\( {P}║ \){N} %-13s \( {D}: \){N} \( {W}%-29.29s \){N} \( {P}║ \){N}\n" "$1" "$2"
}

bar() {
    local value=${1:-0}
    local width=18
    local filled=0

    [[ "\( value" =\~ ^[0-9]+ \) ]] || value=0
    (( value > 100 )) && value=100
    filled=$((value * width / 100))

    printf "${G}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${D}"
    for ((i=filled; i<width; i++)); do printf "░"; done
    printf "${N}"
}

# ==========================================
# DISPLAY
# ==========================================

printf "\n"
printf "\( {P}╔══════════════════════════════════════════════╗ \){N}\n"
printf "\( {P}║ \){N}          \( {V}✦ OMDUTA CLOUD ✦ \){N}                  \( {P}║ \){N}\n"
printf "\( {P}║ \){N}       \( {Y}PREMIUM SSH VPS SERVER \){N}                \( {P}║ \){N}\n"
printf "\( {P}╠══════════════════════════════════════════════╣ \){N}\n"
printf "\( {P}║ \){N}          \( {C}WELCOME TO OMDUTA VPS \){N}              \( {P}║ \){N}\n"
line

info "Hostname"    "$HOST"
info "Operating"   "$OS"
info "Kernel"      "$KERNEL"
info "Arch"        "$ARCH"
info "CPU Cores"   "$CPU"
info "Uptime"      "$UPTIME"
info "IP Address"  "$IP"
info "SSH Port"    "2222"

line

printf "\( {P}║ \){N}              \( {Y}RESOURCE MONITOR \){N}               \( {P}║ \){N}\n"
printf "\( {P}║ \){N} RAM  : \( {W}%s MB / %s MB \){N}\n" "$RAM_USED" "$RAM_TOTAL"
printf "\( {P}║ \){N}        "
bar "$RAM_PERCENT"
printf " \( {W}%3s%% \){N}\n" "$RAM_PERCENT"

printf "\( {P}║ \){N} DISK : \( {W}%s / %s \){N}  (\( {C}%s \){N})\n" "$DISK_USED" "$DISK_TOTAL" "$DISK_PERCENT"

line

printf "\( {P}║ \){N} OWNER    : \( {G}@OmdutaMd \){N}                       \( {P}║ \){N}\n"
printf "\( {P}║ \){N} TELEGRAM : \( {C}https://t.me/OmdutaMd \){N}       \( {P}║ \){N}\n"
line

printf "\( {P}║ \){N}          \( {V}✦ THANK YOU FOR USING ✦ \){N}            \( {P}║ \){N}\n"
printf "\( {P}║ \){N}              \( {W}OMDUTA CLOUD \){N}                    \( {P}║ \){N}\n"
printf "\( {P}╚══════════════════════════════════════════════╝ \){N}\n"
printf "\n"