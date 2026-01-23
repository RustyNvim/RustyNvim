local cmp = require('cmp')
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


-- 🔥 FORCE x Number of ITEMS IN EDITOR & IN CMDLINE
vim.opt.pumheight = 6   -- Default for insert mode (text editor)

-- Override for cmdline mode
vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = function()
        vim.opt.pumheight = 6   -- 5 items in command mode
    end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
        vim.opt.pumheight = 6   -- Back to 4 items in editor
    end,
})
