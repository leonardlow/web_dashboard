#!/bin/bash
#v1 - 20250418 - simple gateway ping test - LL
#v2 - 20250418 - include v6 test - LL

#!/bin/bash

# Extract IPv4 gateway addresses
ipv4_gateways=$(clish -c 'show configuration static-route' | awk '{print $7}' | sort -u)

# Extract IPv6 gateway addresses
ipv6_gateways=$(clish -c 'show configuration ipv6 static-route' | awk '{print $7}' | sort -u)

# Ping each IPv4 gateway and report status
for gateway in $ipv4_gateways; do
  if ping -c 1 $gateway &> /dev/null; then
    echo "Gateway $gateway (IPv4) is reachable."
  else
    echo "Gateway $gateway (IPv4) is not reachable."
  fi
done

# Ping each IPv6 gateway and report status
for gateway in $ipv6_gateways; do
  if ping6 -c 1 $gateway &> /dev/null; then
    echo "Gateway $gateway (IPv6) is reachable."
  else
    echo "Gateway $gateway (IPv6) is not reachable."
  fi
done

