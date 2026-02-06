-- ============================================================================
-- HEAVILY OPTIMIZED Nvim-treesitter Configuration
-- Maximum performance for files of any size
-- ============================================================================

-- Cache frequently used functions
local api = vim.api
local uv = vim.loop or vim.uv  -- Handle both old and new APIs

-- ============================================================================
-- PERFORMANCE SETTINGS
-- ============================================================================

-- File size thresholds (in bytes)
local FILESIZE = {
    DISABLE_ALL = 1024 * 1024,      -- 1MB: disable everything
    DISABLE_HEAVY = 512 * 1024,      -- 512KB: disable heavy features
    DISABLE_INDENT = 256 * 1024,     -- 256KB: disable indent
}

-- ============================================================================
-- SMART FILE SIZE CHECKER (Cached)
-- ============================================================================

local filesize_cache = {}

---@param buf number?
---@return number
local function get_filesize(buf)
    local bufnr = buf or api.nvim_get_current_buf()
    
    if filesize_cache[bufnr] then
        return filesize_cache[bufnr]
    end
    
    local ok, stats = pcall(uv.fs_stat, api.nvim_buf_get_name(bufnr))
    local size = (ok and stats and stats.size) or 0
    
    filesize_cache[bufnr] = size
    return size
end

-- Clear cache when buffer is deleted
api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
        filesize_cache[ev.buf] = nil
    end
})

-- ============================================================================
-- CONDITIONAL DISABLE FUNCTIONS
-- ============================================================================

---@param _ string
---@param buf number
---@return boolean
local function should_disable_heavy(_, buf)
    return get_filesize(buf) > FILESIZE.DISABLE_HEAVY
end

---@param _ string
---@param buf number
---@return boolean
local function should_disable_indent(_, buf)
    return get_filesize(buf) > FILESIZE.DISABLE_INDENT
end

-- ============================================================================
-- LAZY TREESITTER SETUP
-- ============================================================================

-- Delay treesitter initialization until truly needed
local treesitter_loaded = false

local function load_treesitter()
    if treesitter_loaded then return end
    treesitter_loaded = true
    
    -- Debug notification
    vim.notify("Treesitter loaded!", vim.log.levels.INFO)
    
    require('nvim-treesitter.configs').setup({
        -- ====================================================================
        -- MINIMAL PARSER INSTALLATION
        -- ====================================================================
        ensure_installed = {
            "lua", "vim", "zig", -- Added zig for your use case
        },
        
        sync_install = false,
        auto_install = false, -- Manual install only
        ignore_install = {},
        
        -- ====================================================================
        -- CORE: SYNTAX HIGHLIGHTING
        -- ====================================================================
        highlight = {
            enable = true,
            disable = should_disable_heavy,
            
            -- Don't use regex highlighting (slower)
            additional_vim_regex_highlighting = false,
        },
        
        -- ====================================================================
        -- LIGHTWEIGHT: INDENTATION (Keep this)
        -- ====================================================================
        indent = {
            enable = true,
            disable = should_disable_indent,
        },
        
        -- ====================================================================
        -- DISABLED BY DEFAULT: Enable on-demand only
        -- ====================================================================
        
        -- Incremental selection: DISABLED (use visual mode instead)
        incremental_selection = {
            enable = false,
        },
        
        -- Text objects: DISABLED (heavy on large files)
        textobjects = {
            select = { enable = false },
            move = { enable = false },
            swap = { enable = false },
        },
        
        -- Folding: DISABLED (use native folding)
        fold = { enable = false },
    })
end

-- ============================================================================
-- LAZY LOADING TRIGGERS
-- ============================================================================

-- Only load treesitter when actually editing (not just viewing)
local lazy_events = {
    "InsertEnter",
    "CursorHold",
}

local loaded_once = false

for _, event in ipairs(lazy_events) do
    api.nvim_create_autocmd(event, {
        once = true,
        callback = function()
            if not loaded_once then
                loaded_once = true
                vim.defer_fn(load_treesitter, 50) -- Small delay to avoid blocking
            end
        end,
    })
end

-- ============================================================================
-- STATUS COMMAND (Add before textobjects command)
-- ============================================================================

api.nvim_create_user_command('TreesitterStatus', function()
    local bufnr = api.nvim_get_current_buf()
    local size = get_filesize(bufnr)
    local size_kb = size / 1024
    
    local status = {}
    table.insert(status, string.format("File size: %.1f KB", size_kb))
    table.insert(status, string.format("Treesitter loaded: %s", treesitter_loaded and "YES" or "NO"))
    table.insert(status, "")
    
    if size > FILESIZE.DISABLE_HEAVY then
        table.insert(status, "❌ Highlighting: DISABLED (>512KB)")
    else
        table.insert(status, "✅ Highlighting: ENABLED")
    end
    
    if size > FILESIZE.DISABLE_INDENT then
        table.insert(status, "❌ Indentation: DISABLED (>256KB)")
    else
        table.insert(status, "✅ Indentation: ENABLED")
    end
    
    print(table.concat(status, "\n"))
end, {})

-- ============================================================================
-- OPTIONAL: MANUAL TEXTOBJECTS LOADER
-- ============================================================================

-- Create a command to enable textobjects on-demand for smaller files
api.nvim_create_user_command('TreesitterTextobjects', function()
    local bufnr = api.nvim_get_current_buf()
    local size = get_filesize(bufnr)
    
    if size > FILESIZE.DISABLE_INDENT then
        vim.notify(
            string.format("File too large (%.1fKB). Textobjects disabled.", size/1024),
            vim.log.levels.WARN
        )
        return
    end
    
    -- Enable textobjects for current buffer
    require('nvim-treesitter.configs').setup({
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = { ["]m"] = "@function.outer" },
                goto_previous_start = { ["[m"] = "@function.outer" },
            },
        },
    })
    
    vim.notify("Textobjects enabled for current buffer", vim.log.levels.INFO)
end, {})
