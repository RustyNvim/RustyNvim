-- Enable Lua module caching
vim.loader.enable(true)
-- =====================
-- (1) Bootstrap lazy.nvim
-- =====================
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =====================
-- Plugins (lazy.nvim)
-- =====================
require('lazy').setup({
    spec = {
        -- ===========================
        -- Plugin Managers (load early)
        -- ===========================
        -- {
        --     'williamboman/mason.nvim',
        --     cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
        --     build = ':MasonUpdate',
        -- },

        -- ===========================
        -- Core Dependencies (lazy loaded)
        -- ===========================
        { 'nvim-lua/plenary.nvim',        lazy = true },
        { 'MunifTanjim/nui.nvim',         lazy = true },
        { 'nvim-tree/nvim-web-devicons',  lazy = true },
        { 'echasnovski/mini.icons',       version = false, lazy = true },
        { 'nvim-neotest/nvim-nio',        lazy = true },

        -- ===========================
        -- Snippets
        -- ===========================
        { 'rafamadriz/friendly-snippets', lazy = true },
        { 'honza/vim-snippets',           lazy = true },
        {
            'L3MON4D3/LuaSnip',
            version = 'v2.4.1',
            lazy = true,
            dependencies = {
                'rafamadriz/friendly-snippets',
                'honza/vim-snippets',
            },
        },

        -- ===========================
        -- Completion (load on insert)
        -- ===========================
        {
            'saghen/blink.cmp',
            version = 'v1.8.0',
            event = 'InsertEnter',
            dependencies = {
                'rafamadriz/friendly-snippets',
            },
        },

        -- ===========================
        -- LSP (load on file open)
        -- ===========================
        {
            'neovim/nvim-lspconfig',
            version = 'v2.5.0',
            event = { 'BufReadPre', 'BufNewFile' },
        },
        { 'onsails/lspkind-nvim',     lazy = true },
        {
            'SmiteshP/nvim-navic',
            lazy = true,
            dependencies = { 'neovim/nvim-lspconfig' },
        },
        {
            'rmagatti/goto-preview',
            event = 'LspAttach',
            dependencies = { 'rmagatti/logger.nvim' },
            config = true,
        },

        {
            {
                'rachartier/tiny-inline-diagnostic.nvim',
                event = 'VeryLazy',
                priority = 1000,
                config = function()
                    require('tiny-inline-diagnostic').setup()
                    vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
                end,
            }
        },


        -- rust

        {
            'saecki/crates.nvim',
            event = 'Bufread Cargo.toml',
            tag = 'stable',
            config = function()
                require('crates').setup()
            end,
        },

        -- ===========================
        -- Formatting & Diagnostics
        -- ===========================
        {
            'stevearc/conform.nvim',
            event = 'BufWritePre',
        },

        -- ===========================
        -- DAP (Debug Adapter Protocol)
        -- ===========================
        {
            'mfussenegger/nvim-dap',
            version = '0.10.0',
            cmd = { 'DapContinue', 'DapToggleBreakpoint', 'DapStepOver', 'DapStepInto', 'DapStepOut' },
        },
        {
            'rcarriga/nvim-dap-ui',
            dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
            cmd = { 'DapContinue', 'DapToggleBreakpoint' },
        },
        {
            'theHamsta/nvim-dap-virtual-text',
            dependencies = { 'mfussenegger/nvim-dap' },
            event = 'LspAttach',
        },

        -- ===========================
        -- UI Components
        -- ===========================
        {
            'nvim-lualine/lualine.nvim',
            event = 'VeryLazy',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
        },
        {
            'willothy/nvim-cokeline'
        },
        {
            'lukas-reineke/indent-blankline.nvim',
            main = 'ibl',
            version = 'v3.9.0',
            event = { 'BufReadPost', 'BufNewFile' },
        },
        {
            'goolord/alpha-nvim',
            event = 'VimEnter',
            dependencies = { 'MaximilianLloyd/ascii.nvim' },
        },
        {
            'stevearc/dressing.nvim',
            version = 'v3.1.1',
            event = 'VeryLazy',
        },
        {
            'rcarriga/nvim-notify',
            version = 'v3.15.0',
            event = 'VeryLazy',
        },
        {
            'beauwilliams/focus.nvim',
            version = 'v1.0.2',
            cmd = { 'FocusSplitNicely', 'FocusSplitCycle', 'FocusToggle' },
        },

        -- ===========================
        -- Treesitter (load on file open)
        -- ===========================
        {
            'nvim-treesitter/nvim-treesitter',
            version = 'v0.10.0',
            build = ':TSUpdate',
            event = { 'BufReadPost', 'BufNewFile' },
        },

        -- ===========================
        -- File Exploration (lazy load)
        -- ===========================
        {
            'stevearc/oil.nvim',
            version = 'v2.15.0',
            dependencies = { 'echasnovski/mini.icons' },
        },

        {
            'ibhagwan/fzf-lua',
            commit = '518ab7a',
        },

        {
            'ggandor/leap.nvim',
            commit = 'f19d435',
        },

        {
            'mikavilpas/yazi.nvim',
            commit = '5634692',
            event = 'VeryLazy',
            keys = {
                {
                    '<leader>yod',
                    '<cmd>Yazi<cr>',
                    desc = 'Open cwd',
                },
                {
                    '<leader>yoc',
                    function()
                        require('yazi').yazi(nil, vim.fn.stdpath('config'))
                    end,
                    desc = 'Open runtime',
                },
                {
                    '<leader>you',
                    function()
                        require('yazi').yazi(nil, vim.fn.stdpath('config') .. '/lua/user/')
                    end,
                    desc = 'Open user/',
                },
            },
            opts = {
                open_for_directories = false, -- Keep oil as default
                keymaps = {
                    show_help = '<f1>',
                    '<leader>yoh',
                    open_file_in_vertical_split = '<c-v>',
                    open_file_in_horizontal_split = '<c-x>',
                    open_file_in_tab = '<c-t>',
                    grep_in_directory = '<c-g>',
                    replace_in_directory = '<c-r>',
                    cycle_open_buffers = '<tab>',
                    copy_relative_path_to_selected_files = '<c-y>',
                    send_to_quickfix_list = '<c-q>',
                },
            },
        },

        {
            'kdheepak/lazygit.nvim',
            Lazy = false,
            cmd = {
                'LazyGit',
                'LazyGitConfig',
                'LazyGitCurrentFile',
                'LazyGitFilter',
                'LazyGitFilterCurrentFile',
            },
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
        },

        -- ===========================
        -- Editor Enhancements
        -- ===========================
        {
            'kylechui/nvim-surround',
            version = 'v3.1.7',
            event = 'VeryLazy',
            config = true,
        },
        {
            'numToStr/Comment.nvim',
            version = 'v0.8.0',
            keys = {
                { 'gcc', mode = 'n',          desc = 'Comment line' },
                { 'gc',  mode = { 'n', 'v' }, desc = 'Comment' },
            },
        },
        {
            { 'akinsho/toggleterm.nvim',
                version = '*',
                lazy = true,
                config = true },
        },

        -- ===========================
        -- Navigation & Movement
        -- ===========================

        -- ===========================
        -- Utility Features
        -- ===========================
        {
            'folke/which-key.nvim',
            commit = '3aab214',
            version = 'v3.17.0',
            event = 'VeryLazy',
        },
        {
            'mg979/vim-visual-multi',
            commit = 'a6975e7',
            event = 'VeryLazy',
        },
        {
            'mbbill/undotree',
            commit = '178d19e',
            cmd = 'UndotreeToggle',
        },
        {
            'gbprod/yanky.nvim',
            event = 'VeryLazy',
        },
        {
            'kevinhwang91/nvim-ufo',
            event = 'BufReadPost',
            dependencies = { 'kevinhwang91/promise-async' },
        },
        {
            'nvzone/showkeys',
        },

        -- ===========================
        -- Advanced Features
        -- ===========================
        {
            'stevearc/overseer.nvim',
            cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerInfo' },
        },

        -- ===========================
        -- AI Completion
        -- ===========================
        -- {
        --     "monkoose/neocodeium",
        --     event = "InsertEnter",
        --     config = function()
        --         local neocodeium = require("neocodeium")
        --         neocodeium.setup()
        --         vim.keymap.set("i", "<A-f>", neocodeium.accept)
        --         vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
        --         vim.keymap.set("i", "<A-l>", neocodeium.accept_line)
        --         vim.keymap.set("i", "<A-n>", neocodeium.cycle_or_complete)
        --         vim.keymap.set("i", "<A-p>", function() neocodeium.cycle_or_complete(-1) end)
        --         vim.keymap.set("i", "<A-c>", neocodeium.clear)
        --     end,
        -- },
        --
        -- ===========================
        -- Session Management
        -- ===========================
        {
            'stevearc/resession.nvim',
            version = 'v1.2.1',
            lazy = true,
        },

        -- ===========================
        -- Mini.nvim Suite
        -- ===========================
        {
            'echasnovski/mini.nvim',
            version = '*',
            event = 'VeryLazy',
        },

        {
            'windwp/nvim-autopairs',
            dependencies = {
                'saghen/blink.cmp',
            },
            lazy = true,
        },

        -- ===========================
        -- Colorschemes (all lazy loaded)
        -- ===========================
        { 'catppuccin/nvim', },
        { 'EdenEast/nightfox.nvim', },
        { 'rose-pine/neovim', },
        { 'folke/tokyonight.nvim' },
        { 'ellisonleao/gruvbox.nvim', lazy = true },
    },

    -- ============================
    -- Configuration
    -- ============================
    concurrency = 5,

    git = {
        timeout = 300,
        url_format = 'https://github.com/%s.git',
    },

    install = {
        missing = true,
        colorscheme = { 'catppuccin' }, -- Fallback colorscheme during install
    },

    rocks = {
        enabled = false,   -- unnecessary for now
        hererocks = false, -- use system one
    },

    checker = {
        enabled = false,
        notify = false,
        frequency = 3600,
    },

    change_detection = {
        enabled = false,
        notify = false, -- Less noise
    },

    performance = {
        cache = {
            enabled = true,
        },
        reset_packpath = true,
        rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
                'gzip',
                'matchit',
                'matchparen',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            },
        },
    },

    defaults = {
        pin = true,
        -- lazy = true, -- Make all plugins lazy by default
        -- version = false,
    },

    ui = {
        border = 'rounded',
        size = { width = 0.88, height = 0.9 },
        wrap = false,
        title = '   Lazy Plugin Manager ',
        backdrop = 70,
        icons = {
            cmd        = '󰘳 ', -- command / terminal
            config     = '󰒓 ', -- config / settings
            event      = '󰚌 ', -- events / hooks
            ft         = '󰈙 ', -- filetype
            init       = '󰒓 ', -- init / setup
            import     = '󰋺 ', -- import / module
            keys       = '󰌌 ', -- keybindings
            lazy       = '󰒲 ', -- lazy.nvim (kept)
            loaded     = '󰄬 ', -- check / loaded
            not_loaded = '󰄱 ', -- close / disabled
            plugin     = '󰂖 ', -- plugin / package
            runtime    = '󰆦 ', -- runtime / engine
            source     = '󰉋 ', -- source / repo
            start      = '󰐊 ', -- start / play
            task       = '󰆕 ', -- task / todo
            list       = { '󰬪', '󰬜', '󰬐', '󰬅' },
        }
    },
})

-- ===============================
-- 🌈 Theme adaptation
-- ===============================
-- vim.api.nvim_create_autocmd('ColorScheme', {
--     callback = function()
--         local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or '#1e1e2e'
--         local accent = vim.api.nvim_get_hl(0, { name = 'String' }).fg or '#89b4fa'
--         vim.api.nvim_set_hl(0, 'LazyButtonActive', { fg = normal_bg, bg = accent, bold = true })
--         vim.api.nvim_set_hl(0, 'LazyProgressDone', { fg = accent })
--     end,
-- })

-- ============================
-- Batch Control Commands
-- ============================
vim.api.nvim_create_user_command('LazyInstallBatch', function(opts)
    local count = tonumber(opts.args) or 5
    vim.notify('Installing ' .. count .. ' plugins at a time...', vim.log.levels.INFO)
    local lazy_config = require('lazy.core.config')
    local original = lazy_config.options.concurrency
    lazy_config.options.concurrency = count
    require('lazy').install({ wait = true })
    lazy_config.options.concurrency = original
end, { nargs = '?' })

vim.api.nvim_create_user_command('LazyUpdateBatch', function(opts)
    local count = tonumber(opts.args) or 5
    vim.notify('Updating ' .. count .. ' plugins at a time...', vim.log.levels.INFO)
    local lazy_config = require('lazy.core.config')
    local original = lazy_config.options.concurrency
    lazy_config.options.concurrency = count
    require('lazy').update({ wait = true })
    lazy_config.options.concurrency = original
end, { nargs = '?' })

vim.api.nvim_create_user_command('LazySyncBatch', function(opts)
    local count = tonumber(opts.args) or 5
    vim.notify('Syncing ' .. count .. ' plugins at a time...', vim.log.levels.INFO)
    local lazy_config = require('lazy.core.config')
    local original = lazy_config.options.concurrency
    lazy_config.options.concurrency = count
    require('lazy').sync({ wait = true })
    lazy_config.options.concurrency = original
end, { nargs = '?' })

vim.api.nvim_create_user_command('LazySetBatch', function(opts)
    local count = tonumber(opts.args) or 5
    require('lazy.core.config').options.concurrency = count
    vim.notify('Batch size set to: ' .. count, vim.log.levels.INFO)
end, { nargs = 1 })
