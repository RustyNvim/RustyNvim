local Terminal = require("toggleterm.terminal").Terminal


-- Persistent terminal (global)
local runner = Terminal:new({
    direction = "float",
    hidden = true,
    close_on_exit = false, -- NEVER auto close
    start_in_insert = true,
})
local function ensure_runner_open()
    if not runner:is_open() then
        runner:open()
    end
end

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


    -- send command (cd first, DO NOT exit shell)
    ensure_runner_open()
    vim.schedule(function()
        runner:send("cd " .. cwd)
        runner:send("clear")
        runner:send(cmd)
    end)

end

-- Run code
vim.keymap.set("n", "<leader>zz", run_filetype_command, { silent = true })
vim.keymap.set("n", "<leader>xz", function()
    runner:toggle()
end, { silent = true })
