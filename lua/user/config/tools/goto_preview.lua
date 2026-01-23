require("goto-preview").setup({
    width = 120,
    height = 25,
    border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
    default_mappings = false,  -- important since you're defining your own
    resizing_mappings = false, -- is bad let it be false.
    focus_on_open = true,
    dismiss_on_move = false,
    force_close = true,
})

local gp = require("goto-preview")

vim.keymap.set("n", "gpd", gp.goto_preview_definition, { desc = "Preview definition" })
vim.keymap.set("n", "gpt", gp.goto_preview_type_definition, { desc = "Preview type definition" })
vim.keymap.set("n", "gpi", gp.goto_preview_implementation, { desc = "Preview implementation" })
vim.keymap.set("n", "gpD", gp.goto_preview_declaration, { desc = "Preview declaration" })
vim.keymap.set("n", "gpr", gp.goto_preview_references, { desc = "Preview references" })
vim.keymap.set("n", "gP", gp.close_all_win, { desc = "Close all preview windows" })
