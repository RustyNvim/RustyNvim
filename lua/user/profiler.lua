-- =========================================================
-- COMPREHENSIVE NEOVIM CONFIG PROFILER
-- Place this at the VERY TOP of your init.lua
-- =========================================================

local profiler = {
  files = {},
  start_time = vim.loop.hrtime(),
  enabled = true,
}

-- Hook into require() to track all file loads
local original_require = require
_G.require = function(module)
  if not profiler.enabled then
    return original_require(module)
  end

  local start = vim.loop.hrtime()
  local success, result = pcall(original_require, module)
  local elapsed = (vim.loop.hrtime() - start) / 1e6 -- Convert to ms
  
  -- Only track config files and plugins (filter out vim runtime)
  local is_config = module:match("^user%.") or 
                    module:match("^plugins%.") or
                    module:match("^config%.")
  
  if is_config and elapsed > 0.5 then -- Only log files taking >0.5ms
    table.insert(profiler.files, {
      module = module,
      time = elapsed,
      timestamp = (start - profiler.start_time) / 1e6
    })
  end
  
  if not success then
    error(result)
  end
  
  return result
end

-- Generate report after startup
function profiler.report()
  profiler.enabled = false -- Stop tracking
  
  -- Sort by time (slowest first)
  table.sort(profiler.files, function(a, b)
    return a.time > b.time
  end)
  
  local report_lines = {
    "",
    "═══════════════════════════════════════════════════════",
    "           NEOVIM CONFIG PROFILER REPORT",
    "═══════════════════════════════════════════════════════",
    "",
  }
  
  -- Summary stats
  local total_time = 0
  local over_50ms = 0
  local over_20ms = 0
  local over_10ms = 0
  
  for _, file in ipairs(profiler.files) do
    total_time = total_time + file.time
    if file.time > 50 then over_50ms = over_50ms + 1 end
    if file.time > 20 then over_20ms = over_20ms + 1 end
    if file.time > 10 then over_10ms = over_10ms + 1 end
  end
  
  table.insert(report_lines, string.format("Total files tracked: %d", #profiler.files))
  table.insert(report_lines, string.format("Total config time: %.2fms", total_time))
  table.insert(report_lines, string.format("Files >50ms: %d 🔴", over_50ms))
  table.insert(report_lines, string.format("Files >20ms: %d 🟡", over_20ms))
  table.insert(report_lines, string.format("Files >10ms: %d 🟠", over_10ms))
  table.insert(report_lines, "")
  table.insert(report_lines, "───────────────────────────────────────────────────────")
  table.insert(report_lines, "TOP 30 SLOWEST FILES:")
  table.insert(report_lines, "───────────────────────────────────────────────────────")
  
  -- Show top 30 slowest files
  for i = 1, math.min(30, #profiler.files) do
    local file = profiler.files[i]
    local icon = "🔴"
    if file.time < 50 then icon = "🟡" end
    if file.time < 20 then icon = "🟠" end
    if file.time < 10 then icon = "🟢" end
    
    table.insert(report_lines, string.format(
      "%s %6.2fms  %s",
      icon,
      file.time,
      file.module
    ))
  end
  
  table.insert(report_lines, "")
  table.insert(report_lines, "───────────────────────────────────────────────────────")
  table.insert(report_lines, "FULL FILE LIST (sorted by time):")
  table.insert(report_lines, "───────────────────────────────────────────────────────")
  
  -- Group by time categories
  local categories = {
    {name = "🔴 CRITICAL (>50ms)", min = 50, max = math.huge},
    {name = "🟡 HIGH (20-50ms)", min = 20, max = 50},
    {name = "🟠 MEDIUM (10-20ms)", min = 10, max = 20},
    {name = "🟢 LOW (5-10ms)", min = 5, max = 10},
    {name = "⚪ MINIMAL (<5ms)", min = 0, max = 5},
  }
  
  for _, cat in ipairs(categories) do
    local cat_files = {}
    for _, file in ipairs(profiler.files) do
      if file.time >= cat.min and file.time < cat.max then
        table.insert(cat_files, file)
      end
    end
    
    if #cat_files > 0 then
      table.insert(report_lines, "")
      table.insert(report_lines, cat.name .. " (" .. #cat_files .. " files)")
      for _, file in ipairs(cat_files) do
        table.insert(report_lines, string.format(
          "  %6.2fms  %s",
          file.time,
          file.module
        ))
      end
    end
  end
  
  table.insert(report_lines, "")
  table.insert(report_lines, "═══════════════════════════════════════════════════════")
  
  -- Write to file
  local config_path = vim.fn.stdpath("config")
  local report_file = config_path .. "/profiler_report.txt"
  local file = io.open(report_file, "w")
  if file then
    file:write(table.concat(report_lines, "\n"))
    file:close()
    print("\n📊 Profiler report saved to: " .. report_file)
    print("📖 Run ':e " .. report_file .. "' to view full report")
  end
  
  -- Print summary to console
  for i = 1, math.min(15, #report_lines) do
    print(report_lines[i])
  end
end

-- Auto-generate report after UIEnter
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.defer_fn(function()
      profiler.report()
    end, 100) -- Wait 100ms after UIEnter to catch everything
  end,
})

-- Manual report command
vim.api.nvim_create_user_command("ProfilerReport", function()
  profiler.report()
end, {})

return profiler
