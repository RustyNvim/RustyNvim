local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

-- ============================================
-- MAIN CONFIGURATION
-- ============================================
npairs.setup({
    -- Core features
    check_ts = true,   -- Enable treesitter integration
    ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        typescript = { 'string', 'template_string' },
        java = false,
    },

    -- Behavior settings
    disable_filetype = {
        'TelescopePrompt',
        'spectre_panel',
        'vim',
    },
    disable_in_macro = true,
    disable_in_visualblock = false,
    disable_in_replace_mode = true,

    -- Smart pairing
    ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    enable_moveright = true,
    enable_check_bracket_line = true,
    enable_bracket_in_quote = true,
    enable_afterquote = true,

    -- Keymaps
    map_cr = true,
    map_bs = true,
    map_c_w = false,
    map_c_h = false,

    -- Fast wrap configuration
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'PmenuSel',
        highlight_grey = 'LineNr',
        offset = 0,
        manual_position = true,
    },
})

-- ============================================
-- UNIVERSAL SMART RULES
-- ============================================

-- Add spaces inside brackets automatically
-- ( | ) -> (  |  ) when you press space
npairs.add_rules({
    Rule(' ', ' ')
      :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
      end),
    Rule('( ', ' )')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
      end)
      :use_key(')'),
    Rule('{ ', ' }')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
      end)
      :use_key('}'),
    Rule('[ ', ' ]')
      :with_pair(function() return false end)
      :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
      end)
      :use_key(']'),
})


-- ============================================
-- LOAD LANGUAGE-SPECIFIC RULES
-- ============================================
local ok, lang_rules = pcall(require, 'autopairs.autopair_rule')
if ok then
    lang_rules.setup(npairs)
else
    vim.notify(
        'Could not load language-specific autopairs rules',
        vim.log.levels.WARN
    )
end

-- ============================================
-- UTILITY FUNCTIONS & KEYMAPS
-- ============================================

-- Toggle autopairs on/off
vim.keymap.set('n', '<leader>up', function()
    if npairs.state.disabled then
        npairs.enable()
        vim.notify('Autopairs enabled', vim.log.levels.INFO)
    else
        npairs.disable()
        vim.notify('Autopairs disabled', vim.log.levels.WARN)
    end
end, { desc = 'Toggle autopairs' })

-- Debug: Show current rule at cursor
vim.keymap.set('n', '<leader>uP', function()
    local line = vim.fn.getline('.')
    local col = vim.fn.col('.')
    local char = line:sub(col, col)
    print('Char:', char)
    print('Rules:', vim.inspect(npairs.get_rule(char)))
end, { desc = 'Debug autopairs rules' })

-- ============================================
-- PERFORMANCE OPTIMIZATION
-- ============================================

-- Disable in very large files
vim.api.nvim_create_autocmd('BufReadPre', {
    callback = function()
        local ok_stat, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
        if ok_stat and stats and stats.size > 500000 then -- 500KB
            npairs.disable()
            vim.notify(
                'Autopairs disabled for large file',
                vim.log.levels.INFO
            )
        end
    end,
})

