local nvim_lsp = require('lspconfig')

-- *************
-- LSP handler.
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local keymap_opts = { noremap=true, silent=true }

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Regular LSP mappings.

  buf_set_keymap('n', '<leader>h', '<Cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>R', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', keymap_opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', keymap_opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', keymap_opts)

  -- Telescope mappings

  buf_set_keymap('n', '<leader>d', '<Cmd>lua telescope_builtins.lsp_definitions{}<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>c', '<Cmd>lua telescope_builtins.lsp_incoming_calls{}<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>i', '<cmd>lua telescope_builtins.lsp_implementations{}<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>t', '<cmd>lua telescope_builtins.lsp_type_definitions{}<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>r', '<cmd>lua telescope_builtins.lsp_references{}<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua telescope_builtins.diagnostics{}<CR>', keymap_opts)

  buf_set_keymap('n', '<leader>ws', '<cmd>lua telescope_builtins.lsp_dynamic_workspace_symbols{}<CR>', keymap_opts)
  buf_set_keymap('n', '<leader>ls', '<cmd>lua telescope_builtins.lsp_document_symbols{}<CR>', keymap_opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", keymap_opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", keymap_opts)
  end

  -- diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      signs = true,
      update_in_insert = true,
    }
  )
end

-- TypeScript
nvim_lsp.tsserver.setup { on_attach = on_attach }

-- Svelte??
--nvim_lsp.svelte.setup { on_attach = on_attach }

-- Lua
--nvim_lsp.sumneko_lua.setup { on_attach = on_attach }

-- Another one bites the Rust
nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    init_options = {
        codeLenses = {
            test = true
        }
    },
    settings = {
        ["rust-analyzer"] = {
            inlayHints = {
                enable = true,
                maxLength = 100
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            }
        }
    }
}
