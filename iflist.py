#!/usr/bin/env python

import netifaces

for inet_face in netifaces.interfaces():
    print("Interface: {}".format(inet_face))
    ifaddr = netifaces.ifaddresses(inet_face)
    for a in ifaddr:
        print("  {}:".format(a))
        for b in ifaddr[a]:
            for c in b:
                print("    {}: {}".format(c, b[c]))