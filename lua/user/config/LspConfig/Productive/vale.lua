require("lspconfig").vale_ls.setup({
    cmd = { "vale", "--lsp" }, -- run Vale in LSP mode
    filetypes = { "markdown", "text", "md" }, -- only Markdown/text
    root_dir = vim.loop.cwd,
})
