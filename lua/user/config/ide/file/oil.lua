-- oil.nvim configuration for Neovim 0.11
-- A vim-vinegar like file explorer that lets you edit your filesystem like a buffer

require("oil").setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    default_file_explorer = true,

    -- Id is automatically added at the beginning, and name at the end
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },

    -- Buffer-local options to use for oil buffers
    buf_options = {
        buflisted = false,
        bufhidden = "hide",
    },

    -- Window-local options to use for oil buffers
    win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
    },

    -- Send deleted files to the trash instead of permanently deleting them
    delete_to_trash = true,

    -- Skip the confirmation popup for simple operations
    skip_confirm_for_simple_edits = false,

    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    prompt_save_on_select_new_entry = true,

    -- Oil will automatically delete hidden buffers after this delay
    cleanup_delay_ms = 2000,

    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = true,

    -- Keymaps in oil buffer
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
    },

    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,

    view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,

        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
            return vim.startswith(name, ".")
        end,

        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
            return false
        end,

        -- Sort file names in a more intuitive order for humans
        natural_order = true,

        sort = {
            -- sort order can be "asc" or "desc"
            { "type", "asc" },
            { "name", "asc" },
        },
    },

    -- Configuration for the floating window in oil.open_float
    float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 90,
        max_height = 30,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
        -- This is the config that will be passed to nvim_open_win.
        override = function(conf)
            return conf
        end,
    },

    -- Configuration for the actions floating preview window
    preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
    },

    -- Configuration for the floating progress window
    progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
            winblend = 0,
        },
    },

    -- Configuration for the floating SSH window
    ssh = {
        border = "rounded",
    },
})

-- Keymaps using <Leader>ffs series

-- Core navigation
vim.keymap.set("n", "<Leader>ffsf", function()
    require("oil").open_float()
end, { desc = "[Oil] Open in floating window" })

vim.keymap.set("n", "<Leader>ffscd", function()
    require("oil").open(vim.fn.getcwd())
end, { desc = "[Oil] Open from current working directory" })

vim.keymap.set("n", "<Leader>ffshd", function()
    require("oil").open(vim.fn.expand("~"))
end, { desc = "[Oil] Open from home directory" })

vim.keymap.set("n", "<Leader>ffsS", function()
    -- Open oil in float and trigger search
    require("oil").open_float()
    vim.defer_fn(function()
        vim.cmd("normal! /")
    end, 50)
end, { desc = "[Oil] Search files in floating window" })

-- Fuzzy finder with word matching and extension priority
vim.keymap.set("n", "<Leader>ffsF", function()
    local oil = require("oil")
    local current_dir = oil.get_current_dir() or vim.fn.getcwd()

    -- Get all files recursively
    local function get_files(dir, max_depth, current_depth)
        current_depth = current_depth or 0
        max_depth = max_depth or 5

        if current_depth > max_depth then
            return {}
        end

        local files = {}
        local handle = vim.loop.fs_scandir(dir)

        if not handle then
            return files
        end

        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then break end

            -- Skip hidden files and common ignore patterns
            if not name:match("^%.") and
                name ~= "node_modules" and
                name ~= ".git" and
                name ~= "target" and
                name ~= "build" and
                name ~= "dist" then
                local full_path = dir .. "/" .. name

                if type == "directory" then
                    local subfiles = get_files(full_path, max_depth, current_depth + 1)
                    for _, file in ipairs(subfiles) do
                        table.insert(files, file)
                    end
                else
                    table.insert(files, full_path)
                end
            end
        end

        return files
    end

    -- Fuzzy matching with word pairs and extension priority
    local function fuzzy_score(str, pattern)
        str = str:lower()
        pattern = pattern:lower()

        local score = 0
        local ext = str:match("%.([^%.]+)$") or ""
        local basename = str:match("([^/]+)$") or str

        -- Extension exact match bonus
        if ext == pattern then
            score = score + 1000
        elseif ext:find(pattern, 1, true) then
            score = score + 500
        end

        -- Word boundary matching (prioritize matches at word starts)
        local words = {}
        for word in pattern:gmatch("%S+") do
            table.insert(words, word)
        end

        -- Check if all words match
        local all_match = true
        for _, word in ipairs(words) do
            if not str:find(word, 1, true) then
                all_match = false
                break
            end
        end

        if not all_match then
            return 0
        end

        -- Bonus for consecutive character matches
        local pattern_idx = 1
        local last_match_idx = 0
        local consecutive_bonus = 0

        for i = 1, #str do
            if pattern_idx <= #pattern and str:sub(i, i) == pattern:sub(pattern_idx, pattern_idx) then
                if i == last_match_idx + 1 then
                    consecutive_bonus = consecutive_bonus + 10
                end
                score = score + 10 + consecutive_bonus
                last_match_idx = i
                pattern_idx = pattern_idx + 1
            end
        end

        -- Bonus for matches in basename vs full path
        if basename:find(pattern, 1, true) then
            score = score + 200
        end

        -- Bonus for shorter paths
        score = score + (1000 / #str)

        return score
    end

    -- Get and filter files
    local all_files = get_files(current_dir)

    if #all_files == 0 then
        print("No files found in directory")
        return
    end

    -- Create input prompt
    vim.ui.input({ prompt = "Fuzzy find file: " }, function(input)
        if not input or input == "" then
            return
        end

        -- Score and sort files
        local scored_files = {}
        for _, file in ipairs(all_files) do
            local relative_path = file:sub(#current_dir + 2)
            local score = fuzzy_score(relative_path, input)

            if score > 0 then
                table.insert(scored_files, { path = file, score = score, display = relative_path })
            end
        end

        table.sort(scored_files, function(a, b)
            return a.score > b.score
        end)

        if #scored_files == 0 then
            print("No matches found")
            return
        end

        -- Show results in vim.ui.select
        local display_items = {}
        for i, item in ipairs(scored_files) do
            if i <= 20 then -- Limit to top 20 results
                table.insert(display_items, item.display)
            end
        end

        vim.ui.select(display_items, {
            prompt = string.format("Select file (%d matches):", #scored_files),
        }, function(choice, idx)
            if choice and idx then
                vim.cmd("edit " .. vim.fn.fnameescape(scored_files[idx].path))
            end
        end)
    end)
end, { desc = "[Oil] Fuzzy find with word matching & extension priority" })

-- Essential default keymap equivalents
vim.keymap.set("n", "<Leader>ffso", function()
    require("oil").open()
end, { desc = "[Oil] Open (select)" })

vim.keymap.set("n", "<Leader>ffsv", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-s>", true, false, true),
            "n",
            false
        )
    end, 50)
end, { desc = "[Oil] Open in vertical split" })

vim.keymap.set("n", "<Leader>ffsh", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-h>", true, false, true),
            "n",
            false
        )
    end, 50)
end, { desc = "[Oil] Open in horizontal split" })

vim.keymap.set("n", "<Leader>ffst", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-t>", true, false, true),
            "n",
            false
        )
    end, 50)
end, { desc = "[Oil] Open in new tab" })

vim.keymap.set("n", "<Leader>ffsp", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-p>", true, false, true),
            "n",
            false
        )
    end, 50)
end, { desc = "[Oil] Preview file" })

vim.keymap.set("n", "<Leader>ffsc", function()
    require("oil").close()
end, { desc = "[Oil] Close" })

vim.keymap.set("n", "<Leader>ffsr", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-l>", true, false, true),
            "n",
            false
        )
    end, 50)
end, { desc = "[Oil] Refresh" })

vim.keymap.set("n", "<Leader>ffs-", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("-", "n", false)
    end, 50)
end, { desc = "[Oil] Go to parent directory" })

vim.keymap.set("n", "<Leader>ffs_", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("_", "n", false)
    end, 50)
end, { desc = "[Oil] Open cwd" })

vim.keymap.set("n", "<Leader>ffs`", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("`", "n", false)
    end, 50)
end, { desc = "[Oil] CD to directory" })

vim.keymap.set("n", "<Leader>ffs~", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("~", "n", false)
    end, 50)
end, { desc = "[Oil] TCD to directory" })

vim.keymap.set("n", "<Leader>ffss", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("gs", "n", false)
    end, 50)
end, { desc = "[Oil] Change sort order" })

vim.keymap.set("n", "<Leader>ffsx", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("gx", "n", false)
    end, 50)
end, { desc = "[Oil] Open with external program" })

vim.keymap.set("n", "<Leader>ffs.", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("g.", "n", false)
    end, 50)
end, { desc = "[Oil] Toggle hidden files" })

vim.keymap.set("n", "<Leader>ffs\\", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("g\\", "n", false)
    end, 50)
end, { desc = "[Oil] Toggle trash" })

vim.keymap.set("n", "<Leader>ffs?", function()
    require("oil").open()
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("g?", "n", false)
    end, 50)
end, { desc = "[Oil] Show help" })

-- Quick access - keep this for vim-vinegar style workflow
vim.keymap.set("n", "-", function()
    require("oil").open()
end, { desc = "Open parent directory in oil" })

-- Set up autocommand to configure oil buffers
vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        vim.opt_local.colorcolumn = ""
    end,
})

-- Optional: Set tab settings for better alignment in oil buffers
vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})
