#!/usr/bin/env python3

# spotlight_fetcher.py - Utility to download wallpapers from Microsoft Spotlight.
# Version: 0.1
# (c) 2016 Piotr Grzeszczak
# http://www.grzeszczak.it
# Based on https://github.com/liu-yun/spotlight/blob/master/spotlight.py
# License: GPLv3

import json
import os
import random
import uuid
import requests
import hashlib
import signal

from datetime import datetime

dest = os.path.join(os.path.expanduser('~'), "Pictures","Wallpapers", "Spotlight")
file_blacklist = []

# Catch Ctrl + C signal
def ctrlc_handler(signal, frame):
    print('\nSIGINT signal received!\nExiting now...')
    exit(0)

def random_id():
    return str(uuid.uuid4()).replace('-', '')

def read_md5(file):
    hasher = hashlib.md5()
    with open(file, 'rb') as f:
        buf = f.read()
        hasher.update(buf)
    return hasher.hexdigest()

def update_hash_db(path):
    md5_list = []
    for file in os.listdir(path):
        md5_list.append(read_md5(path + '/' + file))
    return md5_list

def downloader(url, session, dest_path):
    d = session.get(url)
    if d.status_code == 200:
        with open(dest_path, 'wb+') as f:
            for chunk in d:
                f.write(chunk)
        md5sum = read_md5(dest_path)
        print('Downloading {} ({})'.format(dest_path.split('/')[-1:][0], md5sum))
        return md5sum
    else:
        print('Download failed! ({})'.format(d.status_code))
        return False

def worker():
    print("Updating MD5 hash file list... ", end='')
    hash_db = update_hash_db(dest)
    print("items: {}".format(len(hash_db)))

    # Magical request
    print('Requesting json...')
    cache_url = 'https://arc.msn.com/v3/Delivery/Cache'
    data = {'pid': random.choice([209562, 209567, 279978]),
            'fmt': 'json', # Output format
            'ctry': 'PL', # Country
            'time': datetime.now().strftime('%Y%m%dT%H%M%SZ'), # Current time
            'lc': 'pl-pl', # https://msdn.microsoft.com/pl-pl/windows/uwp/publish/supported-languages
            'pl': 'pl-pl,en-US',
            'idtp': 'mid',
            'uid': uuid.uuid4(),
            'aid': '00000000-0000-0000-0000-000000000000',
            'ua': 'WindowsShellClient/9.0.40929.0 (Windows)',
            'asid': random_id(),
            'ctmode': 'ImpressionTriggeredRotation',
            'arch': 'x64',
            'cdmver': '10.0.14936.1000',
            'devfam': 'Windows.Desktop',
            'devform': 'Unknown',
            'devosver': '10.0.14936.1000',
            'disphorzres': 1920,
            'dispsize': 15.5,
            'dispvertres': 1080,
            'fosver': 14352,
            'isu': 0,
            'lo': 510893,
            'metered': False,
            'nettype': 'wifi',
            'npid': 'LockScreen',
            'oemid': 'VMWARE',
            'ossku': 'Professional',
            'prevosver': 14257,
            'smBiosDm': 'VMware Virtual Platform',
            'smBiosManufacturerName': 'VMware, Inc.',
            'tl': 4,
            'tsu': 6788
            }

    # Get image urls
    r = requests.get(cache_url, params=data)
    urls = []

    try:
        for item in r.json()['batchrsp']['items']:
            d = json.loads(item['item'])
            urls.append(d['ad']['image_fullscreen_001_landscape']['u'])
    except:
        print("Broken data...")

    print("Found {} images...".format(len(urls)))

    # Download them
    # TODO: Cleanup this part.
    with requests.Session() as s:
        for url in urls:
            local_path = os.path.join(dest, url.split('/')[3] + '.jpg')
            if os.path.exists(local_path) is False and not local_path in file_blacklist:
                md5sum = downloader(url, s, local_path)

                if md5sum in hash_db:
                    print("Exist (md5 sum), added to cache blacklist.")
                    os.remove(local_path)
                    file_blacklist.append(local_path)
                else:
                    hash_db.append(md5sum)
            else:
                print("Exist")

def main():
    print("Ultimate Spotlight Fetcher!")

    # Signals handlers
    signal.signal(signal.SIGINT, ctrlc_handler)
    print("Press Ctrl + C for exit")

    if not os.path.exists(dest):
        print("Destination folder {} not found, creating it...".format(dest))
        os.mkdir(dest)
    else:
        print("Destination: {}".format(dest))

    while(1):
        worker()

if __name__ == '__main__':
    main()
