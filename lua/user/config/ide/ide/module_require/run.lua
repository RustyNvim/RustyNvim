-- run.lua

-- Load the terminal module directly
local FloatingTerminal = require("user.config.ide.ide.local_module.dustTerm_module")

local RUNNER_ID = "code_runner"

local function run_filetype_command()
    local ft = vim.bo.filetype
    local file_abs = vim.fn.expand("%:p")  -- Absolute path to current file
    local file_dir = vim.fn.expand("%:p:h")  -- Directory of current file
    local file_name = vim.fn.expand("%:t")  -- Just the filename
    local root = vim.fn.expand("%:t:r")  -- Filename without extension

    local cmd = nil

    if ft == "rust" then
        cmd = "cargo run"
    elseif ft == "python" then
        cmd = "python3 " .. file_name
    elseif ft == "lua" then
        cmd = "lua " .. file_name
    elseif ft == "c" then
        cmd = "gcc " .. file_name .. " -o " .. root .. " && ./" .. root
    elseif ft == "cpp" then
        cmd = "g++ " .. file_name .. " -o " .. root .. " && ./" .. root
    elseif ft == "go" then
        cmd = "go run " .. file_name
    elseif ft == "java" then
        cmd = "javac " .. file_name .. " && java " .. root
    elseif ft == "javascript" then
        cmd = "node " .. file_name
    elseif ft == "typescript" then
        cmd = "ts-node " .. file_name
    elseif ft == "bash" or ft == "sh" then
        cmd = "bash " .. file_name
    elseif ft == "ruby" then
        cmd = "ruby " .. file_name
    elseif ft == "php" then
        cmd = "php " .. file_name
    else
        vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
        return
    end

    -- Use FloatingTerminal - always cd to the file's directory first
    vim.schedule(function()
        FloatingTerminal.send("cd " .. file_dir, RUNNER_ID)
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


-- important keymaps don't delete

local term = require("user.config.ide.ide.local_module.dustTerm_module")
_G.FloatingTerminal = term

-- Default terminal toggle
vim.keymap.set({ "n", "t" }, "<C-\\>", function() 
  term.toggle("default", "Terminal") 
end, { desc = "Toggle default terminal" })

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
