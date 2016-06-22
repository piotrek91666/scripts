#!/usr/bin/env python

import os
import argparse
import random
import struct
import hashlib
import getpass
from Crypto.Cipher import AES

def encrypt_file(key, in_filename, chunksize=64*1024):
    out_filename = in_filename + '.encrypted'

    iv = bytes([random.randint(0,0xFF) for i in range(16)])
    encryptor = AES.new(key, AES.MODE_CBC, iv)
    filesize = os.path.getsize(in_filename)

    with open(in_filename, 'rb') as infile:
        with open(out_filename, 'wb') as outfile:
            outfile.write(struct.pack('<Q', filesize))
            outfile.write(iv)

            while True:
                chunk = infile.read(chunksize)
                if len(chunk) == 0:
                    break
                elif len(chunk) % 16 != 0:
                    chunk += b' ' * (16 - len(chunk) % 16)

                outfile.write(encryptor.encrypt(chunk))

def decrypt_file(key, in_filename, chunksize=24*1024):
    print(in_filename)
    saveadot = '.' if in_filename[0] == '.' else ''

    out_filename = saveadot.join(args.file.split('.')[0:-1])
    print(out_filename)

    with open(in_filename, 'rb') as infile:
        origsize = struct.unpack('<Q', infile.read(struct.calcsize('Q')))[0]
        iv = infile.read(16)
        decryptor = AES.new(key, AES.MODE_CBC, iv)

        with open(out_filename, 'wb') as outfile:
            while True:
                chunk = infile.read(chunksize)
                if len(chunk) == 0:
                    break
                outfile.write(decryptor.decrypt(chunk))

            outfile.truncate(origsize)

def passwd_prompt():
    passwd = getpass.getpass('Password: ')
    return hashlib.sha256(passwd.encode()).digest()

if __name__ == "__main__":
    argParser = argparse.ArgumentParser()
    argParser.add_argument("file", help="path to file")
    args = argParser.parse_args()

    if args.file.split('.')[-1] == "encrypted":
        print("Decrypting file...")
        decrypt_file(passwd_prompt(), args.file)
        os.remove(args.file)

    else:
        print("Encrypting file...")
        encrypt_file(passwd_prompt(), args.file)
        os.remove(args.file)


