-- Automatically install new addons with Packer
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Automatically reload lua configuration
vim.cmd([[
  augroup lua_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile>
  augroup end
]])

-- Automatically reload vimrc configuration
vim.cmd([[
  augroup viml_user_config
    autocmd!
    autocmd BufWritePost vimrc source <afile>
  augroup end
]])
