""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE: 
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE: 
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if $CSCOPE_DB != ""
    let g:cscope_db_name_target = $CSCOPE_DB
else
    let g:cscope_db_name_target = "cscope.out"
endif

let g:cscope_script_dir = expand('<sfile>:p:h')

function cscope_maps#Find_CS_DB()
    let l:py_script = g:cscope_script_dir . "/find_cscope_out.py"
    let l:python_exec_cmd = 'py3file ' . l:py_script
    execute l:python_exec_cmd
    let s:cscope_db_path = g:cscope_out_root_dir . "/" . g:cscope_db_name_target
endfunction

function cscope_maps#Update_CS_DB()
    let l:py_script = g:cscope_script_dir . "/update_cscope_smart.py"
    let l:python_exec_cmd = 'py3file ' . l:py_script
    execute l:python_exec_cmd
endfunction

function cscope_maps#Add_Cscope_DB()
    if filereadable(g:cscope_db_name_target) && 0
        let l:getting_db_cmd = "cs add " . fnameescape(g:cscope_db_name_target)
        echom l:getting_db_cmd
        execute l:getting_db_cmd
    " else find it in an other folder
    else
        call cscope_maps#Find_CS_DB()
        if filereadable(s:cscope_db_path)
            set csre " Needed to ensure that cscope can read relative path from the DB
            let l:getting_db_cmd = 'cs add ' . (s:cscope_db_path) . ''
            execute l:getting_db_cmd
        endif
    endif
endfunction


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

function cscope_maps#make_full_window_binding(prefix, letter)
    return "nnoremap " . a:prefix . a:letter . " :cs " . cscope_maps#make_binding_letter(a:letter)
endfunction

function cscope_maps#make_hsplit_binding(prefix, letter)
    return "nnoremap " . a:prefix . a:letter . " :scs " . cscope_maps#make_binding_letter(a:letter)
endfunction

function cscope_maps#make_vsplit_binding(prefix, letter)
    return "nnoremap " . a:prefix . a:letter . " :vert scs " . cscope_maps#make_binding_letter(a:letter)
endfunction

function cscope_maps#bind(letter)
    execute cscope_maps#make_full_window_binding(g:cscopeFullKey,     a:letter)
    execute cscope_maps#make_full_window_binding(g:cscopeFullKey_alt, a:letter)
    execute cscope_maps#make_hsplit_binding(g:cscopeHsplitKey,     a:letter)
    execute cscope_maps#make_hsplit_binding(g:cscopeHsplitKey_alt, a:letter)
    execute cscope_maps#make_vsplit_binding(g:cscopeVsplitKey,     a:letter)
    execute cscope_maps#make_vsplit_binding(g:cscopeVsplitKey_alt, a:letter)
endfunction

function cscope_maps#bind_reloads(prefix, letter)
    execute "nnoremap " . a:prefix . a:letter . " " . cscope_maps#make_binding_letter(a:letter)
endfunction

function cscope_maps#bind_all_reloads(letter)
    call cscope_maps#bind_reloads(g:cscopeFullKey,       a:letter)
    call cscope_maps#bind_reloads(g:cscopeFullKey_alt,   a:letter)
    call cscope_maps#bind_reloads(g:cscopeHsplitKey,     a:letter)
    call cscope_maps#bind_reloads(g:cscopeHsplitKey_alt, a:letter)
    call cscope_maps#bind_reloads(g:cscopeVsplitKey,     a:letter)
    call cscope_maps#bind_reloads(g:cscopeVsplitKey_alt, a:letter)
endfunction

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

function cscope_maps#setup()
    " This tests to see if vim was configured with the '--enable-cscope' option
    " when it was compiled.  If it wasn't, time to recompile vim... 
    if has("cscope")

        """"""""""""" Standard cscope/vim boilerplate

        " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
        set cscopetag

        " check cscope for definition of a symbol before checking ctags: set to 1
        " if you want the reverse search order.
        set csto=0

        " add any cscope database in current directory
        call cscope_maps#Add_Cscope_DB()

        " Remove mapping used to getch the autoload
        execute "nnoremap " . g:cscopeFullKey   . " <Nop>"
        execute "nnoremap " . g:cscopeHsplitKey . " <Nop>"
        execute "nnoremap " . g:cscopeVsplitKey . " <Nop>"

        " show msg when any other cscope db added
        set cscopeverbose
      

        """"""""""""" My cscope/vim key mappings
        "
        " The following maps all invoke one of the following cscope search types:
        "
        "   's'   symbol: find all references to the token under cursor
        "   'g'   global: find global definition(s) of the token under cursor
        "   'c'   calls:  find all calls to the function name under cursor
        "   't'   text:   find all instances of the text under cursor
        "   'e'   egrep:  egrep search for the word under cursor
        "   'f'   file:   open the filename under cursor
        "   'i'   includes: find files that include the filename under cursor
        "   'd'   called: find functions that function under cursor calls
        "
        " Below are three sets of the maps: one set that just jumps to your
        " search result, one that splits the existing vim window horizontally and
        " diplays your search result in the new window, and one that does the same
        " thing, but does a vertical split instead (vim 6 only).
        "
        " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
        " unlikely that you need their default mappings (CTRL-\'s default use is
        " as part of CTRL-\ CTRL-N typemap, which basically just does the same
        " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
        " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
        " of these maps to use other keys.  One likely candidate is 'CTRL-_'
        " (which also maps to CTRL-/, which is easier to type).  By default it is
        " used to switch between Hebrew and English keyboard mode.
        "
        " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
        " that searches over '#include <time.h>" return only references to
        " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
        " files that contain 'time.h' as part of their name).


        " To do the first type of search, hit 'CTRL-space' followed by one of the
        " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
        " search will be displayed in the current window.  You can use CTRL-T to
        " go back to where you were before the search.  
        "

        call cscope_maps#bind_all_letters()

        "nnoremap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
        "nnoremap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        "nnoremap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


        " Using 'CTRL-\' (intepreted as CTRL-\ by vim) then a search type
        " makes the vim window split horizontally, with search result displayed in
        " the new window.
        "
        " (Note: earlier versions of vim may not have the :scs command, but it
        " can be simulated roughly via:
        "    nnoremap <C-\>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

        "nnoremap <C-\>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-\>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-\>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-\>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-\>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
        "nnoremap <C-\>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
        "nnoremap <C-\>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
        "nnoremap <C-\>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


        " Hitting CTRL-\ *twice* before the search type does a vertical 
        " split instead of a horizontal one (vim 6 and up only)
        "
        " (Note: you may wish to put a 'set splitright' in your .vimrc
        " if you prefer the new window on the right instead of the left

        "nnoremap <C-\><C-\>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        "nnoremap <C-\><C-\>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        "nnoremap <C-\><C-\>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        "nnoremap <C-\><C-\>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        "nnoremap <C-\><C-\>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        "nnoremap <C-\><C-\>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
        "nnoremap <C-\><C-\>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
        "nnoremap <C-\><C-\>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


        """"""""""""" key map timeouts
        "
        " By default Vim will only wait 1 second for each keystroke in a mapping.
        " You may find that too short with the above typemaps.  If so, you should
        " either turn off mapping timeouts via 'notimeout'.
        "
        "set notimeout 
        "
        " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
        " with your own personal favorite value (in milliseconds):
        "
        "set timeoutlen=4000
        "
        " Either way, since mapping timeout settings by default also set the
        " timeouts for multicharacter 'keys codes' (like <F1>), you should also
        " set ttimeout and ttimeoutlen: otherwise, you will experience strange
        " delays as vim waits for a keystroke after you hit ESC (it will be
        " waiting to see if the ESC is actually part of a key code like <F1>).
        "
        "set ttimeout 
        "
        " personally, I find a tenth of a second to work well for key code
        " timeouts. If you experience problems and have a slow terminal or network
        " connection, set it higher.  If you don't set ttimeoutlen, the value for
        " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
        "
        "set ttimeoutlen=100

    endif
endfunction


