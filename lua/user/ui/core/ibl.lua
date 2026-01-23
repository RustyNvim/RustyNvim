require('ibl').setup({
    indent = {
        char = '▏',
        tab_char = '▏',
        highlight = 'NonText',
        smart_indent_cap = true,
    },
    whitespace = {
        remove_blankline_trail = true,
    },

  scope = {
    enabled = false,
    char = "▎", -- Slightly thicker for current scope
    show_start = false, -- NO underline on scope start
    show_end = false,   -- NO underline on scope end
    show_exact_scope = true,
    injected_languages = true,
    highlight = "Identifier",
    priority = 1024,
    include = {
      node_type = {
        ["*"] = {
          "function",
          "method",
          "class",
          "if_statement",
          "for_statement",
          "while_statement",
          "switch_statement",
          "try_statement",
        },
      },
    },
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


require('mini.indentscope').setup({
    draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
    },
    options = {
        border = 'both',     -- Show top and bottom of scope
        indent_at_cursor = true, -- Highlight scope under cursor
        try_as_border = true, -- Smart handling of try/catch blocks
    },

      -- Mappings for jumping to scope boundaries
  mappings = {
    object_scope = "is",       -- Text object for inner scope
    object_scope_with_border = "as", -- Text object including borders
    
    goto_top = "[s",           -- Jump to scope start
    goto_bottom = "]s",        -- Jump to scope end
  },
})

-- Disable mini.indentscope in UI buffers (auto-inherits from ibl's list)
vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'help', 'dashboard', 'neo-tree', 'Trouble', 'trouble',
        'lazy', 'mason', 'notify', 'toggleterm', 'lazyterm',
        'TelescopePrompt', 'TelescopeResults', 'alpha', 'starter',
    },
    callback = function()
        vim.b.miniindentscope_disable = true
    end,
})
