#!/usr/bin/env python3
"""
This file contains  a function that crawl from the current directory to the
root until a file name 'TARGET' is found. 
Then a shell script jumps to that definition and update the db.
"""

import sys
import os
import tempfile

# Import local lib
path = vim.vars['cscope_script_dir'].decode("UTF-8")
sys.path.append(path)
import path_lib

TARGET = "cscope.out"
FILE_REGEX = r".*\.(c|h|cpp|hpp|go|rs|py|v|nelua)$"

# ---------------------------------- Actions --------------------------------- #

def update_target_name():
    TARGET = vim.vars['cscope_db_name_target']

if __name__ == "__main__":
    update_target_name()
    target_dir = path_lib.crawl_from_here(TARGET)
    if target_dir == "":
        print("No cscope.out found.")
        sys.exit(1)

    lst_searched_files = path_lib.find(target_dir, FILE_REGEX)
    namefile = tempfile.mkstemp()[1]
    with open(namefile, "w") as f:
        for file in lst_searched_files:
            if not os.path.islink(file):
                file = file.replace(path_lib.clean_base_dir(target_dir)+"/", "")
                file = file.replace("\\", "\\\\")
                file = file.replace('"', '\\"')
                f.write(f'"{file}"\n')
        
    script = "cd " + target_dir + " &&\n"
    script +=f"    cscope -Rb -i{namefile} -f {TARGET} && \n"
    script += "    cd - > /dev/null\n"
    os.system(script)
    os.remove(namefile)

