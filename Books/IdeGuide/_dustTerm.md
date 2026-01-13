# FloatingTerminal API - Complete Guide

## Table of Contents
1. [Installation & Setup](#installation--setup)
2. [Basic Usage](#basic-usage)
3. [API Reference](#api-reference)
4. [Integration Examples](#integration-examples)
5. [Advanced Usage](#advanced-usage)
6. [Limitations](#limitations)
7. [Troubleshooting](#troubleshooting)

---

## Installation & Setup

### File Structure
```
~/.config/nvim/
├── lua/
│   └── user/
│       └── config/
│           └── IdeBatch/
│               ├── toggleterm.lua    # The terminal module
│               └── run.lua           # Example integration (code runner)
└── init.lua                          # Your main config
```

### Step 1: Create the Module

Save the terminal module as `lua/user/config/IdeBatch/toggleterm.lua` (or adjust path as needed).

### Step 2: Initialize in init.lua

```lua
-- Load and expose the terminal module globally
local term = require("user.config.IdeBatch.toggleterm")
_G.FloatingTerminal = term

-- Setup with default keymaps
term.setup({
  default_key = "<C-\\>",   -- Toggle default terminal
  next_key = "<leader>tn",  -- Next terminal (normal mode only)
  prev_key = "<leader>tp",  -- Previous terminal (normal mode only)
  select_key = "<leader>ts" -- Select terminal (normal mode only)
})

-- Load other integrations
require("user.config.IdeBatch.run")  -- Code runner example
```

---

## Basic Usage

### Default Keybindings

#### Available Everywhere (Normal & Terminal Mode)
- `Ctrl + \` - Toggle default terminal

#### Terminal Mode Only
- `Ctrl + g` - Toggle git terminal
- `Ctrl + t` - Toggle test terminal
- `Ctrl + x` - Close current terminal
- `Esc Esc` - Close current terminal
- `Ctrl + ↑/↓/←/→` - Resize terminal window
- `Ctrl + Space` - Enter terminal-normal mode (enables leader keys)

#### Terminal-Normal Mode Only (after `Ctrl+Space`)
- `<leader>tn` - Jump to next terminal
- `<leader>tp` - Jump to previous terminal
- `<leader>ts` - Show terminal selector
- `i`, `I`, `a`, `A` - Return to terminal insert mode

---

## API Reference

### Core Functions

#### `FloatingTerminal.toggle(id, title)`
Toggle a terminal by ID. Creates new terminal if it doesn't exist.

```lua
-- Toggle default terminal
_G.FloatingTerminal.toggle("default", "My Terminal")

-- Toggle git terminal
_G.FloatingTerminal.toggle("git", "Git Operations")
```

**Parameters:**
- `id` (string): Unique identifier for the terminal
- `title` (string, optional): Display name in window title bar

---

#### `FloatingTerminal.open(id, title)`
Open a terminal (does nothing if already open).

```lua
_G.FloatingTerminal.open("build", "Build Output")
```

---

#### `FloatingTerminal.close(id)`
Close a specific terminal window.

```lua
_G.FloatingTerminal.close("git")
```

---

#### `FloatingTerminal.is_open(id)`
Check if a terminal is currently open.

```lua
if _G.FloatingTerminal.is_open("default") then
  print("Terminal is open!")
end
```

**Returns:** boolean

---

#### `FloatingTerminal.send(cmd, id)`
Send a command to a specific terminal. Opens terminal if closed.

```lua
-- Send single command
_G.FloatingTerminal.send("ls -la", "default")

-- Send multiple commands
_G.FloatingTerminal.send("cd /tmp", "default")
_G.FloatingTerminal.send("git status", "default")
```

**Parameters:**
- `cmd` (string): Command to execute (automatically adds newline)
- `id` (string): Terminal ID to send command to

---

#### `FloatingTerminal.list_open()`
Get list of all open terminals.

```lua
local terminals = _G.FloatingTerminal.list_open()
for _, term in ipairs(terminals) do
  print("Terminal:", term.id, "Buffer:", term.buf, "Window:", term.win)
end
```

**Returns:** Array of `{id, buf, win}` tables

---

#### `FloatingTerminal.next()`
Jump to next open terminal.

```lua
_G.FloatingTerminal.next()
```

---

#### `FloatingTerminal.prev()`
Jump to previous open terminal.

```lua
_G.FloatingTerminal.prev()
```

---

#### `FloatingTerminal.select()`
Show interactive terminal selector menu.

```lua
_G.FloatingTerminal.select()
```

---

#### `FloatingTerminal.setup(opts)`
Initialize module with custom keybindings.

```lua
_G.FloatingTerminal.setup({
  default_key = "<C-\\>",   -- Custom toggle key
  next_key = "<leader>tn",
  prev_key = "<leader>tp",
  select_key = "<leader>ts"
})
```

---

## Integration Examples

### Example 1: Code Runner (Already Implemented)

**File:** `lua/user/config/IdeBatch/run.lua`

```lua
local FloatingTerminal = require("user.config.IdeBatch.toggleterm")
local RUNNER_ID = "code_runner"

local function run_filetype_command()
    local ft = vim.bo.filetype
    local cwd = vim.fn.getcwd()
    local file = vim.fn.expand("%")
    local root = vim.fn.expand("%:r")

    local cmd = nil

    if ft == "python" then
        cmd = "python3 " .. file
    elseif ft == "javascript" then
        cmd = "node " .. file
    elseif ft == "rust" then
        cmd = "cargo run"
    -- ... more filetypes
    else
        vim.notify("No runner for filetype: " .. ft, vim.log.levels.WARN)
        return
    end

    vim.schedule(function()
        FloatingTerminal.send("cd " .. cwd, RUNNER_ID)
        FloatingTerminal.send("clear", RUNNER_ID)
        FloatingTerminal.send(cmd, RUNNER_ID)
    end)
end

vim.keymap.set("n", "<leader>zz", run_filetype_command, { desc = "Run file" })
vim.keymap.set("n", "<leader>xz", function()
    FloatingTerminal.toggle(RUNNER_ID, "Code Runner")
end, { desc = "Toggle runner" })
```

**Usage:**
- `<leader>zz` - Run current file in dedicated terminal
- `<leader>xz` - Toggle the code runner terminal

---

### Example 2: Git Integration

**File:** `lua/user/config/git_terminal.lua`

```lua
local term = _G.FloatingTerminal
local GIT_ID = "git"

local M = {}

function M.status()
    term.send("git status", GIT_ID)
end

function M.diff()
    term.send("git diff", GIT_ID)
end

function M.log()
    term.send("git log --oneline --graph --all -20", GIT_ID)
end

function M.add_all()
    term.send("git add .", GIT_ID)
end

function M.commit()
    vim.ui.input({ prompt = "Commit message: " }, function(msg)
        if msg then
            term.send('git commit -m "' .. msg .. '"', GIT_ID)
        end
    end)
end

function M.push()
    term.send("git push", GIT_ID)
end

function M.pull()
    term.send("git pull", GIT_ID)
end

-- Setup keymaps
vim.keymap.set("n", "<leader>gs", M.status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", M.diff, { desc = "Git diff" })
vim.keymap.set("n", "<leader>gl", M.log, { desc = "Git log" })
vim.keymap.set("n", "<leader>ga", M.add_all, { desc = "Git add all" })
vim.keymap.set("n", "<leader>gc", M.commit, { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", M.push, { desc = "Git push" })
vim.keymap.set("n", "<leader>gP", M.pull, { desc = "Git pull" })

-- Toggle git terminal
vim.keymap.set({ "n", "t" }, "<leader>gg", function()
    term.toggle(GIT_ID, "Git Terminal")
end, { desc = "Toggle git terminal" })

return M
```

**Usage:**
- `<leader>gs` - Run git status
- `<leader>gd` - Show git diff
- `<leader>gc` - Commit with message prompt
- `<leader>gg` - Toggle git terminal

---

### Example 3: Build System Integration

**File:** `lua/user/config/build_system.lua`

```lua
local term = _G.FloatingTerminal
local BUILD_ID = "build"

local M = {}

-- Project-specific build commands
local build_commands = {
    cmake = {
        configure = "cmake -B build -S .",
        build = "cmake --build build",
        clean = "rm -rf build"
    },
    make = {
        build = "make",
        clean = "make clean",
        install = "make install"
    },
    cargo = {
        build = "cargo build",
        release = "cargo build --release",
        test = "cargo test",
        clean = "cargo clean"
    },
    npm = {
        install = "npm install",
        build = "npm run build",
        dev = "npm run dev",
        test = "npm test"
    }
}

-- Auto-detect build system
function M.detect_build_system()
    if vim.fn.filereadable("Cargo.toml") == 1 then
        return "cargo"
    elseif vim.fn.filereadable("CMakeLists.txt") == 1 then
        return "cmake"
    elseif vim.fn.filereadable("Makefile") == 1 then
        return "make"
    elseif vim.fn.filereadable("package.json") == 1 then
        return "npm"
    end
    return nil
end

function M.build()
    local system = M.detect_build_system()
    if not system then
        vim.notify("No build system detected", vim.log.levels.WARN)
        return
    end
    
    local cmd = build_commands[system].build
    term.send("clear", BUILD_ID)
    term.send(cmd, BUILD_ID)
end

function M.clean()
    local system = M.detect_build_system()
    if not system then
        vim.notify("No build system detected", vim.log.levels.WARN)
        return
    end
    
    local cmd = build_commands[system].clean
    term.send(cmd, BUILD_ID)
end

function M.run_tests()
    local system = M.detect_build_system()
    if system == "cargo" then
        term.send("cargo test", BUILD_ID)
    elseif system == "npm" then
        term.send("npm test", BUILD_ID)
    else
        vim.notify("No test command for " .. system, vim.log.levels.WARN)
    end
end

-- Keymaps
vim.keymap.set("n", "<leader>bb", M.build, { desc = "Build project" })
vim.keymap.set("n", "<leader>bc", M.clean, { desc = "Clean build" })
vim.keymap.set("n", "<leader>bt", M.run_tests, { desc = "Run tests" })
vim.keymap.set("n", "<leader>bw", function()
    term.toggle(BUILD_ID, "Build")
end, { desc = "Toggle build terminal" })

return M
```

**Usage:**
- `<leader>bb` - Build project (auto-detects build system)
- `<leader>bc` - Clean build
- `<leader>bt` - Run tests
- `<leader>bw` - Toggle build terminal

---

### Example 4: Docker Integration

**File:** `lua/user/config/docker_terminal.lua`

```lua
local term = _G.FloatingTerminal
local DOCKER_ID = "docker"

local M = {}

function M.ps()
    term.send("docker ps -a", DOCKER_ID)
end

function M.images()
    term.send("docker images", DOCKER_ID)
end

function M.compose_up()
    term.send("docker-compose up -d", DOCKER_ID)
end

function M.compose_down()
    term.send("docker-compose down", DOCKER_ID)
end

function M.compose_logs()
    term.send("docker-compose logs -f", DOCKER_ID)
end

function M.prune()
    vim.ui.select(
        { "containers", "images", "volumes", "all" },
        { prompt = "Prune what?" },
        function(choice)
            if choice then
                term.send("docker system prune --" .. choice, DOCKER_ID)
            end
        end
    )
end

-- Keymaps
vim.keymap.set("n", "<leader>dp", M.ps, { desc = "Docker ps" })
vim.keymap.set("n", "<leader>di", M.images, { desc = "Docker images" })
vim.keymap.set("n", "<leader>du", M.compose_up, { desc = "Docker compose up" })
vim.keymap.set("n", "<leader>dd", M.compose_down, { desc = "Docker compose down" })
vim.keymap.set("n", "<leader>dl", M.compose_logs, { desc = "Docker logs" })
vim.keymap.set("n", "<leader>dP", M.prune, { desc = "Docker prune" })

vim.keymap.set({ "n", "t" }, "<leader>dt", function()
    term.toggle(DOCKER_ID, "Docker")
end, { desc = "Toggle docker terminal" })

return M
```

---

### Example 5: Testing Framework Integration

**File:** `lua/user/config/test_runner.lua`

```lua
local term = _G.FloatingTerminal
local TEST_ID = "test"

local M = {}

-- Test commands by filetype
local test_commands = {
    python = {
        file = "pytest %s -v",
        all = "pytest",
        coverage = "pytest --cov"
    },
    javascript = {
        file = "npm test -- %s",
        all = "npm test",
        watch = "npm test -- --watch"
    },
    rust = {
        file = "cargo test",
        all = "cargo test",
        specific = "cargo test %s"
    },
    go = {
        file = "go test -v %s",
        all = "go test ./...",
        coverage = "go test -cover ./..."
    }
}

function M.run_current_file()
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%")
    
    if not test_commands[ft] then
        vim.notify("No test runner for " .. ft, vim.log.levels.WARN)
        return
    end
    
    local cmd = string.format(test_commands[ft].file, file)
    term.send("clear", TEST_ID)
    term.send(cmd, TEST_ID)
end

function M.run_all()
    local ft = vim.bo.filetype
    
    if not test_commands[ft] then
        vim.notify("No test runner for " .. ft, vim.log.levels.WARN)
        return
    end
    
    term.send("clear", TEST_ID)
    term.send(test_commands[ft].all, TEST_ID)
end

function M.run_with_coverage()
    local ft = vim.bo.filetype
    
    if not test_commands[ft] or not test_commands[ft].coverage then
        vim.notify("No coverage command for " .. ft, vim.log.levels.WARN)
        return
    end
    
    term.send("clear", TEST_ID)
    term.send(test_commands[ft].coverage, TEST_ID)
end

function M.watch()
    local ft = vim.bo.filetype
    
    if not test_commands[ft] or not test_commands[ft].watch then
        vim.notify("No watch mode for " .. ft, vim.log.levels.WARN)
        return
    end
    
    term.send("clear", TEST_ID)
    term.send(test_commands[ft].watch, TEST_ID)
end

-- Keymaps
vim.keymap.set("n", "<leader>tf", M.run_current_file, { desc = "Test current file" })
vim.keymap.set("n", "<leader>ta", M.run_all, { desc = "Test all" })
vim.keymap.set("n", "<leader>tc", M.run_with_coverage, { desc = "Test with coverage" })
vim.keymap.set("n", "<leader>tw", M.watch, { desc = "Test watch mode" })

vim.keymap.set({ "n", "t" }, "<leader>tt", function()
    term.toggle(TEST_ID, "Test Runner")
end, { desc = "Toggle test terminal" })

return M
```

---

### Example 6: Database Integration

**File:** `lua/user/config/db_terminal.lua`

```lua
local term = _G.FloatingTerminal
local DB_ID = "database"

local M = {}

-- Database connection profiles
M.profiles = {
    local_postgres = {
        cmd = "psql -U postgres -d mydb",
        name = "Local PostgreSQL"
    },
    local_mysql = {
        cmd = "mysql -u root -p",
        name = "Local MySQL"
    },
    local_mongo = {
        cmd = "mongosh",
        name = "Local MongoDB"
    },
    local_redis = {
        cmd = "redis-cli",
        name = "Local Redis"
    }
}

function M.connect(profile_name)
    local profile = M.profiles[profile_name]
    if not profile then
        vim.notify("Unknown profile: " .. profile_name, vim.log.levels.ERROR)
        return
    end
    
    term.open(DB_ID, profile.name)
    term.send(profile.cmd, DB_ID)
end

function M.select_and_connect()
    local profile_names = {}
    for name, _ in pairs(M.profiles) do
        table.insert(profile_names, name)
    end
    
    vim.ui.select(profile_names, {
        prompt = "Select database profile:",
    }, function(choice)
        if choice then
            M.connect(choice)
        end
    end)
end

function M.execute_query()
    if not term.is_open(DB_ID) then
        vim.notify("No database connection open", vim.log.levels.WARN)
        M.select_and_connect()
        return
    end
    
    vim.ui.input({ prompt = "SQL Query: " }, function(query)
        if query then
            term.send(query, DB_ID)
        end
    end)
end

-- Keymaps
vim.keymap.set("n", "<leader>db", M.select_and_connect, { desc = "Connect to database" })
vim.keymap.set("n", "<leader>dq", M.execute_query, { desc = "Execute query" })

vim.keymap.set({ "n", "t" }, "<leader>dt", function()
    term.toggle(DB_ID, "Database")
end, { desc = "Toggle database terminal" })

return M
```

---

## Advanced Usage

### Creating Custom Terminal Managers

You can create specialized terminal managers that wrap the API:

```lua
-- lua/user/config/terminal_manager.lua

local term = _G.FloatingTerminal

local M = {}

-- Track terminal purposes
M.terminals = {
    default = { id = "default", title = "Terminal", icon = "" },
    git = { id = "git", title = "Git", icon = "" },
    build = { id = "build", title = "Build", icon = "" },
    test = { id = "test", title = "Test", icon = "󰙨" },
    docker = { id = "docker", title = "Docker", icon = "" },
    runner = { id = "code_runner", title = "Runner", icon = "" },
}

-- Create terminal with context
function M.create(purpose, custom_title)
    local config = M.terminals[purpose]
    if not config then
        vim.notify("Unknown terminal purpose: " .. purpose, vim.log.levels.ERROR)
        return
    end
    
    local title = custom_title or (config.icon .. " " .. config.title)
    term.toggle(config.id, title)
end

-- Execute command in context
function M.exec(purpose, cmd)
    local config = M.terminals[purpose]
    if not config then
        vim.notify("Unknown terminal purpose: " .. purpose, vim.log.levels.ERROR)
        return
    end
    
    term.send(cmd, config.id)
end

-- Get all open terminals with metadata
function M.list()
    local open = term.list_open()
    local result = {}
    
    for _, t in ipairs(open) do
        for purpose, config in pairs(M.terminals) do
            if config.id == t.id then
                table.insert(result, {
                    purpose = purpose,
                    id = t.id,
                    title = config.title,
                    icon = config.icon,
                    buf = t.buf,
                    win = t.win
                })
                break
            end
        end
    end
    
    return result
end

-- Show terminal dashboard
function M.dashboard()
    local open = M.list()
    
    if #open == 0 then
        vim.notify("No terminals open", vim.log.levels.INFO)
        return
    end
    
    print("\n=== Open Terminals ===")
    for _, t in ipairs(open) do
        local status = term.is_open(t.id) and "●" or "○"
        print(string.format("%s %s %s", status, t.icon, t.title))
    end
    print("======================\n")
end

return M
```

**Usage:**
```lua
local tm = require("user.config.terminal_manager")

-- Create terminals
tm.create("git")
tm.create("build")

-- Execute commands
tm.exec("git", "git status")
tm.exec("build", "make")

-- Show dashboard
tm.dashboard()
```

---

### Session Persistence (Advanced)

Save and restore terminal states across Neovim sessions:

```lua
-- lua/user/config/terminal_session.lua

local term = _G.FloatingTerminal
local M = {}

M.session_file = vim.fn.stdpath("data") .. "/terminal_sessions.json"

function M.save()
    local open = term.list_open()
    local session = {}
    
    for _, t in ipairs(open) do
        table.insert(session, {
            id = t.id,
            -- Note: We can't save terminal content, only which terminals were open
        })
    end
    
    local file = io.open(M.session_file, "w")
    if file then
        file:write(vim.json.encode(session))
        file:close()
        vim.notify("Terminal session saved", vim.log.levels.INFO)
    end
end

function M.restore()
    local file = io.open(M.session_file, "r")
    if not file then
        return
    end
    
    local content = file:read("*a")
    file:close()
    
    local ok, session = pcall(vim.json.decode, content)
    if not ok or not session then
        return
    end
    
    for _, t in ipairs(session) do
        -- Reopen terminals (content won't be restored)
        term.open(t.id)
    end
    
    vim.notify("Terminal session restored", vim.log.levels.INFO)
end

-- Auto-save on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        M.save()
    end
})

return M
```

---

## Limitations

### What the API Can Do ✅

1. **Multiple Independent Terminals**
   - Create unlimited separate terminal instances
   - Each terminal maintains its own session and history
   - Terminals persist when closed/reopened (session stays alive)

2. **Send Commands Programmatically**
   - Execute any shell command
   - Chain multiple commands
   - Integrate with any workflow

3. **Window Management**
   - Toggle terminals on/off
   - Resize windows dynamically
   - Jump between terminals
   - Floating window with borders and titles

4. **State Queries**
   - Check if terminal is open
   - List all open terminals
   - Get terminal metadata (buffer, window, ID)

5. **Integration**
   - Works with any plugin
   - Global API accessible everywhere
   - Lua-based, easy to extend

### What the API Cannot Do ❌

1. **Terminal Content Access**
   - Cannot read terminal output programmatically
   - Cannot capture command results
   - Cannot parse terminal content
   - **Workaround:** Redirect output to files and read files

```lua
-- Instead of reading output:
term.send("ls > /tmp/output.txt", "default")
vim.defer_fn(function()
    local lines = vim.fn.readfile("/tmp/output.txt")
    -- Process lines
end, 100)
```

2. **Command Completion Detection**
   - Cannot detect when a command finishes
   - Cannot get exit codes
   - No callbacks for command completion
   - **Workaround:** Use shell scripting with markers

```lua
term.send("my_command && echo '__DONE__'", "default")
-- Manually check for __DONE__ marker
```

3. **Session Content Persistence**
   - Terminal content is lost when Neovim closes
   - Cannot save/restore terminal output
   - Cannot serialize terminal state
   - **Workaround:** Use terminal multiplexers (tmux, screen)

4. **Interactive Prompts**
   - Cannot programmatically respond to interactive prompts
   - Cannot handle password prompts automatically
   - **Workaround:** Use expect scripts or pre-configure credentials

5. **Terminal Emulation Features**
   - No scrollback buffer access
   - No search within terminal
   - No copy mode (use Neovim's terminal-normal mode instead)
   - Cannot detect cursor position in terminal

6. **Process Management**
   - Cannot list running processes in terminal
   - Cannot kill specific processes
   - Cannot pause/resume processes
   - **Workaround:** Send signals manually (`Ctrl+C` = `<C-c>` in terminal)

7. **Cross-Session Communication**
   - Terminals don't share state with each other
   - Cannot pipe output between terminals
   - **Workaround:** Use temporary files or named pipes

---

## Troubleshooting

### Common Issues

#### Issue: `attempt to index field 'FloatingTerminal' (a nil value)`

**Cause:** Module not loaded before use.

**Solution:**
```lua
-- In init.lua, load BEFORE any files that use it
_G.FloatingTerminal = require("user.config.IdeBatch.toggleterm")

-- THEN load other files
require("user.config.IdeBatch.run")
```

---

#### Issue: Leader keys don't work in terminal

**Cause:** Terminal mode doesn't recognize `<leader>` key.

**Solution:**
```lua
-- Press Ctrl+Space first to enter terminal-normal mode
-- THEN use leader keys
```

Or use Ctrl-based mappings that work in terminal mode:
```lua
vim.keymap.set("t", "<C-g>", function()
    term.toggle("git", "Git")
end)
```

---

#### Issue: Terminal closes immediately after command

**Cause:** Command finishes and shell exits.

**Solution:** Don't let the shell exit:
```lua
-- Wrong: This exits the shell
term.send("python script.py && exit", "runner")

-- Right: Command runs, shell stays open
term.send("python script.py", "runner")
```

---

#### Issue: Commands not executing

**Cause:** Terminal not open or invalid channel.

**Solution:** The API handles this automatically, but ensure terminal ID is correct:
```lua
-- Check if terminal exists
if term.is_open("myterm") then
    term.send("ls", "myterm")
else
    print("Terminal not open")
end
```

---

#### Issue: Cannot resize terminal

**Cause:** Window not in focus or invalid window handle.

**Solution:** Ensure you're in the terminal window:
```lua
-- Resize mappings only work when terminal window is focused
-- Press Ctrl+\ first to focus the terminal
-- Then use Ctrl+Arrow keys
```

---

#### Issue: Terminal selector shows wrong terminals

**Cause:** Terminals weren't properly closed.

**Solution:**
```lua
-- Properly close terminals
term.close("git")

-- Or close all (manual cleanup)
for _, t in ipairs(term.list_open()) do
    term.close(t.id)
end
```

---

### Debug Mode

Add debugging to see what's happening:

```lua
-- Add to toggleterm.lua
local DEBUG = true

local function debug_log(msg)
    if DEBUG then
        print("[FloatingTerminal] " .. msg)
    end
end

-- Use in functions
function M.send(cmd, id)
    debug_log("Sending to " .. id .. ": " .. cmd)
    -- ... rest of function
end
```

---

## Best Practices

### 1. Use Descriptive Terminal IDs
```lua
-- Good
term.toggle("python_repl", "Python REPL")
term.toggle("webpack_dev", "Webpack Dev Server")

-- Bad
term.toggle("term1", "Term1")
term.toggle("t", "T")
```

### 2. Create Dedicated Terminals for Different Tasks
```lua
-- Separate terminals for different purposes
local RUNNER_ID = "code_runner"
local GIT_ID = "git_ops"
local BUILD_ID = "build_system"
local TEST_ID = "test_runner"
```

### 3. Use vim.schedule for Commands
```lua
-- Prevents timing issues
vim.schedule(function()
    term.send("cd " .. dir, "default")
    term.send("ls -la", "default")
end)
```

### 4. Chain Commands Properly
```lua
-- Use && for sequential execution
term.send("cd /project && npm install && npm start", "dev")

-- Or send separately with delays
term.send("cd /project", "dev")
vim.defer_fn(function()
    term.send("npm install", "dev")
end, 100)
```

### 5. Handle Errors Gracefully
```lua
function M.safe_send(cmd, id)
    if not term.is_open(id) then
        vim.notify("Terminal " .. id .. " not open", vim.log.levels.WARN)
        return false
    end
    
    term.send(cmd, id)
    return true
end
```

---

