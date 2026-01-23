-- Smart Clipboard System - Fixed and Simple
-- No async delays, works with Termux, uses telescope for pickers

-- ============================================================================
-- SMART CLIPBOARD DETECTION
-- ============================================================================
local function detect_clipboard()
    local systems = {
        {
            name = 'Termux',
            check = function()
                return vim.fn.executable('termux-clipboard-set') == 1
            end,
            copy_cmd = 'termux-clipboard-set',
            paste_cmd = 'termux-clipboard-get',
        },
        {
            name = 'Wayland',
            check = function()
                return vim.fn.executable('wl-copy') == 1
            end,
            copy_cmd = 'wl-copy',
            paste_cmd = 'wl-paste',
        },
        {
            name = 'X11 (xclip)',
            check = function()
                return vim.fn.executable('xclip') == 1
            end,
            copy_cmd = 'xclip -selection clipboard',
            paste_cmd = 'xclip -selection clipboard -o',
        },
        {
            name = 'X11 (xsel)',
            check = function()
                return vim.fn.executable('xsel') == 1
            end,
            copy_cmd = 'xsel --clipboard --input',
            paste_cmd = 'xsel --clipboard --output',
        },
        {
            name = 'macOS',
            check = function()
                return vim.fn.executable('pbcopy') == 1
            end,
            copy_cmd = 'pbcopy',
            paste_cmd = 'pbpaste',
        },
        {
            name = 'Windows/WSL',
            check = function()
                return vim.fn.executable('clip.exe') == 1
            end,
            copy_cmd = 'clip.exe',
            paste_cmd = 'powershell.exe -c Get-Clipboard',
        },
    }
    
    for _, sys in ipairs(systems) do
        if sys.check() then
            vim.notify('Clipboard: ' .. sys.name, vim.log.levels.INFO)
            return sys
        end
    end
    
    vim.notify('No clipboard detected', vim.log.levels.WARN)
    return nil
end

local clipboard = detect_clipboard()

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Copy text to system clipboard (SYNCHRONOUS - no delays!)
local function copy_to_system(text)
    if not clipboard then
        vim.notify('No clipboard available', vim.log.levels.ERROR)
        return false
    end
    
    -- Use vim.fn.system for immediate execution
    local result = vim.fn.system(clipboard.copy_cmd, text)
    local exit_code = vim.v.shell_error
    
    if exit_code == 0 then
        vim.notify('✓ Copied to clipboard', vim.log.levels.INFO)
        return true
    else
        vim.notify('✗ Copy failed: ' .. result, vim.log.levels.ERROR)
        return false
    end
end

-- Paste from system clipboard (SYNCHRONOUS)
local function paste_from_system()
    if not clipboard then
        vim.notify('No clipboard available', vim.log.levels.ERROR)
        return nil
    end
    
    local text = vim.fn.system(clipboard.paste_cmd)
    if vim.v.shell_error == 0 then
        return text
    else
        vim.notify('✗ Paste failed', vim.log.levels.ERROR)
        return nil
    end
end

-- Get all non-empty registers
local function get_registers()
    local registers = {}
    local reg_list = '"0123456789abcdefghijklmnopqrstuvwxyz-+*'
    
    for i = 1, #reg_list do
        local reg = reg_list:sub(i, i)
        local content = vim.fn.getreg(reg)
        if content and content ~= '' then
            local preview = content:gsub('\n', '↵'):sub(1, 80)
            if #content > 80 then
                preview = preview .. '...'
            end
            table.insert(registers, {
                reg = reg,
                content = content,
                display = string.format('[%s] %s', reg, preview),
            })
        end
    end
    
    return registers
end

-- ============================================================================
-- PICKER FUNCTIONS (with fallback if telescope not available)
-- ============================================================================

local function pick_register(registers, callback)
    -- Try telescope first
    local has_telescope, pickers = pcall(require, 'telescope.pickers')
    
    if has_telescope then
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        
        pickers.new({}, {
            prompt_title = 'Registers',
            finder = finders.new_table({
                results = registers,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.display,
                        ordinal = entry.display,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        callback(selection.value)
                    end
                end)
                return true
            end,
        }):find()
    else
        -- Fallback: use vim.ui.select (requires a select UI plugin or uses default)
        vim.ui.select(registers, {
            prompt = 'Select register:',
            format_item = function(item)
                return item.display
            end,
        }, function(choice)
            if choice then
                callback(choice)
            end
        end)
    end
end

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- 1. <leader>ct - Copy most recent yanked item to system clipboard
vim.keymap.set({'n', 'v'}, '<leader>ct', function()
    -- In visual mode, first yank the selection
    if vim.fn.mode():match('[vV]') then
        vim.cmd('normal! y')
    end
    
    local text = vim.fn.getreg('"')
    if text and text ~= '' then
        copy_to_system(text)
    else
        vim.notify('Nothing to copy', vim.log.levels.WARN)
    end
end, { 
    silent = true, 
    desc = 'Copy recent yank to clipboard' 
})

-- 2. <leader>cp - Open yank picker to select from registers
vim.keymap.set('n', '<leader>cp', function()
    local registers = get_registers()
    
    if #registers == 0 then
        vim.notify('No yanked items', vim.log.levels.WARN)
        return
    end
    
    pick_register(registers, function(choice)
        copy_to_system(choice.content)
    end)
end, { 
    silent = true, 
    desc = 'Pick register to copy' 
})

-- 3. <leader>pp - Paste last copied item from system clipboard
vim.keymap.set('n', '<leader>pp', function()
    local text = paste_from_system()
    if text and text ~= '' then
        vim.fn.setreg('+', text)
        vim.cmd('normal! "+p')
        vim.notify('✓ Pasted from clipboard', vim.log.levels.INFO)
    else
        vim.notify('Clipboard is empty', vim.log.levels.WARN)
    end
end, { 
    silent = true, 
    desc = 'Paste from clipboard' 
})

-- 4. <leader>pk - Pick from registers and paste to editor
vim.keymap.set('n', '<leader>pk', function()
    local registers = get_registers()
    
    if #registers == 0 then
        vim.notify('No yanked items', vim.log.levels.WARN)
        return
    end
    
    pick_register(registers, function(choice)
        vim.fn.setreg('+', choice.content)
        vim.cmd('normal! "+p')
        vim.notify('✓ Pasted from [' .. choice.reg .. ']', vim.log.levels.INFO)
    end)
end, { 
    silent = true, 
    desc = 'Pick register to paste' 
})
