set nocompatible    " do not try to be vi-compatible

set guifont=Inconsolata\ 11

set textwidth=79
set wrap            " auto wrap line view, but not text itself

filetype indent on  " activates indenting for files
set softtabstop=4   " width of a tab
set tabstop=4
set shiftwidth=4    " width of the indentation
set expandtab

set ignorecase      " case-insentive search by default
set smartcase       " search case-sensitive if there is an upper-case letter
set gdefault        " when replacing, use /g by default
set showmatch       " paren match highlighting
set hlsearch        " highlight what you search for
set incsearch       " type-ahead-find
set wildmenu        " command-line completion shows a list of matches
set wildmode=longest,list:longest,full " Bash-vim completion behavior
set autochdir       " use current working directory of a file as base path

set encoding=utf-8

set nu              " show line numbers
set showmode        " show the current mode on the last line
set showcmd         " show informations about selection while in visual mode

set guioptions-=T   "remove toolbar

set colorcolumn=80,100  " highligth the 80th and 120th column

"set cursorline " highlight current line

" all operations such as yy, D, and P work with the clipboard.
" No need to prefix them with "* or "+
set clipboard=unnamed

" New split placed below
set splitbelow
" New vsplit placed right
set splitright

" set foldmethod=syntax " makes vim horribly slow, with syntax coloring
set foldlevelstart=20 " buffer are always loaded with opened folds

" always keep lines around the cursor
set scrolloff=5

" Yank the line, comment it, paste it
nnoremap yp yygccp

" When jumping to a given line, center the screen
nnoremap G Gzz

" activate rainbow parenthesis
" nnoremap <leader>R :RainbowParenthesesToggle<CR>

" activate gundo
" nnoremap <leader>u :GundoToggle<CR>

" print tabs with a special character (add ",eol:·" for end of lines)
set listchars=trail:·,nbsp:·,tab:▸\ ,extends:»,precedes:«,
set list

set laststatus=2    " always show the statusline, even when there is only one file edited

" move the current line up or down with the Ctrl-arrow keys
nmap <C-Down> :<C-u>move .+1<CR>
nmap <C-Up>   :<C-u>move .-2<CR>
imap <C-Down> <C-o>:<C-u>move .+1<CR>
imap <C-Up>   <C-o>:<C-u>move .-2<CR>
vmap <C-Down> :move '>+1<CR>gv
vmap <C-Up> :move '<-2<CR>gv

filetype plugin on
set ofu=syntaxcomplete#Complete

" autocomplétion with <TAB> instead of <C-n>, depending on the context
"   function! Smart_TabComplete()
"     let line = getline('.')                         " curline
"     let substr = strpart(line, -1, col('.')+1)      " from start to cursor
"     let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
"     if (strlen(substr)==0)                          " nothing to match on empty string
"       return "\<tab>"
"     endif
"     let has_period = match(substr, '\.') != -1      " position of period, if any
"     let has_slash = match(substr, '\/') != -1       " position of slash, if any
"     if (!has_period && !has_slash)
"       return "\<C-X>\<C-P>"                         " existing text matching
"     elseif ( has_slash )
"       return "\<C-X>\<C-F>"                         " file matching
"     else
"       return "\<C-X>\<C-O>"                         " plugin matching
"     endif
"   endfunction

" inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
"function! AppendModeline()
"  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
"        \ &tabstop, &shiftwidth, &textwidth)
"  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
"  call append(line("$"), l:modeline)
"endfunction
"nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" search the file for FIXME, TODO and put them in a handy list
" map <F10> <Plug>TaskList

" side pane of class and functions
"map <F11> :TlistToggle<cr>
"nmap <F11> :TagbarToggle<CR>
"nnoremap <leader>b :TagbarToggle<CR>

" side pane of files
"map <F12> :NERDTreeToggle<cr>
"nnoremap <leader>t :NERDTreeToggle<cr>

" configure tags - add additional tags here or comment out not-used ones
"set tags+=~/.vim/tags/cpp
"set tags+=~/.vim/tags/bmdd
"set tags+=~/.vim/tags/bmddsolver
"set tags+=~/.vim/tags/dae
"set tags+=~/.vim/tags/eodev
" build tags of your own project with CTRL+F12
"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" OmniCppComplete
"let OmniCpp_NamespaceSearch = 1
"let OmniCpp_GlobalScopeSearch = 1
"let OmniCpp_ShowAccess = 1
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
"let OmniCpp_MayCompleteDot = 1 " autocomplete after .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
"let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

" close the buffer without deleting its window
":runtime plugins/bclose.vim
"nmap :bc <Plug>Kwbd

"ctags
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
set tags=./tags;/

source ~/.bundles.vim

" config da detectindent
"let g:detectindent_preferred_expandtab = 1
"let g:detectindent_preferred_indent = 4
"autocmd BufNewFile,BufReadPost * :DetectIndent
"autocmd FileType make setlocal noexpandtab

" config da Tagbar
"nmap <F8> :TagbarToggle<CR>
"let g:tagbar_autofocus = 1

" config de CoffeeCompile
"nmap <F9> :CoffeeCompile watch vert<CR>

" older regexp engine, makes vim faster?
syntax on             " syntax coloring by default
set re=1

" In case syntax coloring is slow, deactivate the next three options
" set nocursorcolumn
" set nocursorline
" syntax sync minlines=256

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Activate CtrlP with leader
noremap <leader>p :CtrlP<CR>

" Solarized
set background=dark
set rtp+=~/.vim/bundle/vim-colors-solarized/
if has('gui_running')
    colorscheme solarized
endif

set ruler

