# cscope\_map fork

This repository contains a fork of the script `cscope_map.vim` written by Jason Duell under license I am not sure of.

## Introduction

Ccscope is a software used to keep a database of symbols in a codebase. It's meant to work with C-style languages, but it works quite well with other kind of languages. There is built-in features in Vim to interact with cscope, but the interface are quite clunky. This plugin adds some nice keybindings to use those interfaces and add some more features to interact with the database.

## Cscope database

Cscope uses a database to store information about the files managed. This plugin searches it as the file `cscope.out` by default, but it can be changed with the `CSCOPE_DB` environment variable.

This plugin searches it next to the current directory and the crawl back to the parent directories to try and find it. Once the database is found, this plugin lets you search it with easy keybindings or refresh it to re-index files (default keybinding to do that is `<C-@>r` (`<C-@>` can be either `Ctrl-@` or `Ctrl-space`)). If there is no database but you try to reload it, a new one will be created in the current directory, which let you use scope while never leaving Vim.

## Key bindings

The key bindings to interact with cscope are made in two parts, the destination with specifies where the new file will be open and the search type which specifies how to search the word under the cursor.

### Destination

The searched content can be showed by completely replacing the current buffer (default binding is control plus space, noted `<C-@>`), in a horizontal split (default binding is `<C-@><C-@>`), or in a vertical split (default binding is `<C-@><C-@><C-@>`).

Those binding can be modified with the global variables `g:cscopeFullKey`, `g:cscopeHsplitKey`, and `g:cscopeVsplitKey`. For example, adding `let g:cscopeFullKey = "<C-f>"` in your vimrc will make `<C-f>` the binding to open search result in the current buffer.

If you replaced the current buffer, you can go back to the previous file with `<C-t>`.

### Search types

The search types are the following:

* 's'   symbol: find all references to the token under cursor
* 'g'   global: find global definition(s) of the token under cursor
* 'c'   calls:  find all calls to the function name under cursor
* 't'   text:   find all instances of the text under cursor
* 'e'   egrep:  egrep search for the word under cursor
* 'f'   file:   open the filename under cursor
* 'i'   includes: find files that include the filename under cursor
* 'd'   called: find functions that function under cursor calls

They cannot be changed.

### Database reloading

Instead of a search type, you can press `r` to refresh the cscope database, re-indexing every file recursively inside of the database's directory. You can also use `R` to reload it without changing it, if you changed it with an external program.

Those bindings can be use with any of the three destination prefix.

### Examples

Putting your cursor on the word `my_function` and pressing `<C-@>g` will open the definition of `my_function` replacing the current buffer. Putting your cursor on the word `my_other_function` and pressing `<C-@><C-@>c` will open calls of `my_other_function` in an horizontal split. Pressing `<C-@><C-@>r` will reload the database.

## Installation

To install this plugin, simply put this repository's directory into your plugin directory. For example, if you are using Pathogen as a plugin manager, put in in `bundle`.

## Limitations

* Spaces in the path of the cscope database are not well supported.
* Vim needs to be compiled with both python3 and cscope support.
* The plugin have been written with only POSIX systems in mind. It might not work fully on other systems.
* As the plugin uses bindings with multiple keys, you might want to change the `timeout` or `timeoutlen` settings of Vim if the use of the plugin is not comfortable.

