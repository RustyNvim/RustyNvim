-- current buffer LSP name(s)
local function lsp_server()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if not clients or #clients == 0 then
        return '󰌘 No LSP'
    end

    local names = {}
    for _, c in ipairs(clients) do
        table.insert(names, c.name)
    end

    return '󰌘 ' .. table.concat(names, ', ')
end

local lualine = require('lualine')

lualine.setup({
    options = {
        theme = 'auto',      -- auto-detect colorscheme
        globalstatus = true, -- single statusline (NvChad style)
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = { 'dashboard', 'alpha', 'starter' },
        },
    },

    sections = {
        -- LEFT
        lualine_a = {
            { 'mode', icon = '' },
        },

        lualine_b = {
            { 'branch', icon = '' },
            'diff',
        },

        lualine_c = {
            {
                'filename',
                path = 3, -- relative path => 0 = name , 1 = relative , 2 = absolute , 3rd = shortened
                symbols = {
                    modified = '●',
                    readonly = '',
                    unnamed = '[No Name]',
                },
                color = {
                    gui = "bold"
                },
                shorting_target = 40,
            },
        },

        -- RIGHT
        lualine_x = {
            {
                lsp_server,
            },
            {
                'diagnostics',
                sources = { 'nvim_lsp' },
                symbols = {
                    error = ' ',
                    warn  = ' ',
                    info  = ' ',
                    hint  = '󰌵 ',
                },
            },
            'filetype',
        },
        lualine_y = {
            'progress',
        },

        lualine_z = {
            { 'location', icon = '󰆾' },
        },
    },

    inactive_sections = {
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
    },
})
