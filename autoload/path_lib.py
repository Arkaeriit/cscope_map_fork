#!/usr/bin/env python3
"""
This file is a small lib that is mainly meant to find files in a file system.
The main function is `crawl_from_here` which can find a file by its name in the
hierarchy above the current directory.
"""

import os.path
import re

# ----------------------------- Data manipulation ---------------------------- #

def clean_base_dir(path):
    """Assuming path is a dir, return its wihh no trailing slashes."""
    return os.path.dirname(path + '/')

def is_root(path):
    """Tells if the given path is a root directory."""
    raw_dir = os.path.splitdrive(clean_base_dir(path))[1]
    return raw_dir == "/" or raw_dir == "//"

def is_target_in_dir(path, target):
    """Tells if the file whose name is in the `target` variable is in the current dir."""
    target_path = clean_base_dir(path) + '/' + target
    return os.path.exists(target_path)

def get_previous_dir(path):
    """Return the path of the directory where the given path is."""
    return os.path.dirname(clean_base_dir(path))

def crawler(path, target):
    """Cralls from the given path until the `target` file is found.
    If the TARGET is found, the name of the dir where it is is
    returned. Otherwize, an empty string is returned."""
    if is_target_in_dir(path, target):
        return clean_base_dir(path)
    if is_root(path):
        return ''
    return crawler(get_previous_dir(path), target)

def crawl_from_here(target):
    """Calls the cralwer function from the current dirrectory."""
    pwd = os.path.realpath(".")
    return crawler(pwd, target)

def find(path, regex):
    """Find all the file that comply to the given regex in the given directory
    and return them in a list. Works recursively. The given regex can be a
    string or a compiled regex."""
    ret = []
    if type(regex) == str:
        regex = re.compile(regex)
    if type(regex) != re.Pattern:
        raise TypeError("Input regex should be a string or a compiled Regex")
    for file in os.listdir(path):
        full_path = path+"/"+file
        if os.path.isdir(full_path):
            ret += find(full_path, regex)
        if regex.match(file):
            ret.append(full_path)
    return ret

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
    print(find("../..", ".*\.py$"))

