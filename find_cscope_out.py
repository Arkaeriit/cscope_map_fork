#!/usr/bin/env python3
"""
This file contains  a function that crall from the current dirrectory to the
root until a file name 'cscope.out' is found. Then, the name of the directory
where the csope.out file is found is exported in the variable
'g:cscope_out_roor_dir'. This is meant to work on Windows or UNIX systems but I
only tested it on Linux.
"""

import os.path
#import vim

TARGET = "cscope.out"

# ----------------------------- Data manipulation ---------------------------- #

def clean_base_dir(path):
    """Assuming path is a dir, return its wihh no trailing slashes."""
    return os.path.dirname(path + '/')

def is_root(path):
    """Tells if the given path is a root directory."""
    raw_dir = os.path.splitdrive(clean_base_dir(path))[1]
    return raw_dir == "/" or raw_dir == "//"

def is_target_in_dir(path):
    """Tells if the file whose name is in the TARGET variable is in the current dir."""
    target_path = clean_base_dir(path) + '/' + TARGET
    return os.path.exists(target_path)

def get_previous_dir(path):
    """Return the path of the directory where the given path is."""
    return os.path.dirname(clean_base_dir(path))

def crawler(path):
    """Cralls from the given path until the TARGET file is found.
    If the TARGET is found, the name of the dir where it is is
    returned. Otherwize, an empty string is returned."""
    if is_target_in_dir(path):
        return clean_base_dir(path)
    if is_root(path):
        return ''
    return crawler(get_previous_dir(path))

def crawl_from_here():
    """Calls the cralwer function from the current dirrectory."""
    pwd = os.path.realpath(".")
    return crawler(pwd)

# ---------------------------------- Testing --------------------------------- #

def print_all_until_root(path):
    """Prints the name of all dirs from the path to the root"""
    print(path)
    if not is_root(path):
        print_all_until_root(get_previous_dir(path))

def print_all_form_here():
    """Prints the name of all dirs from the current dir to the root"""
    pwd = os.path.realpath(".")
    print_all_until_root(pwd)

if __name__ == "__main__":
    print_all_form_here()
    print("|", crawl_from_here(), "|")

# ------------------------------ Vim integration ----------------------------- #





