require("lspconfig").pyright.setup({
    cmd = {
        "pyright-langserver",
        "--stdio",
    },
    filetypes = { "python" },
    -- settings is for LSP-specific configuration only
    settings = {}
})
