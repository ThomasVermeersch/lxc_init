#!/bin/bash

pubkey2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCskXKRwkMSKBUxvkv+pTexFY9JGbnqd6y5a5P6XHaBVaBkoBMzqV1ey/zyM1/GHnFIbJJa4wB3DNn9O69uszbR9ctfAeicm3zwdxnboAfpwm32p8IYlVM7S/dGRTtdmDJOrlgE9OVEeomOG48PclypI+8lewSTHZk1SEjMObMAM7a0/mjED0Q6+vhJ1PM99JJSxklSg92/hZeYMturXc+t/CQbSh1pqSqIZOt2dtDZ5RSpXy4dcp+/yslS2DPoSTxUvbl0lBor690fU4H+Eq4rW4n/eKDr2m28pm0csiwH+sw/378ZRtuxoEiTXYHHc4OH9IjmVrv/UsGg/TFGrpD5 backup"
pubkey3="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDT3oEiDWbeFZ9kgy45GPehJPK1DkEAB4y9woQZ01zOpbBgPEj41YVG529EWybpzO7+s7z9/jrK2eooi8+v5SL1xPwylCeo5tHoldqxnJq1KdIs0h4YKZF/gvQ1nNsTuTwIEWtvbRyMYNBj3DZEHMsi2xkVOKgbE1dqJftojH6Y5xyWnbGLN4/gG/j3fKoxkq4Xv48Lcs4igAyyYzrqQTFMXF/75WC2dDCV4OZ4rm5CWVoLpGPRCGwvDIHXRaqhR06wfO+6eO1lI4h3VcNSfbdT90jYSD5szkU2e+0SMzyDAmUzeYvVG2nfoM4kSmXVoZidzNaLhbgkh+pnewABgVKjENdjD093MqopPm8JCC+PGLsLHvTvlzO5gz1TvfCmLyV44kIbI47vOKbVpVgPQ1kwgisdlGS5aVcv/gt0qIW6Kq2+3Ss6/n9BvPV/p7KR2B4pSKv+syeg4dRNMJh5oIkvCV3xhnBtM+B9B2t+Ap5q2h1zrNpquPOT/wSptSl9zPQTCQ42SnElV11zg1rqVVXrBDeRRzFH/2Q1e9ssj4ZuhRiwaOXjsLCkbwsGNQnOb+CV31C299XFDbF7VMM8TSCTaI1faIEwKcQ9qro2zKw+UWHxcAiQ++x7X+lyM3RTKrmnnnrxrieZuNHpxCzZmRslMuanvIG6oMu6XmybVoospQ== thomas11Pro"

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
    echo $pubkey2 >> ~/.ssh/authorized_keys
    echo $pubkey3 >> ~/.ssh/authorized_keys
fi

sshdir="/etc/ssh/sshd_config"

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
echo "Port 22345" >> $sshdir
echo "PermitRootLogin no" >> $sshdir

systemctl restart ssh
echo "make sure to update your firewall to allow port 22345"
echo "done."
