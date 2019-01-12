set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set spelllang=en_us
set encoding=utf-8 nobomb
set shortmess=a

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
Plug 'vim-syntastic/syntastic'
Plug 'Chiel92/vim-autoformat', { 'on': 'Autoformat' }

call plug#end()

" NERDTree Settings

map <C-n> :NERDTreeToggle<CR>

" FZF Settings

map <C-p> :FZF<CR>

" Lightline Settings

let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ }

" Syntastic Settings

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1 
let g:syntastic_auto_loc_list = 1 
let g:syntastic_check_on_open = 1 
let g:syntastic_check_on_wq = 0 

" Autoformat Settings

au BufWrite *.c,*.cpp,*.h :Autoformat

" C/C++ Settings

let g:syntastic_cpp_checkers = ['cpplint']
let g:formatdef_clang_format = '"clang-format -sort-includes=false"'
let g:formatters_cpp = ['clang_format']
