-- Method 2: If you're using nvim-lspconfig
local lspconfig = require('lspconfig')
lspconfig.gdscript.setup({
    -- You can add additional configuration here if needed
    on_attach = function(client, bufnr)
        -- Your on_attach configuration
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})
