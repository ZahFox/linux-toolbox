set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set spelllang=en_us
set encoding=utf-8 nobomb

set history=999
set undolevels=999
set autoread

set esckeys
set nostartofline
set backspace=indent,eol,start

set nobackup
set nowritebackup
set noswapfile

syntax enable

if (has("termguicolors"))
  set termguicolors
endif

colorscheme OceanicNext

set number

set splitbelow
set splitright
set autoindent smartindent
set copyindent
set softtabstop=2
set tabstop=2
set shiftwidth=2
set smarttab

" Tab Shortcuts

map <C-Left> :tabp<cr>
map <C-Right> :tabn<cr>

" Window Shortcuts

map <M-Left> :vsplit<cr>
map <M-Right> :vsplit<cr>
map <M-Up> :split<cr>
map <M-Down> :split<cr>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Plugin Management (Vim Plug)

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug '/usr/bin/fzf'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" NERDTree Settings

map <C-n> :NERDTreeToggle<CR>

" FZF Settings

map <C-p> :FZF<CR>

" Lightline Settings

let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ }
