-- conform.nvim configuration with 4-space indentation and toggle

-- Setup conform.nvim
require("conform").setup({
    formatters_by_ft = {
        -- JavaScript/TypeScript
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },

        -- Web
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- Python
        python = { "black" },

        -- Lua
        lua = { "stylua" },

        -- C/C++
        c = { "clang_format" },
        cpp = { "clang_format" },

        -- Go
        go = { "gofmt" },

        -- Rust
        rust = { "rustfmt" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Other
        toml = { "taplo" },

        -- for all types
        default_format_opts = {
            lsp_format = "fallback",
        },

    },

    -- Configure formatters with 4-space indentation
    formatters = {
        prettier = {
            prepend_args = {
                "--tab-width", "4",
                "--use-tabs", "false",
            },
        },
        black = {
            prepend_args = {
                "--line-length", "88",
            },
        },
        stylua = {
            prepend_args = {
                "--indent-type", "Spaces",
                "--indent-width", "4",
            },
        },
        clang_format = {
            prepend_args = {
                "-style={IndentWidth: 4, UseTab: Never}",
            },
        },
        shfmt = {
            prepend_args = {
                "-i", "4",
            },
        },
    },

    -- This is risky due to its implicity so please use format_on_save = nil , instead.
    -- -- Format on save (will be controlled by toggle)
    -- format_on_save = function(bufnr)
    --     -- Disable autoformat on certain filetypes
    --     local disable_filetypes = { c = true, cpp = true }
    --     if disable_filetypes[vim.bo[bufnr].filetype] then
    --         return
    --     end
    --
    --     -- Check if formatter is enabled
    --     if not vim.g.conform_enabled then
    --         return
    --     end
    --
    --     return {
    --         timeout_ms = 500,
    --         lsp_fallback = true
    --     }
    -- end,

    -- Safest Explicit control via the F literal key in Normal configured in --> ./inbuilt/autosave.lua
    format_on_save = nil,
})

-- Global variable to track formatter state (enabled by default)
vim.g.conform_enabled = true

-- Toggle function
local function toggle_conform()
    vim.g.conform_enabled = not vim.g.conform_enabled
    if vim.g.conform_enabled then
        print("✓ Conform formatter enabled")
    else
        print("✗ Conform formatter disabled")
    end
end

-- Format function that respects the toggle
local function format_file()
    if vim.g.conform_enabled then
        require("conform").format({
            async = false,
            lsp_fallback = true,
            timeout_ms = 500,
        })
    else
        print("Formatter is disabled. Press <Leader>o to enable.")
    end
end

-- Keybindings
vim.keymap.set("n", "<Leader>ffo", toggle_conform, {
    desc = "Toggle conform formatter on/off",
    noremap = true,
    silent = true
})

vim.keymap.set("n", "Fu", format_file, {
    desc = "Format file with conform",
    noremap = true,
    silent = true
})
vim.keymap.set("n", "<C-x>f", format_file, {
    desc = "Format file with conform",
    noremap = true,
    silent = true
})

-- Also support visual mode formatting
vim.keymap.set("v", "<leader>ffp", function()
    if vim.g.conform_enabled then
        require("conform").format({
            async = false,
            lsp_fallback = true
        })
    else
        print("Formatter is disabled. Press <Leader>ffo to enable.")
    end
end, {
    desc = "Format selection with conform",
    noremap = true,
    silent = true
})

-- Set tab settings globally for consistency
