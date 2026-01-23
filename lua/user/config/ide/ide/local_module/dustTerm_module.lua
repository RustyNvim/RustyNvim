vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    -- 1️⃣ No leader delay
    vim.opt_local.timeoutlen = 0
    vim.opt_local.ttimeoutlen = 0

    -- 2️⃣ Kill expensive visuals
    vim.opt_local.cursorline = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.signcolumn = "no"

    -- 3️⃣ Disable text processing
    vim.opt_local.spell = false
    vim.opt_local.list = false
    vim.opt_local.wrap = false

    -- 4️⃣ Terminal should feel raw
    vim.opt_local.foldcolumn = "0"
    vim.opt_local.foldenable = false

    -- 5️⃣ Faster redraw behavior
    vim.opt_local.synmaxcol = 0
  end,
})

local M = {}

-- Store multiple terminals by ID
local terminals = {}

-- Create a new terminal instance
local function create_terminal_instance(id)
  return {
    id = id,
    buf = -1,
    win = -1,
  }
end

-- Get or create terminal by ID
local function get_terminal(id)
  if not terminals[id] then
    terminals[id] = create_terminal_instance(id)
  end
  return terminals[id]
end

-- Function to create/update floating window with resize capability
local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)
  local title = opts.title or "Terminal"

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

-- Recalculate and update window size/position on VimResized
local function setup_auto_resize(term)
  local group = vim.api.nvim_create_augroup("TerminalAutoResize_" .. term.id, { clear = true })
  
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      if vim.api.nvim_win_is_valid(term.win) then
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)
        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor((vim.o.lines - height) / 2)
        
        vim.api.nvim_win_set_config(term.win, {
          relative = "editor",
          width = width,
          height = height,
          col = col,
          row = row,
        })
      end
    end,
  })
  
  -- Clean up autocmd when window closes
  vim.api.nvim_create_autocmd("WinClosed", {
    group = group,
    pattern = tostring(term.win),
    callback = function()
      vim.api.nvim_del_augroup_by_id(group)
    end,
    once = true,
  })
end

-- Setup keymaps for a terminal
local function setup_terminal_keymaps(term)
  local buf = term.buf
  
  -- Close keymaps
  vim.keymap.set("t", "<Esc><Esc>", function()
    if vim.api.nvim_win_is_valid(term.win) then
      vim.api.nvim_win_close(term.win, true)
    end
  end, { buffer = buf })

  vim.keymap.set("t", "<C-x>", function()
    if vim.api.nvim_win_is_valid(term.win) then
      vim.api.nvim_win_close(term.win, true)
    end
  end, { buffer = buf })

  -- Use Alt/Meta instead of Ctrl for resize to avoid conflicts
  -- These work in terminal normal mode (after <M-Space>)
  vim.keymap.set("n", "<M-Up>", function()
    if vim.api.nvim_win_is_valid(term.win) then
      local height = vim.api.nvim_win_get_height(term.win)
      vim.api.nvim_win_set_height(term.win, height + 2)
    end
  end, { buffer = buf })

  vim.keymap.set("n", "<M-Down>", function()
    if vim.api.nvim_win_is_valid(term.win) then
      local height = vim.api.nvim_win_get_height(term.win)
      vim.api.nvim_win_set_height(term.win, math.max(5, height - 2))
    end
  end, { buffer = buf })

  vim.keymap.set("n", "<M-Left>", function()
    if vim.api.nvim_win_is_valid(term.win) then
      local width = vim.api.nvim_win_get_width(term.win)
      vim.api.nvim_win_set_width(term.win, math.max(20, width - 2))
    end
  end, { buffer = buf })

  vim.keymap.set("n", "<M-Right>", function()
    if vim.api.nvim_win_is_valid(term.win) then
      local width = vim.api.nvim_win_get_width(term.win)
      vim.api.nvim_win_set_width(term.win, width + 2)
    end
  end, { buffer = buf })

  -- Enter terminal-normal mode with Alt+Space
  vim.keymap.set("t", "<M-Space>", "<C-\\><C-n>", { buffer = buf, desc = "Enter terminal normal mode" })
  
  -- Quick back to insert mode from normal mode in terminal buffer
  vim.keymap.set("n", "i", "i", { buffer = buf })
  vim.keymap.set("n", "I", "I", { buffer = buf })
  vim.keymap.set("n", "a", "a", { buffer = buf })
  vim.keymap.set("n", "A", "A", { buffer = buf })
end

-- Public API: Toggle terminal by ID
function M.toggle(id, title)
  id = id or "default"
  title = title or id:gsub("^%l", string.upper)
  local term = get_terminal(id)
  
  if not vim.api.nvim_win_is_valid(term.win) then
    local result = create_floating_window({ buf = term.buf, title = title })
    term.buf = result.buf
    term.win = result.win
    
    if vim.bo[term.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      vim.cmd.startinsert()
    else
      vim.cmd.startinsert()
    end

    vim.bo[term.buf].buflisted = false
    setup_terminal_keymaps(term)
    setup_auto_resize(term)
  else
    vim.api.nvim_win_close(term.win, true)
  end
end

function M.open(id, title)
  id = id or "default"
  title = title or id:gsub("^%l", string.upper)
  local term = get_terminal(id)
  
  if not vim.api.nvim_win_is_valid(term.win) then
    M.toggle(id, title)
  end
end

function M.close(id)
  id = id or "default"
  local term = get_terminal(id)
  
  if vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
  end
end

function M.is_open(id)
  id = id or "default"
  local term = get_terminal(id)
  return vim.api.nvim_win_is_valid(term.win)
end

function M.send(cmd, id)
  id = id or "default"
  local term = get_terminal(id)
  
  if not vim.api.nvim_buf_is_valid(term.buf) or vim.bo[term.buf].buftype ~= "terminal" then
    M.toggle(id)
  end
  
  if not vim.api.nvim_win_is_valid(term.win) then
    M.toggle(id)
  end

  local chan_id = vim.bo[term.buf].channel
  
  if chan_id then
    vim.api.nvim_chan_send(chan_id, cmd .. "\n")
  end
end

-- Get all open terminals
function M.list_open()
  local open_terms = {}
  for id, term in pairs(terminals) do
    if vim.api.nvim_win_is_valid(term.win) then
      table.insert(open_terms, {
        id = id,
        buf = term.buf,
        win = term.win,
      })
    end
  end
  return open_terms
end

-- Jump to next terminal
function M.next()
  local open_terms = M.list_open()
  if #open_terms == 0 then
    vim.notify("No terminals open", vim.log.levels.INFO)
    return
  end
  
  local current_win = vim.api.nvim_get_current_win()
  local current_idx = nil
  
  for i, term in ipairs(open_terms) do
    if term.win == current_win then
      current_idx = i
      break
    end
  end
  
  if current_idx then
    local next_idx = (current_idx % #open_terms) + 1
    vim.api.nvim_set_current_win(open_terms[next_idx].win)
  else
    vim.api.nvim_set_current_win(open_terms[1].win)
  end
  vim.cmd.startinsert()
end

-- Jump to previous terminal
function M.prev()
  local open_terms = M.list_open()
  if #open_terms == 0 then
    vim.notify("No terminals open", vim.log.levels.INFO)
    return
  end
  
  local current_win = vim.api.nvim_get_current_win()
  local current_idx = nil
  
  for i, term in ipairs(open_terms) do
    if term.win == current_win then
      current_idx = i
      break
    end
  end
  
  if current_idx then
    local prev_idx = current_idx - 1
    if prev_idx < 1 then prev_idx = #open_terms end
    vim.api.nvim_set_current_win(open_terms[prev_idx].win)
  else
    vim.api.nvim_set_current_win(open_terms[#open_terms].win)
  end
  vim.cmd.startinsert()
end

-- Select terminal with better UI
function M.select()
  local open_terms = M.list_open()
  if #open_terms == 0 then
    vim.notify("No terminals open", vim.log.levels.INFO)
    return
  end
  
  if #open_terms == 1 then
    vim.api.nvim_set_current_win(open_terms[1].win)
    vim.cmd.startinsert()
    return
  end
  
  -- Create selection buffer
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = { "  Select Terminal (press key to jump):", "" }
  
  local keys = "abcdefghijklmnopqrstuvwxyz"
  local key_map = {}
  
  for i, term in ipairs(open_terms) do
    if i <= #keys then
      local key = keys:sub(i, i)
      key_map[key] = term
      table.insert(lines, string.format("  [%s] %s", key, term.id))
    end
  end
  
  table.insert(lines, "")
  table.insert(lines, "  Press <Esc> to cancel")
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  
  -- Create floating window
  local width = 50
  local height = #lines
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Terminal Selector ",
    title_pos = "center",
  })
  
  -- Set up keymaps for selection
  for key, term in pairs(key_map) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_set_current_win(term.win)
      vim.cmd.startinsert()
    end, { buffer = buf, nowait = true })
  end
  
  -- Escape to cancel
  vim.keymap.set("n", "<Esc>", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
  
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })
end

-- Setup default keymaps
function M.setup(opts)
  opts = opts or {}
  
  -- Default terminal toggle (works in normal and terminal mode)
  vim.keymap.set({ "n", "t" }, opts.default_key or "<C-\\>", function() 
    M.toggle("default", "Terminal") 
  end, { desc = "Toggle default terminal" })
  
  -- In NORMAL mode within terminal buffers, add navigation
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      
      -- These only work in normal mode (after Alt+Space in terminal)
      vim.keymap.set("n", opts.next_key or "<leader>tn", function()
        M.next()
      end, { buffer = buf, desc = "Next terminal" })
      
      vim.keymap.set("n", opts.prev_key or "<leader>tp", function()
        M.prev()
      end, { buffer = buf, desc = "Previous terminal" })
      
      vim.keymap.set("n", opts.select_key or "<leader>ts", function()
        M.select()
      end, { buffer = buf, desc = "Select terminal" })
      
      -- Git terminal with Ctrl+g (works in terminal mode)
      vim.keymap.set("t", "<C-g>", function()
        M.toggle("git", "Git Terminal")
      end, { buffer = buf, desc = "Toggle git terminal" })
      
      -- Test terminal with Ctrl+t (works in terminal mode)
      vim.keymap.set("t", "<C-t>", function()
        M.toggle("test", "Test Runner")
      end, { buffer = buf, desc = "Toggle test terminal" })
    end,
  })
end

return M
