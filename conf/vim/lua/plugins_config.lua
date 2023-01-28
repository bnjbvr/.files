-- *************
-- Themes

require('moonlight').set()
--vim.cmd[[colorscheme dracula]]

-- *************
-- File tree
require("nvim-tree").setup()

-- *************
-- Quick search with s{char1}{char2}
require('leap').add_default_mappings()

-- *************
-- Automatically pair opening and closing parens/braces etc
require('nvim-autopairs').setup({
    map_cr = true
})

-- Map shift+enter to autopairs too.
vim.api.nvim_set_keymap(
    'i',
    '<S-CR>',
    'v:lua.MPairs.completion_confirm()',
    { expr = true, noremap = true }
)

-- *************
-- Add indentation line
require('indent_blankline').setup()

-- *************
-- Fidget (displays LSP status in the status line)

require "fidget".setup {}

-- *************
-- Status line
require('lualine').setup()

-- *************
-- Snippets
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = "~/.files/conf/vim/snips/"
})

local function maybe_load_vscode_snippets()
    local Path = require("luasnip.util.path")
    local cur_dir = vim.fn.getcwd()
    local vscode_dir = Path.join(cur_dir, ".vscode")
    local package_json_file = Path.join(vscode_dir, "package.json")
    if Path.exists(package_json_file)
    then
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = vscode_dir
        })
    end
end

maybe_load_vscode_snippets()

-- *************
-- Treesitter

require 'nvim-treesitter.configs'.setup {
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    indent = {
        enable = true,
    },

    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- *************
-- Telescope setup

telescope = require('telescope')

telescope.setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    }
}

telescope.load_extension("ui-select")
telescope.load_extension('luasnip')
telescope.load_extension('fzf')

telescope_builtins = require('telescope.builtin')
