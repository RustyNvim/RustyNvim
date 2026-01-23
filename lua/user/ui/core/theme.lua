-- OPTIMIZED UNIFIED THEME MANAGER
-- High-performance theming with intelligent color extraction and caching
-- ============================================================================

-- The LineNr is located at 235 uncomment itvto get a different line color


local M = {}

-- Cache for extracted colors to avoid repeated calculations
local color_cache = {}
local override_cache = nil

-- Theme definitions with automatic UI color extraction
M.themes = {

  tokyonight = {
    name = "tokyonight",
    background = "dark",
    style = "night",
    setup = function()
      local ok, tokyonight = pcall(require, "tokyonight")
      if not ok then return false end

      tokyonight.setup({
        style = M.themes.tokyonight.style,
        transparent = false,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
      })
      return true
    end
  },

  catppuccin = {
    name = "catppuccin",
    background = "dark",
    flavor = "mocha",
    setup = function()
      local ok, catppuccin = pcall(require, "catppuccin")
      if not ok then return false end

      catppuccin.setup({
        flavour = M.themes.catppuccin.flavor,
        transparent_background = false,
      })
      return true
    end
  },
}

-- Optimized color blending with validation and caching
function M.blend(color1, color2, alpha)
  if color1 == "NONE" or color2 == "NONE" or not color1 or not color2 then
    return color1 or "NONE"
  end

  -- Cache key for blend operations
  local cache_key = color1 .. "_" .. color2 .. "_" .. tostring(alpha)
  if color_cache[cache_key] then
    return color_cache[cache_key]
  end

  local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return nil end

    local r = tonumber(hex:sub(1,2), 16)
    local g = tonumber(hex:sub(3,4), 16)
    local b = tonumber(hex:sub(5,6), 16)

    if not (r and g and b) then return nil end
    return r, g, b
  end

  local r1, g1, b1 = hex_to_rgb(color1)
  local r2, g2, b2 = hex_to_rgb(color2)

  if not (r1 and g1 and b1 and r2 and g2 and b2) then
    return color1
  end

  local r = math.floor(r1 * (1 - alpha) + r2 * alpha + 0.5)
  local g = math.floor(g1 * (1 - alpha) + g2 * alpha + 0.5)
  local b = math.floor(b1 * (1 - alpha) + b2 * alpha + 0.5)

  -- Clamp values
  r = math.max(0, math.min(255, r))
  g = math.max(0, math.min(255, g))
  b = math.max(0, math.min(255, b))

  local result = string.format("#%02x%02x%02x", r, g, b)
  color_cache[cache_key] = result
  return result
end

-- Optimized color extraction with fallback chain
function M.get_theme_colors()
  -- Return cached colors if available and valid
  if override_cache and next(override_cache) then
    return override_cache
  end

  local colors = {}

  -- Optimized highlight extraction
  local function get_hl(name, attr)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if not ok or not hl then return nil end

    if attr == "fg" and hl.fg then
      return string.format("#%06x", hl.fg)
    elseif attr == "bg" and hl.bg then
      return string.format("#%06x", hl.bg)
    end
    return nil
  end

  -- Batch extract core colors with fallback chain
  colors.fg = get_hl("Normal", "fg") or "#c0caf5"
  colors.bg = get_hl("Normal", "bg") or "#1a1b26"

  -- Use fallback chains for robustness
  colors.accent = get_hl("Function", "fg")
    or get_hl("Identifier", "fg")
    or get_hl("Special", "fg")
    or "#7aa2f7"

  colors.error = get_hl("DiagnosticError", "fg")
    or get_hl("ErrorMsg", "fg")
    or "#f7768e"

  colors.warning = get_hl("DiagnosticWarn", "fg")
    or get_hl("WarningMsg", "fg")
    or "#e0af68"

  colors.info = get_hl("DiagnosticInfo", "fg")
    or get_hl("Function", "fg")
    or "#7dcfff"

  colors.hint = get_hl("DiagnosticHint", "fg")
    or get_hl("String", "fg")
    or "#9ece6a"

  colors.green = get_hl("String", "fg")
    or get_hl("DiagnosticOk", "fg")
    or "#9ece6a"

  colors.yellow = get_hl("WarningMsg", "fg")
    or get_hl("Number", "fg")
    or "#e0af68"

  colors.purple = get_hl("Statement", "fg")
    or get_hl("Keyword", "fg")
    or "#bb9af7"

  colors.muted = get_hl("Comment", "fg")
    or get_hl("LineNr", "fg")
    or "#565f89"

  -- Derived colors with optimized blending
  colors.border = colors.muted
  colors.selection = get_hl("Visual", "bg") or M.blend(colors.bg, colors.accent, 0.5)
  -- colors.cursor_line = get_hl("CursorLine", "bg") or M.blend(colors.bg, colors.accent, 0.002)
  colors.bg_float = get_hl("NormalFloat", "bg") or M.blend(colors.bg, colors.fg, 0.03)
  colors.statusline = get_hl("StatusLine", "bg") or M.blend(colors.bg, colors.fg, 0.08)
  colors.sidebar = M.blend(colors.bg, colors.fg, 0.03)
  colors.indent = M.blend(colors.bg, colors.fg, 0.12)
  colors.none = "NONE"

  -- Cache the colors
  override_cache = colors
  return colors
end

-- Universal UI overrides that adapt to any theme
local function get_universal_overrides(colors)
  return {
    -- ═══════════════════════════════════════════════════════════
    -- CORE UI - No shadows/padding, clean backgrounds
    -- ═══════════════════════════════════════════════════════════
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalNC = { fg = colors.fg, bg = colors.bg },

    -- ═══════════════════════════════════════════════════════════
    -- TELESCOPE - Unique borders, no padding, NO bleed
    -- ═══════════════════════════════════════════════════════════
    -- TelescopeNormal         = { bg = colors.bg },
    -- TelescopePromptNormal   = { bg = colors.bg },
    -- TelescopePromptBorder   = { fg = colors.accent, bg = colors.bg },
    -- TelescopePromptPrefix   = { fg = colors.accent, bg = colors.bg },
    -- TelescopePromptTitle    = { fg = colors.bg, bg = colors.accent, bold = true },
    --
    -- TelescopeResultsNormal  = { bg = colors.bg },
    -- TelescopeResultsBorder  = { fg = colors.border, bg = colors.bg },
    -- TelescopeResultsTitle   = { fg = colors.fg, bg = colors.bg },
    --
    -- TelescopePreviewNormal  = { bg = colors.bg },
    -- TelescopePreviewBorder  = { fg = colors.green, bg = colors.bg },
    -- TelescopePreviewTitle   = { fg = colors.bg, bg = colors.green, bold = true },
    --
    -- TelescopeSelection      = { bg = colors.selection, fg = colors.accent, bold = true },
    -- TelescopeSelectionCaret = { fg = colors.accent, bg = colors.selection, bold = true },
    -- TelescopeMatching       = { fg = colors.yellow, bold = true },

    -- ═══════════════════════════════════════════════════════════
    -- GUTTER - Clean, no background variation
    -- ═══════════════════════════════════════════════════════════
    SignColumn    = { bg = colors.bg },
--     LineNr        = { fg = colors.muted, bg = colors.bg },
    -- CursorLineNr  = { fg = colors.accent, bg = colors.bg, bold = true },
    -- FoldColumn    = { fg = colors.muted, bg = colors.bg },
    -- CursorLine    = { bg = colors.cursor_line },
    -- ColorColumn   = { bg = colors.cursor_line },

    -- ═══════════════════════════════════════════════════════════
    -- DIAGNOSTICS - Clean signs
    -- ═══════════════════════════════════════════════════════════
    -- DiagnosticSignError = { fg = colors.error, bg = colors.bg },
    -- DiagnosticSignWarn  = { fg = colors.warning, bg = colors.bg },
    -- DiagnosticSignInfo  = { fg = colors.info, bg = colors.bg },
    -- DiagnosticSignHint  = { fg = colors.hint, bg = colors.bg },

    -- DiagnosticVirtualTextError = { fg = colors.error, bg = colors.none, italic = true },
    -- DiagnosticVirtualTextWarn  = { fg = colors.warning, bg = colors.none, italic = true },
    -- DiagnosticVirtualTextInfo  = { fg = colors.info, bg = colors.none, italic = true },
    -- DiagnosticVirtualTextHint  = { fg = colors.hint, bg = colors.none, italic = true },
    --
    -- DiagnosticUnderlineError = { sp = colors.error, undercurl = true },
    -- DiagnosticUnderlineWarn  = { sp = colors.warning, undercurl = true },
    -- DiagnosticUnderlineInfo  = { sp = colors.info, undercurl = true },
    -- DiagnosticUnderlineHint  = { sp = colors.hint, undercurl = true },

    -- ═══════════════════════════════════════════════════════════
    -- FLOATING WINDOWS - Unique borders, clean bg, NO bleed
    -- ═══════════════════════════════════════════════════════════
    NormalFloat  = { fg = colors.fg, bg = colors.bg },
    FloatBorder  = { fg = colors.accent, bg = colors.bg },
    FloatTitle   = { fg = colors.bg, bg = colors.accent, bold = true },
    FloatFooter  = { fg = colors.muted, bg = colors.bg },

    -- ═══════════════════════════════════════════════════════════
    -- POPUP MENU - Sharp, interactive look, NO color bleed
    -- ═══════════════════════════════════════════════════════════
    -- Pmenu        = { fg = colors.fg, bg = colors.bg },
    -- PmenuSel     = { fg = colors.bg, bg = colors.accent, bold = true },
    -- PmenuSbar    = { bg = colors.bg },
    -- PmenuThumb   = { bg = colors.accent },
    -- PmenuKind    = { fg = colors.purple, bg = colors.bg },
    -- PmenuKindSel = { fg = colors.bg, bg = colors.accent },
    -- PmenuBorder  = { fg = colors.accent, bg = colors.bg },

    -- ═══════════════════════════════════════════════════════════
    -- WHICH-KEY - NO bleed
    -- ═══════════════════════════════════════════════════════════
    -- WhichKey          = { fg = colors.accent, bold = true },
    -- WhichKeyGroup     = { fg = colors.purple },
    -- WhichKeyDesc      = { fg = colors.fg },
    -- WhichKeySeparator = { fg = colors.muted },
    -- WhichKeyBorder    = { fg = colors.accent, bg = colors.bg },
    -- WhichKeyFloat     = { bg = colors.bg },
    -- WhichKeyValue     = { fg = colors.green },

    -- ═══════════════════════════════════════════════════════════
    -- NVIM-TREE - Sidebar with distinct bg
    -- ═══════════════════════════════════════════════════════════
    -- NvimTreeNormal           = { fg = colors.fg, bg = colors.sidebar },
    -- NvimTreeEndOfBuffer      = { fg = colors.sidebar, bg = colors.sidebar },
    -- NvimTreeWinSeparator     = { fg = colors.accent, bg = colors.bg },
    -- NvimTreeVertSplit        = { fg = colors.accent, bg = colors.bg },
    -- NvimTreeFolderIcon       = { fg = colors.accent },
    -- NvimTreeFolderName       = { fg = colors.fg },
    -- NvimTreeOpenedFolderName = { fg = colors.accent, bold = true },
    -- NvimTreeRootFolder       = { fg = colors.purple, bold = true },
    -- NvimTreeGitDirty         = { fg = colors.yellow },
    -- NvimTreeGitNew           = { fg = colors.green },
    -- NvimTreeGitDeleted       = { fg = colors.error },
    --
    -- -- ═══════════════════════════════════════════════════════════
    -- -- STATUSLINE - Clean, minimal
    -- -- ═══════════════════════════════════════════════════════════
    -- StatusLine   = { fg = colors.fg, bg = colors.statusline },
    -- StatusLineNC = { fg = colors.muted, bg = colors.statusline },

    -- ═══════════════════════════════════════════════════════════
    -- TABLINE / BUFFERLINE - Interactive tabs
    -- ═══════════════════════════════════════════════════════════
    TabLine              = { fg = colors.muted, bg = colors.statusline },
    TabLineSel           = { fg = colors.bg, bg = colors.accent, bold = true },
    TabLineFill          = { bg = colors.statusline },

    -- ═══════════════════════════════════════════════════════════
    -- GIT SIGNS - Clean integration
    -- ═══════════════════════════════════════════════════════════
    GitSignsAdd          = { fg = colors.green, bg = colors.bg },
    GitSignsChange       = { fg = colors.yellow, bg = colors.bg },
    GitSignsDelete       = { fg = colors.error, bg = colors.bg },
    GitSignsCurrentLineBlame = { fg = colors.muted, bg = colors.none, italic = true },

    -- ═══════════════════════════════════════════════════════════
    -- INDENT BLANKLINE - Subtle guides
    -- ═══════════════════════════════════════════════════════════
    IblIndent = { fg = colors.indent, nocombine = true },
    IblScope  = { fg = colors.accent, nocombine = true },

    -- Legacy names for compatibility
    IndentBlanklineChar        = { fg = colors.indent, nocombine = true },
    IndentBlanklineContextChar = { fg = colors.accent, nocombine = true },

    -- ═══════════════════════════════════════════════════════════
    -- WINDOWS SEPARATOR - Unique accent borders
    -- ═══════════════════════════════════════════════════════════
    WinSeparator = { fg = colors.accent, bg = colors.none },
    VertSplit    = { fg = colors.accent, bg = colors.none },

    -- ═══════════════════════════════════════════════════════════
    -- SEARCH - High contrast
    -- ═══════════════════════════════════════════════════════════
    -- Search    = { fg = colors.bg, bg = colors.yellow },
    -- IncSearch = { fg = colors.bg, bg = colors.accent, bold = true },
    -- CurSearch = { fg = colors.bg, bg = colors.accent, bold = true },

    -- ═══════════════════════════════════════════════════════════
    -- MISC UI
    -- ═══════════════════════════════════════════════════════════
    -- Title      = { fg = colors.accent, bold = true },
    Question   = { fg = colors.info },
    MoreMsg    = { fg = colors.green },
    WarningMsg = { fg = colors.warning, bold = true },
    ErrorMsg   = { fg = colors.error, bold = true },
    ModeMsg    = { fg = colors.accent, bold = true },

    -- Visual selection
    -- Visual    = { bg = colors.selection },
    -- VisualNOS = { bg = colors.selection },

    -- Diffs
    DiffAdd    = { bg = M.blend(colors.bg, colors.green, 0.15) },
    DiffChange = { bg = M.blend(colors.bg, colors.yellow, 0.15) },
    DiffDelete = { fg = colors.error, bg = M.blend(colors.bg, colors.error, 0.15) },
    DiffText   = { bg = M.blend(colors.bg, colors.yellow, 0.25), bold = true },
  }
end

-- Apply universal theme overrides (optimized)
function M.apply_overrides()
  local colors = M.get_theme_colors()
  local overrides = get_universal_overrides(colors)

  -- Batch apply highlights for better performance
  for group, attrs in pairs(overrides) do
    vim.api.nvim_set_hl(0, group, attrs)
  end
end

-- Clear all caches
local function clear_cache()
  color_cache = {}
  override_cache = nil
end

-- Main function to set a theme
function M.set_theme(theme_name)
  local theme = M.themes[theme_name]

  if not theme then
    vim.notify("Theme '" .. theme_name .. "' not found!", vim.log.levels.ERROR)
    return false
  end

  -- Clear caches before switching
  clear_cache()

  -- Set background
  vim.o.background = theme.background or "dark"

  -- Run theme-specific setup
  if theme.setup then
    local ok = theme.setup()
    if not ok then
      vim.notify("Failed to load theme: " .. theme_name, vim.log.levels.WARN)
      return false
    end
  end

  -- Apply the colorscheme
  local ok = pcall(vim.cmd.colorscheme, theme.name)
  if not ok then
    vim.notify("Failed to apply colorscheme: " .. theme.name, vim.log.levels.ERROR)
    return false
  end

  -- Apply universal overrides immediately (no defer)
  -- The ColorScheme autocmd will handle it, but we do it once here
  vim.schedule(function()
    M.apply_overrides()
  end)

  -- Save current theme for session persistence
  vim.g.current_theme = theme_name

  return true
end

-- Quick theme switcher
function M.switch_theme()
  local theme_names = vim.tbl_keys(M.themes)
  table.sort(theme_names)

  vim.ui.select(theme_names, {
    prompt = "Select Theme:",
    format_item = function(item)
      local current = vim.g.current_theme == item and " (current)" or ""
      return item:gsub("^%l", string.upper) .. current
    end,
  }, function(choice)
    if choice then
      local ok = M.set_theme(choice)
      if ok then
        vim.notify("Theme changed to: " .. choice, vim.log.levels.INFO)
      end
    end
  end)
end

-- Initialize with default theme
function M.setup(opts)
  opts = opts or {}
  local default_theme = opts.default_theme or "gruvbox"

  -- Merge custom themes
  if opts.themes then
    M.themes = vim.tbl_deep_extend("force", M.themes, opts.themes)
  end

  -- Hide the tilde (~) on empty lines
  vim.opt.fillchars = { eob = " " }

  -- Set the default theme
  M.set_theme(default_theme)

  -- Create user commands
  vim.api.nvim_create_user_command("ThemeSwitch", function()
    M.switch_theme()
  end, { desc = "Switch between themes" })

  vim.api.nvim_create_user_command("ThemeReload", function()
    clear_cache()
    M.apply_overrides()
    vim.notify("Theme UI refreshed!", vim.log.levels.INFO)
  end, { desc = "Reload theme UI overrides" })

  vim.api.nvim_create_user_command("ThemeClearCache", function()
    clear_cache()
    vim.notify("Theme cache cleared!", vim.log.levels.INFO)
  end, { desc = "Clear theme color cache" })

  -- Auto-refresh on colorscheme change (optimized)
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ThemeManager", { clear = true }),
    callback = function()
      -- Clear cache and reapply on colorscheme change
      clear_cache()
      vim.schedule(M.apply_overrides)
    end,
  })
end

return M


