math.randomseed(os.time())

require './plugins'
require './lsp'
require './autocmd'

-- *************
-- Regular settings

vim.opt.encoding = 'utf-8'
vim.opt.guifont = "Fira Code NerdFont 14"
vim.opt.textwidth = 99 -- welcome to the future

vim.opt.wrap = true -- auto wrap line view, but not text itself
vim.opt.softtabstop = 4 -- tab width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4  -- indent width
vim.opt.expandtab = true

vim.opt.colorcolumn = '100' -- highlight the 100th column
vim.opt.cursorline = true -- highlight the current line
vim.opt.cursorcolumn = true -- highlight the current column too

vim.opt.ignorecase = true -- case-insentive search by default
vim.opt.smartcase = true -- search case-sensitive if there is an upper-case letter
vim.opt.gdefault = true -- when replacing, use /g by default
vim.opt.showmatch = true -- paren match highlighting
vim.opt.hlsearch = true -- highlight what you search for
vim.opt.incsearch = true -- type-ahead-find
vim.opt.wildmenu = true -- command-line completion shows a list of matches
vim.opt.wildmode = 'longest,list:longest,full' -- bash-vim completion behavior
vim.opt.autochdir = true -- use current working directory of a file as base path
vim.opt.icm = 'split' -- show preview of search/replace
vim.opt.nu = true -- show line numbers
vim.opt.showmode = true -- show the current mode on the last line
vim.opt.showcmd = true -- show informations about selection while in visual mode
vim.opt.ruler = true
vim.opt.backspace = 'indent,eol,start' -- magic for backspace/delete issues in term mode
vim.opt.splitbelow = true -- new splits placed below...
vim.opt.splitright = true -- ...new vsplits placed right.
vim.opt.scrolloff = 5 -- always keep lines around the cursor
vim.opt.signcolumn = 'yes' -- always draw the sign column
vim.opt.listchars = 'trail:·,nbsp:·,tab:▸ ,extends:»,precedes:«,' -- print tabs with special char + trailing chars
vim.opt.list = true
vim.opt.laststatus = 2 -- always show the statusline, even where there is only one file edited
vim.opt.ofu = "syntaxcomplete#Complete"

-- all operations such as yy, D, and P work with the clipboard.
-- No need to prefix them with "* or "+
vim.opt.clipboard = 'unnamed'

vim.g.mapleader = ' '

require './plugins_config'
require './keys'
