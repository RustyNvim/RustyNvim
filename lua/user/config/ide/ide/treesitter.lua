-- ============================================================================
-- OPTIMIZED Nvim-treesitter Configuration
-- Defers heavy operations until after startup
-- ============================================================================

-- Defer the heavy treesitter setup
vim.defer_fn(function()
    require('nvim-treesitter.configs').setup({
        -- ============================================================================
        -- PARSER INSTALLATION MANAGEMENT
        -- ============================================================================

        ensure_installed = {
            "lua", "vim", "rust", 
        },

        sync_install = false,
        auto_install = false,
        vim.notify(""),
        ignore_install = {},

        -- ============================================================================
        -- HIGHLIGHTING MODULE
        -- ============================================================================

        highlight = {
            enable = true,

            -- Disable for large files
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,

            additional_vim_regex_highlighting = false,
        },

        -- ============================================================================
        -- INCREMENTAL SELECTION
        -- ============================================================================

        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },

        -- ============================================================================
        -- INDENTATION MODULE
        -- ============================================================================

        indent = {
            enable = true,
            disable = {},
        },

        -- ============================================================================
        -- TEXT OBJECTS
        -- ============================================================================

        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                },
            },

            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                    ["]a"] = "@parameter.inner",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                    ["]A"] = "@parameter.inner",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                    ["[a"] = "@parameter.inner",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                    ["[A"] = "@parameter.inner",
                },
            },

            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
        },

        fold = { enable = true },
    })
end, 100) -- Defer by 100ms
