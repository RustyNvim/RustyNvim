-- Undotree configuration (Vimscript plugin - use vim.g for settings)
vim.g.undotree_WindowLayout = 2 -- Layout style (1-4)
vim.g.undotree_ShortIndicators = 1 -- Use short time indicators
vim.g.undotree_SplitWidth = 20 -- Width of undo tree window
vim.g.undotree_DiffpanelHeight = 10 -- Height of diff panel
vim.g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when toggled
vim.g.undotree_TreeNodeShape = '◉' -- Node shape
vim.g.undotree_DiffAutoOpen = 1 -- Auto open diff window

-- Keymap for undotree
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
