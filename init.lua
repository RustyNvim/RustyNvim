vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- =========================================================
-- 1. Safe require (isolates failures)
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

vim.lsp.set_log_level('warn') -- Only show warnings and errors, not info

-- =========================================================
-- 2. Alias registry (logical namespaces)
-- =========================================================
local ALIAS = {
    -- UI
    uc  = 'user._ui._core',
    ucc = 'user._ui._customts',
    uch = 'user._ui.cherry',

    -- System
    us  = 'user.sys',

    -- Mini ecosystem
    um  = 'user.ecosys.mini',

    -- LSP / IDE
    lsp = 'user.config.LspConfig',
    lb  = 'user.config.LspBatch',
    ide = 'user.config.IdeBatch',

    -- Other
    ext = 'user.other.extconfig',
}

-- =========================================================
-- 3. Alias-aware require
-- =========================================================
local function r(mod)
    local head, tail = mod:match('^([^.]+)%.?(.*)$')
    if ALIAS[head] then
        if tail ~= '' then
            return safe_require(ALIAS[head] .. '.' .. tail)
        else
            return safe_require(ALIAS[head])
        end
    end
    return safe_require(mod)
end

-- Optional: expose globally for quick access
_G.r = r

-- =========================================================
-- 4. Helper for staged loading (preserves control flow)
-- =========================================================
local function load_stage(stage)
    for _, entry in ipairs(stage) do
        if type(entry) == 'string' then
            r(entry)
        elseif type(entry) == 'function' then
            entry()
        elseif type(entry) == 'table' and entry.load then
            entry.load()
        end
    end
end

-- =========================================================
-- 5. Staged configuration (control flow preserved)
-- =========================================================
local FLOW = {

    -- 1. System core override
    {
        r('uc._itallic0'),
        r('us.directMap.quit_save'),
        r('us.directMap.buf_cycle'),
        r('us.directMap.autopopup_toggle'),
        r('us.plugins'),
    },

    -- 2. Inbuilt core
    {
        r('us.inbuilt.last_pos'),
    },

    -- 3. BASIC SETTINGS CORE
    {
        r('us.env'),
        r('us.options'),
        r('us.mappings'),
        r('us.autoreload'),
        r('us.mason'),
    },

    -- 4. UI CORE
    {
        r('uc._dashboard'),
        r('uc._diagonasticsigns'),
        r('uc._ibl'),
        r('uc._bufferline'),
        r('uc._statusline'),
        r('uc._dressing'),
        r('uc._windows'),
        r('uc._sgt'),
        r('uc._notify'),
        r('uc._ascii'),
    },

    -- 5. Custom treesitter
    {
        -- r("ucc.ts_file_call"),
        -- r("ucc.gruvbox_ts"),
    },

    -- 6. Cherry on top
    {
        r('uch.custom_treesitters'),
        r('uch.gitsigns'),
        r('uch.theme'),
        r('uch.colors'),
    },

    -- 7. Mini ecosystem
    {
        r('um.mini_surround'),
        r('um.mini_notify'),
        r('um.mini_icons'),
        r('um.mini_animate'),
        r('um.mini_jump'),
        r('um.mini_pairs')
    },

    -- {
    --     r("lsp.verbose"),
    -- },
    -- 8. LSP Config Setup
    {
        -- HighLevel
        r('lsp.HighLevel.lua_ls'),
        r('lsp.HighLevel.pyright'),
        -- LowLevel
        r('lsp.LowLevel.asm'),
        r('lsp.LowLevel.clang'),
        r('lsp.LowLevel.cmake'),
        r('lsp.LowLevel.rust_analyzer'),
        r('lsp.LowLevel.zls'),
        -- Productive
        r('lsp.Productive.bash_ls'),
        r('lsp.Productive.marksman'),
        r('lsp.Productive.vale'),
        r('lsp.Productive.vimls'),
        -- Utilities
        r('lsp.Utilities.dockerls'),
        r('lsp.Utilities.jsonls'),
        r('lsp.Utilities.yamlls'),
        -- Web
        r('lsp.Web.css_ls'),
        r('lsp.Web.gopls'),
        r('lsp.Web.html'),
        r('lsp.Web.phpactor'),
        r('lsp.Web.ts_ls'),
        -- GameDev
        r('lsp.GameDev.Godot_ls'),
        -- Activate all
        r('lb.lsp'),
    },

    -- 9. LspBatch + Dap
    {
        r('lb.blinkCmp'),
        r('lb.goto_preview'),
        -- r("lb.autopairs"),
        r('lb.formatter'),
        r('lb.luasnip'),
        r('lb.lspkind'),
        r('lb.trouble'),
        r('lb.navic'),

        r('user.config.Dap.setup'),
        r('user.config.Dap.keymaps'),
        r('user.config.Dap.langs.rust'),
    },

    -- 10. IDE Batch
    {
        r('ide.run'),
        r('ide.nvimtree'),
        r('ide.treesitter'),
        r('ide.project'),
        r('ide.sessions'),
        r('ide.refactoring'),
        r('ide.snipe'),
        r('ide.todo'),
        r('ide.whkey'),
        r('ide.treesitter'),
        r('ide.showkey'),
        r('ide.surround'),
        r('ide.telescope'),
        r('ide.comments'),
        r('ide.lazygit'),
        r('ide.undotree'),
        r('ide.dustTerm'),
        r('ide.oil'),
        r('ide.neoscroll'),
        r('ide.fold'),
        r('ide.yanky'),
        r('ide.file_organizer_setup'),
        r('ide._autosave'),
    },
    -- 12. Plugin extension

}

-- =========================================================
-- 6. Execute all stages
-- =========================================================
for _, stage in ipairs(FLOW) do
    load_stage(stage)
end

-- =========================================================
-- 7. Post-init (UI & keymaps)
-- =========================================================
vim.cmd.colorscheme("nightfox")

vim.keymap.set('n', '<leader>tc', function()
    require('telescope.builtin').find_files({
        cwd = vim.fn.expand('$MYVIMRC'):match('(.*/)'),
        prompt_title = '< Neovim Config >'
    })
end, { desc = 'Find config files' })
