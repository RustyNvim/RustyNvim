require("which-key").setup({
    preset = "modern",
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
        border = "single",
        wo = { winblend = 0 },
    },

    icons = {
        mappings = false, -- Disable for performance
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

local wk = require("which-key")

-- ============================================
-- Leader Key Groups with Named Categories
-- ============================================
-- WARNING: : You are not allowed to add amy other groups outside these like A group will and must not exist standalone!
-- WARNING  : You can only add groups inside these Big Groups only as a Child Groups like leader aA
-- WARNING  : If a Group is useless only delete the items inside it !
-- NOTE:    : Must verify your keymappings before publishing them out & you are not allowed to ruin them !
-- NOTE:    : MUST add FIXED todo like this but here in capital only -->  -- Fixed:
-- NOTE:    : Do only stay inside the wk.add({ ....... }) table !
-- NOTE:    : TAKE A LOOK AT ~/.config/nvrush/lua/user/config/IdeBatch/telescope.lua for better understanding of how to add mappings to which key ui even in differemt files !

wk.add({
    -- ===============
    -- a/A Group
    -- ===============
    -- WARN: Let it be single
    { "<leader>a",   group = "Absolute Path" },
    { "<leader>as",  "<Cmd>ASToggle<CR>",                        desc = "Auto-Save-Toggle" },
    -- ===============
    -- B/b Group
    -- ===============
    { "<leader>b",   group = "Buffers" },
    { "<leader>bn",  "<Cmd>BufferLineCycleNext<CR>",             desc = "Next Buffer" },
    { "<leader>bs",  "<Cmd>w<CR>",                               desc = "Save" },
    { "<leader>bc",  "<Cmd>%d<CR>",                              desc = "Clean current buffer data" },
    { "<leader>bp",  "<Cmd>BufferLineCyclePrev<CR>",             desc = "Previous Buffer" },
    { "<leader>bd",  "<Cmd>bdelete<CR>",                         desc = "Delete Current Buffer" },
    { "<leader>bl",  "<Cmd>Telescope buffers<CR>",               desc = "List Buffers (Picker)" },


    -- Commands
    { "<leader>c",   group = "Commands" },
    { "<leader>ca",  "<Cmd>wa<CR>",                              desc = "Save All" },
    { "<leader>cq",  "<Cmd>wall<CR>",                            desc = "Force Save All" },

    -- File Operations
    { "<leader>cf",  group = "File" },
    { "<leader>cfr", "<Cmd>edit!<CR>",                           desc = "Reload Buffer" },
    { "<leader>cfn", "<Cmd>noa w<CR>",                           desc = "Save Without Format" },
    { "<leader>cfe", "<Cmd>!chmod +x %<CR>",                     desc = "Make Executable" },
    { "<leader>cfw", "<Cmd>pwd<CR>",                             desc = "Show Directory" },
    { "<leader>cff", "<Cmd>Format<CR>",                          desc = "Format Buffer" },
    { "<leader>cfx", [[<Cmd>%s/\s\+$//e<CR>]],                   desc = "Trim Whitespace" },
    { "<leader>cft", "<Cmd>retab<CR>",                           desc = "Fix Tabs/Spaces" },

    -- Window Management
    { "<leader>cw",  group = "Window" },
    { "<leader>cwo", "<Cmd>only<CR>",                            desc = "Close Others" },
    { "<leader>cw=", "<Cmd>resize | vertical resize<CR>",        desc = "Equalize Windows" },
    { "<leader>cwt", "<Cmd>tabnew<CR>",                          desc = "New Tab" },

    -- Toggle Options
    { "<leader>ct",  group = "Toggle" },
    { "<leader>ctn", "<Cmd>set number!<CR>",                     desc = "Line Numbers" },
    { "<leader>cti", "<Cmd>set list!<CR>",                       desc = "Invisibles" },
    { "<leader>ctp", "<Cmd>set paste!<CR>",                      desc = "Paste Mode" },
    { "<leader>ctl", "<Cmd>set cursorline!<CR>",                 desc = "Cursor Line" },
    { "<leader>ctc", "<Cmd>set cursorcolumn!<CR>",               desc = "Cursor Column" },
    { "<leader>ctm", "<Cmd>set mouse!<CR>",                      desc = "Mouse" },
    { "<leader>cth", "<Cmd>noh<CR>",                             desc = "Clear Highlight" },

    -- Quick Actions
    { "<leader>cq",  "<Cmd>copen<CR>",                           desc = "Quickfix List" },
    { "<leader>cz",  "zE",                                       desc = "Rebuild Folds" },

    -- ===============
    -- D/d Group
    -- ===============
    { "<leader>d",   group = "Diagonastics" },
    { "<leader>dt",  "<Cmd>Trouble diagnostics toggle<CR>",      desc = "Toggle Trouble" },
    { "<leader>dr",  "<Cmd>Trouble diagnostics<CR>",             desc = "Diagnostics Report" },
    { "<leader>dn",  "<Cmd>lua vim.diagnostic.goto_next()<CR>",  desc = "Next Diagnostic" },
    { "<leader>dp",  "<Cmd>lua vim.diagnostic.goto_prev()<CR>",  desc = "Previous Diagnostic" },

    -- E - File Explorer
    -- WARN: Let it be single
    { "<leader>e",   "<Cmd>NvimTreeToggle<CR>",                  desc = "Explorer" },

    -- ===============
    -- T Group
    -- ===============
    -- { "<leader>t",    group = "Telescope" },
    -- { "<leader>td",   group = "Trouble" },
    -- { "<leader>tdq",  "<Cmd>Trouble quickfix toggle<CR>",        desc = "Quickfix" },
    -- { "<leader>tdl",  "<Cmd>Trouble loclist toggle<CR>",         desc = "Location List" },
    -- { "<leader>tds",  "<Cmd>Trouble symbols toggle<CR>",         desc = "Symbols" },
    --
    -- -- Telescope LSP (nested)
    -- { "<leader>tdr",  "<cmd>Telescope lsp_references<cr>",       desc = "LSP References" },
    -- { "<leader>tdd",  "<cmd>Telescope lsp_definitions<cr>",      desc = "LSP Definitions" },
    --
    -- -- Telescope General
    -- { "<leader>tf",   group = "Files" },
    -- { "<leader>tff",  "<cmd>Telescope find_files<cr>",           desc = "Find files" },
    -- { "<leader>tfc",  "<cmd>Telescope commands<cr>",             desc = "Telescope Commands" },
    -- { "<leader>tfb",  "<cmd>Telescope file_browser<cr>",         desc = "File browser" },
    -- { "<leader>tfg",  "<cmd>Telescope live_grep<cr>",            desc = "Live grep" },
    -- { "<leader>tfb",  "<cmd>Telescope buffers<cr>",              desc = "Buffers" },
    -- { "<leader>tfo",  "<cmd>Telescope oldfiles<cr>",             desc = "Recent files" },
    -- { "<leader>tfk",  "<cmd>Telescope keymaps<cr>",              desc = "Keymaps" },
    -- { "<leader>tft",  "<Cmd>Telescope colorscheme<CR>",          desc = "Themes" },
    -- { "<leader>tfn",  "<Cmd>enew<CR>",                           desc = "New File" },
    -- { "<leader>tfh",  group = "History Search" },
    -- { "<leader>tfhs", "<Cmd>Telescope search_history<CR>",       desc = "Search" },
    -- { "<leader>tfhc", "<Cmd>Telescope command_history<CR>",      desc = "Command" },
    --
    -- -- Telescope Git (nested)
    -- { "<leader>tG",   group = "Git" },
    -- { "<leader>tGs",  "<cmd>Telescope git_status<cr>",           desc = "Git status" },
    -- { "<leader>tGc",  "<cmd>Telescope git_commits<cr>",          desc = "Git commits" },
    -- { "<leader>tGb",  "<cmd>Telescope git_branches<cr>",         desc = "Git branches" },
    --
    -- { "<leader>tg",   group = "Toggle" },
    -- { "<leader>tgi",  "<Cmd>IBLToggle<CR>",                      desc = "Toggle IBL" },
    -- { "<leader>tgn",  "<Cmd>set number!<CR>",                    desc = "Line Numbers" },
    -- { "<leader>tgr",  "<Cmd>set relativenumber!<CR>",            desc = "Relative Numbers" },
    -- { "<leader>tgw",  "<Cmd>set wrap!<CR>",                      desc = "Word Wrap" },
    -- { "<leader>tgs",  "<Cmd>set spell!<CR>",                     desc = "Spell Check" },
    -- { "<leader>tgl",  "<Cmd>set list!<CR>",                      desc = "List Chars" },
    -- { "<leader>tgc",  "<Cmd>set cursorline!<CR>",                desc = "Cursor Line" },
    -- { "<leader>tgh",  "<Cmd>set hlsearch!<CR>",                  desc = "Highlight Search" },

    -- Main Telescope group
    { "<leader>t",   group = "Telescope" },

    -- Find/Search operations
    { "<leader>tf",  group = "Find" },
    { "<leader>tff", "<cmd>Telescope find_files<cr>",            desc = "Files" },
    { "<leader>tfg", "<cmd>Telescope live_grep<cr>",             desc = "Grep" },
    { "<leader>tfb", "<cmd>Telescope buffers<cr>",               desc = "Buffers" },
    { "<leader>tfo", "<cmd>Telescope oldfiles<cr>",              desc = "Recent Files" },
    { "<leader>tfr", "<cmd>Telescope resume<cr>",                desc = "Resume Last" },
    { "<leader>tfw", "<cmd>Telescope grep_string<cr>",           desc = "Word Under Cursor" },

    -- LSP operations
    { "<leader>tl",  group = "LSP" },
    { "<leader>tlr", "<cmd>Telescope lsp_references<cr>",        desc = "References" },
    { "<leader>tld", "<cmd>Telescope lsp_definitions<cr>",       desc = "Definitions" },
    { "<leader>tli", "<cmd>Telescope lsp_implementations<cr>",   desc = "Implementations" },
    { "<leader>tlt", "<cmd>Telescope lsp_type_definitions<cr>",  desc = "Type Definitions" },
    { "<leader>tls", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
    { "<leader>tlw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

    -- Git operations
    { "<leader>tg",  group = "Git" },
    { "<leader>tgs", "<cmd>Telescope git_status<cr>",            desc = "Status" },
    { "<leader>tgc", "<cmd>Telescope git_commits<cr>",           desc = "Commits" },
    { "<leader>tgb", "<cmd>Telescope git_branches<cr>",          desc = "Branches" },
    { "<leader>tgf", "<cmd>Telescope git_files<cr>",             desc = "Files" },

    -- Vim/Editor utilities
    { "<leader>tv",  group = "Vim" },
    { "<leader>tvc", "<cmd>Telescope commands<cr>",              desc = "Commands" },
    { "<leader>tvk", "<cmd>Telescope keymaps<cr>",               desc = "Keymaps" },
    { "<leader>tvh", "<cmd>Telescope help_tags<cr>",             desc = "Help Tags" },
    { "<leader>tvo", "<cmd>Telescope vim_options<cr>",           desc = "Options" },
    { "<leader>tvt", "<cmd>Telescope colorscheme<cr>",           desc = "Themes" },
    { "<leader>tvr", "<cmd>Telescope registers<cr>",             desc = "Registers" },
    { "<leader>tvm", "<cmd>Telescope marks<cr>",                 desc = "Marks" },
    { "<leader>tvj", "<cmd>Telescope jumplist<cr>",              desc = "Jumplist" },
    -- Browser/Explorer
    { "<leader>tb",  "<cmd>Telescope file_browser<cr>",          desc = "File Browser" },

    -- Trouble (diagnostics UI)
    { "<leader>td",  group = "Trouble" },
    { "<leader>tdq", "<Cmd>Trouble quickfix toggle<CR>",         desc = "Quickfix" },
    { "<leader>tdl", "<Cmd>Trouble loclist toggle<CR>",          desc = "Location List" },
    { "<leader>tds", "<Cmd>Trouble symbols toggle<CR>",          desc = "Symbols" },
    -- ===============
    -- Git
    -- ===============
    { "<leader>g",   group = "Git" },
    -- ===============
    -- Help
    -- ===============

    { "<leader>h",   group = "Help" },
    { "<leader>hh",  "<Cmd>Telescope help_tags<CR>",             desc = "Help Tags" },
    { "<leader>hm",  "<Cmd>Telescope man_pages<CR>",             desc = "Man Pages" },
    { "<leader>hk",  "<Cmd>Telescope keymaps<CR>",               desc = "Keymaps" },
    { "<leader>hc",  "<Cmd>Telescope commands<CR>",              desc = "Commands" },
    -- ===============
    -- LSP
    -- ===============
    { "<leader>l",   group = "LSP" },
    { "<leader>lr",  "<Cmd>LspRestart<CR>",                      desc = "Restart" },
    { "<leader>li",  "<Cmd>LspInfo<CR>",                         desc = "Info" },
    { "<leader>ll",  "<Cmd>LspLog<CR>",                          desc = "Log" },

    -- ===============
    -- Messages/Notifications
    -- ===============
    { "<leader>m",   group = "Messages" },
    { "<leader>mm",  "<Cmd>messages<CR>",                        desc = "Show Messages" },
    { "<leader>mn",  "<Cmd>Telescope notify<CR>",                desc = "Notifications" },
    { "<leader>me",  "<Cmd>Noice errors<CR>",                    desc = "Errors (Noice)" },
    { "<leader>mc",  "<Cmd>messages clear<CR>",                  desc = "Clear Messages" },
    { "<leader>my",  "<Cmd>%y+<CR>",                             desc = "Yank All" },
    -- Paste
    { "<leader>mp",  group = "Paste" },
    { "<leader>mpa", '"+p',                                      desc = "After Cursor" },
    { "<leader>mpb", '"+P',                                      desc = "Before Cursor" },


    -- ===============
    -- Project
    -- ===============
    { "<leader>p",   group = "Project" },

    -- ===============
    -- Quit
    -- ===============
    -- Quit & Save
    { "<leader>q",   group = "Quit" },

    { "<leader>qq",  "<Cmd>q<CR>",                               desc = "Quit" },
    { "<leader>qf",  group = "Force Quit" },
    { "<leader>qfq", "<Cmd>q!<CR>",                              desc = "Force Quit" },
    { "<leader>qfa", "<Cmd>qa<CR>",                              desc = "Force Quit All" },
    { "<leader>qfw", "<Cmd>qa!<CR>",                             desc = "Force Quit All" },

    -- ===============
    -- Replace/Substitute
    -- ===============
    -- { "<leader>r",    group = "Replace" },
    -- { "<leader>ra",   ":lua SubstituteAll()<CR>",                desc = "Whole File" },
    -- { "<leader>rm",   ":lua SubstituteMatchingLines()<CR>",      desc = "Matching Lines" },
    -- { "<leader>rr",   ":lua SubstituteRange()<CR>",              desc = "Range" },
    -- { "<leader>re",   "<Cmd>NvimTreeRefresh<CR>",                desc = "Refresh Explorer" },
    { "<leader>r",   group = "Replace" },

    -- Substitute operations
    { "<leader>rs",  group = "Substitute" },
    { "<leader>rsa", ":lua SubstituteAll()<CR>",                 desc = "Whole File" },
    { "<leader>rsm", ":lua SubstituteMatchingLines()<CR>",       desc = "Matching Lines" },
    { "<leader>rsr", ":lua SubstituteRange()<CR>",               desc = "Range" },
    { "<leader>rsl", ":s/",                                      desc = "Current Line" },
    { "<leader>rsv", ":s/\\%V",                                  desc = "Visual Selection" },

    -- Quick replace (no submenu)
    { "<leader>rr",  ":lua SubstituteRange()<CR>",               desc = "Replace Range" },
    { "<leader>ra",  ":lua SubstituteAll()<CR>",                 desc = "Replace All" },

    -- Refresh operations
    { "<leader>re",  group = "Refresh" },
    { "<leader>ree", "<Cmd>NvimTreeRefresh<CR>",                 desc = "Explorer" },
    { "<leader>reb", "<Cmd>edit!<CR>",                           desc = "Buffer" },
    { "<leader>res", "<Cmd>source %<CR>",                        desc = "Source File" },

    -- ===============
    -- Sessions --> Refrence to /path/to/IdeBatch/Sessions.lua
    -- ===============
    { "<leader>s",   group = "Session" },
    -- ===============
    -- Undo  --> Refrence to /path/to/IdeBatch/undotree.lua
    -- ===============
    { "<leader>u",   group = "Toggle" },
    { "<leader>ui",  "<Cmd>IBLToggle<CR>",                       desc = "Indent Lines" },
    { "<leader>un",  "<Cmd>set number!<CR>",                     desc = "Line Numbers" },
    { "<leader>ur",  "<Cmd>set relativenumber!<CR>",             desc = "Relative Numbers" },
    { "<leader>uw",  "<Cmd>set wrap!<CR>",                       desc = "Word Wrap" },
    { "<leader>us",  "<Cmd>set spell!<CR>",                      desc = "Spell Check" },
    { "<leader>ul",  "<Cmd>set list!<CR>",                       desc = "List Chars" },
    { "<leader>uc",  "<Cmd>set cursorline!<CR>",                 desc = "Cursor Line" },
    { "<leader>uh",  "<Cmd>set hlsearch!<CR>",                   desc = "Highlight Search" },


    -- ===============
    -- Visual Mode Group
    -- ===============
    { "<leader>v",   group = "Visual" },
    -- ===============
    -- Save
    -- ===============
    { "<leader>w",   group = "Save" },
    { "<leader>wq",  "<Cmd>wq<CR>",                              desc = "Save & Quit current buffer" },
    { "<leader>ws",  "<cmd>wall<cr>",                            desc = "Save all" },

    { "<leader>wf",  group = "Force save" },

    { "<leader>wfs", "<cmd>w!<cr>",                              desc = "Force save" },
    { "<leader>wfS", "<cmd>wall!<cr>",                           desc = "Force Save all" },
    { "<leader>wfa", "<cmd>wqall!<cr>",                          desc = "Forece Save & Quit all" },
    -- ===============
    -- Yank
    -- ===============
    { "<leader>y",   group = "Copy" },
    { "<leader>ya",  "<Cmd>%y+<CR>",                             desc = "Yank All" },
    { "<leader>yp",  "<Cmd>let @+ = expand('%:p')<CR>",          desc = "Yank File Path" },
    { "<leader>yf",  "<Cmd>let @+ = expand('%:t')<CR>",          desc = "Yank File Name" },
})

-- ============================================
-- Visual/Select Mode Mappings
-- ============================================
wk.add({
    mode = { "v", "x" },
    { "<leader>r",  group = "Replace" },
    { "<leader>rs", ":s///g<Left><Left>", desc = "In Selection" },
    { "<leader>y",  '"+y',                desc = "Yank to Clipboard" },
})

-- ============================================
-- Helper Functions (if not already defined)
-- ============================================

-- Replace in entire file
function SubstituteAll()
    local search = vim.fn.input("Search: ")
    if search == "" then return end
    local replace = vim.fn.input("Replace with: ")
    vim.cmd(string.format("%%s/%s/%s/g", search, replace))
end

-- Replace in matching lines
function SubstituteMatchingLines()
    local pattern = vim.fn.input("Match pattern: ")
    if pattern == "" then return end
    local search = vim.fn.input("Search: ")
    if search == "" then return end
    local replace = vim.fn.input("Replace with: ")
    vim.cmd(string.format("g/%s/s/%s/%s/g", pattern, search, replace))
end

-- Replace in range
function SubstituteRange()
    local start_line = vim.fn.input("Start line: ")
    if start_line == "" then return end
    local end_line = vim.fn.input("End line: ")
    if end_line == "" then return end
    local search = vim.fn.input("Search: ")
    if search == "" then return end
    local replace = vim.fn.input("Replace with: ")
    vim.cmd(string.format("%s,%ss/%s/%s/g", start_line, end_line, search, replace))
end

-- ============================================
-- Troubleshooting Note
-- ============================================
-- If Trouble diagnostics doesn't open, ensure:
-- 1. Trouble.nvim is installed: require("trouble").setup()
-- 2. Run :checkhealth trouble
-- 3. Try: :Trouble diagnostics toggle
-- 4. Alternative: Use <leader>dr for direct command
