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

set number
set relativenumber

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent

set ignorecase
set smartcase
set hlsearch
set incsearch

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

set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undo

set splitbelow
set splitright
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

" ── FZF — ignorar vendor, node_modules, .git, etc ───────────
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git --exclude vendor --exclude node_modules --exclude public/storage --exclude storage/framework --exclude bootstrap/cache'
else
  let $FZF_DEFAULT_COMMAND = 'find . -type f -not -path "./.git/*" -not -path "./vendor/*" -not -path "./node_modules/*" -not -path "./storage/framework/*" -not -path "./bootstrap/cache/*"'
endif

" Navegación con j/k dentro del popup de FZF
let $FZF_DEFAULT_OPTS = '--bind=ctrl-j:down,ctrl-k:up'

" Sin preview, ventana compacta abajo
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_preview_window = []

" Ripgrep también respeta los mismos filtros
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case
  \       --glob "!vendor" --glob "!node_modules" --glob "!.git"
  \       --glob "!storage/framework" --glob "!bootstrap/cache" -- '.shellescape(<q-args>),
  \   fzf#vim#with_preview({'options': '--no-preview'}), <bang>0)

" ── KEYMAPS ──────────────────────────────────────────────────

" --- Explorador de archivos ---
nnoremap <leader>e :w<CR>:Explore<CR>

" --- Terminal ---
nnoremap <leader>t :botright terminal<CR>
tnoremap <Esc> <C-\><C-n>

" --- Alternar entre últimos 2 archivos ---
nnoremap <leader><Tab> :b#<CR>

" --- Buffers ---
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" --- FZF ---
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>

" --- Buscar en archivo actual ---
nnoremap <leader>fs :BLines<CR>

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

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" --- Diagnósticos (errores/warnings visuales) ---
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nnoremap <leader>d :CocDiagnostics<CR>

" --- Splits ---
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Guardar y salir ---
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" --- Limpiar highlight de búsqueda ---
nnoremap <Esc> :nohlsearch<CR>

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

" ── FIN ──────────────────────────────────────────────────────
