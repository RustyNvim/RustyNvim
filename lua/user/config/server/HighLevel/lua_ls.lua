require('lspconfig').lua_ls.setup({
    root_dir = require('lspconfig.util').root_pattern('.git', 'lua', 'init.lua'),
    settings = {
        Lua = {
            runtime = {
                version = 'Lua 5.4',
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                enable = true,
                globals = { 'vim', 'describe', 'it', 'before_each', 'after_each' },
                disable = { 'trailing-space' },
                groupSeverity = { strong = 'Warning', strict = 'Warning' },
                groupFileStatus = {
                    ['ambiguity'] = 'Opened',
                    ['await'] = 'Opened',
                    ['codestyle'] = 'None',
                    ['duplicate'] = 'Opened',
                    ['global'] = 'Opened',
                    ['luadoc'] = 'Opened',
                    ['redefined'] = 'Opened',
                    ['strict'] = 'Opened',
                    ['strong'] = 'Opened',
                    ['type-check'] = 'Opened',
                    ['unbalanced'] = 'Opened',
                    ['unused'] = 'Opened',
                },
                unusedLocalExclude = { '_*' },
            },
            workspace = {
                library = { vim.env.VIMRUNTIME .. '/lua' },
                checkThirdParty = false,
                maxPreload = 2000,
                preloadFileSize = 500,
                ignoreDir = { '.git', 'node_modules', '.vscode', '.github', 'build', 'dist', 'target', '.cache' },
                ignoreSubmodules = true,
            },
            completion = {
                callSnippet = 'Replace',
                keywordSnippet = 'Replace',
                showWord = 'Disable',
                workspaceWord = false,
                postfix = '.',
                displayContext = 0,
                requireSeparator = '.',
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = 'space',
                    indent_size = '2',
                    quote_style = 'single',
                    call_arg_parentheses = 'keep',
                    continuation_indent = '2',
                    max_line_length = '100',
                }
            },
            hint = { enable = true },
            telemetry = { enable = false },
            semantic = { enable = false },
            window = { statusBar = false, progressBar = false },
            hover = { enable = true, viewString = true, viewStringMax = 1000, viewNumber = true, fieldInfer = 1000, previewFields = 20, enumsLimit = 5 },
        },
    },

    handlers = {
        ['$/progress'] = function() end,
    },

    capabilities = (function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.textDocument = capabilities.textDocument or {}
        capabilities.textDocument.diagnostic = { dynamicRegistration = true, relatedDocumentSupport = false }
        return capabilities
    end)(),

    flags = { debounce_text_changes = 150, allow_incremental_sync = true },
    init_options = { usePlaceholders = false },

})
