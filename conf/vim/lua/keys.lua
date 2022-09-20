helpers = require './helpers' -- ultisnips expects this global variable to be defined for some snippets

helpers.map('n', '<leader>s', '<Cmd>lua telescope.extensions.ultisnips.ultisnips{}<CR>')
helpers.map('n', '<leader>b', '<Cmd>lua telescope_builtins.buffers{}<CR>')
helpers.map('n', '<leader>gf', '<Cmd>lua telescope_builtins.find_files{}<CR>')
helpers.map('n', '<leader>gg', '<Cmd>lua telescope_builtins.live_grep{}<CR>')
