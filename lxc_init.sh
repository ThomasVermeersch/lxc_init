#!/bin/bash

pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAhaD8k9RzGl5lV0OZ9EJm9CkAaV+oI1sArCSgZg33gbg0+RO9vATUnKRQ6m/F4/MJsluFlZT/4bHn2GsUUi5aF0WYu1iCkShZ20t5OV5pZNQhwyyWAaMnA5SYXcHUojCpUCDACbLvkkL4ICiZeTZfzNcJXjzA5U/D7rZAB9ZJ4WBPUZysVrt+M9K7Y4eOskvUkL+zVisndffroqKRayoTIP9c6rdUHSdfTB68ppSz4m1ZBByeENXO0Bl6gLUZEgot1fTsB6eVCK2QcM/f8m80GHQ59Kp4kNV64t1CwN+v5+djsoWmth3qfqDoOvOJdzAHEuAFq9Qe+MuZBY236AEuAaajIq3sbMH/LigxFbJ2v+x1LlnCIAtmtZRDhO63d+N6x0hnV/62zJJWc7jOOMW4JC0K2S4yT/MP4mux/zLLHli0oClqlL5iAqZ/Sn3fYePlQodfstEiyeJl8J8LX4F2EtP5wb52NdIvX3JTkS1p5+HdgIc3GFfgHMCbxLC87mln90iNb/Y+/v/b/UR1RxPP54lQh0MEFh94tLdSHJoNSDJu828VlZ7G8lCW/cVjOAf0xj8qQOg1MFbU6yVWM+m6t6l+sxxF7sFlPLkGz5FCrFj2A1lTxXbv+pRHkYtS68hB/0B8xGyNi04JV13GmilPf8o67sv0XJSYAkwdmtAVpB0="
pubkey2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCskXKRwkMSKBUxvkv+pTexFY9JGbnqd6y5a5P6XHaBVaBkoBMzqV1ey/zyM1/GHnFIbJJa4wB3DNn9O69uszbR9ctfAeicm3zwdxnboAfpwm32p8IYlVM7S/dGRTtdmDJOrlgE9OVEeomOG48PclypI+8lewSTHZk1SEjMObMAM7a0/mjED0Q6+vhJ1PM99JJSxklSg92/hZeYMturXc+t/CQbSh1pqSqIZOt2dtDZ5RSpXy4dcp+/yslS2DPoSTxUvbl0lBor690fU4H+Eq4rW4n/eKDr2m28pm0csiwH+sw/378ZRtuxoEiTXYHHc4OH9IjmVrv/UsGg/TFGrpD5 backup"
pubkey3="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkZqTnf3Ck9ebtiMCFTMt1KpeF4QLXzN5emX8o7QwmVvC1ZsvB1GmR0YG1CVfhd4FOJkj/vpe31+zYDjbyOLz3VY1KqqLW6X1d9ULBLUME2u5Us9xpdbEmChoDW63AFvMHZXEf4r/f9ZnIWdJObWMp9HuI6+t6Vgd+8hrAqz2j6k1mgtZj7SU/hWjDLWErt9xc6NG3OdMjkfJ1yCtSPLtH5zOgs4q4raTa7ftIdbfH0awm2rRVxHGz5tcclNQFI0QaTCbOL/JUkVP7h5bpB2ax281pzbQsELA+H/G2ZwRebDJ7QoyyI4yCC2w3EhyMQFKzR8Fy1fUAThtlAq/ZFzalI0iLD5TsiO2u+O1Smrxqoemj9h3h7i7e+bBHSkXERpBt2P84f69WxHOibcUUPk+HYRlRM4NgLX6OK2ur2BHE9GmxvG2uDx+mar2yGzXR5alGtxHKhTllbbQVlS3vgzIxG38oNopiWD479ucVOA0w6i90hp26oQLV+JciJ+4iXtU= GalaxyA50"

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
    echo $pubkey > ~/.ssh/authorized_keys
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
