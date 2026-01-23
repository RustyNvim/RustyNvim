local cmp = require('cmp')
local luasnip = require('luasnip')

-- State management for documentation window
local cmp_state = {
    doc_enabled = false,         -- Documentation disabled by default
    doc_enabled_permanent = nil, -- Permanent override state (nil = use session setting)
}

-- Beautiful glyphics for completion kinds
local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "󰒓",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "󰜰",
    Module = "󰏗",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "󰕘",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "󰕘",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "󰃭",
    Operator = "󰪚",
    TypeParameter = "󰐱",
    Copilot = "",
    Codeium = "",
    TabNine = "󰏚",
}

-- Source priorities and display names
local source_names = {
    nvim_lsp = "[LSP]",
    luasnip = "[Snip]",
    buffer = "[Buf]",
    path = "[Path]",
    nvim_lua = "[Lua]",
    copilot = "[AI]",
    codeium = "[AI]",
    cmp_tabnine = "[AI]",
}

-- Get current documentation state
local function get_doc_config()
    if cmp_state.doc_enabled_permanent ~= nil then
        return cmp_state.doc_enabled_permanent
    end
    return cmp_state.doc_enabled
end

-- Configure cmp with current settings
local function apply_cmp_config()
    local doc_enabled = get_doc_config()

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        window = {
            completion = cmp.config.window.bordered({
                border = "rounded",
                winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
                scrollbar = true,
            }),
            documentation = doc_enabled and {
                border = "rounded",
                winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
                max_height = math.floor(vim.o.lines * 0.3),
                max_width = math.floor(vim.o.columns * 0.4),
                zindex = 50,
            } or {
                border = "none",
                max_height = 0,
                max_width = 0,
            },
        },

        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)

                -- Source display
                vim_item.menu = source_names[entry.source.name] or string.format("[%s]", entry.source.name)

                -- Truncate long completion items
                local max_width = 40
                if #vim_item.abbr > max_width then
                    vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 3) .. "..."
                end

                return vim_item
            end,
        },

        mapping = cmp.mapping.preset.insert({
            -- Navigate between completion items
            ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

            -- Scroll documentation window
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),

            -- Toggle completion menu
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),

            -- Confirm completion
            ['<CR>'] = cmp.mapping.confirm({ select = false }),

            -- Fixed Tab behavior
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { 'i', 's' }),

            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),

        -- Smart source configuration - INCREASED LIMITS FOR SCROLLBAR
        sources = cmp.config.sources({
            { name = 'nvim_lsp', priority = 1000, max_item_count = 30 }, -- ✅ Increased
            { name = 'luasnip',  priority = 750,  max_item_count = 15 }, -- ✅ Increased
            { name = 'path',     priority = 500,  max_item_count = 15 }, -- ✅ Increased
            { name = 'nvim_lua', priority = 700,  max_item_count = 15 }, -- ✅ Increased
        }, {
            {
                name = 'buffer',
                priority = 200,
                max_item_count = 20, -- ✅ Increased
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end
                }
            },
        }),

        -- Performance optimizations - ALLOW MORE ITEMS TO BE LOADED
        performance = {
            debounce = 60,
            throttle = 30,
            fetching_timeout = 200,
            confirm_resolve_timeout = 80,
            async_budget = 1,
            max_view_entries = 50, -- ✅ CHANGED FROM 5 TO 50 - This is the key fix!
        },

        -- Smart completion behavior
        completion = {
            completeopt = 'menu,menuone,noinsert',
            keyword_length = 1,
        },

        -- Experimental features for blink-like behavior
        experimental = {
            ghost_text = {
                hl_group = "CmpGhostText",
            },
        },

        -- Sorting for better results
        sorting = {
            priority_weight = 2,
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                cmp.config.compare.recently_used,
                cmp.config.compare.locality,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
    })

    -- 📝 COMMAND-LINE COMPLETION - FIXED ENTER BEHAVIOR
    cmp.setup.cmdline(':', {
        mapping = {
            -- Arrow keys to navigate WITHOUT auto-filling
            ['<Down>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
            ['<Up>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },
            ['<C-n>'] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }) },
            ['<C-p>'] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }) },

            -- TAB to fill selected item into cmdline (does NOT execute)
            ['<Tab>'] = {
                c = function()
                    if cmp.visible() then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true
                        })
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', true)
                    end
                end,
            },

            -- ENTER: if item selected, fill it; otherwise execute command immediately
            ['<CR>'] = {
                c = function()
                    if cmp.visible() and cmp.get_selected_entry() then
                        -- Item is selected: insert it into cmdline
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = false
                        })
                    else
                        -- No item selected or menu closed: execute command
                        cmp.abort()
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
                    end
                end,
            },

            -- ESC to close menu WITHOUT filling
            ['<C-e>'] = { c = cmp.mapping.abort() },
            ['<Esc>'] = { c = cmp.mapping.abort() },
        },
        sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline' }
        }),
        window = {
            completion = {
                border = "rounded",
                scrollbar = true,
            },
        },
    })

    -- 📝 SEARCH COMPLETION - Same fix
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = {
            ['<Down>'] = {
                c = function()
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        cmp.complete()
                    end
                end
            },
            ['<Up>'] = {
                c = function()
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        cmp.complete()
                    end
                end
            },
            ['<Tab>'] = {
                c = function()
                    if cmp.visible() then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = true
                        })
                    else
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', true)
                    end
                end,
            },
            ['<CR>'] = {
                c = function()
                    if cmp.visible() and cmp.get_selected_entry() then
                        -- Item is selected: insert it
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Insert,
                            select = false
                        })
                    else
                        -- No item selected: execute search
                        cmp.abort()
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n', true)
                    end
                end,
            },
            ['<C-e>'] = { c = cmp.mapping.abort() },
            ['<Esc>'] = { c = cmp.mapping.abort() },
        },
        sources = {
            { name = 'buffer', keyword_length = 2 }
        },
        window = {
            completion = {
                border = "rounded",
                scrollbar = true,
            },
        },
        completion = {
            autocomplete = false,
        },
    })
end

-- Initialize with default config
apply_cmp_config()

-- 🔥 FORCE 6 VISIBLE ITEMS (but load up to 50) - MUST BE AFTER apply_cmp_config()
vim.opt.pumheight = 6

-- Override for cmdline mode
vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = function()
        vim.opt.pumheight = 6
    end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
        vim.opt.pumheight = 6
    end,
})

-- Toggle documentation for current session (all buffers)
local function toggle_doc_current_session()
    cmp_state.doc_enabled = not cmp_state.doc_enabled
    apply_cmp_config()

    local status = cmp_state.doc_enabled and "enabled" or "disabled"
    vim.notify('Documentation (session): ' .. status, vim.log.levels.INFO)
end

-- Toggle documentation permanently (overrides session setting)
local function toggle_doc_permanent()
    if cmp_state.doc_enabled_permanent == nil then
        cmp_state.doc_enabled_permanent = true
    else
        cmp_state.doc_enabled_permanent = not cmp_state.doc_enabled_permanent
    end
    apply_cmp_config()

    local status = cmp_state.doc_enabled_permanent and "enabled" or "disabled"
    vim.notify('Documentation (permanent): ' .. status, vim.log.levels.INFO)
end

-- Reset permanent override
local function reset_doc_permanent()
    cmp_state.doc_enabled_permanent = nil
    apply_cmp_config()
    vim.notify('Documentation permanent override cleared', vim.log.levels.INFO)
end

-- Create user commands
vim.api.nvim_create_user_command('DocToggle', toggle_doc_permanent,
    { desc = 'Toggle documentation permanently (overrides session)' })
vim.api.nvim_create_user_command('DocReset', reset_doc_permanent,
    { desc = 'Reset permanent documentation override' })
vim.api.nvim_create_user_command('DocSession', toggle_doc_current_session,
    { desc = 'Toggle documentation for current session' })

-- Keybindings
vim.keymap.set('n', 'dc', toggle_doc_current_session, { desc = 'Toggle doc (session)' })
vim.keymap.set('n', '<leader>cD', toggle_doc_permanent, { desc = 'Toggle doc (permanent)' })

-- Highlight groups for beautiful appearance
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e1e2e", fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#45475a", fg = "#cdd6f4", bold = true })
        vim.api.nvim_set_hl(0, "PmenuBorder", { fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#313244" })  -- ✅ Scrollbar track
        vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#585b70" }) -- ✅ Scrollbar thumb
        vim.api.nvim_set_hl(0, "CmpDoc", { bg = "#181825", fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#f9e2af" })
        vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#6c7086", italic = true })
        vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#f38ba8" })
        vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#f5c2e7" })
        vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#94e2d5" })
        vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#fab387" })
        vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#a6e3a1" })
    end,
})

vim.cmd("doautocmd ColorScheme")

-- Auto-pairs integration
local cmp_autopairs_ok, cmp_autopairs_module = pcall(require, "nvim-autopairs.completion.cmp")
if cmp_autopairs_ok then
    cmp.event:on("confirm_done", cmp_autopairs_module.on_confirm_done())
end

vim.notify("✨ nvim-cmp: 6 visible items, scrollbar enabled for 7+ items!", vim.log.levels.INFO)
