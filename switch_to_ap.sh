#!/bin/bash

echo "[*] Switching to AP mode..."

# Kill wpa_supplicant & netplan interface
sudo killall wpa_supplicant
#sudo killall dhclient
#sudo nmcli dev disconnect wlan0 2>/dev/null
#sudo networkctl down wlan0
sudo ip link set wlan0 down

# disable systemd-resolved
sudo systemctl stop systemd-resolved
echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf


# Static IP for AP
sudo ip addr flush dev wlan0
sudo ip link set wlan0 up
sudo ip addr add 192.168.42.1/24 dev wlan0

# Start services
sudo dnsmasq --conf-file=/etc/dnsmasq.ap.conf
sudo hostapd -B /etc/hostapd/hostapd.conf

# Remove the STA address (previous ops doesn't remove it)
sudo ip addr del 192.168.1.30/24 dev wlan0

# Enable NAT from wlan0 to eth0
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT

