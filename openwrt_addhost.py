#!/usr/bin/env python

# openwrt_hosts.py - Utility to add host and domain in your openwrt router.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

import argparse
from openwrt.UCI import UCI

parser = argparse.ArgumentParser()
parser.add_argument("ow_host", help="openwrt host")
parser.add_argument('-n', "--name", help="hostname")
parser.add_argument('-m', "--mac", help="hardware address")
parser.add_argument('-i', "--ip", help="ip address")
args = parser.parse_args()

ow = UCI(args.ow_host)
