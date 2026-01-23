-- SGT (Set Global Theme) - Writes theme directly to init.lua
-- Usage: :SGT <theme_name> or just :SGT for picker

local init_path = vim.fn.stdpath("config") .. "/init.lua"

-- Find and replace colorscheme line in init.lua
local function write_theme_to_init(theme_name)
    local file = io.open(init_path, "r")
    if not file then
        vim.notify("Could not open init.lua", vim.log.levels.ERROR)
        return false
    end

    local content = file:read("*all")
    file:close()

    -- Pattern to match various colorscheme declarations
    local patterns = {
        'vim%.cmd%s*%(?%s*["\']colorscheme%s+[^"\']+["\']%s*%)?',
        'vim%.cmd%.colorscheme%s*%(?%s*["\']([^"\']+)["\']%s*%)?',
        'vim%.cmd%.colorscheme%s*%(%s*["\']([^"\']+)["\']%s*%)',
        'colorscheme%s+%S+',
    }

    local replaced = false
    local new_line = 'vim.cmd.colorscheme("' .. theme_name .. '")'

    -- Try each pattern
    for _, pattern in ipairs(patterns) do
        if content:match(pattern) then
            content = content:gsub(pattern, new_line)
            replaced = true
            break
        end
    end

    -- If no existing colorscheme line found, append at the end
    if not replaced then
        -- Add before the last line or at the end
        content = content .. "\n" .. new_line .. "\n"
    end

    -- Write back to init.lua
    file = io.open(init_path, "w")
    if not file then
        vim.notify("Could not write to init.lua", vim.log.levels.ERROR)
        return false
    end

    file:write(content)
    file:close()

    return true
end

-- Set global theme
local function set_global_theme(name)
    local ok = pcall(vim.cmd.colorscheme, name)
    if ok then
        if write_theme_to_init(name) then
            vim.notify("Global theme set to: " .. name .. " (written to init.lua)", vim.log.levels.INFO)
        else
            vim.notify("Theme applied but failed to write to init.lua", vim.log.levels.WARN)
        end
    else
        vim.notify("Theme not found: " .. name, vim.log.levels.ERROR)
    end
end

-- Create SGT command
vim.api.nvim_create_user_command("SGT", function(opts)
    if opts.args == "" then
        -- No args: show interactive picker
        local themes = vim.fn.getcompletion("", "color")
        table.sort(themes)
        vim.ui.select(themes, {
            prompt = "Select Global Theme:",
        }, function(choice)
            if choice then
                set_global_theme(choice)
            end
        end)
    else
        -- Direct theme name provided
        set_global_theme(opts.args)
    end
end, {
    nargs = "?",
    complete = function(lead)
        local themes = vim.fn.getcompletion("", "color")
        local matches = {}
        for _, t in ipairs(themes) do
            if t:lower():find(lead:lower(), 1, true) then
                table.insert(matches, t)
            end
        end
        return matches
    end,
    desc = "Set Global Theme - writes directly to init.lua"
})
