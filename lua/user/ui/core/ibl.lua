-- Install both plugins
-- ibl for static indent guides
-- mini.indentscope for active scope highlighting

-- IBL Setup - subtle, always-on guides
require('ibl').setup({
    indent = {
        char = '│',  -- or '▏' for thinner, '┊' for dotted
        tab_char = '│',
        highlight = { 'IblIndent' },
        smart_indent_cap = true,
    },

    whitespace = {
        remove_blankline_trail = true,
    },

    scope = {
        enabled = false,  -- Let mini.indentscope handle this
    },

    exclude = {
        filetypes = {
            'help', 'dashboard', 'neo-tree', 'Trouble', 'trouble',
            'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
            'packer', 'checkhealth', 'man', 'gitcommit',
            'TelescopePrompt', 'TelescopeResults', 'lspinfo',
            'alpha', 'starter', '',
        },
        buftypes = {
            'terminal', 'nofile', 'quickfix', 'prompt',
        },
    },
})

-- Mini Indentscope - animated scope highlighting
require('mini.indentscope').setup({
    draw = {
        delay = 50,
        animation = require('mini.indentscope').gen_animation.none(),
    },
    
    mappings = {
      -- Textobjects
      object_scope = 'is',
      object_scope_with_border = 'as',

      -- Motions (jump to respective border line; if not present - body line)
      goto_top = '[s',
      goto_bottom = ']s',
    },
    symbol = '│',  -- matches ibl for consistency
    
    options = {
        try_as_border = true,
        indent_at_cursor = true,
    },
})

-- Force highlight override after colorscheme loads
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'IblIndent', { link = 'NonText' })
        vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'Special' })  -- or 'Function'
    end,
})


-- Link to existing highlight groups for theme consistency
vim.api.nvim_set_hl(0, 'IblIndent', { link = 'NonText' })
vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'Special' })
