#!/usr/bin/env python3
"""
This file contains  a function that crall from the current dirrectory to the
root until a file name 'cscope.out' is found. Then, the name of the directory
where the csope.out file is found is exported in the variable
'g:cscope_out_roor_dir'. This is meant to work on Windows or UNIX systems but I
only tested it on Linux.

The name of the target is 'cscope.out' by default but it can be updated from
Vim by setting it in the variable 'g:cscope_db_name_target' and calling
the function 'update_target_name'.

The search for the new data_base is added by calling the function 'find_db'.
"""

import sys
import vim

# Import local lib
path = vim.vars['cscope_script_dir'].decode("UTF-8")
sys.path.append(path)
import path_lib

TARGET = "cscope.out"

# ------------------------------ Vim integration ----------------------------- #

def update_target_name():
    TARGET = vim.vars['cscope_db_name_target']

def find_db():
    vim.vars['cscope_out_root_dir'] = path_lib.crawl_from_here(TARGET)

if __name__ == "__main__":
    update_target_name()
    find_db()

