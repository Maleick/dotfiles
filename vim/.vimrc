" .vimrc
" maleick
" 07/21/20

" general vim settings
syntax enable
filetype plugin indent on
set nocompatible
set autoindent
set tabstop=4
set shiftwidth=4
set relativenumber 
set number

" vim plugin
packadd! dracula_pro
let g:dracula_colorterm = 0
colorscheme dracula_pro_van_helsing
