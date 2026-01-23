require("lspconfig").html.setup({
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "templ" }
})
