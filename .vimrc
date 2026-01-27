" Basic settings
set nocompatible              " Use Vim settings, not Vi
filetype plugin indent on     " Enable file type detection
syntax enable                 " Enable syntax highlighting

" Display settings
set number                    " Show line numbers
set ruler                     " Show cursor position
set showcmd                   " Show incomplete commands
set showmode                  " Show current mode
set wildmenu                  " Enhanced command-line completion
set cursorline                " Highlight current line

" Search settings
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case-insensitive search
set smartcase                 " Case-sensitive if uppercase present

" Indentation settings
set autoindent                " Copy indent from current line
set smartindent               " Smart autoindenting
set expandtab                 " Use spaces instead of tabs
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set softtabstop=4             " Backspace removes 4 spaces

" Performance settings
set lazyredraw                " Don't redraw during macros
set ttyfast                   " Fast terminal connection

" Behavior settings
set backspace=indent,eol,start " Allow backspace over everything
set hidden                    " Allow hidden buffers
set autoread                  " Auto-reload changed files
set mouse=a                   " Enable mouse support

" Backup settings
set nobackup                  " No backup files
set nowritebackup             " No backup before overwrite
set noswapfile                " No swap files

" Encoding
set encoding=utf-8            " Default encoding

" Color scheme
colorscheme default
set background=dark

" Key mappings
" Leader key
let mapleader = ","

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" File type specific settings
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
