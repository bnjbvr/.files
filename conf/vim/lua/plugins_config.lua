-- *************
-- Themes

require('moonlight').set()
--vim.cmd[[colorscheme dracula]]

-- *************
-- Fidget (displays LSP status in the status line)

require"fidget".setup{}

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

-- press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
--helpers.map('i', '')
--imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
--" -1 for jumping backwards.
--inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
--snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
--snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

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