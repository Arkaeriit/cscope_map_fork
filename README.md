# cscope\_map fork

This repository contains a fork of the script `cscope_map.vim` written by Jason Duell under a BSD 3-clause license.

## Modifications made

The main modification I made was to let the script crawl from the working directory to the root directory to search for a cscope database. The default name for the database is `cscope.out` but you can supply any name with the `$CSCOPE_DB` environment variable.

I also inverted `ctrl+\` and `ctrl+<space>` to better suit my need.

