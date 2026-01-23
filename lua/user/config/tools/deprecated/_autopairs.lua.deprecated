-- Load nvim-autopairs safely
local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
  vim.notify("nvim-autopairs not found!", vim.log.levels.ERROR)
  return
end

local Rule = require("nvim-autopairs.rule")

-- Path to JSON config
local config_path = vim.fn.stdpath("config") .. "/lua/user/config/LspBatch/autopairs.json"

-- Function to read and parse JSON
local function read_json(path)
  local f = io.open(path, "r")
  if not f then
    vim.notify("autopairs.json not found: " .. path, vim.log.levels.WARN)
    return {}
  end
  local content = f:read("*a")
  f:close()
  local ok, parsed = pcall(vim.fn.json_decode, content)
  if not ok then
    vim.notify("Invalid JSON in autopairs.json", vim.log.levels.ERROR)
    return {}
  end
  return parsed
end

-- Load config
local config = read_json(config_path)

-- Setup nvim-autopairs basics
npairs.setup({
  check_ts = true,
  disable_filetype = { "TelescopePrompt", "vim" },
})

-- Add global pairs
if config.global then
  for _, pair in ipairs(config.global) do
    npairs.add_rule(Rule(pair[1], pair[2]))
  end
end

-- Add filetype-specific pairs
for ft, rules in pairs(config) do
  if ft ~= "global" then
    for _, pair in ipairs(rules) do
      npairs.add_rule(Rule(pair[1], pair[2], ft))
    end
  end
end
