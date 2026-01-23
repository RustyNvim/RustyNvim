require("showkeys").setup({
    -- Position on screen
    position = "top-right", -- "top-right" | "top-center" | "top-left" | "bottom-right" | "bottom-center" | "bottom-left"
    
    -- Timing
    timeout = 3, -- seconds to show keys
    maxkeys = 5, -- max keys to show in history
    
    -- Appearance
    show_count = true, -- show count for repeated keys
    excluded_modes = {}, -- modes to exclude from showing keys
    
    -- Keymaps to exclude from display
    excluded_keys = {
        "<leader>", 
        "<C-c>",
        "<Esc>",
    },
    
    -- Window style
    winopts = {
        border = "rounded", -- "none" | "single" | "double" | "rounded" | "solid" | "shadow"
        relative = "editor",
        style = "minimal",
        focusable = false,
        width = 40,
        height = 3,
        row = 1,
        col = vim.o.columns - 42,
    },
    
    -- Colors (adjust to match your theme)
    hl = {
        border = "FloatBorder",
        background = "Normal",
        keys = "String",
        count = "Number",
    },
})

-- Toggle showkeys on/off
vim.keymap.set("n", "<leader>sk", function()
    vim.cmd("ShowkeysToggle")
end, { desc = "Toggle Showkeys" })
