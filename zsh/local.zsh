# Machine-specific configuration: hardware quirks and paths that only make
# sense on this laptop. Safe to skip on other machines.

# Some tools look for Microsoft Edge; point them at brave instead
export EDGE_PATH="/usr/bin/brave"

# Bypass the VPN by binding curl to the wifi interface
alias curl-novpn="curl --interface wlp1s0"

alias restart_touchpad_drivers="sudo modprobe -r psmouse; sudo modprobe psmouse"
