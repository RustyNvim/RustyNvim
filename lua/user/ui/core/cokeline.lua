local get_hex = require('cokeline.hlgroups').get_hl_attr

require('cokeline').setup({
    default_hl = {
        fg = function(buffer)
            return
              buffer.is_focused
              and get_hex('Normal', 'fg')
              or get_hex('Comment', 'fg')
        end,
        bg = 'NONE',
    },
    components = {
        {
            text = function(buffer) return (buffer.index ~= 1) and '▏' or '' end,
            fg = function() return get_hex('Normal', 'fg') end
        },
        {
            text = function(buffer) return '    ' .. buffer.devicon.icon end,
            fg = function(buffer) return buffer.devicon.color end,
        },
        {
            text = function(buffer) return buffer.filename end,
            bold = function(buffer) return buffer.is_focused end,
        },
        {
            text = function(buffer)
                return buffer.is_modified and ' [*]' or ''
            end,
            fg = function(buffer)
                return buffer.is_focused
                  and get_hex('DiagnosticWarn', 'fg')
                  or get_hex('Comment', 'fg')
            end,
            italic = false,
            bold = true
        },
        {
            text = '    ',
        },
        {
            text = '󰖭',
            on_click = function(_, _, _, _, buffer)
                buffer:delete()
            end
        },
        {
            text = '  ',
        },
    },
})
vim.keymap.set('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)',
    { silent = true, desc = 'Previous buffer' })
vim.keymap.set('n', '<Tab>', '<Plug>(cokeline-focus-next)', { silent = true, desc = 'Next buffer' })

-- Move buffer left/right
vim.keymap.set('n', '<A-,>', '<Plug>(cokeline-switch-prev)', { silent = true })
vim.keymap.set('n', '<A-.>', '<Plug>(cokeline-switch-next)', { silent = true })
