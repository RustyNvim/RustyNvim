require("user.config.ide.ide.local_module.autosave_module").setup({
    enabled = true,
    allow = { "all" },
    -- disallow = { "c", "cpp" },
    speed = 100, -- ms delay
    mode = "n",

    -- NEW: Advanced options
    format_on_save = false,      -- Auto-format with Conform/LSP
    reload_diagnostics = false,   -- I warn you to not use it otherwise you will be waiting 2-3 seconds for diagonastic refresh
    debounce = true,             -- Prevent rapid-fire saves
    notify = false,              -- Show save notifications (off by default)

    exclude_ft_from_format = {}, -- Skip formatting: {"markdown", "text"}

    -- Integration
    use_conform = true,    -- Use conform.nvim
    use_lsp_format = true, -- Fallback to LSP
})
