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

    buf_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)

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

expand_macro = function()
    vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro", vim.lsp.util.make_position_params(), function(result)
        -- Create a new tab
        vim.cmd("vsplit")

        -- Create an empty scratch buffer (non-listed, non-file i.e scratch)
        local buf = vim.api.nvim_create_buf(false, true)

        -- and set it to the current window
        vim.api.nvim_win_set_buf(0, buf)

        if result then
            -- set the filetype to rust so that rust's syntax highlighting works
            vim.api.nvim_set_option_value("filetype", "rust", { buf = 0 })

            -- Insert the result into the new buffer.
            for client_id, res in pairs(result) do
                if res and res.result and res.result.expansion then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.result.expansion, "\n"))
                end
            end
        else
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
                "Error: No result returned."
            })
        end
    end)
end

-- *************
-- Basic configuration of LSP servers.

-- LSP for Rust
local rust_analyzer_settings = {
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

-- If the current machine is the work machine, add a configuration to use rustfmt nightly, for
-- better compatibility with work on the Matrix Rust SDK.
local status, result = pcall(function() return vim.fn.system("hostnamectl --static") end)
if status then
    result = vim.trim(result)
    if result == 'archlinux' then
        rust_analyzer_settings.rustfmt = {}
        rust_analyzer_settings.rustfmt.extraArgs = { "+nightly-2025-02-20" }
    end
else
    vim.notify("Error getting hostname: " .. result, vim.log.levels.ERROR)
end

vim.lsp.config.rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    settings = {
        ["rust-analyzer"] = rust_analyzer_settings
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

-- LSP for Python
vim.lsp.config.pylsp = {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { ".git", ".pylintrc", "setup.py", "setup.cfg", "pyproject.toml" },
}
vim.lsp.enable('pylsp')

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
