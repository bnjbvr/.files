helpers = require './helpers' -- ultisnips expects this global variable to be defined for some snippets

-- ****************************************************************
-- Simple key remaps

-- keep visual block selected after indent/outdent
helpers.map('v', '<', '<gv')
helpers.map('v', '>', '>gv')

-- erase the highlight on search
helpers.map('n', '<leader><CR>', ':noh<CR>')

-- leave terminal mode with escape
helpers.map('t', '<Esc>', '<C-\\><C-n>')

-- ****************************************************************
-- Plugins

-- Move in the yank stack
vim.keymap.set('n', '<leader>P', '<Plug>yankstack_substitute_newer_paste')
vim.keymap.set('n', '<leader>p', '<Plug>yankstack_substitute_older_paste')

-- Telescope
helpers.map('n', '<leader>s', '<Cmd>lua telescope.extensions.luasnip.luasnip{}<CR>')
helpers.map('n', '<leader>b', '<Cmd>lua telescope_builtins.buffers{}<CR>')
helpers.map('n', '<leader>gf', '<Cmd>lua telescope_builtins.find_files{}<CR>')
helpers.map('n', '<leader>gg', '<Cmd>lua telescope_builtins.live_grep{}<CR>')

-- Extra rust actions!
helpers.map('n', '<leader>o', '<Cmd>:RustRunnables<CR>')

-- ****************************************************************
-- Better tab sequence that expands lua snippets or inserts tab

local luasnip = require 'luasnip'
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function helpers.tab()
    if luasnip.expand_or_jumpable()
    then
        luasnip.expand_or_jump()
    else
        vim.fn.feedkeys(t("<tab>"), "n")
    end
end

helpers.map('i', '<tab>', '<Cmd>lua helpers.tab()<CR>')
helpers.map('i', '<s-tab>', '<Cmd>lua require(\'luasnip\').jump(-1)<CR>')
