helpers = require './helpers' -- ultisnips expects this global variable to be defined for some snippets

-- ****************************************************************
-- Simple key remaps

-- keep visual block selected after indent/outdent
helpers.map('v', '<', '<gv')
helpers.map('v', '>', '>gv')

-- erase the highlight on search
helpers.map('n', '<leader><CR>', ':noh<CR>')

-- leave terminal mode with shift+escape
helpers.map('t', '<s-Esc>', '<C-\\><C-n>')

-- generate a GUID with \g
helpers.map('i', '\\g', '<Cmd>lua helpers.guid()<CR>')

-- ****************************************************************
-- LSP maps

local lsp_keys = function(client, buf_set_keymap)
  -- Regular LSP mappings.

  buf_set_keymap('n', '<leader>h', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_set_keymap('n', '<leader>R', '<cmd>lua vim.lsp.buf.rename()<CR>')
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')

  -- Telescope mappings

  buf_set_keymap('n', '<leader>d', '<Cmd>lua telescope_builtins.lsp_definitions{}<CR>')
  buf_set_keymap('n', '<leader>c', '<Cmd>lua telescope_builtins.lsp_incoming_calls{}<CR>')
  buf_set_keymap('n', '<leader>i', '<cmd>lua telescope_builtins.lsp_implementations{}<CR>')
  buf_set_keymap('n', '<leader>t', '<cmd>lua telescope_builtins.lsp_type_definitions{}<CR>')
  buf_set_keymap('n', '<leader>r', '<cmd>lua telescope_builtins.lsp_references{}<CR>')
  buf_set_keymap('n', '<leader>q', '<cmd>lua telescope_builtins.diagnostics{}<CR>')

  buf_set_keymap('n', '<leader>ws', '<cmd>lua telescope_builtins.lsp_dynamic_workspace_symbols{}<CR>')
  buf_set_keymap('n', '<leader>ls', '<cmd>lua telescope_builtins.lsp_document_symbols{}<CR>')

  -- Set some keybinds conditional on server capabilities

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
  end
end

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

-- FTerm bindings
local FTerm = require('FTerm')

--      open terminal with \t
vim.keymap.set('n', '\\t', function()
    FTerm.toggle()
end)
vim.keymap.set('t', '\\t', function()
    FTerm.toggle()
end)

--      open btop or htop with \b
local btop = FTerm:new({
    ft = 'fterm_btop',
    cmd = 'btop || htop'
})
vim.keymap.set('n', '\\b', function()
    btop:toggle()
end)
vim.keymap.set('t', '\\b', function()
    btop:toggle()
end)

--      open terminal with \g
local lazygit = FTerm:new({
    ft = 'fterm_lazygit',
    cmd = 'lazygit'
})
vim.keymap.set('n', '\\g', function()
    lazygit:toggle()
end)
vim.keymap.set('t', '\\g', function()
    lazygit:toggle()
end)

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

return lsp_keys
