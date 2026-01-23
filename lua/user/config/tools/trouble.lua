local trouble = require("trouble")

trouble.setup({
    auto_close = false,
    auto_open = false,
    auto_preview = false,
    auto_refresh = true,
    auto_jump = false,
    focus = false,
    restore = true,
    follow = true,
    indent_guides = true,
    max_items = 200,
    multiline = true,
    pinned = false,
    warn_no_results = true,
    open_no_results = false,

    -- Window configuration
    win = {
        type = "split",
        relative = "editor",
        position = "bottom",
        size = { height = 10 },
        border = "rounded",
        title = " 󰔫 Trouble ",
        title_pos = "center",
        padding = { top = 0, bottom = 0, left = 1, right = 1 },
        zindex = 200,
        wo = {
            wrap = true,      -- Enable line wrapping
            linebreak = true, -- Wrap at word boundaries
        },
    },

    -- Preview window configuration
    preview = {
        type = "main",
        scratch = true,
        wo = {
            wrap = true,      -- Enable wrapping in preview too
            linebreak = true,
        },
    },

    -- Throttle configuration
    throttle = {
        refresh = 20,
        update = 10,
        render = 10,
        follow = 100,
        preview = { ms = 100, debounce = true },
    },

    -- Key mappings
    keys = {
        ["?"] = "help",
        r = "refresh",
        R = "toggle_refresh",
        q = "close",
        o = "jump_close",
        ["<esc>"] = "cancel",
        ["<cr>"] = "jump",
        ["<2-leftmouse>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["}"] = "next",
        ["]]"] = "next",
        ["{"] = "prev",
        ["[["] = "prev",
        j = "next",
        k = "prev",
        dd = "delete",
        d = { action = "delete", mode = "v" },
        i = "inspect",
        p = "preview",
        P = "toggle_preview",
        zo = "fold_open",
        zO = "fold_open_recursive",
        zc = "fold_close",
        zC = "fold_close_recursive",
        za = "fold_toggle",
        zA = "fold_toggle_recursive",
        zm = "fold_more",
        zM = "fold_close_all",
        zr = "fold_reduce",
        zR = "fold_open_all",
        zx = "fold_update",
        zX = "fold_update_all",
        zn = "fold_disable",
        zN = "fold_enable",
        zi = "fold_toggle_enable",
    },

    -- Mode configurations
    modes = {
        diagnostics = {
            mode = "diagnostics",
            preview = {
                type = "split",
                relative = "win",
                position = "right",
                size = 0.3,
            },
        },
        symbols = {
            desc = "document symbols",
            mode = "lsp_document_symbols",
            focus = false,
            win = { position = "right" },
            filter = {
                ["not"] = { ft = "lua", kind = "Package" },
                any = {
                    ft = { "lua" },
                    kind = {
                        "Class",
                        "Constructor",
                        "Enum",
                        "Field",
                        "Function",
                        "Interface",
                        "Method",
                        "Module",
                        "Namespace",
                        "Package",
                        "Property",
                        "Struct",
                        "Trait",
                    },
                },
            },
        },
    },

    -- Icons configuration
    icons = {
        indent = {
            top = "│ ",
            middle = "├╴",
            last = "└╴",
            fold_open = " ",
            fold_closed = " ",
            ws = "  ",
        },
        folder_closed = " ",
        folder_open = " ",
        kinds = {
            Array = " ",
            Boolean = "󰨙 ",
            Class = " ",
            Constant = "󰏿 ",
            Constructor = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Function = "󰊕 ",
            Interface = " ",
            Key = " ",
            Method = "󰊕 ",
            Module = " ",
            Namespace = "󰦮 ",
            Null = " ",
            Number = "󰎠 ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            String = " ",
            Struct = "󰆼 ",
            TypeParameter = " ",
            Variable = "󰀫 ",
        },
    },
})

-- Recommended keymaps
vim.keymap.set("n", "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "󰔫 Diagnostics (Trouble)" })

