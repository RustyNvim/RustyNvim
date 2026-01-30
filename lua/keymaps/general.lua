wk = require('which-key')
wk.add({
    { '<leader>f',  group = 'Fzf Lua' },
    { '<leader>c',  group = 'C' },
    { '<leader>f',  group = 'Fzf Lua' },
    { '<leader>v',  group = 'Visual' },
    { '<leader>y',  group = 'Yank or Yazi' },
    { '<leader>yo',  group = 'Yazi Open' },
    { '<leader>l',  group = 'Local' },
    { '<leader>ll', group = 'Lazy' },
    { '<leader>ls', group = 'Server' },
    { '<leader>pp', group = 'Paste' },
})
-- reload init.lua (global)
map('n', '<leader>rrc', '<cmd>source $MYVIMRC<cr>', {
    desc = 'Reload config (init.lua)',
})

-- reload current file
map('n', '<leader>rrf', '<cmd>source %<cr>', {
    desc = 'Source current file',
})

-- refresh buffer (discard changes)
map('n', '<leader>rrb', '<cmd>edit!<cr>', {
    desc = 'Reload buffer',
})

map('n', '<leader>rrl', '<cmd>LspRestart<cr>', {
    desc = 'Restart Lsp',
})

-- replace/substitute

-- current line substitute (native vim, fastest)
map('n', '<leader>rsl', ':s/', {
    desc = 'Substitute line',
})

-- visual selection substitute
map('v', '<leader>rsv', ':s/\\%V', {
    desc = 'Substitute selection',
})

-- range substitute (explicit)
map('n', '<leader>rsr', function()
    SubstituteRange()
end, {
    desc = 'Substitute range',
})

-- matching lines substitute
map('n', '<leader>rsm', function()
    SubstituteMatchingLines()
end, {
    desc = 'Substitute matching lines',
})

-- whole file substitute (dangerous, explicit)
map('n', '<leader>rsa', function()
    SubstituteAll()
end, {
    desc = 'Substitute entire file',
})

-- Lazy
map('n', '<leader>llp', '<cmd>Lazy profile<cr>', { desc = 'Lazy profile' })
map('n', '<leader>llu', '<cmd>Lazy update<cr>', { desc = 'Lazy update' })
map('n', '<leader>lls', '<cmd>Lazy sync<cr>', { desc = 'Lazy sync' })


-- Info
map('n', '<leader>lsi', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
map('n', '<leader>lsl', '<cmd>LspLog<cr>', { desc = 'Lsp Log' })
map('n', '<leader>lsr', '<cmd>LspRestart<cr>', { desc = 'Lsp Log' })
