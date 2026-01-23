-- Neovim Autosave Plugin with LSP/Conform Integration
-- Place this in ~/.config/nvim/lua/autosave.lua

local M = {}

-- Default configuration
M.config = {
    enabled = true,
    allow = { "all" }, -- {"rust", "python", "lua"} or {"all"}
    disallow = {},     -- Disallowed by default
    -- disallow = { "c", "cpp" }, -- Disallowed by default
    speed = 100,       -- Delay in milliseconds (0 for instant)
    mode = "n",        -- normal mode only

    -- Advanced options
    format_on_save = true,       -- Trigger formatting (Conform/LSP)
    reload_diagnostics = false,   -- Reload diagnostics after save
    debounce = true,             -- Use debouncing to avoid excessive saves
    notify = false,              -- Show notification on autosave
    exclude_ft_from_format = {}, -- Filetypes to skip formatting: {"markdown", "text"}

    -- Integration settings
    use_conform = true,    -- Use conform.nvim if available
    use_lsp_format = true, -- Fallback to LSP formatting
}

-- State
local timer = nil
local autocmd_id = nil
local last_save_time = {}
local is_saving = false

-- Check if current filetype is allowed
local function is_filetype_allowed()
    local ft = vim.bo.filetype

    if ft == "" then
        return false
    end

    -- Check disallow list first
    for _, disallowed in ipairs(M.config.disallow) do
        if disallowed == "all" then
            return false
        end
        if ft == disallowed then
            return false
        end
    end

    -- Check allow list
    for _, allowed in ipairs(M.config.allow) do
        if allowed == "all" then
            return true
        end
        if ft == allowed then
            return true
        end
    end

    return false
end

-- Check if buffer can be saved
local function can_save_buffer()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Prevent recursive saves
    if is_saving then
        return false
    end

    -- Check if buffer is modifiable and modified
    if not vim.bo[bufnr].modifiable then
        return false
    end

    if not vim.bo[bufnr].modified then
        return false
    end

    -- Check if buffer has a valid filename
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == "" or filename:match("^term://") then
        return false
    end

    -- Check if in normal mode
    local mode = vim.api.nvim_get_mode().mode
    if mode ~= M.config.mode then
        return false
    end

    -- Check filetype
    if not is_filetype_allowed() then
        return false
    end

    -- Check if too soon since last save (debounce)
    if M.config.debounce then
        local current_time = vim.loop.hrtime()
        local last_time = last_save_time[bufnr] or 0
        local time_diff = (current_time - last_time) / 1e6 -- Convert to ms

        if time_diff < M.config.speed then
            return false
        end
    end

    return true
end

-- Check if filetype should skip formatting
local function should_format()
    if not M.config.format_on_save then
        return false
    end

    local ft = vim.bo.filetype
    for _, excluded_ft in ipairs(M.config.exclude_ft_from_format) do
        if ft == excluded_ft then
            return false
        end
    end

    return true
end

-- Format buffer using Conform or LSP
local function format_buffer(bufnr)
    if not should_format() then
        return
    end

    -- Try conform.nvim first
    if M.config.use_conform then
        local ok, conform = pcall(require, "conform")
        if ok then
            conform.format({
                bufnr = bufnr,
                timeout_ms = 500,
                lsp_fallback = M.config.use_lsp_format,
                quiet = true,
            })
            return
        end
    end

    -- Fallback to LSP formatting
    if M.config.use_lsp_format then
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, client in ipairs(clients) do
            if client.server_capabilities.documentFormattingProvider then
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    timeout_ms = 500,
                    async = false,
                })
                return
            end
        end
    end
end

-- Perform autosave with formatting and diagnostics
local function autosave()
    if not M.config.enabled then
        return
    end

    if not can_save_buffer() then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()

    -- Set saving flag to prevent recursion
    is_saving = true

    -- Store cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local view = vim.fn.winsaveview()

    -- Format before save
    format_buffer(bufnr)

    -- Save the buffer (this triggers BufWritePre, BufWritePost, etc.)
    local success = pcall(function()
        vim.cmd("silent write")
    end)

    if success then
        -- Update last save time
        last_save_time[bufnr] = vim.loop.hrtime()

        -- Keep these commented as they can cause trouble in lsp diagnostic updates 
        -- Reload diagnostics if configured
        -- if M.config.reload_diagnostics then
        --     vim.defer_fn(function()
        --         vim.diagnostic.reset()
        --         -- Turn this off to prevent errors in Marksman or Godot
        --         -- vim.lsp.buf.document_highlight()
        --     end, 50)
        -- end

        -- Show notification if configured
        if M.config.notify then
            vim.notify("Autosaved: " .. vim.fn.expand("%:t"), vim.log.levels.INFO, {
                title = "Autosave",
                timeout = 500,
            })
        end

        -- Restore cursor and view
        pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
        pcall(vim.fn.winrestview, view)
    end

    -- Reset saving flag
    is_saving = false
end

-- Debounced autosave
local function schedule_autosave()
    if timer then
        timer:stop()
    end

    if M.config.speed == 0 then
        autosave()
    else
        timer = vim.defer_fn(autosave, M.config.speed)
    end
end

-- Setup autocmds
local function setup_autocmds()
    if autocmd_id then
        vim.api.nvim_del_augroup_by_id(autocmd_id)
    end

    autocmd_id = vim.api.nvim_create_augroup("AutosaveIntegrated", { clear = true })

    -- Trigger on text changes
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = autocmd_id,
        callback = function()
            if M.config.enabled and not is_saving then
                schedule_autosave()
            end
        end,
    })

    -- Additional trigger on leaving insert mode
    vim.api.nvim_create_autocmd("InsertLeave", {
        group = autocmd_id,
        callback = function()
            if M.config.enabled and not is_saving then
                schedule_autosave()
            end
        end,
    })

    -- Clean up last_save_time on buffer delete
    vim.api.nvim_create_autocmd("BufDelete", {
        group = autocmd_id,
        callback = function(args)
            last_save_time[args.buf] = nil
        end,
    })
end

-- Toggle autosave
function M.toggle()
    M.config.enabled = not M.config.enabled

    if M.config.enabled then
        vim.notify("Autosave enabled (with formatting)", vim.log.levels.INFO)
    else
        vim.notify("Autosave disabled", vim.log.levels.INFO)
        if timer then
            timer:stop()
            timer = nil
        end
    end
end

-- Toggle formatting on autosave
function M.toggle_format()
    M.config.format_on_save = not M.config.format_on_save
    vim.notify(
        "Autosave formatting: " .. (M.config.format_on_save and "enabled" or "disabled"),
        vim.log.levels.INFO
    )
end

-- Toggle notifications
function M.toggle_notify()
    M.config.notify = not M.config.notify
    vim.notify(
        "Autosave notifications: " .. (M.config.notify and "enabled" or "disabled"),
        vim.log.levels.INFO
    )
end

-- Get status for statusline
function M.status()
    if not M.config.enabled then
        return ""
    end

    local icon = M.config.format_on_save and "💾✨" or "💾"
    return icon
end

-- Setup function
function M.setup(opts)
    -- Merge user config with defaults
    if opts then
        M.config = vim.tbl_deep_extend("force", M.config, opts)
    end

    -- Setup autocmds
    setup_autocmds()

    -- Create user commands
    vim.api.nvim_create_user_command("AutosaveToggle", M.toggle, {})
    vim.api.nvim_create_user_command("AutosaveToggleFormat", M.toggle_format, {})
    vim.api.nvim_create_user_command("AutosaveToggleNotify", M.toggle_notify, {})

    -- Setup keybindings
    vim.keymap.set("n", "U", M.toggle, {
        desc = "Toggle Autosave",
        silent = true
    })
    vim.keymap.set("n", "Ft", M.toggle_format, {
        desc = "Qucik Formattting Toggle",
        silent = true
    })

    vim.keymap.set("n", "<leader>as", M.toggle, {
        desc = "Toggle Autosave",
        silent = true
    })

    vim.keymap.set("n", "<leader>af", M.toggle_format, {
        desc = "Toggle Autosave Formatting",
        silent = true
    })

    vim.keymap.set("n", "<leader>an", M.toggle_notify, {
        desc = "Toggle Autosave Notifications",
        silent = true
    })
end

return M
