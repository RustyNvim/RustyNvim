-- Yanky configuration
require("yanky").setup({
    ring = {
        history_length = 100,
        storage = "shada", -- can be "shada" or "sqlite" or "memory"
        sync_with_numbered_registers = true,
        cancel_event = "update",
    },
    picker = {
        select = {
            action = nil, -- nil to use default put action
        },
        telescope = {
            use_default_mappings = true,
            mappings = nil, -- nil to use default mappings
        },
    },
    system_clipboard = {
        sync_with_ring = true,
    },
    highlight = {
        on_put = true,
        on_yank = true,
        timer = 500,
    },
    preserve_cursor_position = {
        enabled = true,
    },
})

-- Recommended keymaps for yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")

-- Optional: Telescope integration for yanky
vim.keymap.set("n", "<leader>yh", function() require("telescope").extensions.yank_history.yank_history({}) end,
    { desc = "Open Yank History" })
