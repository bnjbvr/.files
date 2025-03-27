local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself!
    use 'wbthomason/packer.nvim'

    -- ********************************************************************************************
    -- Interface

    -- Fancy themes!
    use 'shaunsingh/moonlight.nvim'
    --use 'Mofiqul/dracula.nvim'
    --use 'catppuccin/nvim'

    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.cmd [[colorscheme tokyonight-night]]
        end
    }

    -- Better status line.
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end
    }

    -- Fuzzy finder and nice windows
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            -- Must be global.
            telescope = require('telescope')
            local trouble = require("trouble.sources.telescope")

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
                },

                defaults = {
                    mappings = {
                        i = { ["<c-t>"] = trouble.open },
                        n = { ["<c-t>"] = trouble.open },
                    },
                },
            }

            telescope.load_extension("ui-select")
            telescope.load_extension('luasnip')
            telescope.load_extension('fzf')

            -- Must be global.
            telescope_builtins = require('telescope.builtin')
        end
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
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
        end
    }

    --- Use telescope for e.g. code actions
    use 'nvim-telescope/telescope-ui-select.nvim'

    --- Use a C clone of fzf for fuzzy search in telescope! (assume preinstalled)
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    --- Show LSP status above the status line
    use { 'j-hui/fidget.nvim',
        config = function()
            require "fidget".setup {}
        end
    }

    --- Floating terminal windows!
    use "numToStr/FTerm.nvim"

    --- File tree!
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            local HEIGHT_RATIO = 0.8
            local WIDTH_RATIO = 0.5

            -- From nvim-tree recipes https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#center-a-floating-nvim-tree-window
            require('nvim-tree').setup({
                view = {
                    float = {
                        enable = true,
                        open_win_config = function()
                            local screen_w = vim.opt.columns:get()
                            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                            local window_w = screen_w * WIDTH_RATIO
                            local window_h = screen_h * HEIGHT_RATIO
                            local window_w_int = math.floor(window_w)
                            local window_h_int = math.floor(window_h)
                            local center_x = (screen_w - window_w) / 2
                            local center_y = ((vim.opt.lines:get() - window_h) / 2)
                                - vim.opt.cmdheight:get()
                            return {
                                border = 'rounded',
                                relative = 'editor',
                                row = center_y,
                                col = center_x,
                                width = window_w_int,
                                height = window_h_int,
                            }
                        end,
                    },
                    width = function()
                        return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                    end,
                },
            })
        end
    }

    --- Diagnostic/references/telescope results/quickfix/location lists.
    use {
        'folke/trouble.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' }
    }

    --- Good looking input/select replacements.
    use {
        'stevearc/dressing.nvim',
        config = function()
            require('dressing').setup()
        end
    }

    -- ********************************************************************************************
    -- Behaviors

    -- Indent lines
    use {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {},
        config = function()
            require('ibl').setup()
        end
    }

    -- Add surround operator for text objects.
    use 'tpope/vim-surround'

    -- Git information from within vim.
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'

    -- Easy comment code blocks in/out.
    use 'scrooloose/nerdcommenter'

    -- Automatically inserts closing chars for pairs of open/close chars (e.g. parens).
    use {
        "windwp/nvim-autopairs",
        config = function()
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
        end
    }

    -- Emacs yank schemes
    use 'maxbrunsfeld/vim-yankstack'

    -- Snippets engine
    use({
        "L3MON4D3/LuaSnip",
        tag = "v1.*",
        config = function()
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
        end
    })

    -- Snippets engine integration with telescope
    use 'benfowler/telescope-luasnip.nvim'

    -- Github integration.
    use {
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            --require "octo".setup()
        end
    }

    -- Quick search with s(char1)(char2)
    use {
        'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end
    }

    -- Completion framework
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            vim.cmd([[
                autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
            ]])

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require "luasnip"
            local cmp = require 'cmp'

            cmp.setup({
                -- Enable LSP snippets
                snippet = {
                    expand = function(args)
                        require 'luasnip'.lsp_expand(args.body)
                    end,
                },

                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),

                    -- Add supertab support, thanks to https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- they way you will only jump inside the snippet region
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },

                -- Installed sources:
                sources = {
                    { name = 'path' },                                       -- file paths
                    { name = 'nvim_lsp',               keyword_length = 2 }, -- from language server
                    { name = 'nvim_lsp_signature_help' },                    -- display function signatures with current parameter emphasized
                    { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
                    { name = 'buffer',                 keyword_length = 2 }, -- source current buffer
                    { name = 'luasnip' },                                    -- nvim-cmp source for luasnip
                    { name = 'calc' },                                       -- source for math calculation
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                formatting = {
                    fields = { 'menu', 'abbr', 'kind' },
                    format = function(entry, item)
                        local menu_icon = {
                            nvim_lsp = 'λ',
                            luasnip = '⋗',
                            buffer = 'Ω',
                            path = '🖫',
                        }
                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },
            })
        end
    }

    -- Look for typos
    use {
        'poljar/typos.nvim',
        config = function()
            require('typos').setup()
        end
    }

    -- Remember work sessions.
    use {
        "folke/persistence.nvim",
        event = "VimEnter",
        module = "persistence",
        config = function()
            require("persistence").setup()
        end
    }

    -- ********************************************************************************************
    -- Language specific

    -- All hail our robotic overlords.
    use {
        'github/copilot.vim',
        config = function()
            -- Don't use copilot's default keybindings for accepting a suggestion.
            vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false
            })
            vim.g.copilot_no_tab_map = true
        end
    }

    -- ********************************************************************************************
    -- Automatically set up your configuration after cloning packer.nvim
    -- Keep this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
