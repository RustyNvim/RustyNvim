vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'gruvbox',
    callback = function()
        -- link common columns to Normal
        local link = { link = 'Normal' }
        for _, g in ipairs({
            'SignColumn',
        }) do
            vim.api.nvim_set_hl(0, g, link)
        end

        -- fetch base colors
        local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
        local error  = vim.api.nvim_get_hl(0, { name = 'Error' })
        local warn   = vim.api.nvim_get_hl(0, { name = 'WarningMsg' })
        local info   = vim.api.nvim_get_hl(0, { name = 'Identifier' })
        local hint   = vim.api.nvim_get_hl(0, { name = 'Comment' })

        -- diagnostics: fg from severity, bg from Normal
        vim.api.nvim_set_hl(0, 'DiagnosticSignError', {
            fg = error.fg,
            bg = normal.bg,
        })

        vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', {
            fg = warn.fg,
            bg = normal.bg,
        })

        vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', {
            fg = info.fg,
            bg = normal.bg,
        })

        vim.api.nvim_set_hl(0, 'DiagnosticSignHint', {
            fg = hint.fg,
            bg = normal.bg,
        })
    end,
})

vim.api.nvim_create_user_command("GruvboxHard", function()
  require("gruvbox").setup({ contrast = "hard"  })
  vim.cmd("colorscheme gruvbox")
end, {})

vim.api.nvim_create_user_command("GruvboxSoft", function()
  require("gruvbox").setup({ contrast = "soft"  })
  vim.cmd("colorscheme gruvbox")
end, {})

vim.api.nvim_create_user_command("GruvboxDefault", function()
  require("gruvbox").setup({ contrast = ""  })
  vim.cmd("colorscheme gruvbox")
end, {})
