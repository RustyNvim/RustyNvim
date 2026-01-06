require("user.config.IdeBatch.inbuilt.autosave").setup({
    enabled = true,
    allow = { "all" },
    -- disallow = { "c", "cpp" },
    speed = 100, -- ms delay
    mode = "n",

    -- NEW: Advanced options
    format_on_save = false,      -- Auto-format with Conform/LSP
    reload_diagnostics = true,   -- Refresh diagnostics
    debounce = true,             -- Prevent rapid-fire saves
    notify = false,              -- Show save notifications (off by default)

    exclude_ft_from_format = {}, -- Skip formatting: {"markdown", "text"}

    -- Integration
    use_conform = true,    -- Use conform.nvim
    use_lsp_format = true, -- Fallback to LSP
})
