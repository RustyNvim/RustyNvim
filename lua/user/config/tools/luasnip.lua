-- =========================================================
-- OPTIMIZED LUASNIP CONFIG
-- Only loads snippets when you actually enter insert mode
-- =========================================================

local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    vim.notify("❌ LuaSnip not found!", vim.log.levels.ERROR)
    return
end

-- Basic configuration (this is fast, keep it)
luasnip.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
})

-- Get the snippets path
local snippet_path = vim.fn.stdpath("config") .. "/lua/user/snippets"

-- =========================================================
-- LAZY LOAD SNIPPETS ON FIRST INSERT MODE
-- This is what saves ~79ms at startup!
-- =========================================================
local snippets_loaded = false

vim.api.nvim_create_autocmd("InsertEnter", {
    once = true,  -- Only run once
    callback = function()
        if not snippets_loaded then
            -- Check if directory exists
            if vim.fn.isdirectory(snippet_path) == 1 then
                -- Load snippets NOW (when you actually need them)
                require("luasnip.loaders.from_vscode").lazy_load({
                    paths = { snippet_path }
                })
                snippets_loaded = true
                vim.notify("✅ Snippets loaded", vim.log.levels.INFO)
            end
        end
    end,
})

-- =========================================================
-- KEYMAPS (these work fine at startup)
-- =========================================================
vim.keymap.set({ "i" }, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true, desc = "Expand or jump" })

vim.keymap.set({ "i" }, "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true, desc = "Jump back" })

-- =========================================================
-- DEBUG COMMAND
-- =========================================================
vim.api.nvim_create_user_command("SnippetDebug", function()
    print("\n=== SNIPPET DEBUG ===")
    print("Snippet path: " .. snippet_path)
    print("Directory exists: " .. (vim.fn.isdirectory(snippet_path) == 1 and "YES" or "NO"))
    print("Snippets loaded: " .. (snippets_loaded and "YES" or "NO"))

    -- List files
    local handle = io.popen('ls -la ' .. snippet_path .. ' 2>/dev/null')
    if handle then
        local result = handle:read("*a")
        handle:close()
        if result ~= "" then
            print("Files in snippets dir:\n" .. result)
        end
    end

    -- Check available snippets for current filetype
    local ft = vim.bo.filetype
    print("Current filetype: " .. ft)
    local snips = luasnip.get_snippets(ft)
    if snips and #snips > 0 then
        print("Available snippets for " .. ft .. ":")
        for _, snip in ipairs(snips) do
            print("  - " .. snip.trigger .. " : " .. (snip.name or "no name"))
        end
    else
        print("❌ NO SNIPPETS FOUND for filetype: " .. ft)
        if not snippets_loaded then
            print("💡 TIP: Enter insert mode to load snippets")
        end
    end
end, {})

-- =========================================================
-- MANUAL LOAD COMMAND (for testing)
-- =========================================================
vim.api.nvim_create_user_command("SnippetLoad", function()
    if not snippets_loaded and vim.fn.isdirectory(snippet_path) == 1 then
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { snippet_path }
        })
        snippets_loaded = true
        vim.notify("✅ Snippets loaded manually", vim.log.levels.INFO)
    else
        vim.notify("ℹ️ Snippets already loaded", vim.log.levels.INFO)
    end
end, {})
