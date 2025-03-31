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
end

-- Autoformat on save
local autoformat_on_save = function(client, bufnr)
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
-- Basic configuration of LSP servers.

-- LSP for Rust
vim.lsp.config.rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = {
            inlayHints = {
                enable = true,
                maxLength = 100
            },
            cargo = {
                autoreload = true,
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    },
    -- Do not include `Cargo.toml` here, otherwise this will badly break in workspaces.
    root_markers = { ".git", ".rustfmt" },
}
vim.lsp.enable('rust_analyzer')

-- LSP for lua
vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { '.luarc.json', '.luarc.jsonc' },
}
vim.lsp.enable('lua_ls')

-- LSP for TypeScript
vim.lsp.config.ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
}
vim.lsp.enable('ts_ls')

-- General LSP configuration.
vim.diagnostic.config({
    virtual_text = true,
    --virtual_lines = true, -- a bit too invasive
})

vim.lsp.inlay_hint.enable()

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        lsp_on_attach(client, args.buf)
        autoformat_on_save(client, args.buf)

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})
