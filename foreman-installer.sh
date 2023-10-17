#!/usr/bin/env bash

dnf install -y foreman-installer-katello

foreman-installer --scenario katello -l info \
  --enable-puppet \
  --enable-foreman-cli-puppet \
  --enable-foreman-plugin-puppet \
  --foreman-proxy-puppet true \
  --foreman-proxy-puppetca true \
  --puppet-server true \
  --puppet-server-foreman-ssl-ca /etc/pki/katello/puppet/puppet_client_ca.crt \
  --puppet-server-foreman-ssl-cert /etc/pki/katello/puppet/puppet_client.crt \
  --puppet-server-foreman-ssl-key /etc/pki/katello/puppet/puppet_client.key \
  --foreman-proxy-dns true \
  --foreman-proxy-dns-interface enp5s0 \
  --foreman-proxy-dhcp true \
  --foreman-proxy-dhcp-interface enp5s0 \
  --foreman-proxy-dhcp-range "172.16.0.200 172.16.0.220" \
  --foreman-proxy-dhcp-nameservers 172.16.0.12 \
  --foreman-proxy-tftp true
