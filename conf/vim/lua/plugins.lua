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
    use 'Mofiqul/dracula.nvim'
    use 'catppuccin/nvim'
    use 'folke/tokyonight.nvim'

    -- Better status line.
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' }
    }

    -- Fuzzy finder and nice windows
    use {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    --- Use telescope for e.g. code actions
    use 'nvim-telescope/telescope-ui-select.nvim'

    --- Use a C clone of fzf for fuzzy search in telescope! (assume preinstalled)
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    --- Show LSP status above the status line
    use 'j-hui/fidget.nvim'

    --- Floating terminal windows!
    use "numToStr/FTerm.nvim"

    --- File tree!
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
    }

    -- ********************************************************************************************
    -- Behaviors

    -- Indent lines
    use 'lukas-reineke/indent-blankline.nvim'

    -- Add surround operator for text objects.
    use 'tpope/vim-surround'

    -- Git information from within vim.
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'

    -- Easy comment code blocks in/out.
    use 'scrooloose/nerdcommenter'

    -- Automatically inserts closing chars for pairs of open/close chars (e.g. parens).
    use "windwp/nvim-autopairs"

    -- Emacs yank schemes
    use 'maxbrunsfeld/vim-yankstack'

    -- Snippets engine
    use({ "L3MON4D3/LuaSnip", tag = "v1.*" })

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
            require "octo".setup()
        end
    }

    -- Quick search with s(char1)(char2)
    use 'ggandor/leap.nvim'

    -- Completion framework
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'saadparwaiz1/cmp_luasnip'

    -- ********************************************************************************************
    -- Language specific

    -- Native LangServer protocol.
    use 'neovim/nvim-lspconfig'

    -- Extra LSP for rust!
    use 'simrat39/rust-tools.nvim'

    -- Auto install LSP.
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- ********************************************************************************************
    -- Automatically set up your configuration after cloning packer.nvim
    -- Keep this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
