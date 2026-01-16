-- Line Notes Plugin for Neovim (Word-tracking version)
-- Save as ~/.config/nvim/lua/user/config/IdeBatch/notes.lua
-- Then add to your init.lua: require('user.config.IdeBatch.notes').setup()

local M = {}
local api = vim.api
local fn = vim.fn

-- Configuration
local config = {
  notes_dir = "notes",
  float_width_ratio = 0.8,
  float_height_ratio = 0.8,
  border = "rounded",
  virt_text = "{notes}",
  virt_text_hl = "Comment",
  -- Custom template function
  template = function(context)
    return {
      string.format("# %s → %s", context.word, context.filename),
      "",
      string.format("**Line %d:** `%s`", context.line_no, context.line_content),
      "",
      "---",
      "",
    }
  end,
}

-- Store namespace for extmarks
local ns = api.nvim_create_namespace("line_notes")
local sign_group = "LineNotes"

-- Generate unique ID for a word at a position
local function generate_word_id(word, line_no, col)
  -- Create a hash-like ID based on word and initial position
  return string.format("%s_%d_%d_%d", word, line_no, col, os.time())
end

-- Get the notes directory path
local function get_notes_dir()
  return fn.getcwd() .. "/" .. config.notes_dir
end

-- Get the current file's notes directory
local function get_file_notes_dir()
  local current_file = fn.expand("%:t:r")
  if current_file == "" then
    return nil, "No file is currently open"
  end
  return get_notes_dir() .. "/" .. current_file, nil
end

-- Get word under cursor with position
local function get_current_word()
  local word = fn.expand("<cword>")
  local pos = api.nvim_win_get_cursor(0)
  local line_no = pos[1]
  local col = pos[2]
  
  return word, line_no, col
end

-- Get or create note metadata file (tracks word IDs to notes)
local function get_metadata_path()
  local file_notes_dir, err = get_file_notes_dir()
  if err then
    return nil, err
  end
  return file_notes_dir .. "/.metadata.json", nil
end

-- Load metadata
local function load_metadata()
  local metadata_path, err = get_metadata_path()
  if err then
    return {}, err
  end
  
  if fn.filereadable(metadata_path) == 0 then
    return {}, nil
  end
  
  local file = io.open(metadata_path, "r")
  if not file then
    return {}, nil
  end
  
  local content = file:read("*all")
  file:close()
  
  local ok, metadata = pcall(vim.json.decode, content)
  if not ok then
    return {}, nil
  end
  
  return metadata, nil
end

-- Save metadata
local function save_metadata(metadata)
  local metadata_path, err = get_metadata_path()
  if err then
    return
  end
  
  local file_notes_dir = get_file_notes_dir()
  if fn.isdirectory(file_notes_dir) == 0 then
    fn.mkdir(file_notes_dir, "p")
  end
  
  local file = io.open(metadata_path, "w")
  if file then
    file:write(vim.json.encode(metadata))
    file:close()
  end
end

-- Find word at specific position in buffer
local function find_word_at_position(bufnr, word, start_line)
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  -- Search from start_line outward
  for offset = 0, #lines do
    for direction = 1, -1, -2 do  -- Search down then up
      local line_idx = start_line + (offset * direction)
      
      if line_idx >= 1 and line_idx <= #lines then
        local line = lines[line_idx]
        local col = string.find(line, "%f[%w]" .. vim.pesc(word) .. "%f[%W]")
        
        if col then
          return line_idx, col - 1
        end
      end
      
      if offset == 0 then break end  -- Don't search same line twice
    end
  end
  
  return nil, nil
end

-- Find the current instance of word (handles multiple occurrences)
local function find_word_instance(word, line_no, col)
  local current_line = api.nvim_get_current_line()
  local instance = 1
  local pos = 1
  
  -- Count which instance we're on in the current line
  while pos do
    pos = string.find(current_line, "%f[%w]" .. vim.pesc(word) .. "%f[%W]", pos)
    if pos and pos <= col + 1 then
      if pos == col + 1 then
        break
      end
      instance = instance + 1
      pos = pos + 1
    else
      break
    end
  end
  
  return instance
end

-- Get note path for word
local function get_note_path_for_word(word_id)
  local file_notes_dir, err = get_file_notes_dir()
  if err then
    return nil, err
  end
  
  local filename = fn.expand("%:t:r")
  local note_name = string.format("%s_%s.md", filename, word_id)
  
  return file_notes_dir .. "/" .. note_name, nil
end

-- Get note for current word
local function get_note_for_current_word()
  local word, line_no, col = get_current_word()
  local metadata, err = load_metadata()
  
  if err then
    return nil, nil, err
  end
  
  local instance = find_word_instance(word, line_no, col)
  local search_key = string.format("%s_%d_%d", word, line_no, instance)
  
  -- First, try exact match with line and instance
  for word_id, data in pairs(metadata) do
    if data.word == word and data.line == line_no and data.instance == instance then
      return word_id, data, nil
    end
  end
  
  -- Then try nearby lines (word might have moved slightly)
  for word_id, data in pairs(metadata) do
    if data.word == word and math.abs(data.line - line_no) <= 5 and data.instance == instance then
      return word_id, data, nil
    end
  end
  
  return nil, nil, nil
end

-- Create directory if it doesn't exist
local function ensure_dir(path)
  if fn.isdirectory(path) == 0 then
    fn.mkdir(path, "p")
  end
end

-- Calculate dynamic window size
local function calculate_dynamic_size(content_lines)
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  
  local base_width = math.floor(editor_width * config.float_width_ratio)
  local base_height = math.floor(editor_height * config.float_height_ratio)
  
  local content_height = #content_lines + 2
  local dynamic_height = math.min(content_height, base_height)
  dynamic_height = math.max(dynamic_height, 10)
  
  local max_line_length = 0
  for _, line in ipairs(content_lines) do
    max_line_length = math.max(max_line_length, vim.fn.strdisplaywidth(line))
  end
  local dynamic_width = math.min(max_line_length + 4, base_width)
  dynamic_width = math.max(dynamic_width, 50)
  
  dynamic_width = math.min(dynamic_width, editor_width - 4)
  dynamic_height = math.min(dynamic_height, editor_height - 4)
  
  local row = math.floor((editor_height - dynamic_height) / 2)
  local col = math.floor((editor_width - dynamic_width) / 2)
  
  return {
    width = dynamic_width,
    height = dynamic_height,
    row = row,
    col = col,
  }
end

-- Store active float windows
local active_floats = {}

-- Create floating window with dynamic sizing
local function create_float(lines, title, editable)
  local buf = api.nvim_create_buf(false, true)
  
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  api.nvim_buf_set_option(buf, 'buftype', editable and 'acwrite' or 'nofile')
  
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  if not editable then
    api.nvim_buf_set_option(buf, 'modifiable', false)
  else
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_option(buf, 'modified', false)
  end
  
  local size = calculate_dynamic_size(lines)
  
  local opts = {
    relative = 'editor',
    width = size.width,
    height = size.height,
    row = size.row,
    col = size.col,
    style = 'minimal',
    border = config.border,
    title = title,
    title_pos = 'center',
    focusable = true,
    zindex = 50,
  }
  
  local win = api.nvim_open_win(buf, true, opts)
  
  api.nvim_win_set_option(win, 'wrap', true)
  api.nvim_win_set_option(win, 'linebreak', true)
  api.nvim_win_set_option(win, 'cursorline', true)
  api.nvim_win_set_option(win, 'number', true)
  api.nvim_win_set_option(win, 'relativenumber', false)
  
  active_floats[win] = {
    buf = buf,
    title = title,
    lines = lines,
  }
  
  api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    callback = function()
      active_floats[win] = nil
    end,
    once = true,
  })
  
  local function close_float()
    if api.nvim_win_is_valid(win) then
      api.nvim_win_close(win, true)
    end
  end
  
  api.nvim_buf_set_keymap(buf, 'n', 'q', '', { 
    noremap = true, 
    silent = true,
    callback = close_float,
  })
  
  api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', { 
    noremap = true, 
    silent = true,
    callback = close_float,
  })
  
  local scroll_keys = {
    ['<C-d>'] = '<C-d>',
    ['<C-u>'] = '<C-u>',
    ['<C-f>'] = '<C-f>',
    ['<C-b>'] = '<C-b>',
  }
  
  for key, cmd in pairs(scroll_keys) do
    api.nvim_buf_set_keymap(buf, 'n', key, cmd, { noremap = true, silent = true })
  end
  
  return buf, win
end

-- Resize active floats
local function resize_active_floats()
  for win, info in pairs(active_floats) do
    if api.nvim_win_is_valid(win) then
      local size = calculate_dynamic_size(info.lines)
      api.nvim_win_set_config(win, {
        relative = 'editor',
        width = size.width,
        height = size.height,
        row = size.row,
        col = size.col,
      })
    end
  end
end

-- Place extmark for word tracking
local function place_word_mark(bufnr, word_id, line, col)
  -- Validate buffer
  if not api.nvim_buf_is_valid(bufnr) then
    return
  end
  
  -- Get buffer line count and validate line number
  local line_count = api.nvim_buf_line_count(bufnr)
  if line < 1 or line > line_count then
    return  -- Line out of range, skip marking
  end
  
  -- Validate column
  if col < 0 then
    col = 0
  end
  
  -- Remove existing mark for this word_id
  local marks = api.nvim_buf_get_extmarks(bufnr, ns, 0, -1, { details = true })
  for _, mark in ipairs(marks) do
    local mark_id = mark[1]
    pcall(api.nvim_buf_del_extmark, bufnr, ns, mark_id)
  end
  
  -- Place new mark with virtual text only (no sign)
  pcall(api.nvim_buf_set_extmark, bufnr, ns, line - 1, 0, {
    virt_text = {{config.virt_text, config.virt_text_hl}},
    virt_text_pos = "eol",
    priority = 5,
    right_gravity = false,
  })
end

-- Refresh all marks for current buffer
local function refresh_marks()
  local bufnr = api.nvim_get_current_buf()
  
  -- Don't refresh if not a normal file buffer
  if not api.nvim_buf_is_valid(bufnr) or api.nvim_buf_get_option(bufnr, 'buftype') ~= '' then
    return
  end
  
  local metadata, err = load_metadata()
  
  if err or not metadata then
    return
  end
  
  -- Clear all marks in this buffer
  api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  
  -- Re-place marks based on word positions
  for word_id, data in pairs(metadata) do
    local line, col = find_word_at_position(bufnr, data.word, data.line)
    if line and col then
      -- Update metadata with new position
      metadata[word_id].line = line
      place_word_mark(bufnr, word_id, line, col)
    end
  end
  
  save_metadata(metadata)
end

-- Create or edit note for current word
local function create_note()
  local word, line_no, col = get_current_word()
  
  if word == "" then
    print("No word under cursor")
    return
  end
  
  local file_notes_dir = get_file_notes_dir()
  ensure_dir(file_notes_dir)
  
  -- Check if note already exists for this word
  local word_id, data, err = get_note_for_current_word()
  
  local metadata = load_metadata()
  local note_path
  local is_new = false
  
  if not word_id then
    -- Create new note
    is_new = true
    local instance = find_word_instance(word, line_no, col)
    word_id = generate_word_id(word, line_no, col)
    
    metadata[word_id] = {
      word = word,
      line = line_no,
      col = col,
      instance = instance,
      created = os.time(),
    }
    
    save_metadata(metadata)
  end
  
  note_path = get_note_path_for_word(word_id)
  
  local content
  if is_new or fn.filereadable(note_path) == 0 then
    local current_file = fn.expand("%:t")
    local line_content = api.nvim_get_current_line()
    
    local context = {
      word = word,
      filename = current_file,
      line_no = line_no,
      line_content = line_content,
      filepath = fn.expand("%:p"),
      date = os.date("%Y-%m-%d"),
      time = os.date("%H:%M:%S"),
    }
    
    content = config.template(context)
  else
    content = fn.readfile(note_path)
  end
  
  local buf, win = create_float(content, string.format(" Note: %s ", word), true)
  
  -- Place mark for word tracking
  local bufnr = api.nvim_get_current_buf()
  place_word_mark(bufnr, word_id, line_no, col)
  
  api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
      
      local file = io.open(note_path, "w")
      if file then
        file:write(table.concat(lines, "\n") .. "\n")
        file:close()
        
        api.nvim_buf_set_option(buf, 'modified', false)
        print(string.format("Note saved: %s", word))
        
        vim.schedule(refresh_marks)
      end
    end,
  })
  
  api.nvim_buf_set_keymap(buf, 'n', '<leader>w', '', { 
    noremap = true, 
    silent = true,
    callback = function()
      vim.cmd('write')
      if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
    end,
  })
  
  api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    callback = function()
      if api.nvim_buf_is_valid(buf) and api.nvim_buf_get_option(buf, 'modified') then
        local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
        local file = io.open(note_path, "w")
        if file then
          file:write(table.concat(lines, "\n") .. "\n")
          file:close()
        end
      end
      vim.schedule(refresh_marks)
    end,
    once = true,
  })
end

-- Show note for current word
local function show_current_note()
  local word_id, data, err = get_note_for_current_word()
  
  if not word_id then
    local word = fn.expand("<cword>")
    print(string.format("No note for: %s", word))
    return
  end
  
  local note_path = get_note_path_for_word(word_id)
  
  if fn.filereadable(note_path) == 0 then
    print("Note file not found")
    return
  end
  
  local lines = fn.readfile(note_path)
  create_float(lines, string.format(" Note: %s ", data.word), false)
end

-- List all notes
local function list_all_notes()
  local metadata, err = load_metadata()
  
  if err then
    print("Error loading notes")
    return
  end
  
  local notes = {}
  for word_id, data in pairs(metadata) do
    table.insert(notes, data)
  end
  
  if #notes == 0 then
    print("No notes found")
    return
  end
  
  table.sort(notes, function(a, b) return a.line < b.line end)
  
  local lines = {}
  local current_file = fn.expand("%:t")
  
  table.insert(lines, string.format("# Notes for %s", current_file))
  table.insert(lines, "")
  table.insert(lines, string.format("Total notes: %d", #notes))
  table.insert(lines, "")
  table.insert(lines, "---")
  table.insert(lines, "")
  
  for _, note in ipairs(notes) do
    table.insert(lines, string.format("• **%s** (line ~%d)", note.word, note.line))
  end
  
  create_float(lines, " Notes Index ", false)
end

-- Setup function
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})
  
  local augroup = api.nvim_create_augroup("LineNotes", { clear = true })
  
  api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = augroup,
    callback = function()
      vim.schedule(refresh_marks)
    end,
  })
  
  -- Refresh on text changes but with debounce
  local timer = nil
  api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = augroup,
    callback = function()
      if timer then
        timer:stop()
      end
      timer = vim.defer_fn(function()
        refresh_marks()
      end, 500)  -- 500ms debounce
    end,
  })
  
  api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = resize_active_floats,
  })
  
  vim.api.nvim_create_user_command('LineNoteCreate', create_note, {})
  vim.api.nvim_create_user_command('LineNoteShow', show_current_note, {})
  vim.api.nvim_create_user_command('LineNotesList', list_all_notes, {})
  vim.api.nvim_create_user_command('LineNotesRefresh', refresh_marks, {})
  
  vim.keymap.set('n', '<leader>ni', create_note, { 
    noremap = true, 
    silent = true, 
    desc = 'Create/Edit note for word under cursor' 
  })
  
  vim.keymap.set('n', '<leader>no', show_current_note, { 
    noremap = true, 
    silent = true, 
    desc = 'Show note for this word' 
  })
  
  vim.keymap.set('n', '<leader>ns', show_current_note, { 
    noremap = true, 
    silent = true, 
    desc = 'Show note for this word' 
  })
  
  vim.keymap.set('n', '<leader>nl', list_all_notes, { 
    noremap = true, 
    silent = true, 
    desc = 'List all notes' 
  })
  
end

return M
