-- Enable Lua module caching
vim.loader.enable(true)
-- =====================
-- (1) Bootstrap lazy.nvim
-- =====================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =====================
-- Plugins (lazy.nvim)
-- =====================
require("lazy").setup({
    spec = {
        -- ===========================
        -- Plugin Managers (load early)
        -- ===========================
        {
            "williamboman/mason.nvim",
            cmd = { "Mason", "MasonInstall", "MasonUpdate" },
            build = ":MasonUpdate",
        },

        -- ===========================
        -- Core Dependencies (lazy loaded)
        -- ===========================
        { "nvim-lua/plenary.nvim",        lazy = true },
        { "MunifTanjim/nui.nvim",         lazy = true },
        { "nvim-tree/nvim-web-devicons",  lazy = true },
        { "echasnovski/mini.icons",       version = false, lazy = true },
        { "nvim-neotest/nvim-nio",        lazy = true },

        -- ===========================
        -- Snippets
        -- ===========================
        { "rafamadriz/friendly-snippets", lazy = true },
        { "honza/vim-snippets",           lazy = true },
        {
            "L3MON4D3/LuaSnip",
            version = "v2.4.1",
            event = "InsertEnter",
            dependencies = {
                "rafamadriz/friendly-snippets",
                "honza/vim-snippets",
            },
        },

        -- ===========================
        -- Completion (load on insert)
        -- ===========================
        {
            "saghen/blink.cmp",
            version = "v1.8.0",
            event = "InsertEnter",
            dependencies = {
                "rafamadriz/friendly-snippets",
            },
        },
        -- CMP dependencies (if you're using nvim-cmp alongside blink)
        { "hrsh7th/cmp-nvim-lsp",     lazy = true },
        { "hrsh7th/cmp-buffer",       lazy = true },
        { "hrsh7th/cmp-path",         lazy = true },
        { "hrsh7th/cmp-cmdline",      lazy = true },
        { "saadparwaiz1/cmp_luasnip", lazy = true },
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
        },

        -- ===========================
        -- LSP (load on file open)
        -- ===========================
        {
            "neovim/nvim-lspconfig",
            version = "v2.5.0",
            event = { "BufReadPre", "BufNewFile" },
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
            },
        },
        { "onsails/lspkind-nvim",        lazy = true },
        {
            "SmiteshP/nvim-navic",
            lazy = true,
            dependencies = { "neovim/nvim-lspconfig" },
        },
        {
            "rmagatti/goto-preview",
            event = "LspAttach",
            dependencies = { "rmagatti/logger.nvim" },
            config = true,
        },

        -- ===========================
        -- Formatting & Diagnostics
        -- ===========================
        {
            "stevearc/conform.nvim",
            event = "BufWritePre",
        },
        {
            "folke/trouble.nvim",
            branch = "main",
            version = "v3.7.1",
            cmd = { "Trouble", "TroubleToggle" },
        },

        -- ===========================
        -- DAP (Debug Adapter Protocol)
        -- ===========================
        {
            "mfussenegger/nvim-dap",
            version = "0.10.0",
            cmd = { "DapContinue", "DapToggleBreakpoint", "DapStepOver", "DapStepInto", "DapStepOut" },
        },
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
            cmd = { "DapContinue", "DapToggleBreakpoint" },
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            dependencies = { "mfussenegger/nvim-dap" },
            event = "LspAttach",
        },

        -- ===========================
        -- UI Components
        -- ===========================
        {
            "nvim-lualine/lualine.nvim",
            event = "VeryLazy",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        {
            "akinsho/bufferline.nvim",
            version = "v4.9.1",
            event = "VeryLazy",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            version = "v3.9.0",
            event = { "BufReadPost", "BufNewFile" },
        },
        {
            "goolord/alpha-nvim",
            event = "VimEnter",
            dependencies = { "MaximilianLloyd/ascii.nvim" },
        },
        {
            "stevearc/dressing.nvim",
            version = "v3.1.1",
            event = "VeryLazy",
        },
        {
            "rcarriga/nvim-notify",
            version = "v3.15.0",
            event = "VeryLazy",
        },
        {
            "beauwilliams/focus.nvim",
            version = "v1.0.2",
            cmd = { "FocusSplitNicely", "FocusSplitCycle", "FocusToggle" },
        },

        -- ===========================
        -- Treesitter (load on file open)
        -- ===========================
        {
            "nvim-treesitter/nvim-treesitter",
            version = "v0.10.0",
            build = ":TSUpdate",
            event = { "BufReadPost", "BufNewFile" },
            cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        },

        -- ===========================
        -- File Exploration (lazy load)
        -- ===========================
        {
            "nvim-tree/nvim-tree.lua",
            version = "v1.14.0",
            cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
            keys = {
                { "<leader>e", "<cmd>NvimTreeToggle<cr>" }
                ,
            },
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("user.config.IdeBatch.nvimtree")
            end

        },
        {
            "stevearc/oil.nvim",
            version = "v2.15.0",
            cmd = "Oil",
            dependencies = { "echasnovski/mini.icons" },
            config = function()
                require("user.config.IdeBatch.oil")
            end
        },

        -- ===========================
        -- Telescope (lazy load)
        -- ===========================
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.5",
            cmd = "Telescope",
            keys = {
                { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
                { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
                { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-tree/nvim-web-devicons",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
                "nvim-telescope/telescope-fzy-native.nvim",
                "nvim-telescope/telescope-file-browser.nvim",
                "nvim-telescope/telescope-project.nvim",
                "jvgrootveld/telescope-zoxide",
                "debugloop/telescope-undo.nvim",
                "nvim-telescope/telescope-ui-select.nvim",
            },

            config = function()
                require("user.config.IdeBatch.telescope")
            end
        },

        -- ===========================
        -- Editor Enhancements
        -- ===========================
        {
            "akinsho/toggleterm.nvim",
            version = "*",
            keys = {
                { "<C-x><Space>", "<cmd>ToggleTerm<cr>" },
            },
            config = function()
                require("user.config.IdeBatch.toggleterm")
            end,
        },
        {
            "windwp/nvim-autopairs",
            version = "0.10.0",
            event = "InsertEnter",
        },
        {
            "kylechui/nvim-surround",
            version = "v3.1.7",
            event = "VeryLazy",
            config = true,
        },
        {
            "numToStr/Comment.nvim",
            version = "v0.8.0",
            keys = {
                { "gcc", mode = "n",          desc = "Comment line" },
                { "gc",  mode = { "n", "v" }, desc = "Comment" },
            },
        },
        {
            "folke/todo-comments.nvim",
            version = "v1.5.0",
            event = { "BufReadPost", "BufNewFile" },
            keys = {
                { "gc", mode = { "n", "v" } },
                { "gb", mode = { "n", "v" } },
            },
            cmd = { "TodoTrouble", "TodoTelescope" },
            config = function()
                require("user.config.IdeBatch.todo")
            end
        },

        -- ===========================
        -- Navigation & Movement
        -- ===========================
        {
            "karb94/neoscroll.nvim",
            version = "0.2.0",
            event = "VeryLazy",
            config = true,
        },
        {
            "leath-dub/snipe.nvim",
            keys = {
                { "<leader>sn", function() require("snipe").open() end, { desc = "Snipe Menu" } },
            },
        },

        -- ===========================
        -- Git Integration
        -- ===========================
        {
            "kdheepak/lazygit.nvim",
            cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
            keys = {
                { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
            },
        },

        -- ===========================
        -- Utility Features
        -- ===========================
        {
            "folke/which-key.nvim",
            version = "v3.17.0",
            event = "VeryLazy",
        },
        {
            "mg979/vim-visual-multi",
            event = "VeryLazy",
        },
        {
            "mbbill/undotree",
            cmd = "UndotreeToggle",
            keys = {
                { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
            },
            config = function()
                require("user.config.IdeBatch.undotree")
            end
        },
        {
            "gbprod/yanky.nvim",
            event = "VeryLazy",
        },
        {
            "kevinhwang91/nvim-ufo",
            event = "BufReadPost",
            dependencies = { "kevinhwang91/promise-async" },
            config = function()
                require("user.config.IdeBatch.fold")
            end
        },
        {
            "nvzone/showkeys",
            cmd = "ShowkeysToggle",
        },

        -- ===========================
        -- Advanced Features
        -- ===========================
        {
            "ThePrimeagen/refactoring.nvim",
            cmd = "Refactor",
        },
        {
            "stevearc/overseer.nvim",
            cmd = { "OverseerRun", "OverseerToggle", "OverseerInfo" },
            config = function()
                require("user.other.extconfig.overseer")
            end
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
            "stevearc/resession.nvim",
            version = "v1.2.1",
            lazy = true,
        },
        {
            "ahmedkhalf/project.nvim",
            event = "BufReadPost",
        },

        -- ===========================
        -- Mini.nvim Suite
        -- ===========================
        {
            "echasnovski/mini.nvim",
            version = "*",
            event = "VeryLazy",
        },

        -- ===========================
        -- Colorschemes (all lazy loaded)
        -- ===========================
        { "ellisonleao/gruvbox.nvim",    name = "gruvbox-ellison",          lazy = true },
        { "projekt0n/github-nvim-theme", name = "github-theme",             lazy = true },
        { "catppuccin/nvim",             name = "catppuccin",               lazy = true },
        { "EdenEast/nightfox.nvim",      lazy = true },
        { "rebelot/kanagawa.nvim",       lazy = true },
        { "rose-pine/neovim",            name = "rose-pine",                lazy = true },
        { "sainnhe/everforest",          name = "everforest",               lazy = true },
        { "sainnhe/gruvbox-material",    name = "gruvbox-material-sainnhe", lazy = true },
        { "ribru17/bamboo.nvim",         name = "bamboo",                   lazy = true },
        { "olimorris/onedarkpro.nvim",   lazy = true },
        { "oxfist/night-owl.nvim",       lazy = true },
        { "mellow-theme/mellow.nvim",    lazy = true },
    },

    -- ============================
    -- Configuration
    -- ============================
    concurrency = 5,

    git = {
        timeout = 300,
        url_format = "https://github.com/%s.git",
    },

    install = {
        missing = true,
        colorscheme = { "nightfox" }, -- Fallback colorscheme during install
    },

    checker = {
        enabled = false,
        notify = false,
        frequency = 3600,
    },

    change_detection = {
        enabled = true,
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
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    defaults = {
        lazy = true, -- Make all plugins lazy by default
        version = false,
    },

    ui = {
        border = "rounded",
        size = { width = 0.88, height = 0.9 },
        wrap = false,
        title = "   Lazy Plugin Manager ",
        backdrop = 70,
        icons = {
            cmd = " ",
            config = " ",
            event = " ",
            ft = " ",
            init = "⚙️ ",
            import = " ",
            keys = " ",
            lazy = "󰒲 ",
            loaded = " ",
            not_loaded = " ",
            plugin = " ",
            runtime = " ",
            source = " ",
            start = " ",
            task = " ",
            list = { "●", "➜", "★", "‒" },
        },
    },
})

-- ===============================
-- 🌈 Theme adaptation
-- ===============================
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg or "#1e1e2e"
        local accent = vim.api.nvim_get_hl(0, { name = "String" }).fg or "#89b4fa"
        vim.api.nvim_set_hl(0, "LazyButtonActive", { fg = normal_bg, bg = accent, bold = true })
        vim.api.nvim_set_hl(0, "LazyProgressDone", { fg = accent })
    end,
})

-- ============================
-- Batch Control Commands
-- ============================
vim.api.nvim_create_user_command("LazyInstallBatch", function(opts)
    local count = tonumber(opts.args) or 5
    vim.notify("Installing " .. count .. " plugins at a time...", vim.log.levels.INFO)
    local lazy_config = require("lazy.core.config")
    local original = lazy_config.options.concurrency
    lazy_config.options.concurrency = count
    require("lazy").install({ wait = true })
    lazy_config.options.concurrency = original
end, { nargs = "?" })

vim.api.nvim_create_user_command("LazyUpdateBatch", function(opts)
    local count = tonumber(opts.args) or 5
    vim.notify("Updating " .. count .. " plugins at a time...", vim.log.levels.INFO)
    local lazy_config = require("lazy.core.config")
    local original = lazy_config.options.concurrency
    lazy_config.options.concurrency = count
    require("lazy").update({ wait = true })
    lazy_config.options.concurrency = original
end, { nargs = "?" })

vim.api.nvim_create_user_command("LazySyncBatch", function(opts)
    local count = tonumber(opts.args) or 5
    vim.notify("Syncing " .. count .. " plugins at a time...", vim.log.levels.INFO)
    local lazy_config = require("lazy.core.config")
    local original = lazy_config.options.concurrency
    lazy_config.options.concurrency = count
    require("lazy").sync({ wait = true })
    lazy_config.options.concurrency = original
end, { nargs = "?" })

vim.api.nvim_create_user_command("LazySetBatch", function(opts)
    local count = tonumber(opts.args) or 5
    require("lazy.core.config").options.concurrency = count
    vim.notify("Batch size set to: " .. count, vim.log.levels.INFO)
end, { nargs = 1 })
