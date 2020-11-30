#!/bin/bash

raspberrypi=10.42.0.219

#remote setting
ssh pi@$raspberrypi 'rm -rf ~/.ssh; mkdir ~/.ssh; chmod 700 ~/.ssh; touch ~/.ssh/authorized_keys; chmod 700 ~/.ssh/authorized_keys; exit'

#host setting
if [ -d "~/.ssh" ]; then
   rm -rf  ~/.ssh
fi

if [ ! -d "~/.ssh" ]; then
   mkdir ~/.ssh
   chmod 700 ~/.ssh
   ssh-keygen
   chmod 700 ~/.ssh/id_rsa*
   chmod 700 ~/.ssh
fi

cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub | ssh pi@$raspberrypi 'cat >> ~/.ssh/authorized_keys'

exit 0
