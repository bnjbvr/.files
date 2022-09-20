-- *************
-- Themes

require('moonlight').set()
--vim.cmd[[colorscheme dracula]]

-- *************
-- Fidget (displays LSP status in the status line)

require"fidget".setup{}

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
telescope.load_extension("ultisnips")
telescope.load_extension('fzf')

telescope_builtins = require('telescope.builtin')
