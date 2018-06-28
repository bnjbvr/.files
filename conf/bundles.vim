set nocompatible
filetype off

"Bundle 'scrooloose/syntastic'
"Bundle 'Valloric/YouCompleteMe'

call plug#begin(expand('~/.local/share/nvim/bundle'))

" *****************************************************************************
" Interface *******************************************************************
" *****************************************************************************

" Solarized theme.
Plug 'altercation/vim-colors-solarized'

" Better status line.
Plug 'bling/vim-airline'

" Show trailing whitespaces in red.
Plug 'bitc/vim-bad-whitespace'

" File explorer.
Plug 'scrooloose/nerdtree'

" Creates a list of TODO/FIXME/etc.
Plug 'vim-scripts/TaskList.vim'

" Multi-selection UI
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

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

" Easy comment code blocks in/out.
Plug 'scrooloose/nerdcommenter'

" Automatically inserts closing chars for pairs of open/close chars (e.g. parens).
Plug 'Townk/vim-autoclose'

" Colors pairs of matching parentheses.
Plug 'kien/rainbow_parentheses.vim'

" Emacs yank schemes
Plug 'maxbrunsfeld/vim-yankstack'

" *****************************************************************************
" Language specific ***********************************************************
" *****************************************************************************

" HTML expander with <C-E>.
Plug 'rstacruz/sparkup'

" Syntax highlighting for ES6.
Plug 'isRuslan/vim-es6'

" Syntax highlighting for Vue.
Plug 'posva/vim-vue'

" Syntax highlighting for TypeScript.
Plug 'leafgarland/typescript-vim'

" Syntax highlighting and detection of rust files.
Plug 'rust-lang/rust.vim'

" LangServer protocol.
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

" Integration with deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Showing function signature and inline doc
Plug 'Shougo/echodoc.vim'

" call vundle#end()
call plug#end()

filetype plugin indent on
