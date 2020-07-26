#!/usr/bin/env python

from subprocess import PIPE
from subprocess import Popen
from subprocess import check_output

import os
import stat
import shutil



def create_command_string(cmd):
    # p = Popen(cmd,stdout=PIPE)
    process = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
    output = process.communicate()[0]
    output = output.decode("utf-8").rstrip('\n')
    return output 

def brew_cleanup():
    str_brew_path = create_command_string("which brew")
    command = str_brew_path + " cleanup"
    process = Popen(command, stdout=PIPE, stderr=PIPE, shell=True)
    output, error = process.communicate()
    print (output)

def clean_library_caches():
    user = os.getlogin()
    library_cache_path = os.path.join('/Users', user, 'Library/Caches/')
    shutil.rmtree(library_cache_path, ignore_errors=False, onerror=None)

def clean_tmp():
    shutil.rmtree('/tmp/', ignore_errors=False, onerror=None)

def main():
    brew_cleanup()
    clean_library_caches()
    # clean_tmp()

if __name__ == "__main__": 
    main()
