#!/usr/bin/env python

# openwrt_uci.py - Wrapper to OpenWRT UCI System.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.pw
# License: GPLv3

import paramiko
import socket

class UCI:
    def __init__(self, ow_host):
        self.ssh_client = paramiko.SSHClient()
        self.ssh_client.load_system_host_keys()
        self.ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        try:
            self.ssh_client.connect(ow_host, 22, 'root', look_for_keys=True)
        except (paramiko.SSHException, socket.gaierror) as e:
            print("Connection error: {}".format(e))
            exit(1)

    def _send_cmd(self, command):
        stdin, stdout, stderr = self.ssh_client.exec_command(command=command, timeout=25)

        stderr_r = stderr.read()
        if stderr_r:
            print('Error occurred while executing remote command: {}\n{}'.format(command, stderr_r.decode()))
            return None

        return stdout.read()

    def cfg_export(self, cmd_string):
        self._send_cmd('uci export {}'.format(cmd_string))

    def cfg_import(self, cmd_string):
        self._send_cmd('uci import {}'.format(cmd_string))

    def cfg_changes(self, cmd_string):
        self._send_cmd('uci changes {}'.format(cmd_string))

    def commit(self, cmd_string):
        self._send_cmd('uci commit {}'.format(cmd_string))

    def add(self, cmd_string):
        print('Adding new section: {}'.format(cmd_string))
        self._send_cmd('uci add {}'.format(cmd_string))

    def add_list(self, cmd_string):
        self._send_cmd('uci add_list {}'.format(cmd_string))

    def del_list(self, cmd_string):
        self._send_cmd('uci del_list {}'.format(cmd_string))

    def show(self, cmd_string):
        self._send_cmd('uci show {} -X'.format(cmd_string))

    def get(self, cmd_string):
        self._send_cmd('uci get {}'.format(cmd_string))

    def set(self, cmd_string):
        self._send_cmd('uci set {}'.format(cmd_string))

    def delete(self, cmd_string):
        self._send_cmd('uci delete {}'.format(cmd_string))

    def rename(self, cmd_string):
        self._send_cmd('uci rename {}'.format(cmd_string))

    def revert(self, cmd_string):
        self._send_cmd('uci revert {}'.format(cmd_string))

    def reorder(self, cmd_string):
        self._send_cmd('uci reorder {}'.format(cmd_string))

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.ssh_client.close()

t = UCI('homegate')
t.show('dhcpp')

