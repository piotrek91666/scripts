#!/usr/bin/env python

# iflist.py - Utility to lis all network interfaces.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

import netifaces

for inet_face in netifaces.interfaces():
    print("Interface: {}".format(inet_face))
    ifaddr = netifaces.ifaddresses(inet_face)
    for a in ifaddr:
        print("  {}:".format(a))
        for b in ifaddr[a]:
            for c in b:
                print("    {}: {}".format(c, b[c]))