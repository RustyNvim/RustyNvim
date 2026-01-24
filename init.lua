-- require("user.profiler")
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.lsp.set_log_level('warn')

-- =========================================================
-- 1. Safe require helper
-- =========================================================
local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        vim.notify(
            'Failed to load: ' .. module .. '\n' .. tostring(result),
            vim.log.levels.ERROR,
            { title = 'Module Load Error' }
        )
        return nil
    end
    return result
end

-- =========================================================
-- 2. Auto-discover and load stages in numerical order
-- =========================================================
local function load_stages()
    local stages_path = vim.fn.stdpath('config') .. '/lua/user/stages'
    local files = vim.fn.readdir(stages_path)
    
    -- Filter for .lua files and sort them numerically
    local lua_files = {}
    for _, file in ipairs(files) do
        if file:match('%.lua$') then
            table.insert(lua_files, file)
        end
    end
    
    -- Sort numerically by extracting leading numbers
    table.sort(lua_files, function(a, b)
        local num_a = tonumber(a:match('^(%d+)'))
        local num_b = tonumber(b:match('^(%d+)'))
        if num_a and num_b then
            return num_a < num_b
        end
        return a < b  -- Fallback to alphabetical
    end)
    
    -- Load each stage in order
    for _, file in ipairs(lua_files) do
        local module_name = file:gsub('%.lua$', '')
        local stage_module = 'user.stages.' .. module_name
        safe_require(stage_module)
    end
end

load_stages()

-- =========================================================
-- 3. Post-init
-- =========================================================
require('user.ui.core.theme')
require('user.ui.core.colors')

vim.cmd.colorscheme("nightfox")
local cl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
local clr = vim.api.nvim_get_hl(0, { name = "CursorLineNr" })

vim.api.nvim_set_hl(0, "CursorLineNr", {
  fg   = clr.fg,
  bg   = cl.bg,
  bold = clr.bold,
})

vim.api.nvim_set_hl(0, "CursorLineSign", {
  bg = cl.bg,
})
