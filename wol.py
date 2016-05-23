#!/usr/bin/env python

# wol.py - Utility to awake machines using the Wake on LAN.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

import socket
import struct
import netifaces
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("mac",
                    help="hardware address")

parser.add_argument("-p", "--port",
                    help="destination port (default 9)",
                    default=9,
                    type=int)

parser.add_argument("-i", "--interface",
                    help="interface (default eth0)",
                    default='eth0')

parser.add_argument("-b", "--bcast",
                    help="broadcast address (default 255.255.255.255)",
                    default='255.255.255.255')

args = parser.parse_args()

macaddress = args.mac


if len(macaddress) == 17:
    macaddress = macaddress.replace(macaddress[2], '')

elif len(macaddress) == 12:
    pass

else:
    try:
        raise ValueError(macaddress)
    except:
        print('\nInvalid hardware address.')
        exit(1)

print("Sending magic packet to {}:{} with {}... ". format(macaddress, args.port, args.bcast), end='')

data = b'FFFFFFFFFFFF' + (macaddress * 20).encode()
send_data = b''

iface_addr = ''

try:
    for i in range(0, len(data), 2):
        send_data += struct.pack(b'B', int(data[i:i + 2], 16))

except ValueError:
    print("\nError occurred while translating mac address.")
    exit(1)

try:
    iface_addr = netifaces.ifaddresses(args.interface)[netifaces.AF_INET][0]['addr']
except:
    print("\nError occurred while specifying interface.")
    exit(1)

try:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((iface_addr, 0))
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    sock.connect((args.bcast, args.port))
    sock.send(send_data)
    sock.close()

except:
    print("failed!")
    exit(1)
else:
    print("success!")
