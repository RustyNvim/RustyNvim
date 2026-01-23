-- TypeScript/JavaScript LSP Configuration - Optimized for Performance
require('lspconfig').ts_ls.setup({
    settings = {
        typescript = {
            inlayHints = {
                -- CRITICAL: Disable most inlay hints for better performance
                -- Only enable the most useful ones
                includeInlayParameterNameHints = 'literals', -- Only for literals, not 'all'
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false, -- Disabled: causes clutter
                includeInlayVariableTypeHints = false, -- Disabled: too much noise
                includeInlayPropertyDeclarationTypeHints = false, -- Disabled
                includeInlayFunctionLikeReturnTypeHints = true, -- Keep: useful
                includeInlayEnumMemberValueHints = true, -- Keep: useful
            }
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = 'literals',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            }
        }
    },
    flags = {
        debounce_text_changes = 300, -- Increased from 150 to 300 for better performance
    },
})
