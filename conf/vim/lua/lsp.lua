local nvim_lsp = require('lspconfig')
local lsp_keys = require('./keys')

-- *************
-- LSP handler.

local lsp_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local keymap_opts = { noremap=true, silent=true }

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  lsp_keys(client, function(mode, from, to)
      buf_set_keymap(mode, from, to, keymap_opts)
  end)

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
nvim_lsp.tsserver.setup { on_attach = lsp_on_attach }

-- Svelte??
--nvim_lsp.svelte.setup { on_attach = lsp_on_attach }

-- Lua
--nvim_lsp.sumneko_lua.setup { on_attach = lsp_on_attach }

-- Rust LSP + tools
require('rust-tools').setup({
    server = {
        on_attach = function(client, bufnr) 
            lsp_on_attach(client, bufnr)
        end,

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
        },
    },
})
