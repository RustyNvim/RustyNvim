-- Smart and toggleable diagnostic configuration for Neovim
-- Universal solution for ALL LSP servers

-- Create augroup for cleanup
local diagnostic_group = vim.api.nvim_create_augroup("CustomDiagnostics", { clear = true })

-- State variables
local diagnostics_state = {
    enabled = true,
    virtual_text = false,
    signs = true,
    underline = true,
    auto_popup = true,
    update_in_insert = false,
}

-- Apply diagnostic configuration
local function apply_diagnostic_config()
    vim.diagnostic.config({
        update_in_insert = diagnostics_state.update_in_insert,
        severity_sort = true,
        virtual_text = diagnostics_state.virtual_text and {
            spacing = 4,
            prefix = '●',
            severity = {
                min = vim.diagnostic.severity.HINT,
            },
        } or false,
        signs = diagnostics_state.signs and {
            text = {
                [vim.diagnostic.severity.ERROR] = "󰅙",
                [vim.diagnostic.severity.WARN]  = "󰀩",
                [vim.diagnostic.severity.HINT]  = "󰋼",
                [vim.diagnostic.severity.INFO]  = "󰌵",
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            },
        } or false,
        underline = diagnostics_state.underline,
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = function(diagnostic, i, total)
                local severity = diagnostic.severity
                local prefix_map = {
                    [vim.diagnostic.severity.ERROR] = "[E] ",
                    [vim.diagnostic.severity.WARN] = "[W] ",
                    [vim.diagnostic.severity.HINT] = "[H] ",
                    [vim.diagnostic.severity.INFO] = "[I] ",
                }
                return i .. ". " .. (prefix_map[severity] or ""),
                    "DiagnosticFloating" .. vim.diagnostic.severity[severity]
            end,
        },
    })

    if not diagnostics_state.enabled then
        vim.diagnostic.disable()
    else
        vim.diagnostic.enable()
    end
end

-- Initialize configuration
apply_diagnostic_config()

-- Auto-show diagnostics ONLY in Normal mode
local function setup_auto_popup()
    -- Clear ALL autocmds in the group
    vim.api.nvim_clear_autocmds({ group = diagnostic_group, event = "CursorHold" })

    if diagnostics_state.auto_popup and diagnostics_state.enabled then
        vim.api.nvim_create_autocmd("CursorHold", {
            group = diagnostic_group,
            pattern = "*",
            callback = function()
                local mode = vim.api.nvim_get_mode().mode
                -- Don't open if ANY floating window is already open
                if mode == 'n' then
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_config(win).relative ~= "" then
                            return -- A floating window is open, don't interfere
                        end
                    end
                    
                    vim.diagnostic.open_float(nil, {
                        focus = false,
                        scope = "cursor",
                        border = "rounded",
                    })
                end
            end,
        })
    end
end

setup_auto_popup()

-- Reduce delay for cursor hold
vim.opt.updatetime = 300

-- Toggle functions
local function toggle_diagnostics()
    diagnostics_state.enabled = not diagnostics_state.enabled
    apply_diagnostic_config()
    setup_auto_popup()
    vim.notify('Diagnostics: ' .. (diagnostics_state.enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_virtual_text()
    diagnostics_state.virtual_text = not diagnostics_state.virtual_text
    apply_diagnostic_config()
    vim.notify('Virtual text: ' .. (diagnostics_state.virtual_text and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_signs()
    diagnostics_state.signs = not diagnostics_state.signs
    apply_diagnostic_config()
    vim.notify('Diagnostic signs: ' .. (diagnostics_state.signs and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_underline()
    diagnostics_state.underline = not diagnostics_state.underline
    apply_diagnostic_config()
    vim.notify('Diagnostic underline: ' .. (diagnostics_state.underline and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_auto_popup()
    diagnostics_state.auto_popup = not diagnostics_state.auto_popup
    setup_auto_popup()
    vim.notify('Auto popup: ' .. (diagnostics_state.auto_popup and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_update_in_insert()
    diagnostics_state.update_in_insert = not diagnostics_state.update_in_insert
    apply_diagnostic_config()
    vim.notify('Update in insert: ' .. (diagnostics_state.update_in_insert and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

-- Cycle through diagnostic modes
local diagnostic_modes = {
    { name = "Full",    enabled = true,  virtual_text = false, signs = true,  underline = true,  auto_popup = false },
    { name = "Minimal", enabled = true,  virtual_text = false, signs = true,  underline = false, auto_popup = false },
    { name = "Silent",  enabled = true,  virtual_text = false, signs = false, underline = false, auto_popup = false },
    { name = "Off",     enabled = false, virtual_text = false, signs = false, underline = false, auto_popup = false },
}
local current_mode = 1

local function cycle_diagnostic_mode()
    current_mode = (current_mode % #diagnostic_modes) + 1
    local mode = diagnostic_modes[current_mode]

    diagnostics_state.enabled = mode.enabled
    diagnostics_state.virtual_text = mode.virtual_text
    diagnostics_state.signs = mode.signs
    diagnostics_state.underline = mode.underline
    diagnostics_state.auto_popup = mode.auto_popup

    apply_diagnostic_config()
    setup_auto_popup()
    vim.notify('Diagnostic mode: ' .. mode.name, vim.log.levels.INFO)
end

-- Manual diagnostic popup
local function show_diagnostic_popup()
    vim.diagnostic.open_float(nil, {
        focus = false,
        scope = "cursor",
        border = "rounded",
    })
end

-- Create user commands
vim.api.nvim_create_user_command('ToggleDiagnostics', toggle_diagnostics, { desc = 'Toggle all diagnostics' })
vim.api.nvim_create_user_command('ToggleVirtualText', toggle_virtual_text, { desc = 'Toggle diagnostic virtual text' })
vim.api.nvim_create_user_command('ToggleSigns', toggle_signs, { desc = 'Toggle diagnostic signs' })
vim.api.nvim_create_user_command('ToggleUnderline', toggle_underline, { desc = 'Toggle diagnostic underline' })
vim.api.nvim_create_user_command('ToggleAutoPopup', toggle_auto_popup, { desc = 'Toggle auto diagnostic popup' })
vim.api.nvim_create_user_command('ToggleUpdateInInsert', toggle_update_in_insert, { desc = 'Toggle update in insert mode' })
vim.api.nvim_create_user_command('CycleDiagnosticMode', cycle_diagnostic_mode, { desc = 'Cycle through diagnostic modes' })
vim.api.nvim_create_user_command('ShowDiagnostic', show_diagnostic_popup, { desc = 'Show diagnostic popup' })

-- Diagnostics Toggles
vim.keymap.set('n', '<leader>udt', toggle_diagnostics, { desc = 'Toggle All Diagnostics' })
vim.keymap.set('n', '<leader>udm', cycle_diagnostic_mode, { desc = 'Cycle Diagnostic Mode' })
vim.keymap.set('n', '<leader>udv', toggle_virtual_text, { desc = 'Toggle Virtual Text' })
vim.keymap.set('n', '<leader>uds', toggle_signs, { desc = 'Toggle Signs' })
vim.keymap.set('n', '<leader>udu', toggle_underline, { desc = 'Toggle Underline' })
vim.keymap.set('n', '<leader>udp', toggle_auto_popup, { desc = 'Toggle Auto Popup' })
vim.keymap.set('n', '<leader>udi', toggle_update_in_insert, { desc = 'Toggle Update in Insert' })
vim.keymap.set('n', '<leader>udS', show_diagnostic_popup, { desc = 'Show Diagnostic' })
vim.keymap.set('n', 'gl', show_diagnostic_popup, { desc = 'Show Line Diagnostic' })

-- Diagnostic count in statusline
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
    group = diagnostic_group,
    pattern = "*",
    callback = function()
        local diagnostics = vim.diagnostic.get(0)
        local count = { error = 0, warn = 0, info = 0, hint = 0 }
        for _, diagnostic in ipairs(diagnostics) do
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
                count.error = count.error + 1
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                count.warn = count.warn + 1
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                count.info = count.info + 1
            elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                count.hint = count.hint + 1
            end
        end
        vim.b.diagnostic_count = count
    end,
})

-- ============================================================================
-- UNIVERSAL LSP DIAGNOSTIC HANDLER
-- Works with ALL LSP servers: rust-analyzer, tsserver, pyright, lua_ls, etc.
-- ============================================================================

-- Track buffers that have LSP attached to avoid duplicate autocmds
local lsp_attached_buffers = {}

vim.api.nvim_create_autocmd("LspAttach", {
    group = diagnostic_group,
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        
        if not client then return end
        
        -- Skip if we've already set up this buffer
        if lsp_attached_buffers[bufnr] then return end
        lsp_attached_buffers[bufnr] = true
        
        -- Create a unique buffer-local augroup
        local buf_group_name = "LSPDiagnostics_" .. bufnr
        local buf_group = vim.api.nvim_create_augroup(buf_group_name, { clear = true })
        
        -- Clean up when buffer is deleted
        vim.api.nvim_create_autocmd("BufDelete", {
            buffer = bufnr,
            once = true,
            callback = function()
                lsp_attached_buffers[bufnr] = nil
                pcall(vim.api.nvim_del_augroup_by_name, buf_group_name)
            end,
        })
        
        -- Only set up refresh triggers if diagnostics are enabled
        if not diagnostics_state.enabled then return end
        
        -- Universal approach: Let LSP handle its own diagnostic timing
        -- We just ensure the display settings are applied when diagnostics arrive
        
        -- Refresh display after leaving insert mode (for all LSPs)
        vim.api.nvim_create_autocmd("InsertLeave", {
            group = buf_group,
            buffer = bufnr,
            callback = function()
                if diagnostics_state.enabled and vim.api.nvim_buf_is_valid(bufnr) then
                    -- Just redraw the existing diagnostics with current settings
                    -- Don't request new ones - LSP will send them automatically
                    local ns = vim.diagnostic.get_namespaces()
                    for _, namespace_id in pairs(ns) do
                        local diags = vim.diagnostic.get(bufnr, { namespace = namespace_id })
                        if #diags > 0 then
                            vim.diagnostic.show(namespace_id, bufnr, diags, {})
                        end
                    end
                end
            end,
        })
        
        -- Refresh display after saving (for all LSPs)
        vim.api.nvim_create_autocmd("BufWritePost", {
            group = buf_group,
            buffer = bufnr,
            callback = function()
                if diagnostics_state.enabled and vim.api.nvim_buf_is_valid(bufnr) then
                    -- Small delay to let LSP process the save
                    vim.defer_fn(function()
                        if vim.api.nvim_buf_is_valid(bufnr) then
                            local ns = vim.diagnostic.get_namespaces()
                            for _, namespace_id in pairs(ns) do
                                local diags = vim.diagnostic.get(bufnr, { namespace = namespace_id })
                                if #diags > 0 then
                                    vim.diagnostic.show(namespace_id, bufnr, diags, {})
                                end
                            end
                        end
                    end, 100)
                end
            end,
        })
    end,
})

-- Manual refresh command (works for all LSP servers)
vim.api.nvim_create_user_command('DiagnosticRefresh', function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_is_valid(bufnr) then
        local ns = vim.diagnostic.get_namespaces()
        for _, namespace_id in pairs(ns) do
            local diags = vim.diagnostic.get(bufnr, { namespace = namespace_id })
            vim.diagnostic.show(namespace_id, bufnr, diags, {})
        end
        vim.notify('Diagnostics refreshed', vim.log.levels.INFO)
    end
end, { desc = 'Force refresh diagnostic display' })

vim.keymap.set('n', '<leader>udr', '<cmd>DiagnosticRefresh<CR>', { desc = 'Refresh Diagnostics' })

-- Optional: Add a command to check LSP diagnostic status
vim.api.nvim_create_user_command('DiagnosticInfo', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    
    if #clients == 0 then
        vim.notify('No LSP clients attached', vim.log.levels.WARN)
        return
    end
    
    local info = { 'LSP Diagnostic Info:', '' }
    for _, client in ipairs(clients) do
        table.insert(info, string.format('Client: %s', client.name))
        local ns = vim.lsp.diagnostic.get_namespace(client.id)
        local diags = vim.diagnostic.get(bufnr, { namespace = ns })
        table.insert(info, string.format('  Diagnostics: %d', #diags))
    end
    
    table.insert(info, '')
    table.insert(info, string.format('Total diagnostics: %d', #vim.diagnostic.get(bufnr)))
    table.insert(info, string.format('Enabled: %s', diagnostics_state.enabled))
    table.insert(info, string.format('Signs: %s', diagnostics_state.signs))
    table.insert(info, string.format('Underline: %s', diagnostics_state.underline))
    
    vim.notify(table.concat(info, '\n'), vim.log.levels.INFO)
end, { desc = 'Show LSP diagnostic information' })

vim.keymap.set('n', '<leader>udi', '<cmd>DiagnosticInfo<CR>', { desc = 'Diagnostic Info' })
