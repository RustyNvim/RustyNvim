-- Important , this will lazy_load to prevent unnecessary startup time
vim.defer_fn(function()
  require('luasnip.loaders.from_vscode').lazy_load()
end, 100)



vim.lsp.handlers["textDocument/documentHighlight"] = function() end
-- Set global border style for LSP floating windows
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    }
)

-- Global border style (affects other floating windows too)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 20
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Keybindings for LSP
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- K for hover documentation
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

        -- H for signature help
        vim.keymap.set('n', 'H', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts) -- Also in insert mode
    end,
})

-- 2. Disable document highlight for servers that don't support it
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client then
            -- Disable for marksman and gdscript
            if client.name == "marksman" or client.name == "gdscript" then
                client.server_capabilities.documentHighlightProvider = false
            end
        end
    end,
})
