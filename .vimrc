" .vimrc
"
" Maleick
" Updated 8/24/17
"
" Enable Syntax and Plugins
syntax enable
filetype indent plugin on

" Enter the current Millenium
set nocompatible

" Fuzzy Finding
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Numbers
set rnu
function ToggleNumbersOn()
    set rnu!
    set nu
endfunction
function ToggleRelativeOn()
    set nu!
    set rnu
endfunction
autocmd FocusLost * call ToggleNumbersOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleNumbersOn()
autocmd InsertLeave * call ToggleRelativeOn()
