-- ============================================================================
-- OPTIMIZED Blink.cmp Configuration
-- Loads core immediately, defers heavy UI setup
-- ============================================================================

-- Set highlight overrides first (cheap)
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { underline = false, bg = 'NONE' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { underline = false, bg = 'NONE' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { underline = false, bg = 'NONE' })

-- Setup blink.cmp with minimal config first
require('blink.cmp').setup({
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'normal',

        kind_icons = {
            Text          = '󰉿',
            Method        = '󰆧',
            Function      = '󰊕',
            Constructor   = '󰆧',
            Field         = '󰜢',
            Variable      = '󰀫',
            Property      = '󰜢',
            Constant      = '󰏿',
            Class         = '󰠱',
            Struct        = '󰙅',
            Interface     = '󰕘',
            Module        = '󰕳',
            Enum          = '󰕘',
            EnumMember    = '󰆔',
            TypeParameter = '󰊄',
            Unit          = '󰑭',
            Value         = '󰎠',
            Keyword       = '󰌋',
            Operator      = '󰆕',
            Snippet       = '󰘌',
            Event         = '󰌘',
            Reference     = '󰈇',
            File          = '󰈙',
            Folder        = '󰉋',
            Color         = '󰏘',
        },
    },

    completion = {
        list = {
            max_items = 20,
        },

        accept = {
            auto_brackets = {
                enabled = false,
            },
        },

        menu = {
            enabled = true,
            min_width = 15,
            max_height = 10,
            border = 'rounded',
            scrollbar = true,
            scrolloff = 2,
            winblend = 0,

            draw = {
                padding = 1,
                gap = 1,
                treesitter = { 'lsp' },

                columns = {
                    { 'kind_icon', 'kind',              gap = 1 },
                    { 'label',     'label_description', gap = 1 },
                },

                components = {
                    kind_icon = {
                        ellipsis = false,
                        text = function(ctx)
                            return ctx.kind_icon .. ctx.icon_gap
                        end,
                        highlight = function(ctx)
                            return { { group = ctx.kind_hl, priority = 20000 } }
                        end,
                    },

                    kind = {
                        width = { max = 20 },
                        text = function(ctx) return ctx.kind end,
                        highlight = function(ctx) return ctx.kind_hl end,
                    },

                    label = {
                        width = { fill = true, max = 20 },
                        text = function(ctx) return ctx.label .. ctx.label_detail end,
                        highlight = function(ctx)
                            local highlights = {
                                { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                            }
                            if ctx.label_detail then
                                table.insert(highlights,
                                    { #ctx.label, #ctx.label + #ctx.label_detail, group =
                                    'BlinkCmpLabelDetail' })
                            end
                            for _, idx in ipairs(ctx.label_matched_indices) do
                                table.insert(highlights,
                                    { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                            end
                            return highlights
                        end,
                    },

                    label_description = {
                        width = { max = 30 },
                        text = function(ctx) return ctx.label_description end,
                        highlight = 'BlinkCmpLabelDescription',
                    },
                },
            },
            auto_show = true,
        },

        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            treesitter_highlighting = true,

            window = {
                min_width = 10,
                max_width = 40,
                max_height = 40,
                border = 'rounded',
                winblend = 25,
                scrollbar = true,

                direction_priority = {
                    menu_north = { 'e' },
                    menu_south = { 'e' },
                },
            },
        },

        ghost_text = {
            enabled = false,
        },
    },

    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    keymap = {
        preset = 'default',
        ['<C-space>'] = { 'show', 'show_documentation' },
        ['<C-e>'] = { 'hide', 'hide_documentation' },
        ['<C-k>'] = { 'show_documentation', 'hide_documentation' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    },

    signature = {
        enabled = false,
    },

    cmdline = {
        enabled = true,
        sources = { 'cmdline' },

        keymap = {
            preset = 'super-tab',
            ['<CR>'] = { 'accept', 'fallback' },
            ['<Tab>'] = { 'select_next', 'fallback' },
            ['<S-Tab>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
        },

        completion = {
            trigger = {
                show_on_blocked_trigger_characters = {},
                show_on_x_blocked_trigger_characters = {},
            },

            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
            },

            menu = {
                auto_show = true,
                draw = {
                    columns = {
                        { 'label' }
                    },
                },
            },

            ghost_text = {
                enabled = false
            },
        },
    },

    term = {
        enabled = true,
        sources = {},
        keymap = { preset = 'inherit' },
        completion = {
            trigger = {
                show_on_blocked_trigger_characters = {},
                show_on_x_blocked_trigger_characters = nil,
            },
            list = {
                selection = {
                    preselect = nil,
                    auto_insert = nil,
                },
            },
            menu = { auto_show = nil },
            ghost_text = { enabled = false },
        }
    }
})

-- Get capabilities (needed for LSP)
local blink_capabilities = require('blink.cmp').get_lsp_capabilities()

blink_capabilities.textDocument.completion.completionItem = {
    snippetSupport = true,
    resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    },
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    commitCharactersSupport = true,
    documentationFormat = { 'markdown', 'plaintext' },
    deprecatedSupport = true,
    preselectSupport = true,
}

-- Export capabilities for LSP servers to use
_G.blink_capabilities = blink_capabilities


-- Adding new thing if anything unusal happens delete immediately
--
vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        -- Triggers every few seconds of inactivity
        require('blink.cmp').reload()
    end
})
