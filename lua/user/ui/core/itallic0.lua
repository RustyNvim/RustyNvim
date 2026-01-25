vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            if hl.italic then
                hl.italic = false
                vim.api.nvim_set_hl(0, group, hl)
            end
        end
    end,
})

-- Also run it immediately for the current colorscheme
for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if hl.italic then
        hl.italic = false
        vim.api.nvim_set_hl(0, group, hl)
    end
end
