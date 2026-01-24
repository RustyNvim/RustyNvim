vim.api.nvim_create_user_command("H", function(opts)
  vim.cmd("help " .. opts.args)

  local buf = vim.api.nvim_get_current_buf()
  local help_topic = opts.args ~= "" and opts.args or "help.txt"
  vim.cmd("wincmd q")

  local function get_dimensions()
    local w = math.floor(vim.o.columns * 0.75)
    local h = math.floor(vim.o.lines * 0.75)
    return w, h
  end

  local w, h = get_dimensions()

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    row = math.floor((vim.o.lines - h) / 2),
    col = math.floor((vim.o.columns - w) / 2),
    border = "rounded",
    title = " 󰋖 Help: " .. help_topic .. " ",
    title_pos = "center",
  })

  -- Handle resize
  local function resize()
    local new_w, new_h = get_dimensions()
    vim.api.nvim_win_set_config(win, {
      relative = "editor",
      width = new_w,
      height = new_h,
      row = math.floor((vim.o.lines - new_h) / 2),
      col = math.floor((vim.o.columns - new_w) / 2),
    })
  end

  vim.api.nvim_create_autocmd("VimResized", {
    buffer = buf,
    callback = resize,
  })

end, { nargs = "?", complete = "help" })

-- Intercept FzfLua helptags to open in float
local fzf_ok, fzf = pcall(require, 'fzf-lua')
if fzf_ok then
  -- Wrap the original helptags function
  local original_helptags = fzf.helptags
  
  fzf.helptags = function(opts)
    opts = opts or {}
    -- Add action to open with :H instead of default
    opts.actions = opts.actions or {}
    opts.actions.default = function(selected)
      if selected and selected[1] then
        local tag = selected[1]:match("^([^%s]+)")
        vim.cmd("H " .. tag)
      end
    end
    original_helptags(opts)
  end
else 
    vim.notify("fzf lua not found")
end

-- Keymap for FzfLua helptags (will use our wrapped version)
vim.keymap.set('n', '<leader>hf', '<cmd>FzfLua helptags<cr>', { desc = 'Help tags (FzfLua)' })
