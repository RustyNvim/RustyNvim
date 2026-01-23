-- lua/config/alpha.lua
local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local status_ok_ascii, ascii = pcall(require, "ascii")
if not status_ok_ascii then
  return
end

local dashboard = require("alpha.themes.dashboard")

-- ==================== HEADER ====================
dashboard.section.header.val = ascii.art.text.neovim.sharp
dashboard.section.header.opts.hl = "AlphaHeader"

-- ==================== BUTTONS ====================
dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", ":FzfLua files<CR>"),
  dashboard.button("r", "  Recent files", ":FzfLua oldfiles<CR>"),
  dashboard.button("g", "  Find text", ":FzfLua live_grep<CR>"),
  dashboard.button("y", "  File manager", ":Yazi<CR>"),
  dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}
-- ==================== FOOTER ====================
local function footer()
  local total_plugins = #vim.tbl_keys(require("lazy").plugins())
  local datetime = os.date(" %d-%m-%Y")
  local version = vim.version()
  local nvim_version = "v" .. version.major .. "." .. version.minor .. "." .. version.patch
  return datetime .. "   " .. total_plugins .. " plugins   " .. nvim_version
end

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "AlphaFooter"

-- ==================== LAYOUT ====================
dashboard.config.layout = {
  { type = "padding", val = 2 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}

-- ==================== HIGHLIGHTS ====================
vim.cmd([[
  highlight AlphaHeader guifg=#7aa2f7
  highlight AlphaButtons guifg=#c0caf5
  highlight AlphaShortcut guifg=#ff9e64
  highlight AlphaFooter guifg=#565f89
]])

-- ==================== SETUP ====================
alpha.setup(dashboard.config)

-- Disable folding on alpha buffer
vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
]])
