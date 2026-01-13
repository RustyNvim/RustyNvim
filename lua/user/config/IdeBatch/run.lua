-- run.lua

-- Load the terminal module directly
local FloatingTerminal = require("user.config.IdeBatch.dustTerm")

local RUNNER_ID = "code_runner"

local function run_filetype_command()
    local ft = vim.bo.filetype
    local cwd = vim.fn.getcwd()
    local file = vim.fn.expand("%")
    local root = vim.fn.expand("%:r")

    local cmd = nil

    if ft == "rust" then
        cmd = "cargo run"
    elseif ft == "python" then
        cmd = "python3 " .. file
    elseif ft == "lua" then
        cmd = "lua " .. file
    elseif ft == "c" then
        cmd = "gcc " .. file .. " -o " .. root .. " && ./" .. root
    elseif ft == "cpp" then
        cmd = "g++ " .. file .. " -o " .. root .. " && ./" .. root
    elseif ft == "go" then
        cmd = "go run " .. file
    elseif ft == "java" then
        cmd = "javac " .. file .. " && java " .. root
    elseif ft == "javascript" then
        cmd = "node " .. file
    elseif ft == "typescript" then
        cmd = "ts-node " .. file
    elseif ft == "bash" or ft == "sh" then
        cmd = "bash " .. file
    elseif ft == "ruby" then
        cmd = "ruby " .. file
    elseif ft == "php" then
        cmd = "php " .. file
    else
        vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
        return
    end

    -- Use FloatingTerminal
    vim.schedule(function()
        FloatingTerminal.send("cd " .. cwd, RUNNER_ID)
        FloatingTerminal.send("clear", RUNNER_ID)
        FloatingTerminal.send(cmd, RUNNER_ID)
    end)
end

-- Run code
vim.keymap.set("n", "<leader>zz", run_filetype_command, { silent = true })

-- Toggle runner terminal
vim.keymap.set("n", "<leader>xz", function()
    FloatingTerminal.toggle(RUNNER_ID, "Code Runner")
end, { silent = true })


local term = require("user.config.IdeBatch.dustTerm")
_G.FloatingTerminal = term

-- Default terminal toggle
vim.keymap.set({ "n", "t" }, "<C-\\>", function() 
  term.toggle("default", "Terminal") 
end, { desc = "Toggle default terminal" })

-- Git terminal
vim.keymap.set({ "n", "t" }, "<leader>gg", function() 
  term.toggle("git", "Git Terminal") 
end, { desc = "Toggle git terminal" })

-- Test terminal
vim.keymap.set({ "n", "t" }, "<leader>tt", function() 
  term.toggle("test", "Test Runner") 
end, { desc = "Toggle test terminal" })

-- Navigation between terminals
vim.keymap.set({ "n", "t" }, "<leader>tn", function()
  term.next()
end, { desc = "Next terminal" })

vim.keymap.set({ "n", "t" }, "<leader>tp", function()
  term.prev()
end, { desc = "Previous terminal" })

-- Terminal selection
vim.keymap.set({ "n", "t" }, "<leader>ts", function()
  term.select()
end, { desc = "Select terminal" })


