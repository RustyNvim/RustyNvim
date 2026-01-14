local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup({
    flags = {
        debounce_text_changes = 300,
    },
    settings = {
        ["rust-analyzer"] = {
            -- IMPORTANT: avoid Cargo path mismatches
            checkOnSave = {
                enable = true,
                command = "check", -- Set to check use clippy instead
            },

            rustc = {
                source = "discover",
            },

            cargo = {
                allFeatures = false,
                buildScripts = {
                    enable = false,
                },
            },

            procMacro = {
                enable = false, -- For termux optimization
            },

            files = {
                excludeDirs = {
                    ".git",
                    "target",
                    "node_modules",
                },
            },

            diagnostics = {
                enable = true,
                experimental = {
                    enable = false,
                },
            },
        },
    },
})

vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
    return vim.NIL
end
