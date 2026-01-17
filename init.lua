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
-- 2. Explicit Stage Loader (Matches Directory Names)
-- =========================================================
local STAGES = {
    'user.stages.01_sys',
    'user.stages.02_uiCore',
    'user.stages.03_uiCherry',
    'user.stages.04_ecosysMini',
    'user.stages.05_lspC',
    'user.stages.06_lspB',
    'user.stages.07_ideB',
    'user.stages.08_last',
}

for i, stage_module in ipairs(STAGES) do
    safe_require(stage_module)
end

-- =========================================================
-- 3. Post-init
-- =========================================================
vim.cmd.colorscheme("nightfox")


vim.api.nvim_set_hl(0, "CursorLineSign", { link = "CursorLine" })
vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLine" })
