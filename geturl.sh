#!/bin/bash
#
# Run this script in RK2611A box
#

PACKAGES="hostapd dnsmasq wireless-tools psmisc"

apt-get --print-uris install $PACKAGES | cut -d"'" -f2 > package.url

