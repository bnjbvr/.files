helpers = require './helpers' -- ultisnips expects this global variable to be defined for some snippets

helpers.map('n', '<leader>s', '<Cmd>lua telescope.extensions.luasnip.luasnip{}<CR>')
helpers.map('n', '<leader>b', '<Cmd>lua telescope_builtins.buffers{}<CR>')
helpers.map('n', '<leader>gf', '<Cmd>lua telescope_builtins.find_files{}<CR>')
helpers.map('n', '<leader>gg', '<Cmd>lua telescope_builtins.live_grep{}<CR>')

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
