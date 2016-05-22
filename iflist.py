#!/usr/bin/env python

# iflist.py - Utility to list all network interfaces.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

import netifaces

for inet_face in netifaces.interfaces():
    print("Interface: {}".format(inet_face))
    ifaddr = netifaces.ifaddresses(inet_face)
    for addr_id in ifaddr:
        print("  {}:".format(addr_id))
        for addr_num in ifaddr[addr_id]:
            for addr_val in addr_num:
                print("    {}: {}".format(addr_val, addr_num[addr_val]))
    print("")