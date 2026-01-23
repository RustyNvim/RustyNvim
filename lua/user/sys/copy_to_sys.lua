-- Detect clipboard provider ONCE at startup (fast)
local function detect_clipboard_command()
    if vim.fn.executable('termux-clipboard-set') == 1 then
        return 'termux-clipboard-set'
    elseif vim.fn.executable('xclip') == 1 then
        return 'xclip -selection clipboard'
    elseif vim.fn.executable('xsel') == 1 then
        return 'xsel --clipboard --input'
    elseif vim.fn.executable('wl-copy') == 1 then
        return 'wl-copy'
    elseif vim.fn.executable('pbcopy') == 1 then
        return 'pbcopy'
    elseif vim.fn.executable('clip.exe') == 1 then
        return 'clip.exe'
    end
    return nil
end

local clipboard_cmd = detect_clipboard_command()

-- Manual keybinding - only copies when you want it
if clipboard_cmd then
    vim.keymap.set({ 'n', 'v' }, '<leader>y', function()
        -- Yank to unnamed register first (fast, local operation)
        vim.cmd('normal! "zy')
        local text = vim.fn.getreg('z')
        -- Then copy to system clipboard asynchronously
        vim.fn.jobstart(clipboard_cmd, {
            stdin = 'pipe',
            on_stdin = function(_, _, _)
                return { text }
            end,
        })
    end, { silent = true, desc = 'Copy to system clipboard' })
end

-- DON'T set unnamedplus - this is what causes slowdown
-- vim.opt.clipboard = 'unnamedplus'  -- REMOVE THIS LINE
