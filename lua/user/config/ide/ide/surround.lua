-- Minimal nvim-surround setup without any leader keys
require("nvim-surround").setup({
    -- No special keymaps defined: uses default ys, ds, cs commands
    -- These are intuitive and work directly:
    -- ys{motion}{char} - add surrounding
    -- ds{char}         - delete surrounding
    -- cs{old}{new}     - change surrounding
    -- Surround whole line = "<leader>yss"
    -- NOTE: Work only with leader i.e space
    -- NOTE: you are free to use leader cs & leader ds in normal
    -- WARN: ys cS ySS yS gS S <C-g>s <C-g>s are depreciated or may not work as expected !  And please don not use left Delimeters like ({[<\ it will always add up spaces around your surrounding so go for right sided ones !
    -- NOTE: Use :
    -- <leader>ysiw + input like )}]> /
    -- <leader>yss for selecting current line and adding surround ,
    -- <leader>cs for changing surround &
    -- <leader>ds for deleting
    keymaps = {
        -- Default = True
        -- Must never go for custom !
        keymaps = {
            insert = true,
            insert_line = true,
            normal = true,
            normal_cur = true,
            normal_line = true,
            normal_cur_line = true,
            visual = true,
            visual_line = true,
            delete = true,
            change = true,
            change_line = true,
            hwllo = true
        },
    },
    -- Default Mappings :
    -- keymaps = {
    --     insert = "<C-g>s",
    --     insert_line = "<C-g>S",
    --     normal = "ys",
    --     normal_cur = "yss",
    --     normal_line = "yS",
    --     normal_cur_line = "ySS",
    --     visual = "S",
    --     visual_line = "gS",
    --     delete = "ds",
    --     change = "cs",
    --     change_line = "cS",
    -- },
})
