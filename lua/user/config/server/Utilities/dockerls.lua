require("lspconfig").dockerls.setup({
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" }
})
