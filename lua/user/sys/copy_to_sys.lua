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
  local has_fzf, fzf = pcall(require, "fzf-lua")

  if has_fzf then
    fzf.fzf_exec(
      -- source
      vim.tbl_map(function(item)
        return item.display
      end, registers),

      {
        prompt = "Registers> ",
        winopts = {
          height = 0.4,
          width = 0.6,
          preview = {
            hidden = "hidden",
          },
        },

        actions = {
          ["default"] = function(selected)
            if not selected or #selected == 0 then
              return
            end

            local chosen_display = selected[1]

            for _, item in ipairs(registers) do
              if item.display == chosen_display then
                callback(item)
                return
              end
            end
          end,
        },
      }
    )

  else
    -- Fallback: vim.ui.select
    vim.ui.select(registers, {
      prompt = "Select register:",
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
vim.keymap.set({'n', 'v'}, '<leader>yt', function()
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
    desc = 'Recent most Yank to clipboard' 
})

-- 2. <leader>cp - Open yank picker to select from registers
vim.keymap.set('n', '<leader>yp', function()
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
    desc = 'Pick register to yank to system' 
})

-- 3. <leader>pp - Paste last copied item from system clipboard
vim.keymap.set('n', '<leader>ppp', function()
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
vim.keymap.set('n', '<leader>ppk', function()
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
