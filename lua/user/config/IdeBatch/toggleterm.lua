require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-\>]], -- Default mapping (we'll override with custom ones)
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'horizontal', -- 'vertical' | 'horizontal' | 'tab' | 'float'
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,
    float_opts = {
        border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved'
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
})

-- Create a single terminal instance to avoid duplicates
local Terminal = require('toggleterm.terminal').Terminal
local main_term = Terminal:new({
    hidden = true,
    direction = "float",
    on_open = function(term)
        vim.cmd("startinsert!")
    end,
    on_close = function(term)
        vim.cmd("startinsert!")
    end,
})

-- Function to toggle the main terminal
function _G.toggle_main_terminal()
    main_term:toggle()
end

-- Set up keymaps
local opts = { noremap = true, silent = true }

-- Leader + xa mapping
vim.keymap.set('n', '<leader>xa', '<cmd>lua toggle_main_terminal()<CR>', opts)
vim.keymap.set('t', '<leader>xa', '<cmd>lua toggle_main_terminal()<CR>', opts)

vim.keymap.set('n', '<C-x><Space>', '<cmd>lua toggle_main_terminal()<CR>', opts)
-- Ctrl + Space mapping
vim.keymap.set('t', '<C-x><Space>', '<cmd>lua toggle_main_terminal()<CR>', opts)

-- Additional terminal mode mappings for better control
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts) -- Escape to normal mode in terminal
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)

local second_term = Terminal:new({ hidden = true, direction = "horizontal" })

function _G.toggle_second_terminal()
    second_term:toggle()
end

vim.keymap.set('n', '<leader>xb', '<cmd>lua toggle_second_terminal()<CR>', opts)
