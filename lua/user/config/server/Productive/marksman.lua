require('lspconfig').marksman.setup({
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    -- Or suppress stderr
    flags = {
        debounce_text_changes = 300,
    },
})
