if !exists("g:cscopeFullKey")
    let g:cscopeFullKey = '<C-@>'
endif
if !exists("g:cscopeHspliKey")
    let g:cscopeHsplitKey = '<C-@><C-@>'
endif
if !exists("g:cscopeVspliKey")
    let g:cscopeVsplitKey = '<c-@><C-@><C-@>'
endif

let g:cscopeFullKey_alt   = 'cscopebindingalt'
let g:cscopeHsplitKey_alt = 'cscopebindinghalt'
let g:cscopeVsplitKey_alt = 'cscopebindingvalt'

execute "nnoremap " . g:cscopeFullKey   . " :call cscope_maps#setup()<Cr>:call feedkeys('" . g:cscopeFullKey_alt   . "', 'i')<Cr>"
execute "nnoremap " . g:cscopeHsplitKey . " :call cscope_maps#setup()<Cr>:call feedkeys('" . g:cscopeHsplitKey_alt . "', 'i')<Cr>"
execute "nnoremap " . g:cscopeVsplitKey . " :call cscope_maps#setup()<Cr>:call feedkeys('" . g:cscopeVsplitKey_alt . "', 'i')<Cr>"

