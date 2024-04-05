""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"----------------------------- Database management ----------------------------"

if $CSCOPE_DB != ""
    let g:cscope_db_name_target = $CSCOPE_DB
else
    let g:cscope_db_name_target = "cscope.out"
endif

let g:cscope_script_dir = expand('<sfile>:p:h')

" Find the cscope database in the current directory or in its parents.
function cscope_maps#Find_CS_DB()
    let l:py_script = g:cscope_script_dir . "/find_cscope_out.py"
    let l:python_exec_cmd = 'py3file ' . l:py_script
    execute l:python_exec_cmd
    let s:cscope_db_path = g:cscope_out_root_dir . "/" . g:cscope_db_name_target
endfunction

" Refresh the database, updating it with all the files in the file system tree
" it is at the top of.
function cscope_maps#Update_CS_DB()
    let l:py_script = g:cscope_script_dir . "/update_cscope_smart.py"
    let l:python_exec_cmd = 'py3file ' . l:py_script
    execute l:python_exec_cmd
endfunction

" Find the cscope database and read it
function cscope_maps#Add_Cscope_DB()
    call cscope_maps#Find_CS_DB()
    if filereadable(s:cscope_db_path)
        set csre " Needed to ensure that cscope can read relative path from the DB
        let l:getting_db_cmd = 'cs add ' . (s:cscope_db_path) . ''
        execute l:getting_db_cmd
    endif
endfunction

"--------------------------- Keybindings generation ---------------------------"

" For a given letter (l, g, s, ...) return the end of the cscope binding
" command.
function cscope_maps#make_binding_letter(letter)
    if a:letter == 's'
        return 'find s <C-R>=expand("<cword>")<CR><CR>'
    elseif a:letter == 'g'
        return 'find g <C-R>=expand("<cword>")<CR><CR>'
    elseif a:letter == 'c'
        return 'find c <C-R>=expand("<cword>")<CR><CR>'
    elseif a:letter == 't'
        return 'find t <C-R>=expand("<cword>")<CR><CR>'
    elseif a:letter == 'e'
        return 'find e <C-R>=expand("<cword>")<CR><CR>'
    elseif a:letter == 'f'
        " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
        " that searches over '#include <time.h>" return only references to
        " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
        " files that contain 'time.h' as part of their name).
        return 'find f <C-R>=expand("<cfile>")<CR><CR>'
    elseif a:letter == 'i'
        return 'find i ^<C-R>=expand("<cfile>")<CR><CR>'
    elseif a:letter == 'd'
        return 'find d <C-R>=expand("<cword>")<CR><CR>'
    elseif a:letter == 'r'
        return ":call cscope_maps#Update_CS_DB()<Cr>:cs kill -1<Cr>:call cscope_maps#Add_Cscope_DB()<Cr>:echom 'Cscope DB updated.'<Cr>"
    elseif a:letter == 'R'
        return ":cs kill -1<Cr>:call cscope_maps#Add_Cscope_DB()<Cr>:echom 'Cscope DB reloaded.'<Cr>"
    else
        echom "Error, invalid input to `make_binding_letter`."
        return "\nNope, lol"
    endif
endfunction

" Set a bindings for the given letter for full buffer replacement.
function cscope_maps#make_full_window_binding(prefix, letter)
    return "nnoremap " . a:prefix . a:letter . " :cs " . cscope_maps#make_binding_letter(a:letter)
endfunction

" Set a bindings for the given letter for horizontal split seach.
function cscope_maps#make_hsplit_binding(prefix, letter)
    return "nnoremap " . a:prefix . a:letter . " :scs " . cscope_maps#make_binding_letter(a:letter)
endfunction

" Set a bindings for the given letter for vertical split seach.
function cscope_maps#make_vsplit_binding(prefix, letter)
    return "nnoremap " . a:prefix . a:letter . " :vert scs " . cscope_maps#make_binding_letter(a:letter)
endfunction

" Set a bindings for all destination searches for a given letter.
function cscope_maps#bind(letter)
    execute cscope_maps#make_full_window_binding(g:cscopeFullKey,     a:letter)
    execute cscope_maps#make_full_window_binding(g:cscopeFullKey_alt, a:letter)
    execute cscope_maps#make_hsplit_binding(g:cscopeHsplitKey,     a:letter)
    execute cscope_maps#make_hsplit_binding(g:cscopeHsplitKey_alt, a:letter)
    execute cscope_maps#make_vsplit_binding(g:cscopeVsplitKey,     a:letter)
    execute cscope_maps#make_vsplit_binding(g:cscopeVsplitKey_alt, a:letter)
endfunction

" Sets the binding for a database action.
function cscope_maps#bind_reloads(prefix, letter)
    execute "nnoremap " . a:prefix . a:letter . " " . cscope_maps#make_binding_letter(a:letter)
endfunction

" Sets the bindings for database action with all the possible prefix.
function cscope_maps#bind_all_reloads(letter)
    call cscope_maps#bind_reloads(g:cscopeFullKey,       a:letter)
    call cscope_maps#bind_reloads(g:cscopeFullKey_alt,   a:letter)
    call cscope_maps#bind_reloads(g:cscopeHsplitKey,     a:letter)
    call cscope_maps#bind_reloads(g:cscopeHsplitKey_alt, a:letter)
    call cscope_maps#bind_reloads(g:cscopeVsplitKey,     a:letter)
    call cscope_maps#bind_reloads(g:cscopeVsplitKey_alt, a:letter)
endfunction

" Sets all the bindings for every input of the plugin.
function cscope_maps#bind_all_letters()
    call cscope_maps#bind("s")
    call cscope_maps#bind("g")
    call cscope_maps#bind("c")
    call cscope_maps#bind("t")
    call cscope_maps#bind("e")
    call cscope_maps#bind("f")
    call cscope_maps#bind("i")
    call cscope_maps#bind("d")
    call cscope_maps#bind_all_reloads("r")
    call cscope_maps#bind_all_reloads("R")
endfunction

"---------------------- Boilerplate cscope initialization ---------------------"

function cscope_maps#setup()
    " This tests to see if vim was configured with the '--enable-cscope' option
    " when it was compiled.  If it wasn't, time to recompile vim... 
    if has("cscope")
        " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
        set cscopetag

        " Check cscope for definition of a symbol before checking ctags: set to 1
        " if you want the reverse search order.
        set csto=0

        " add any cscope database in current directory
        call cscope_maps#Add_Cscope_DB()

        " Remove mapping used to get the autoload
        execute "nnoremap " . g:cscopeFullKey   . " <Nop>"
        execute "nnoremap " . g:cscopeHsplitKey . " <Nop>"
        execute "nnoremap " . g:cscopeVsplitKey . " <Nop>"

        " Show msg when any other cscope db added
        set cscopeverbose
      
        " Sets keybindings
        call cscope_maps#bind_all_letters()

    endif
endfunction

" Original author:
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
"
" Upgaded by
" Maxime Bouillot   maxbouillot@gmail.com         2024-04-05

