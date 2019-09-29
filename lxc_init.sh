#!/bin/bash

pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTqJS1AqRKQW3Paez7lzti/RW94YYesUKRmN3JRx3mHifoLjezxh1eN++mPAXnBG0fMwAkiOC4vyWgQEZDZQjn2V2ZTkefztUxLIcfn7OY7sU9ivdftthByyQQ8f06UmXfgiOl0d5Nm+2Dy9gr4Vd5JhtdlYCe4xI+X998Lcgbil0wG/WyTfXhwyXB+K5l5CJmqSr1HluAfd6YNO7tK4KgaHcv7PODRmy4E9jvZ/jFOSU4MRL30p9LgN2qjMhmJQM92fpen7p/EBSk3m21GuB4y+K5SGGIjPiS5eXampnV2pBvxS6uT/puQD69ZyTn1rpl1KLpnJEH1/BWSrhqhRdKbdkLlSufadYrE19k+C/4qZSOTiyKRzKGMWDQduA1WZxcUdxh2N5jqG47zIDsEwfcAPA/eMe5z14lH8nHYIFy4cReTvRcz6d9ttntp+CAYPTxVrbgRWFu6gaLgjNcj/lkcTNFOG4VYo7q6SNhoCXD8WETx2END+Pz3LpB9TATCwk= huaweipsmart"
pubkey2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCskXKRwkMSKBUxvkv+pTexFY9JGbnqd6y5a5P6XHaBVaBkoBMzqV1ey/zyM1/GHnFIbJJa4wB3DNn9O69uszbR9ctfAeicm3zwdxnboAfpwm32p8IYlVM7S/dGRTtdmDJOrlgE9OVEeomOG48PclypI+8lewSTHZk1SEjMObMAM7a0/mjED0Q6+vhJ1PM99JJSxklSg92/hZeYMturXc+t/CQbSh1pqSqIZOt2dtDZ5RSpXy4dcp+/yslS2DPoSTxUvbl0lBor690fU4H+Eq4rW4n/eKDr2m28pm0csiwH+sw/378ZRtuxoEiTXYHHc4OH9IjmVrv/UsGg/TFGrpD5 backup"
sshport="22"

locale
locale-gen en_US.UTF-8
locale-gen nl_BE.UTF-8
update-locale LANG=en_US.UTF-8
update-locale LANGUAGE=en_US
update-locale LC_NUMERIC=nl_BE.UTF-8
update-locale LC_TIME=nl_BE.UTF-8
update-locale LC_MONETARY=nl_BE.UTF-8
update-locale LC_PAPER=nl_BE.UTF-8
update-locale LC_NAME=nl_BE.UTF-8
update-locale LC_ADDRESS=nl_BE.UTF-8
update-locale LC_TELEPHONE=nl_BE.UTF-8
update-locale LC_MEASUREMENT=nl_BE.UTF-8
update-locale LC_IDENTIFICATION=nl_BE.UTF-8

adduser tvermeersch
adduser tvermeersch sudo
su tvermeersch

cd /home/tvermeersch

echo "starting system optimalization for ubuntu 18.04"
echo "changing timezone"
timedatectl set-timezone Europe/Brussels

echo "updating system"
apt update

echo "upgrading system"
apt upgrade -y

if [ ! -d "~/.ssh" ]; then
    mkdir ~/.ssh
    touch ~/.ssh/authorized_keys
    echo "adding public key"
    echo $pubkey > ~/.ssh/authorized_keys
    echo $pubkey2 >> ~/.ssh/authorized_keys
fi

sshdir="/etc/ssh/sshd_config"

read -p "Do you want a custom ssh port (y/n): " choice
case "$choice" in 
  y|Y ) read -p "Enter a port: " sshport;;
  n|N ) echo "keeping standard port 22";;
  * ) echo "invalid";;
esac

echo "PasswordAuthentication no" >> $sshdir
echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr" >> $sshdir
echo "HostKeyAlgorithms ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-rsa,ssh-dss" >> $sshdir
echo "KexAlgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha256" >> $sshdir
echo "MACs hmac-sha2-256,hmac-sha2-512,hmac-sha1" >> $sshdir
echo "LogLevel VERBOSE" >> $sshdir
echo "AllowTcpForwarding no" >> $sshdir
echo "AllowStreamLocalForwarding no" >> $sshdir
echo "GatewayPorts no" >> $sshdir
echo "PermitTunnel no" >> $sshdir
echo "Port" $sshport >> $sshdir
echo "PermitRootLogin no" >> $sshdir

systemctl restart ssh
echo "make sure to update your firewall to allow port " $sshport
echo "done."
