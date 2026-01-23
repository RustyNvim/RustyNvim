require("lspconfig").cmake.setup({
    cmd = {
        "cmake-language-server"
    },
    filetypes = {
        "cmake"
    },
})
