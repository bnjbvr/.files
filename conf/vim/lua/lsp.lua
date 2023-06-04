local lsp_keys = require('./keys')

-- *************
-- LSP handler.

local lsp_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local keymap_opts = { noremap = true, silent = true }

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

    -- Autoformat on save
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr }),
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end
end

-- *************
-- Auto install LSP language servers
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = { "rust_analyzer" }
})

require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup { on_attach = lsp_on_attach }
    end,

    ["rust_analyzer"] = function()
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
                            autoreload = false,
                            loadOutDirsFromCheck = true
                        },
                        procMacro = {
                            enable = true
                        },
                    }
                },
            },
        })
    end
}
