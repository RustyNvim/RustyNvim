local resession = require("resession")

resession.setup({
    autosave = {
        enabled = true,
        interval = 60,
        notify = false,
    },
    options = {
        "binary", "bufhidden", "buflisted", "cmdheight",
        "diff", "filetype", "modifiable", "previewwindow",
        "readonly", "scrollbind", "winfixheight", "winfixwidth",
    },
    extensions = {
        overseer = {},
        quickfix = {},
    },
    buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        return buftype ~= "help" and buftype ~= "nofile"
    end,
})

-- Session state tracking
local M = {}
M.current_session = nil
M.last_session = nil

-- Helper: Get session info with metadata
local function get_session_info()
    local sessions = resession.list()
    local session_data = {}
    
    for _, name in ipairs(sessions) do
        local is_current = (name == M.current_session)
        local is_last = (name == M.last_session)
        local marker = is_current and "●" or (is_last and "○" or " ")
        
        table.insert(session_data, {
            name = name,
            display = string.format("%s %s%s%s", 
                marker, 
                name,
                is_current and " [current]" or "",
                is_last and " [last]" or ""
            ),
            is_current = is_current,
            is_last = is_last,
        })
    end
    
    return session_data
end

-- Helper: Show session info in a floating window
local function show_session_info()
    local session_data = get_session_info()
    
    if #session_data == 0 then
        vim.notify("No sessions found", vim.log.levels.INFO)
        return
    end
    
    local lines = { " Available Sessions:", "" }
    for _, session in ipairs(session_data) do
        table.insert(lines, "  " .. session.display)
    end
    table.insert(lines, "")
    table.insert(lines, "Legend: ● current  ○ last  ")
    
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "resession-info"
    
    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(width, #line)
    end
    width = math.min(width + 4, vim.o.columns - 10)
    local height = math.min(#lines + 2, vim.o.lines - 10)
    
    local win = vim.api.nvim_open_win(buf, false, {
        relative = "editor",
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = "minimal",
        border = "rounded",
        title = " Session Manager ",
        title_pos = "center",
    })
    
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })
    
    -- Syntax highlighting
    vim.api.nvim_buf_call(buf, function()
        vim.cmd([[syntax match ResessionTitle /^📂.*$/]])
        vim.cmd([[syntax match ResessionCurrent /●.*\[current\]/]])
        vim.cmd([[syntax match ResessionLast /○.*\[last\]/]])
        vim.cmd([[syntax match ResessionLegend /^Legend:.*$/]])
        vim.cmd([[highlight ResessionTitle guifg=#89b4fa gui=bold]])
        vim.cmd([[highlight ResessionCurrent guifg=#a6e3a1 gui=bold]])
        vim.cmd([[highlight ResessionLast guifg=#f9e2af]])
        vim.cmd([[highlight ResessionLegend guifg=#6c7086 gui=italic]])
    end)
end

-- Modern picker function with multiple fallbacks
local function show_picker(opts)
    local session_data = opts.session_data
    local on_select = opts.on_select
    local title = opts.title or "Sessions"
    
    -- Try fzf-lua first (modern and fast)
    local fzf_ok, fzf = pcall(require, "fzf-lua")
    if fzf_ok then
        local items = {}
        for _, session in ipairs(session_data) do
            table.insert(items, session.display)
        end
        
        fzf.fzf_exec(items, {
            prompt = title .. " > ",
            winopts = {
                height = 0.4,
                width = 0.6,
                row = 0.5,
                col = 0.5,
                border = "rounded",
                title = " " .. title .. " ",
                title_pos = "center",
            },
            actions = {
                ["default"] = function(selected)
                    if selected and selected[1] then
                        for i, session in ipairs(session_data) do
                            if session.display == selected[1] then
                                on_select(session, i)
                                break
                            end
                        end
                    end
                end,
            },
        })
        return
    end
    
    -- Try Telescope (popular choice)
    local tel_ok, telescope = pcall(require, "telescope")
    if tel_ok then
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        
        pickers.new({}, {
            prompt_title = title,
            finder = finders.new_table({
                results = session_data,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = entry.display,
                        ordinal = entry.name,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    if selection then
                        for i, session in ipairs(session_data) do
                            if session.name == selection.value.name then
                                on_select(session, i)
                                break
                            end
                        end
                    end
                end)
                return true
            end,
        }):find()
        return
    end
    
    -- Try mini.pick (minimal and modern)
    local mini_ok, mini_pick = pcall(require, "mini.pick")
    if mini_ok then
        local items = {}
        for _, session in ipairs(session_data) do
            table.insert(items, session.display)
        end
        
        local chosen = mini_pick.start({
            source = {
                items = items,
                name = title,
                show = function(buf_id, items_to_show, query)
                    mini_pick.default_show(buf_id, items_to_show, query)
                end,
            },
        })
        
        if chosen then
            for i, session in ipairs(session_data) do
                if session.display == chosen then
                    on_select(session, i)
                    break
                end
            end
        end
        return
    end
    
    -- Fallback to vim.ui.select (built-in)
    local choices = {}
    for _, session in ipairs(session_data) do
        table.insert(choices, session.display)
    end
    
    vim.ui.select(choices, { 
        prompt = title .. ":",
        format_item = function(item) 
            return item 
        end,
    }, function(choice, idx)
        if choice and idx then
            on_select(session_data[idx], idx)
        end
    end)
end

-- Auto-save current session before leaving
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if M.current_session then
            resession.save(M.current_session, { notify = false })
        else
            resession.save(vim.fn.getcwd(), { notify = false })
        end
    end,
})

-- Save session (with improved naming)
vim.keymap.set("n", "<leader>ss", function()
    local default_name = M.current_session or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    vim.ui.input({ 
        prompt = " Session name: ", 
        default = default_name 
    }, function(name)
        if name and name ~= "" then
            M.last_session = M.current_session
            M.current_session = name
            resession.save(name)
            vim.notify("Session '" .. name .. "' saved", vim.log.levels.INFO)
        end
    end)
end, { desc = "Session: Save" })

-- Load last session
vim.keymap.set("n", "<leader>sl", function()
    local sessions = resession.list()
    if #sessions == 0 then
        vim.notify("No sessions available", vim.log.levels.WARN)
        return
    end
    local target = M.last_session or sessions[1] or vim.fn.getcwd()
    M.last_session = M.current_session
    M.current_session = target
    resession.load(target)
    vim.notify("Loaded session: " .. target, vim.log.levels.INFO)
end, { desc = "Session: Load last" })

-- Interactive session picker with modern pickers
vim.keymap.set("n", "<leader>sf", function()
    local session_data = get_session_info()
    
    if #session_data == 0 then
        vim.notify("No sessions available", vim.log.levels.WARN)
        return
    end
    show_picker({
        session_data = session_data,
        title = "📂 Load Session",
        on_select = function(session, idx)
            M.last_session = M.current_session
            M.current_session = session.name
            resession.load(session.name)
            vim.notify("Loaded: " .. session.name, vim.log.levels.INFO)
        end,
    })
end, { desc = "Session: Pick & Load" })

-- Delete session with picker
vim.keymap.set("n", "<leader>sd", function()
    local session_data = get_session_info()
    if #session_data == 0 then
        vim.notify("No sessions to delete", vim.log.levels.WARN)
        return
    end
    show_picker({
        session_data = session_data,
        title = "🗑️  Delete Session",
        on_select = function(session, idx)
            vim.ui.input({
                prompt = "Delete '" .. session.name .. "'? (y/N): ",
            }, function(confirm)
                if confirm and confirm:lower() == "y" then
                    resession.delete(session.name)
                    if M.current_session == session.name then
                        M.current_session = nil
                    end
                    if M.last_session == session.name then
                        M.last_session = nil
                    end
                    vim.notify("Deleted session: " .. session.name, vim.log.levels.INFO)
                end
            end)
        end,
    })
end, { desc = "Session: Delete" })

-- Show session info window
vim.keymap.set("n", "<leader>si", show_session_info, { desc = "Session: Info" })

-- User command for session management
vim.api.nvim_create_user_command("SessionInfo", show_session_info, {})
vim.api.nvim_create_user_command("SessionList", function()
    local sessions = resession.list()
    print("Sessions: " .. vim.inspect(sessions))
end, {})

return M
