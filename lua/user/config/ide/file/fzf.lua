-- Defer the entire telescope setup
vim.defer_fn(function()
    require('fzf-lua').setup({
        winopts = {
            height = 0.85,
            width = 0.80,
            row = 0.35,
            col = 0.50,
            border = 'rounded', -- Rounded borders
            preview = {
                border = 'rounded',
                wrap = 'nowrap',
                hidden = 'nohidden',
                vertical = 'down:45%',
                horizontal = 'right:60%',
                layout = 'flex',
                flip_columns = 120,
            },
        },
        files = {
            prompt = ' ',
            multiprocess = true,
            git_icons = true,
            file_icons = true,
            color_icons = true,
            find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
            rg_opts = "--color=never --files --hidden --follow -g '!.git'",
            fd_opts = '--color=never --type f --hidden --follow --exclude .git',
        },
        grep = {
            prompt = ' ',
            input_prompt = 'Grep  ',
            multiprocess = true,
            git_icons = true,
            file_icons = true,
            color_icons = true,
            rg_opts =
            "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git'",
        },
    })
end, 150) -- Defer by 150ms

-- <leader>tc - Find Neovim config files
vim.keymap.set('n', '<leader>tc', function()
    require('fzf-lua').files({
        cwd = vim.fn.expand('$MYVIMRC'):match('(.*/)'),
        prompt = '< Neovim Config > ',
    })
end, { desc = 'Find config files' })

-- <leader>ts - Find user stage files
vim.keymap.set('n', '<leader>fs', function()
    require('fzf-lua').files({
        cwd = vim.fn.stdpath('config') .. '/lua/user/stages',
        prompt = '< User Stages > ',
    })
end, { desc = 'Find user stage files' })

-- Highly useful
vim.keymap.set('n', '<leader>fc', function()
    require('fzf-lua').live_grep({
        cwd = vim.fn.stdpath('config'),
        prompt = '< Config Grep > ',
    })
end, { desc = 'Grep in Neovim config' })

vim.keymap.set('n' , '<leader>ft', '<cmd>FzfLua diagnostics_workspace<cr>',{
    desc = "Document Dignostic"
})

vim.keymap.set('n' , '<leader>fz', '<cmd>FzfLua<cr>',{
    desc = "Document Dignostic"
})


-- Buffer picker
vim.keymap.set('n', '<leader>fb', function()
    require('fzf-lua').buffers()
end, { desc = 'Find buffers' })

-- CWD file picker (current working directory)
vim.keymap.set('n', '<leader>fd', function()
    require('fzf-lua').files()
end, { desc = 'Find files in CWD' })

-- Additional useful keymaps
vim.keymap.set('n', '<leader>fgc', function()
    require('fzf-lua').live_grep()
end, { desc = 'Live grep in CWD' })

vim.keymap.set('n', '<leader>fo', function()
    require('fzf-lua').oldfiles()
end, { desc = 'Recent files' })

-- Git pickers
vim.keymap.set('n', '<leader>gc', function()
    require('fzf-lua').git_commits()
end, { desc = 'Git commits' })

vim.keymap.set('n', '<leader>gs', function()
    require('fzf-lua').git_status()
end, { desc = 'Git status' })


-- Smart system-aware fzf.lua configuration
-- Automatically detects Termux, standard Linux, or other systems

local function get_system_home()
  -- Check if running in Termux
  if vim.fn.getenv("TERMUX_VERSION") ~= vim.NIL then
    return "/data/data/com.termux/files/home"
  end
  
  -- Check if PREFIX exists (another Termux indicator)
  local prefix = vim.fn.getenv("PREFIX")
  if prefix ~= vim.NIL and prefix:match("com%.termux") then
    return "/data/data/com.termux/files/home"
  end
  
  -- For standard Linux/Unix systems, use $HOME
  local home = vim.fn.getenv("HOME")
  if home ~= vim.NIL then
    return home
  end
  
  -- Fallback to current directory
  return vim.fn.getcwd()
end

local function get_system_root()
  -- Check if running in Termux
  if vim.fn.getenv("TERMUX_VERSION") ~= vim.NIL or 
     (vim.fn.getenv("PREFIX") ~= vim.NIL and vim.fn.getenv("PREFIX"):match("com%.termux")) then
    return "/data/data/com.termux/files"
  end
  
  -- For standard systems, use root
  return "/"
end

-- Setup fzf.lua keymaps
local fzf = require('fzf-lua')

-- Keymap: Search files in system home
vim.keymap.set('n', '<leader>fih', function()
  local home = get_system_home()
  fzf.files({ cwd = home })
end, { desc = 'Find files in system home' })

-- Keymap: Search all files from system root (use with caution)
vim.keymap.set('n', '<leader>fir', function()
  local root = get_system_root()
  fzf.files({ cwd = root })
end, { desc = 'Find files from system root' })

-- Keymap: Grep in system home
vim.keymap.set('n', '<leader>fgh', function()
  local home = get_system_home()
  fzf.live_grep({ cwd = home })
end, { desc = 'Live grep in system home' })

-- Keymap: Grep in system root
vim.keymap.set('n', '<leader>fgr', function()
  local root = get_system_root()
  fzf.live_grep({ cwd = root })
end, { desc = 'Live grep in system root' })

-- Keymap: Show system info
vim.keymap.set('n', '<leader>fgi', function()
  local home = get_system_home()
  local root = get_system_root()
  local is_termux = vim.fn.getenv("TERMUX_VERSION") ~= vim.NIL
  
  local msg = string.format(
    "System Info:\n" ..
    "Environment: %s\n" ..
    "Home: %s\n" ..
    "Root: %s",
    is_termux and "Termux" or "Standard Linux",
    home,
    root
  )
  
  vim.notify(msg, vim.log.levels.INFO)
end, { desc = 'Show system information' })

