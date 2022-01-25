#!/usr/bin/env python3
"""
This file contains  a function that crawl from the current directory to the
root until a file name 'TARGET' is found. 
Then a shell script jumps to that definition and update the db.
"""

import sys
import os

# Import local lib
path = vim.vars['cscope_script_dir'].decode("UTF-8")
sys.path.append(path)
import path_lib

TARGET = "cscope.out"

# ---------------------------------- Actions --------------------------------- #

def update_target_name():
    TARGET = vim.vars['cscope_db_name_target']

if __name__ == "__main__":
    update_target_name()
    target_dir = path_lib.crawl_from_here(TARGET)
    if target_dir == "":
        print("No cscope.out found.")
        sys.exit(1)
    script = "cd " + target_dir + " &&\n"
    script += "    cscope -Rb -f" + TARGET + "&& \n"
    script += "    cd - > /dev/null\n"
    os.system(script)

