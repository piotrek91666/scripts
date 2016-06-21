#!/usr/bin/env python

# randmac.py - Utility to generate random mac address for vm's or containers.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

from sys import argv
from random import randint
from hashlib import md5

hash = md5()
hash.update((argv[1] if len(argv) > 1 else '').encode())
mac = hash.hexdigest()[:6] + "%02x%02x%02x" % (randint(0, 255), randint(0, 255), randint(0, 255))
print(':'.join([mac[i:i+2] for i in range(0, len(mac), 2)]))
