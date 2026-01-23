require("lspconfig").clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--log=error", -- Only log actual errors

    },
    filetypes = { "c", "cpp" },
    -- settings is for LSP-specific configuration only
    settings = {}
})
