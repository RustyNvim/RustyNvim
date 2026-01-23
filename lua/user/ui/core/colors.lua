local theme_manager = require('user.ui.core.theme') -- Save the artifact as lua/theme_manager.lua

theme_manager.setup({
    default_theme = 'catppuccin', -- Your default theme

    -- Optional: Add custom themes
    themes = {}
})
