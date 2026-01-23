-- Snipe.nvim - Maxed Out
local snipe = require("snipe")
local columns = vim.o.columns
local lines = vim.o.lines

snipe.setup({
    behavior = {
        auto_open = false,        -- Auto-open menu on buffer switch
        auto_close = true,        -- Auto-close if no items
        sort_by_recent = true,    -- Sort buffers by most recently used
    },
    mappings = {
        open_menu = "<leader>gb",      -- Open buffer menu
        close_menu = "<Esc>",          -- Close buffer menu
        select_item = "<CR>",          -- Select buffer
        next_item = "<Tab>",           -- Navigate down in menu
        prev_item = "<S-Tab>",         -- Navigate up in menu
        delete_item = "<leader>bd",    -- Delete buffer from menu
    },
    ui = {
        position = "center",
        width = 40,    -- 70% of terminal width
        max_height = 10, -- 70% of terminal height
        border = "rounded",
        show_numbers = true,
        show_icons = true,
        icon_default = "",
        highlight_current = "Visual",
    },
})

-- Keymaps for buffers outside the menu
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Open Snipe buffer menu
map("n", "<leader>sb", snipe.open_buffer_menu, vim.tbl_extend("force", opts, { desc = "Snipe: Open buffer menu" }))

map("n", "<leader>sd", function()
    snipe.open_buffer_menu()
end, vim.tbl_extend("force", opts, { desc = "Snipe: Open buffer menu to delete" }))
