require("lspconfig").jsonls.setup({
    cmd = {
        "vscode-json-language-server", "--stdio"
    },
    filetypes = {
        "json" }
})
