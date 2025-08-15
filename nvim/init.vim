set number
" set relativenumber
syntax on
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Enable mouse support
set mouse=a

" Enable line wrapping
set nowrap

" Set clipboard to use system clipboard
set clipboard=unnamedplus

set cursorline

set encoding=utf-8

set termguicolors

call plug#begin('~/.local/share/nvim/plugged')

" List of plugins
" Tema
Plug 'ericbn/vim-solarized'
" Otros
" File explorer
Plug 'preservim/nerdtree'
" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Better syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" LSP configurations
Plug 'neovim/nvim-lspconfig'
" Autocompletion
Plug 'hrsh7th/nvim-compe'
" Pre visualizar modificacion en bloque
" Plug 'mg979/vim-visual-multi'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

syntax enable
set background=dark
colorscheme solarized

let mapleader = " "

" Split vertical
nnoremap <leader>vs :vsp<CR>

