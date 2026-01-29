local lualine = require("lualine")

lualine.setup({
  options = {
    theme = "auto",          -- auto-detect colorscheme
    globalstatus = true,     -- single statusline (NvChad style)
    icons_enabled = true,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "dashboard", "alpha", "starter" },
    },
  },

  sections = {
    -- LEFT
    lualine_a = {
      { "mode", icon = "" },
    },

    lualine_b = {
      { "branch", icon = "" },
      "diff",
    },

    lualine_c = {
      {
        "filename",
        path = 1, -- relative path
        symbols = {
          modified = "●",
          readonly = "",
          unnamed = "[No Name]",
        },
      },
    },

    -- RIGHT
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_lsp" },
        symbols = {
          error = " ",
          warn  = " ",
          info  = " ",
          hint  = "󰌵 ",
        },
      },
      "filetype",
    },

    lualine_y = {
      "progress",
    },

    lualine_z = {
      { "location", icon = "󰆾" },
    },
  },

  inactive_sections = {
    lualine_c = { "filename" },
    lualine_x = { "location" },
  },
})



-- -- ─────────────────────────────────────────────
-- -- Enhanced Dynamic Lualine (Auto theme-sync)
-- -- Features:
-- -- - Auto theme switching on colorscheme change
-- -- - Cursor line matches editor background
-- -- - Bold LSP section backgrounds
-- -- - Instant diagnostic popup
-- -- - Optimized theming
-- -- ─────────────────────────────────────────────
--
-- local lualine = require("lualine")
--
-- -- ─────────────────────────────────────────────
-- -- Utility: safely extract color from highlights
-- -- ─────────────────────────────────────────────
-- local function get_colors()
--   local function hl(name, attr)
--     local ok, val = pcall(function()
--       return vim.api.nvim_get_hl(0, { name = name })[attr]
--     end)
--     if ok and val then return string.format("#%06x", val) end
--     return nil
--   end
--
--   -- Derive from the active colorscheme
--   return {
--     bg       = hl("Normal", "bg") or hl("StatusLine", "bg") or "#1e1e2e",  -- Editor bg
--     fg       = hl("StatusLine", "fg") or "#cdd6f4",
--     normal   = hl("Function", "fg") or "#89b4fa",
--     insert   = hl("String", "fg") or "#a6e3a1",
--     visual   = hl("Type", "fg") or "#f5c2e7",
--     replace  = hl("Error", "fg") or "#f38ba8",
--     command  = hl("Keyword", "fg") or "#fab387",
--     lavender = hl("Constant", "fg") or "#b4befe",
--     teal     = hl("PreProc", "fg") or "#94e2d5",
--     peach    = hl("Number", "fg") or "#fab387",
--     yellow   = hl("Identifier", "fg") or "#f9e2af",
--     surface0 = hl("StatusLineNC", "bg") or "#313244",
--     surface1 = hl("LineNr", "fg") or "#45475a",
--     surface2 = hl("CursorLine", "bg") or "#585b70",
--   }
-- end
--
-- -- ─────────────────────────────────────────────
-- -- Bubble theme builder with optimized colors
-- -- ─────────────────────────────────────────────
-- local function make_bubbles_theme(colors)
--   return {
--     normal = {
--       a = { bg = colors.normal, fg = colors.bg, gui = "bold" },
--       b = { bg = colors.bg, fg = colors.lavender, gui = "bold" },
--       c = { bg = colors.bg, fg = colors.fg },  -- Match editor bg
--     },
--     insert = {
--       a = { bg = colors.insert, fg = colors.bg, gui = "bold" },
--       b = { bg = colors.bg, fg = colors.teal, gui = "bold" },
--       c = { bg = colors.bg, fg = colors.fg },
--     },
--     visual = {
--       a = { bg = colors.visual, fg = colors.bg, gui = "bold" },
--       b = { bg = colors.bg, fg = colors.visual, gui = "bold" },
--       c = { bg = colors.bg, fg = colors.fg },
--     },
--     replace = {
--       a = { bg = colors.replace, fg = colors.bg, gui = "bold" },
--       b = { bg = colors.bg, fg = colors.peach, gui = "bold" },
--       c = { bg = colors.bg, fg = colors.fg },
--     },
--     command = {
--       a = { bg = colors.command, fg = colors.bg, gui = "bold" },
--       b = { bg = colors.bg, fg = colors.yellow, gui = "bold" },
--       c = { bg = colors.bg, fg = colors.fg },
--     },
--     inactive = {
--       a = { bg = colors.bg, fg = colors.surface2 },
--       b = { bg = colors.bg, fg = colors.surface2 },
--       c = { bg = colors.bg, fg = colors.surface2 },
--     },
--   }
-- end
--
-- -- ─────────────────────────────────────────────
-- -- Helpers
-- -- ─────────────────────────────────────────────
--
-- -- Safe LSP name display with bold background
-- local function lsp_name()
--   local msg = "󰌘 No LSP"
--   local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
--   for _, client in ipairs(vim.lsp.get_active_clients()) do
--     if client.config.filetypes and vim.fn.index(client.config.filetypes, buf_ft) ~= -1 then
--       return "  " .. client.name
--     end
--   end
--   return msg
-- end
--
-- -- Instant diagnostics with no caching for immediate updates
-- local function diag_summary()
--   local counts = { E = 0, W = 0, I = 0, H = 0 }
--   for _, d in ipairs(vim.diagnostic.get(0)) do
--     if d.severity == vim.diagnostic.severity.ERROR then counts.E = counts.E + 1 end
--     if d.severity == vim.diagnostic.severity.WARN then counts.W = counts.W + 1 end
--     if d.severity == vim.diagnostic.severity.INFO then counts.I = counts.I + 1 end
--     if d.severity == vim.diagnostic.severity.HINT then counts.H = counts.H + 1 end
--   end
--
--   local parts = {}
--   if counts.E > 0 then table.insert(parts, "✘ " .. counts.E) end
--   if counts.W > 0 then table.insert(parts, "▲ " .. counts.W) end
--   if counts.I > 0 then table.insert(parts, " " .. counts.I) end
--   if counts.H > 0 then table.insert(parts, "⚑ " .. counts.H) end
--   return (#parts == 0) and "󰦕 All Good" or table.concat(parts, "  ")
-- end
--
-- -- ─────────────────────────────────────────────
-- -- Main setup (theme reactive)
-- -- ─────────────────────────────────────────────
-- local function setup_lualine()
--   local colors = get_colors()
--   local bubbles_theme = make_bubbles_theme(colors)
--
--   lualine.setup({
--     options = {
--       theme = bubbles_theme,
--       component_separators = { left = "", right = "" },
--       section_separators = { left = "", right = "" },
--       globalstatus = true,
--       refresh = { statusline = 100 },  -- Faster refresh for instant diagnostics
--       disabled_filetypes = { "NvimTree", "neo-tree", "dashboard", "lazy" },
--     },
--     sections = {
--       lualine_a = { 
--         { 
--           "mode", 
--           icons_enabled = true,
--           separator = { left = "", right = "" },
--         } 
--       },
--       lualine_b = {
--         { "branch", icon = "", color = { fg = colors.lavender, gui = "bold" } },
--         { 
--           lsp_name, 
--           icon = "󰒍",
--           color = { fg = colors.teal, bg = colors.bg, gui = "bold" },
--           separator = { left = "", right = "" },
--         },
--       },
--       lualine_c = {
--         { 
--           "filename", 
--           path = 1,
--           file_status = true,
--           newfile_status = true,
--           symbols = { 
--             modified = " 󰷥", 
--             readonly = " 󰌾", 
--             unnamed = "  No Name",
--             newfile = " 󰎔"
--           },
--           color = { bg = colors.bg },  -- Match editor bg
--         },
--       },
--       lualine_x = {
--         { 
--           "encoding",
--           icon = "󰉿",
--           color = { fg = colors.fg, gui = "bold" },
--         },
--         { 
--           diag_summary, 
--           icon = "󱖫",
--           color = { fg = colors.peach, gui = "bold" },
--         },
--         { 
--           "filetype", 
--           icon_only = false,
--           icons_enabled = true,
--           color = { fg = colors.teal, gui = "bold" } 
--         },
--       },
--       lualine_y = { 
--         { 
--           "progress", 
--           icon = "󰦨",
--           color = { fg = colors.yellow, bg = colors.bg, gui = "bold" },
--           separator = { left = "", right = "" },
--         } 
--       },
--       lualine_z = {
--         { 
--           "location", 
--           icon = "󰉸", 
--           color = { fg = colors.lavender, bg = colors.bg, gui = "bold" },
--           separator = { left = "", right = "" },
--         },
--       },
--     },
--     inactive_sections = {
--       lualine_a = {}, lualine_b = {},
--       lualine_c = { { "filename", color = { fg = colors.surface2, bg = colors.bg } } },
--       lualine_x = {}, lualine_y = {}, lualine_z = {},
--     },
--     extensions = { "nvim-tree", "quickfix", "fugitive" },
--   })
-- end
--
-- -- ─────────────────────────────────────────────
-- -- Auto-refresh on colorscheme change (Smart Switcher)
-- -- ─────────────────────────────────────────────
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   group = vim.api.nvim_create_augroup("LualineThemeSync", { clear = true }),
--   callback = function()
--     vim.defer_fn(setup_lualine, 50)
--   end,
-- })
--
-- -- ─────────────────────────────────────────────
-- -- Instant diagnostic popup on DiagnosticChanged
-- -- ─────────────────────────────────────────────
-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
--   group = vim.api.nvim_create_augroup("LualineDiagnosticUpdate", { clear = true }),
--   callback = function()
--     -- Force immediate statusline refresh
--     vim.cmd("redrawstatus")
--   end,
-- })
--
-- -- Also refresh on LSP attach/detach for instant updates
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = vim.api.nvim_create_augroup("LualineLspUpdate", { clear = true }),
--   callback = function()
--     vim.cmd("redrawstatus")
--   end,
-- })
--
-- -- ─────────────────────────────────────────────
-- -- Commands for manual control
-- -- ─────────────────────────────────────────────
-- vim.api.nvim_create_user_command("LualineRefreshTheme", setup_lualine, {})
-- vim.api.nvim_create_user_command("LualineRefresh", function()
--   vim.cmd("redrawstatus")
-- end, {})
--
-- -- Initial setup
-- setup_lualine()
