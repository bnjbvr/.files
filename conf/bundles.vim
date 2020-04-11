set nocompatible
filetype off

call plug#begin(expand('~/.local/share/nvim/bundle'))

" *****************************************************************************
" Interface *******************************************************************
" *****************************************************************************

" Solarized theme.
Plug 'altercation/vim-colors-solarized'

" Better status line.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File explorer.
Plug 'scrooloose/nerdtree'

" Multi-selection UI
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }

" *****************************************************************************
" Behavior ********************************************************************
" *****************************************************************************

" Sublime-like multiple cursors.
Plug 'terryma/vim-multiple-cursors'

" Add surround operator for text objects.
Plug 'tpope/vim-surround'

" Vertical alignment with Tabularize.
Plug 'godlygeek/tabular'

" Mercurial information from within vim.
Plug 'jlfwong/vim-mercenary'

" Git information from within vim.
Plug 'tpope/vim-fugitive'

" Easy comment code blocks in/out.
Plug 'scrooloose/nerdcommenter'

" Automatically inserts closing chars for pairs of open/close chars (e.g. parens).
Plug 'Raimondi/delimitMate'

" Emacs yank schemes
Plug 'maxbrunsfeld/vim-yankstack'

" Snippets engine (requires Python support).
Plug 'SirVer/ultisnips'

" *****************************************************************************
" Language specific ***********************************************************
" *****************************************************************************

" Cranelift IR.
Plug 'CraneStation/cranelift.vim'

" HTML expander with <C-E>.
Plug 'rstacruz/sparkup'

" Syntax highlighting for Vue.
Plug 'posva/vim-vue'

" Syntax highlighting for TypeScript.
Plug 'leafgarland/typescript-vim'

" Syntax highlighting and detection of rust files.
Plug 'rust-lang/rust.vim'

" LangServer protocol.
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
\ }

" Showing function signature and inline doc
Plug 'Shougo/echodoc.vim'

" call vundle#end()
call plug#end()

filetype plugin indent on
