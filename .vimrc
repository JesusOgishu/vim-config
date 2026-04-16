" ============================================================
"  .vimrc — Laravel Dev Config (ligero, servidor-ready)
"  PHP · JS · CSS · HTML · Blade · SQL
" ============================================================

" ── PLUGIN MANAGER (vim-plug) ────────────────────────────────
call plug#begin('~/.vim/plugged')

" --- Colores / UI ---
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'

" --- Syntax highlight ---
Plug 'sheerun/vim-polyglot'
Plug 'jwalton512/vim-blade'
Plug 'nelsyeung/twig.vim'

" --- Autocompletado LSP-like ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" --- Fuzzy finder ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" --- Git ---
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" --- Utilidades Laravel / PHP ---
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'

call plug#end()

" ── OPCIONES BASE ────────────────────────────────────────────
set nocompatible
set encoding=utf-8
set fileencoding=utf-8

" Números de línea
set number
set relativenumber

" Indentación
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent

" Búsqueda
set ignorecase
set smartcase
set hlsearch
set incsearch

" UI
set cursorline
set showmatch
set scrolloff=8
set sidescrolloff=8
set wrap
set linebreak
set showcmd
set wildmenu
set wildmode=longest:full,full

" Performance servidor
set lazyredraw
set updatetime=300
set ttimeoutlen=10

" Sin archivos de swap
set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undo

" Dividir ventanas de forma natural
set splitbelow
set splitright

" Clipboard
set clipboard=unnamed

" ── COLORES ──────────────────────────────────────────────────
syntax on
set termguicolors
set background=dark
colorscheme catppuccin_mocha

let g:lightline = { 'colorscheme': 'catppuccin_mocha' }
set laststatus=2
set noshowmode

" ── LEADER ───────────────────────────────────────────────────
let mapleader = " "

" ── KEYMAPS ──────────────────────────────────────────────────

" --- Explorador de archivos (netrw estilo :Ex) ---
" Leader e → guarda, cierra el archivo actual y abre netrw
nnoremap <leader>e :w<CR>:Explore<CR>

" --- Terminal dentro de Vim ---
" Leader t → abre terminal abajo
nnoremap <leader>t :botright terminal<CR>
" Salir del modo insert de la terminal con Esc
tnoremap <Esc> <C-\><C-n>

" --- Alternar entre los últimos 2 archivos ---
" Leader Tab → salta al buffer anterior
nnoremap <leader><Tab> :b#<CR>

" --- Buffers ---
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bl :buffers<CR>

" --- FZF ---
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>

" --- CoC (autocompletado / LSP) ---
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> K  :call ShowDocumentation()<CR>
nmap <leader>rn  <Plug>(coc-rename)
nmap <leader>f   :CocCommand editor.action.formatDocument<CR>
nmap <leader>ca  <Plug>(coc-codeaction-cursor)

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Diagnósticos
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <leader>d :CocDiagnostics<CR>

" --- Splits / navegación entre ventanas ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Guardar y salir ---
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" --- Limpiar highlight de búsqueda ---
nnoremap <Esc> :nohlsearch<CR>

" --- Git (fugitive) ---
nnoremap <leader>gs :Git status<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log --oneline<CR>

" --- Emmet (solo en HTML/Blade) ---
let g:user_emmet_leader_key = '<C-z>'
let g:user_emmet_install_global = 0
autocmd FileType html,blade,php EmmetInstall

" ── COC — EXTENSIONES ────────────────────────────────────────
let g:coc_global_extensions = [
  \ 'coc-phpls',
  \ 'coc-tsserver',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-sql'
  \ ]

" ── FILETYPES ESPECIALES ─────────────────────────────────────
autocmd BufRead,BufNewFile *.blade.php set filetype=blade
autocmd FileType sql setlocal tabstop=2 shiftwidth=2

" ── GITGUTTER ────────────────────────────────────────────────
let g:gitgutter_enabled = 1
let g:gitgutter_sign_added    = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed  = '▎'

" ── FIN ──────────────────────────────────────────────────────
