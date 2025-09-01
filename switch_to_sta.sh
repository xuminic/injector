#!/bin/bash

echo "[*] Switching to STA mode..."

# Kill hostapd + dnsmasq
sudo killall hostapd dnsmasq

# Bring interface down
sudo ip link set wlan0 down
sudo ip addr flush dev wlan0

# Let netplan take over
sudo netplan apply

# Remove NAT and forwarding rules
sudo iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -D FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo iptables -D FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
