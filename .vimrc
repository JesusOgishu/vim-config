" ============================================================
"  .vimrc — Laravel Dev Config (ligero, servidor-ready)
"  PHP · JS · CSS · HTML · Blade · SQL
"  github.com/TU_USUARIO/vim-laravel-config
" ============================================================

" ── PLUGIN MANAGER (vim-plug) ────────────────────────────────
call plug#begin('~/.vim/plugged')

" --- Colores / UI ---
Plug 'catppuccin/vim', { 'as': 'catppuccin' }   " mismo tema que tu nvim
Plug 'itchyny/lightline.vim'                     " statusline ligera

" --- Syntax highlight ---
Plug 'sheerun/vim-polyglot'                      " PHP, JS, CSS, HTML, SQL…
Plug 'jwalton512/vim-blade'                      " Blade templates
Plug 'nelsyeung/twig.vim'                        " Twig (bonus)

" --- Autocompletado LSP-like ---
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " el más potente en Vim

" --- Navegación de archivos ---
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'                    " íconos en NERDTree

" --- Fuzzy finder ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" --- Git ---
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" --- Utilidades Laravel / PHP ---
Plug 'tpope/vim-commentary'                      " comentar con gcc
Plug 'jiangmiao/auto-pairs'                      " cierre automático de brackets
Plug 'tpope/vim-surround'                        " cambiar comillas/brackets
Plug 'mattn/emmet-vim'                           " Emmet para HTML/Blade

call plug#end()

" ── OPCIONES BASE ────────────────────────────────────────────
set nocompatible
set encoding=utf-8
set fileencoding=utf-8

" Números de línea
set number
set relativenumber

" Indentación (PSR-4 / Laravel: 4 espacios)
set tabstop=4
set shiftwidth=4
set softtabstop=4
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

" Sin archivos de swap en el proyecto
set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undo

" Dividir ventanas de forma natural
set splitbelow
set splitright

" Clipboard (si el servidor tiene xclip/xsel o tmux)
set clipboard=unnamed

" ── COLORES ──────────────────────────────────────────────────
syntax on
set termguicolors
set background=dark
colorscheme catppuccin_mocha          " igual que tu nvim (o prueba catppuccin_latte)

" Lightline con catppuccin
let g:lightline = { 'colorscheme': 'catppuccin_mocha' }
set laststatus=2
set noshowmode                         " lightline ya muestra el modo

" ── LEADER ───────────────────────────────────────────────────
let mapleader = " "

" ── KEYMAPS ──────────────────────────────────────────────────

" --- NERDTree ---
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>o :NERDTreeFind<CR>

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

" --- Splits / navegación ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Buffers ---
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" --- Guardar rápido ---
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

" ── COC — EXTENSIONES PARA LARAVEL ───────────────────────────
" Instala con :CocInstall después de abrir Vim:
"
"   :CocInstall coc-intelephense   ← PHP (el mejor para Laravel)
"   :CocInstall coc-tsserver       ← JS / TypeScript
"   :CocInstall coc-css            ← CSS / SCSS
"   :CocInstall coc-html           ← HTML
"   :CocInstall coc-json           ← JSON (package.json, composer.json)
"   :CocInstall coc-sql            ← SQL
"
" ── COC — SETTINGS (equivalente a coc-settings.json) ────────
let g:coc_global_extensions = [
  \ 'coc-intelephense',
  \ 'coc-tsserver',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-sql'
  \ ]

" ── FILETYPES ESPECIALES ─────────────────────────────────────
" Blade → PHP + Blade
autocmd BufRead,BufNewFile *.blade.php set filetype=blade

" SQL: indentación de 2 espacios (opcional)
autocmd FileType sql setlocal tabstop=2 shiftwidth=2

" ── NERDTREE ─────────────────────────────────────────────────
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', 'node_modules', 'vendor', '\.DS_Store']
" Cierra NERDTree si es la última ventana
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
  \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ── GITGUTTER ────────────────────────────────────────────────
let g:gitgutter_enabled = 1
let g:gitgutter_sign_added    = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed  = '▎'

" ── FIN ──────────────────────────────────────────────────────
