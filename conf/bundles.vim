set nocompatible
filetype off

"Bundle 'scrooloose/syntastic'
"Bundle 'Valloric/YouCompleteMe'
"Bundle 'maxbrunsfeld/vim-yankstack'

call plug#begin(expand('~/.local/share/nvim/bundle'))

" Solarized theme.
Plug 'altercation/vim-colors-solarized'

" Sublime-like multiple cursors.
Plug 'terryma/vim-multiple-cursors'

Plug 'bling/vim-airline'

" Show trailing whitespaces in red.
Plug 'bitc/vim-bad-whitespace'

Plug 'Lokaltog/powerline'

Plug 'kien/ctrlp.vim'

" Add surround operator for text objects.
Plug 'tpope/vim-surround'

" Vertical alignment with Tabularize.
Plug 'godlygeek/tabular'

Plug 'jlfwong/vim-mercenary'

" File explorer.
Plug 'scrooloose/nerdtree'

" Easy comment code blocks in/out.
Plug 'scrooloose/nerdcommenter'

Plug 'rstacruz/sparkup'

Plug 'vim-scripts/TaskList.vim'

Plug 'Townk/vim-autoclose'

Plug 'kien/rainbow_parentheses.vim'

" Syntax highlighting for ES6.
Plug 'isRuslan/vim-es6'

" Syntax highlighting and detection of rust files.
Plug 'rust-lang/rust.vim'

" call vundle#end()
call plug#end()

filetype plugin indent on
