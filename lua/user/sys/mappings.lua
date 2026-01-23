--=========================
--Custom Command
--=========================
vim.api.nvim_create_user_command("Tldr", function()
    vim.cmd("Trouble diagnostics toggle")
end, {})


-- ======================
-- Move Line Up or down 
-- ======================
-- Normal mode: move current line up/down
-- Visual Line mode: move selected lines up/down
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { noremap = true, silent = true })

-- Visual Line mode: move selected lines up/down (repeatable)
vim.keymap.set("x", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("x", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Keep selection after shifting with < or >
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Ctrl-based mappings (example: Ctrl-h and Ctrl-l)
vim.keymap.set("v", "<C-h>", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-l>", ">gv", { noremap = true, silent = true })


-- Interactice replace word from two lines
function _G.SubstituteRange()
  local start_line = vim.fn.input("Start line: ")
  local end_line = vim.fn.input("End line: ")
  local old = vim.fn.input("Find: ")
  local new = vim.fn.input("Replace with: ")
  vim.cmd(start_line .. "," .. end_line .. "s/" .. old .. "/" .. new .. "/g")
end

vim.keymap.set("n", "<leader>rs", ":lua SubstituteRange()<CR>", { desc = "Range substitute" })

-- Whole Buffer , select 1 and last line 
function _G.SubstituteAll()
  local old = vim.fn.input("Find: ")
  local new = vim.fn.input("Replace with: ")
  local last_line = vim.api.nvim_buf_line_count(0)
  vim.cmd("1," .. last_line .. "s/" .. old .. "/" .. new .. "/g")
end

vim.keymap.set("n", "<leader>ra", ":lua SubstituteAll()<CR>", { desc = "Replace in whole file" })

-- Visual Mode Select as much as as you want.
vim.keymap.set("v", "<leader>rs", ":s///g<Left><Left>", { desc = "Replace in selection" })

-- Pattern Based 
function _G.SubstituteMatchingLines()
  local pattern = vim.fn.input("Line contains: ")
  local old = vim.fn.input("Find: ")
  local new = vim.fn.input("Replace with: ")
  vim.cmd("g/" .. pattern .. "/s/" .. old .. "/" .. new .. "/g")
end

vim.keymap.set("n", "<leader>rm", ":lua SubstituteMatchingLines()<CR>", { desc = "Replace in matching lines" })

-- ####################
-- Keymaps Overlapping
-- ####################
local function find_leader_overlaps()
    local seen = {}
    local found_overlap = false

    for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
        if map.lhs:match("^<leader>") then
            if seen[map.lhs] then
                found_overlap = true
                vim.notify(
                    string.format("Overlap detected: %s -> %s AND %s", map.lhs, seen[map.lhs], map.rhs),
                    vim.log.levels.WARN
                )
            else
                seen[map.lhs] = map.rhs
            end
        end
    end

    if not found_overlap then
        vim.notify("No leader key overlaps detected", vim.log.levels.INFO)
    end
end

-- Run the check
find_leader_overlaps()

-- ###################
-- Move to Destiny
-- ###################
-- Move selected block of lines to a target line number
-- Works with visual line mode (V), visual mode (v), and visual block mode (Ctrl-v)
local function move_block_to_line()
  -- Get the visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Prompt for target line number
  local target = vim.fn.input("Move to line: ")
  target = tonumber(target)

  if not target then
    print("\nInvalid line number")
    return
  end

  -- Get the lines to move
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local num_lines = #lines

  -- Delete the selected lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})

  -- Adjust target line if needed (if target is after deleted lines)
  local adjusted_target = target
  if target > start_line then
    adjusted_target = target - num_lines
  end

  -- Insert lines at target position
  -- If target is at the end, we need to handle it differently
  local total_lines = vim.api.nvim_buf_line_count(0)
  if adjusted_target > total_lines then
    adjusted_target = total_lines
  end

  vim.api.nvim_buf_set_lines(0, adjusted_target, adjusted_target, false, lines)

  -- Move cursor to the moved block
  vim.api.nvim_win_set_cursor(0, {adjusted_target + 1, 0})

  print(string.format("\nMoved %d lines to line %d", num_lines, adjusted_target + 1))
end

-- Create a user command for easier access
vim.api.nvim_create_user_command('MoveBlock', move_block_to_line, { range = true })

-- Set up keymapping (optional - you can change this)
-- In visual mode, press <leader>m to move selected block
vim.keymap.set('v', '<leader>m', ':MoveBlock<CR>', { noremap = true, silent = false, desc = 'Move block to line' })

-- Alternative: Quick move with just `:M <line_number>`
vim.api.nvim_create_user_command('M', move_block_to_line, { range = true })

