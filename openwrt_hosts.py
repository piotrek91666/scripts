#!/usr/bin/env python3

# openwrt_hosts.py - Utility to list host defined in your openwrt router.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

import paramiko
import socket
import argparse
from subprocess import Popen, PIPE, STDOUT

parser = argparse.ArgumentParser()
parser.add_argument("host",
                    help="OpenWrt host")

parser.add_argument("-f", "--file",
                    help="dhcp file (default /etc/config/dhcp)",
                    default='/etc/config/dhcp')

args = parser.parse_args()

ssh_client = paramiko.SSHClient()
ssh_client.load_system_host_keys()
ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

try:
    ssh_client.connect(args.host, 22, 'root', look_for_keys=True)
except (paramiko.SSHException, socket.gaierror) as e:
    print("Connection error: {}".format(e))
    exit(1)

sftp = ssh_client.open_sftp()

fileObject = None
try:
    fileObject = sftp.open(args.file, 'r', -1)
except FileNotFoundError as e:
    print("Error while opening remote file: {}\n".format(args.file), e, sep='')
    exit(1)

lines = []
for line in fileObject:
    line = line.strip()
    if line != '':
        lines.append(line)

sftp.close()
ssh_client.close()

opt_sem = False
hosts = []
tmp_dict = {}
for line in lines:
    if line == 'config host':
        opt_sem = True

    elif line.split()[0] == 'option' and opt_sem:
        tmp_dict[line.split()[1].strip("'")] = line.split()[2].strip("'")

    elif line.split()[0] != 'option' and opt_sem:
        hosts.append(tmp_dict)
        tmp_dict = {}

    else:
        opt_sem = False

for host in hosts:
    ping_result = Popen(["/bin/ping", "-c1", host["name"]], stderr=STDOUT,
        stdout=PIPE)
    ping_state = ping_result.communicate()[0], ping_result.returncode
    print("Host: {}\tIP: {}\tMAC: {}\t State: {}".format(
        host["name"], host["ip"], host["mac"],
        'DOWN' if ping_state[1] else 'UP').expandtabs(25))
