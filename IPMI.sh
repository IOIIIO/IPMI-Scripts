#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

# Script for relaying as much IPMI data as possible to Graphite
# Copyright 2019 IOIIIO
# https://github.com/IOIIIO/IPMI-Scripts

if [ ! -d "/tmp/ipmi-logger/" ]; then
    mkdir /tmp/ipmi-logger
fi

#HP Machines
echo "Pulling DL380 G6"
bash HP/DL380-G6-script.sh
echo "Pulling DL320 G6"
bash HP/DL320-G6-script.sh

#Dell Machines

echo "We're done!"
exit