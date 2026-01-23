require("lspconfig").gopls.setup({
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
        gopls = {
            -- PERFORMANCE: Critical settings
            analyses = {
                unusedparams = true,
                shadow = false,     -- Disable expensive analysis
                unusedwrite = false,
                useany = false,
            },

            -- Reduce completion load
            completeUnimported = true,
            completionBudget = "100ms",     -- Cap completion time

            -- Matcher settings
            matcher = "Fuzzy",
            deepCompletion = false,     -- CRITICAL: Disable deep search

            -- Reduce semantic token load
            semanticTokens = false,

            -- Hints (disable if still slow)
            hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
            },

            -- Staticcheck can be slow
            staticcheck = false,

            -- Codelens overhead
            codelenses = {
                generate = false,
                gc_details = false,
                test = false,
                tidy = false,
            },
        },
    },
})
