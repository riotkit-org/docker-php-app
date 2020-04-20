#!/usr/bin/env python3

import os
import subprocess


def create_file(source: str, dest: str) -> None:
    subprocess.call('mkdir -p %s' % (os.path.dirname(target_path)), shell=True)
    subprocess.check_call('j2 %s > %s' % (file, target_path), shell=True)


CONFIGS_PATH = os.getenv('CONFIGS_PATH','/.etc.template')
CONFIGS_DEST_PATH = os.getenv('CONFIGS_DEST_PATH', '/etc')

files_list = subprocess.check_output('find ' + CONFIGS_PATH + ' -name \'*.j2\'', shell=True).decode('utf-8').\
    strip().split("\n")

for file in files_list:
    target_path = file[:-3]                        # cut off the extension
    target_path = target_path[len(CONFIGS_PATH):]  # cut off the original directory
    target_path = CONFIGS_DEST_PATH + target_path  # append new directory

    print(" >> Rendering file %s into %s" % (file, target_path))
    create_file(file, target_path)
