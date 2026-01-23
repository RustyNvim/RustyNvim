local dap = require("dap")
local dapui = require("dapui")

-- UI setup
dapui.setup()

-- Auto open / close UI
dap.listeners.after.event_initialized["dapui"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
    dapui.close()
end

-- Signs (breakpoint icons)
vim.fn.sign_define("DapBreakpoint", {
    text = "●",
    texthl = "DiagnosticError",
})

vim.fn.sign_define("DapStopped", {
    text = "▶",
    texthl = "DiagnosticWarn",
    linehl = "Visual",
})

return dap
