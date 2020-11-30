#!/bin/bash

set -ex

mount -t ext4 -o noload,rw /dev/sdb2 /mnt/sd
