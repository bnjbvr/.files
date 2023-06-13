helpers = require './helpers'

-- ****************************************************************
-- Simple key remaps

-- keep visual block selected after indent/outdent
helpers.map('v', '<', '<gv')
helpers.map('v', '>', '>gv')

-- erase the highlight on search
helpers.map('n', '<leader><CR>', ':noh<CR>')

--- file tree!
helpers.map('n', '<leader>n', '<Cmd>:NvimTreeFindFile<CR>')

-- leave terminal mode with shift+escape
helpers.map('t', '<s-Esc>', '<C-\\><C-n>')

-- generate a GUID with \g
helpers.map('i', '\\g', '<Cmd>lua helpers.guid()<CR>')

-- open a new vsplit with space-v
helpers.map('n', '<leader>v', '<Cmd>:vsplit<CR>')

-- ****************************************************************
-- LSP maps

local lsp_keys = function(client, buf_set_keymap)
    buf_set_keymap('n', '<leader>k', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')

    buf_set_keymap('n', 'gd', '<Cmd>lua telescope_builtins.lsp_definitions{}<CR>')
    buf_set_keymap('n', 'g]d', '<Cmd>vsplit<CR><Cmd>lua telescope_builtins.lsp_definitions{}<CR>')
    buf_set_keymap('n', 'g[d', '<Cmd>split<CR><Cmd>lua telescope_builtins.lsp_definitions{}<CR>')

    buf_set_keymap('n', 'gi', '<cmd>lua telescope_builtins.lsp_implementations{}<CR>')
    buf_set_keymap('n', 'gr', '<cmd>lua telescope_builtins.lsp_references{}<CR>')
    buf_set_keymap('n', '<leader>d', '<cmd>lua telescope_builtins.diagnostics{}<CR>')

    buf_set_keymap('n', 'gy', '<cmd>lua telescope_builtins.lsp_type_definitions{}<CR>')
    buf_set_keymap('n', 'g]y', '<Cmd>vsplit<CR><Cmd>lua telescope_builtins.lsp_type_definitions{}<CR>')
    buf_set_keymap('n', 'g[y', '<Cmd>split<CR><Cmd>lua telescope_builtins.lsp_type_definitions{}<CR>')

    buf_set_keymap('n', 'gc', '<Cmd>lua telescope_builtins.lsp_incoming_calls{}<CR>')

    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>')

    buf_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>")
    buf_set_keymap('n', '<leader>W', '<cmd>lua telescope_builtins.lsp_dynamic_workspace_symbols{}<CR>')
    buf_set_keymap('n', '<leader>S', '<cmd>lua telescope_builtins.lsp_document_symbols{}<CR>')
end

-- ****************************************************************
-- Plugins

-- Move in the yank stack
vim.g.yankstack_yank_keys = { 'c', 'd', 'x', 'y' }
vim.keymap.set('n', '<leader>P', '<Plug>yankstack_substitute_newer_paste')
vim.keymap.set('n', '<leader>p', '<Plug>yankstack_substitute_older_paste')

-- Telescope
helpers.map('n', '<leader>s', '<Cmd>lua telescope.extensions.luasnip.luasnip{}<CR>')
helpers.map('n', '<leader>b', '<Cmd>lua telescope_builtins.buffers{}<CR>')
helpers.map('n', '<leader>f', '<Cmd>lua telescope_builtins.find_files{}<CR>')
helpers.map('n', '<leader>g', '<Cmd>lua telescope_builtins.live_grep{}<CR>')

-- Extra rust actions!
helpers.map('n', '<leader>o', '<Cmd>:RustRunnables<CR>')

-- FTerm bindings
local FTerm = require('FTerm')
FTerm.setup({
    border = 'double',
    blend = 30,
    dimensions = {
        height = 0.9,
        width = 0.9,
    }
})

-- > open terminal with \t
vim.keymap.set('n', '\\t', function()
    FTerm.toggle()
end)
vim.keymap.set('t', '\\t', function()
    FTerm.toggle()
end)

-- > moar bindings
local fterms = {
    ['\\b'] = {
        ft = 'fterm_btop',
        cmd = 'btm || btop || htop || top'
    },
    ['\\g'] = {
        ft = "fterm_lazygit",
        cmd = "lazygit"
    },
    ['\\s'] = {
        ft = "fterm_ncspot",
        cmd = "ncspot"
    }
}

local function set_up_fterm(map)
    for k, v in pairs(map) do
        local term = FTerm:new({
            ft = v.ft,
            cmd = v.cmd,
            border = 'double',
            blend = 30,
            dimensions = {
                height = 0.9,
                width = 0.9
            }
        })
        local function toggle()
            term:toggle()
        end

        vim.keymap.set('n', k, toggle)
        vim.keymap.set('t', k, toggle)
    end
end

set_up_fterm(fterms)

return lsp_keys
