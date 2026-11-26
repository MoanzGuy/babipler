#!/bin/bash
cat << "EOF"

  ╔══════════════════════════════════════╗
  ║     ✦ WELCOME TO OMDUTA CLOUD ✦     ║
  ╠══════════════════════════════════════╣
EOF

echo "  ║  Host   : $(hostname)"
echo "  ║  OS     : $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '\"')"
echo "  ║  Kernel : $(uname -r)"
echo "  ║  Arch   : $(uname -m)"
UP=$(awk '{d=int($1/86400);h=int(($1%86400)/3600);m=int(($1%3600)/60);printf "%dd %dh %dm",d,h,m}' /proc/uptime)
echo "  ║  Uptime : $UP"
echo "  ╠══════════════════════════════════════╣"
echo "  ║  Owner  : @OmdutaMd"
echo "  ║  TG     : t.me/OmdutaMd"
echo "  ╚══════════════════════════════════════╝"
echo ""