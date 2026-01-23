local dap = require("dap")

-- Debug execution
vim.keymap.set("n", "<leader>dc", dap.continue, {
    desc = "Debug: Continue / Start",
})

vim.keymap.set("n", "<leader>dn", dap.step_over, {
    desc = "Debug: Step Over",
})

vim.keymap.set("n", "<leader>di", dap.step_into, {
    desc = "Debug: Step Into",
})

vim.keymap.set("n", "<leader>do", dap.step_out, {
    desc = "Debug: Step Out",
})

-- Breakpoints
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {
    desc = "Debug: Toggle Breakpoint",
})

vim.keymap.set("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, {
    desc = "Debug: Conditional Breakpoint",
})
