local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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

    -- Better status line.
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- ********************************************************************************************
    -- Behaviors

    -- Indent lines
    use 'Yggdroot/indentLine'

    -- Sublime-like multiple cursors.
    use 'terryma/vim-multiple-cursors'

    -- Add surround operator for text objects.
    use 'tpope/vim-surround'

    -- Git information from within vim.
    use 'tpope/vim-fugitive'

    -- Easy comment code blocks in/out.
    use 'scrooloose/nerdcommenter'

    -- Automatically inserts closing chars for pairs of open/close chars (e.g. parens).
    use 'Raimondi/delimitMate'

    -- Emacs yank schemes
    use 'maxbrunsfeld/vim-yankstack'

    -- Snippets engine (requires Python support).
    use({"L3MON4D3/LuaSnip", tag = "v1.*"})
    use 'benfowler/telescope-luasnip.nvim'

    -- Github integration.
    use {
      'pwntester/octo.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function ()
        require"octo".setup()
      end
    }

    -- ********************************************************************************************
    -- Language specific

    -- Cranelift IR.
    use 'CraneStation/cranelift.vim'

    -- Native LangServer protocol.
    use 'neovim/nvim-lspconfig'

    -- Extra LSP for rust!
    use 'simrat39/rust-tools.nvim'

    -- Fuzzy finder and nice windows
    use 'nvim-telescope/telescope.nvim'

    --- Use telescope for e.g. code actions
    use 'nvim-telescope/telescope-ui-select.nvim'

    --- Use fzf for fuzzy search in telescope! (assume preinstalled)
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    --- Helper functions used by telescope
    use 'nvim-lua/plenary.nvim'

    --- Show LSP status above the status line
    use 'j-hui/fidget.nvim'

    -- ********************************************************************************************
    -- Automatically set up your configuration after cloning packer.nvim
    -- Keep this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
