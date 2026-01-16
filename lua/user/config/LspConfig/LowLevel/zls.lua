local lspconfig = require("lspconfig")

lspconfig.zls.setup({
  cmd = { "zls" },
  filetypes = { "zig" },
  root_dir = lspconfig.util.root_pattern(
    "build.zig",
    ".git"
  ),
  settings = {
    zls = {
      enable_inlay_hints = true,
      enable_snippets = true,
      warn_style = true,
    },
  },
})
