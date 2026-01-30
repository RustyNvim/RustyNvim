require('which-key').setup({
    preset = 'modern',
    delay = 200,

    -- This is the key part - which-key should NEVER trigger in insert mode
    modes = {
        n = true,  -- Normal mode
        v = true,  -- Visual mode
        o = true,  -- Operator pending
        i = false, -- INSERT MODE - explicitly disable
        c = false, -- Command line
    },

    win = {
        border = 'rounded',
        wo = { winblend = 0 },
    },

    icons = {
        mappings = true, -- Disable for performance
    },
})
-- ============================================
-- Which-Key Configuration
-- Clean, organized keymaps for better workflow
-- ============================================


-- ============================================
-- Leader Key Groups
-- ============================================
-- ============================================
-- Which-Key Configuration
-- Clean, organized keymaps for better workflow
-- ============================================

local wk = require('which-key')

-- ============================================
-- Leader Key Groups with Named Categories
-- ============================================
-- WARNING: : You are not allowed to add amy other groups outside these like A group will and must not exist standalone!
-- WARNING  : You can only add groups inside these Big Groups only as a Child Groups like leader aA
-- WARNING  : If a Group is useless only delete the items inside it !
-- NOTE:    : Must verify your keymappings before publishing them out & you are not allowed to ruin them !
-- NOTE:    : MUST add FIXED todo like this but here in capital only -->  -- Fixed:
-- NOTE:    : Do only stay inside the wk.add({ ....... }) table !

wk.add({
    -- ===============
    -- a/A Group
    -- ===============
    -- WARN: Let it be single
    { '<leader>a',   group = 'Absolute Path' },
    { '<leader>as',  '<Cmd>ASToggle<CR>',                       desc = 'Auto-Save-Toggle' },
    -- ===============
    -- B/b Group
    -- ===============
    { '<leader>b',   group = 'Buffers' },
    { '<leader>bs',  '<Cmd>w<CR>',                              desc = 'Save' },
    { '<leader>bc',  '<Cmd>%d<CR>',                             desc = 'Clean current buffer data' },
    { '<leader>bd',  '<Cmd>bdelete<CR>',                        desc = 'Delete Current Buffer' },

    -- ===============
    -- D/d Group
    -- ===============
    { '<leader>d',   group = 'Diagonastics' },
    { '<leader>dr',  '<Cmd>Trouble diagnostics<CR>',            desc = 'Diagnostics Report' },
    { 'll',  '<Cmd>lua vim.diagnostic.goto_next()<CR>', desc = 'Next Diagnostic' },
    { 'hh',  '<Cmd>lua vim.diagnostic.goto_prev()<CR>', desc = 'Previous Diagnostic' },

    -- ===============
    -- Git
    -- ===============
    { '<leader>g',   group = 'Git' },
    { '<leader>gl',  '<cmd>LazyGit<cr>',                        desc = 'Lazy Git' },
    -- ===============
    -- Help
    -- ===============

    { '<leader>h',   group = 'Help' },
    -- ===============
    -- LSP
    -- ===============

    { '<leader>n',   group = 'Notify' },
    { '<leader>nh',  '<Cmd>lua MiniNotify.show_history()<CR>',  desc = 'Notification history' },
    { '<leader>nc',  '<Cmd>lua MiniNotify.clear()<CR>',         desc = 'Clear notifications' },
    { '<leader>nr',  '<Cmd>lua MiniNotify.refresh()<CR>',       desc = 'Refresh notifications' },

    -- ===============
    -- Messages/Notifications
    -- ===============
    { '<leader>m',   group = 'Messages' },
    { '<leader>mm',  '<Cmd>messages<CR>',                       desc = 'Show Messages' },
    { '<leader>mn',  '<Cmd>Telescope notify<CR>',               desc = 'Notifications' },
    { '<leader>me',  '<Cmd>Noice errors<CR>',                   desc = 'Errors (Noice)' },
    { '<leader>mc',  '<Cmd>messages clear<CR>',                 desc = 'Clear Messages' },
    { '<leader>my',  '<Cmd>%y+<CR>',                            desc = 'Yank All' },
    -- Paste
    { '<leader>mp',  group = 'Paste' },
    { '<leader>mpa', '"+p',                                     desc = 'After Cursor' },
    { '<leader>mpb', '"+P',                                     desc = 'Before Cursor' },


    -- ===============
    -- Project
    -- ===============
    { '<leader>p',   group = 'Project' },

    -- ===============
    -- Quit
    -- ===============
    -- Quit & Save
    { '<leader>q',   group = 'Quit' },

    { '<leader>qq',  '<Cmd>q<CR>',                              desc = 'Quit' },
    { '<leader>qf',  group = 'Force Quit' },
    { '<leader>qfq', '<Cmd>q!<CR>',                             desc = 'Force Quit' },
    { '<leader>qfa', '<Cmd>qa<CR>',                             desc = 'Force Quit All' },
    { '<leader>qfw', '<Cmd>qa!<CR>',                            desc = 'Force Quit All' },

    -- ===============
    -- Replace/Substitute
    -- ===============
    { "<leader>r",    group = "Reload/Substitute" },
    { "<leader>rr",    group = "Reload" },
    { "<leader>rs",    group = "Substitute" },
    -- ===============
    -- Sessions --> Refrence to /path/to/IdeBatch/Sessions.lua
    -- ===============
    { '<leader>s',   group = 'Session' },
    -- ===============
    -- Undo  --> Refrence to /path/to/IdeBatch/undotree.lua
    -- ===============
    { '<leader>u',   group = 'Toggle' },
    { '<leader>ui',  '<Cmd>IBLToggle<CR>',                      desc = 'Indent Lines' },
    { '<leader>un',  '<Cmd>set number!<CR>',                    desc = 'Line Numbers' },
    { '<leader>ur',  '<Cmd>set relativenumber!<CR>',            desc = 'Relative Numbers' },
    { '<leader>uw',  '<Cmd>set wrap!<CR>',                      desc = 'Word Wrap' },
    { '<leader>us',  '<Cmd>set spell!<CR>',                     desc = 'Spell Check' },
    { '<leader>ul',  '<Cmd>set list!<CR>',                      desc = 'List Chars' },
    { '<leader>uc',  '<Cmd>set cursorline!<CR>',                desc = 'Cursor Line' },
    { '<leader>uh',  '<Cmd>set hlsearch!<CR>',                  desc = 'Highlight Search' },


    -- ===============
    -- Visual Mode Group
    -- ===============
    -- ===============
    -- Save
    -- ===============
    { '<leader>w',   group = 'Save' },
    { '<leader>wq',  '<Cmd>wq<CR>',                             desc = 'Save & Quit current buffer' },
    { '<leader>ws',  '<cmd>wall<cr>',                           desc = 'Save all' },

    { '<leader>wf',  group = 'Force save' },

    { '<leader>wfs', '<cmd>w!<cr>',                             desc = 'Force save' },
    { '<leader>wfS', '<cmd>wall!<cr>',                          desc = 'Force Save all' },
    { '<leader>wfa', '<cmd>wqall!<cr>',                         desc = 'Forece Save & Quit all' },
    -- ===============
    -- Yank
    -- ===============
    { '<leader>ya',  '<Cmd>%y+<CR>',                            desc = 'Yank All' },
    { '<leader>yp',  "<Cmd>let @+ = expand('%:p')<CR>",         desc = 'Yank File Path' },
    { '<leader>yf',  "<Cmd>let @+ = expand('%:t')<CR>",         desc = 'Yank File Name' },
})

-- ============================================
-- Visual/Select Mode Mappings
-- ============================================
wk.add({
    mode = { 'v', 'x' },
    { '<leader>r',  group = 'Replace' },
    { '<leader>rs', ':s///g<Left><Left>', desc = 'In Selection' },
    { '<leader>y',  '"+y',                desc = 'Yank to Clipboard' },
})

-- ============================================
-- Helper Functions (if not already defined)
-- ============================================

-- Replace in entire file
function SubstituteAll()
    local search = vim.fn.input('Search: ')
    if search == '' then return end
    local replace = vim.fn.input('Replace with: ')
    vim.cmd(string.format('%%s/%s/%s/g', search, replace))
end

-- Replace in matching lines
function SubstituteMatchingLines()
    local pattern = vim.fn.input('Match pattern: ')
    if pattern == '' then return end
    local search = vim.fn.input('Search: ')
    if search == '' then return end
    local replace = vim.fn.input('Replace with: ')
    vim.cmd(string.format('g/%s/s/%s/%s/g', pattern, search, replace))
end

-- Replace in range
function SubstituteRange()
    local start_line = vim.fn.input('Start line: ')
    if start_line == '' then return end
    local end_line = vim.fn.input('End line: ')
    if end_line == '' then return end
    local search = vim.fn.input('Search: ')
    if search == '' then return end
    local replace = vim.fn.input('Replace with: ')
    vim.cmd(string.format('%s,%ss/%s/%s/g', start_line, end_line, search, replace))
end

-- ============================================
-- Troubleshooting Note
-- ============================================
-- If Trouble diagnostics doesn't open, ensure:
-- 1. Trouble.nvim is installed: require("trouble").setup()
-- 2. Run :checkhealth trouble
-- 3. Try: :Trouble diagnostics toggle
-- 4. Alternative: Use <leader>dr for direct command
