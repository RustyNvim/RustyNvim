# DustNvim

<div align="center">

**🦀 A blazing-fast Neovim distribution built for speed and simplicity.**

**Sub-400ms startup • 63 plugins • 20 LSP servers • 5 theme collections • Zero bloat.**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Neovim](https://img.shields.io/badge/neovim-0.10+-green.svg)](https://neovim.io)
[![Platform](https://img.shields.io/badge/platform-Linux%20|%20macOS%20|%20Termux-lightgrey.svg)]()

[Features](#-features) • [Installation](#-installation) • [Screenshots](#-screenshots) • [Structure](#-architecture) • [Contributing](#-contributing)

</div>

---

## 🎯 Philosophy

DustNvim is a **production-ready IDE** that respects your time. No configuration sprawl. No endless tweaking. Just a carefully curated setup that works out of the box—from desktop workstations to mobile devices.

### Why DustNvim?

| Feature | DustNvim | Typical Configs |
|---------|----------|-----------------|
| **Startup** | <400ms (std/fs.rs on Termux) | 2-5 seconds |
| **Mobile** | Built & tested on Termux | Often broken |
| **Themes** | 5 curated collections | Scattered individual themes |
| **Plugins** | 63 carefully selected | 100+ bloat |
| **Rust** | Pre-configured rust-analyzer | Manual setup |
| **LSP** | Manual control, no Mason | Auto-installed dependencies |
| **Philosophy** | Opinionated, ready to use | Configure everything |

**Perfect for:**
- 🚀 Developers who want to code, not configure
- 📱 Mobile development in Termux
- 🦀 Rustaceans seeking first-class tooling
- ⚡ Anyone who values speed over complexity
- 🎨 Theme enthusiasts

---

## ✨ Features

### **⚡ Performance Note**

> **Termux (Mobile):** ~300ms for std/fs.rs file loading. Some lag expected due to mobile CPU constraints.  
> **Desktop:** Blazing fast startup (<100ms on modern CPUs). All features run smoothly.

DustNvim is optimized for both, but desktop will always be faster. Termux configs include specific optimizations (disabled proc macros, reduced cargo features, etc.).

### **🔥 Core Strengths**

- **⚡ Blazing Fast** — Sub-400ms startup on desktop; ~300ms for std/fs.rs on Termux
- **🦀 Rust Excellence** — Termux-optimized rust-analyzer with instant diagnostics
- **📱 Termux Native** — Tested and optimized for mobile development
- **🎨 Curated Themes** — 5 popular collections (Catppuccin, Rose Pine, Tokyo Night, Nightfox, Gruvbox)
- **🛠️ LSP Ready** — 20 pre-configured language servers across 6 categories (manual binary management)
- **💡 Smart Completion** — Blink.cmp with snippet support
- **📁 Dual File Navigation** — Oil.nvim (buffer-style) + Yazi (visual manager)

### **💻 Developer Experience**

| Feature | Tool | Keybinding |
|---------|------|------------|
| **Fuzzy Finding** | fzf-lua | `<Space>f` + sequence |
| **File Explorer** | Oil.nvim | `-` (open) / `<C-c>` (close) |
| **Visual Manager** | Yazi | `<Space>yo` + sequence |
| **Precision Jumps** | Leap.nvim | `m`/`M` + 2 chars |
| **Buffer Switching** | Snipe | `<Space>sb` |
| **LSP Actions** | Native LSP | `gp` + sequence |
| **LSP Hover** | Native LSP | `K` |
| **Code Preview** | goto-preview | `gpd`/`gpr`/`gpi` |
| **Diagnostics** | Trouble.nvim | Auto + `<Space>ut` |
| **Undo History** | Undotree | `<Space>ut` |
| **Terminal** | Built-in + Lazygit | `<C-\>` / `<Space>gl` |
| **Sessions** | auto-session | `<Space>ss/sl/si` |
| **Run Code** | Custom module | `<Space>zz` |
| **Which-Key** | which-key.nvim | `<Space>` |

### **🎨 UI Polish**

- **Tokyo Night Default** — Beautiful Tokyo Night theme out of the box
- **5 Theme Collections** — Catppuccin, Rose Pine, Tokyo Night, Nightfox, Gruvbox variants
- **Smart Statusline** — File info, LSP status, git branch (lualine)
- **Buffer Tabline** — Visual buffer management (cokeline)
- **Indent Guides** — Rainbow indentation (indent-blankline)
- **Icon Support** — Beautiful file icons (mini.icons + web-devicons)
- **Clean Notifications** — Non-intrusive popups (mini.notify)

### **🔧 Language Support**

**20 pre-configured LSP servers:**

<details>
<summary><b>🔩 Low-Level (5 servers)</b></summary>

- Rust (`rust-analyzer`)
- C/C++ (`clangd`)
- Zig (`zls`)
- Assembly (`asm-lsp`)
- CMake (`cmake`)

</details>

<details>
<summary><b>🐍 High-Level (2 servers)</b></summary>

- Python (`pyright`)
- Lua (`lua-ls`)

</details>

<details>
<summary><b>🌐 Web Development (5 servers)</b></summary>

- TypeScript/JavaScript (`ts_ls`)
- Go (`gopls`)
- HTML (`html`)
- CSS (`css_ls`)
- PHP (`phpactor`)

</details>

<details>
<summary><b>🎮 Game Development (1 server)</b></summary>

- GDScript (`godot_ls`)

</details>

<details>
<summary><b>📝 Productivity (4 servers)</b></summary>

- Markdown (`marksman`)
- Bash (`bash_ls`)
- Vim (`vimls`)
- Vale (prose linting)

</details>

<details>
<summary><b>🔧 Utilities (3 servers)</b></summary>

- Docker (`dockerls`)
- JSON (`jsonls`)
- YAML (`yamlls`)

</details>

---

## 📸 Screenshots

<div align="center">

### Coding Interface with LSP Diagnostics
![Main Interface](https://github.com/user-attachments/assets/f0cafcf7-5e85-426e-b689-8b0e13a1b101)

### File Navigation & Buffer Management
![File Navigation](https://github.com/user-attachments/assets/448f5763-c4c7-4157-9d70-48baae2b0dad)

### Fuzzy Finding with fzf.lua
![Fuzzy Finder](https://github.com/user-attachments/assets/2a345bc7-32eb-4692-ae71-45f6cfc0938b)

<details>
<summary>📷 <b>View More Screenshots</b></summary>

<br>

### Live Diagnostics & Error Highlighting
![Diagnostics](https://github.com/user-attachments/assets/13fa7537-bb8a-4add-bcdb-25d652a417ad)

### LSP Features & Code Actions
![LSP Features](https://github.com/user-attachments/assets/e045b264-80f2-4ff7-b4da-77f487e748d4)

### Integrated Terminal & Git
![Terminal](https://github.com/user-attachments/assets/cd27e86e-707d-46ab-95a3-5f11da96dcee)

</details>

</div>

---

## 🚀 Installation

### Recommended: Stable Release (v1.0.0)

```bash
# Clone stable version
mkdir -p ~/.config/dusn && cd ~/.config/dusn
git clone --depth 1 --branch v1.0.0 https://github.com/visrust/DustNvim.git .
# First launch (auto-installs plugins)
NVIM_APPNAME=dusn nvim
```

**First Launch:** Lazy.nvim auto-installs all plugins (1-2 minutes). Restart Neovim after completion.

### Unstable (Not Recommended)

> ⚠️ **Deprecated:** Continuous updates may cause breaking changes. Only use if you need bleeding-edge features.

```bash
# Clone main branch (unstable)
mkdir -p ~/.config/dusn && cd ~/.config/dusn
git clone --depth=1 https://github.com/visrust/DustNvim.git .

# Launch
NVIM_APPNAME=dusn nvim
```

### Add Alias

```bash
# Bash
echo "alias dusn='NVIM_APPNAME=dusn nvim'" >> ~/.bashrc && source ~/.bashrc

# Zsh
echo "alias dusn='NVIM_APPNAME=dusn nvim'" >> ~/.zshrc && source ~/.zshrc

# Fish
echo "alias dusn='NVIM_APPNAME=dusn nvim'" >> ~/.config/fish/config.fish && source ~/.config/fish/config.fish
```

**Launch:** Type `dusn` in your terminal

### Uninstall

```bash
rm -rf ~/.config/dusn/ ~/.local/share/dusn/ ~/.local/state/dusn/ ~/.cache/dusn/
```

---

## 📦 Dependencies

### **Essential (Core Features)**

```bash
fzf ripgrep fd yazi lazygit git
```

**Install:**

```bash
# Termux
pkg install fzf ripgrep fd yazi lazygit git

# Debian/Ubuntu
sudo apt install fzf ripgrep fd-find yazi lazygit git

# Arch Linux
sudo pacman -S fzf ripgrep fd yazi lazygit git

# macOS
brew install fzf ripgrep fd yazi lazygit git
```

### **Recommended (Enhanced Experience)**

```bash
bat git-delta nodejs python3 gcc/clang
```

**Install:**

```bash
# Termux
pkg install bat git-delta nodejs python clang

# Debian/Ubuntu
sudo apt install bat git-delta nodejs python3 build-essential

# Arch Linux
sudo pacman -S bat git-delta nodejs python gcc

# macOS
brew install bat git-delta node python
```

### **Language Tools**

LSP servers are configured via nvim-lspconfig. **You install the binaries yourself** (no Mason):

```bash
# Rust (via rustup - recommended)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add rust-analyzer rustfmt clippy

# C/C++
# Install clangd from your package manager

# Python
pip install pyright black isort

# Go
go install golang.org/x/tools/gopls@latest

# Web (TypeScript/JavaScript)
npm install -g typescript typescript-language-server

# Lua
# Install lua-language-server from your package manager

# Others
# Install LSP binaries manually as needed
```

**Example rust-analyzer config** (Termux-optimized):
```lua
-- lua/user/config/server/LowLevel/rust_analyzer.lua
local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup({
    flags = {
        debounce_text_changes = 300,
    },
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                enable = true,
                command = "clippy",
            },
            cargo = {
                allFeatures = false,
                buildScripts = { enable = false },
            },
            procMacro = { enable = false }, -- Termux optimization
            diagnostics = { enable = true },
        },
    },
})
```

**You control your toolchain.** Install binaries when you need them.

---

## 🎨 Customization

### Theme Switching

**5 theme collections with multiple variants:**

```vim
:SGT catppuccin-mocha       " Catppuccin variants
:SGT rose-pine              " Rose Pine
:SGT tokyonight-night       " Tokyo Night variants
:SGT nightfox               " Nightfox family
:SGT gruvbox                " Gruvbox
```

**Available collections:**
- **Catppuccin** — Mocha, Latte, Frappé, Macchiato
- **Nightfox** — Nightfox, Dawnfox, Dayfox, Duskfox, Nordfox, Terafox, Carbonfox
- **Rose Pine** — Main, Moon, Dawn
- **Tokyo Night** — Night, Storm, Day, Moon
- **Gruvbox** — Dark, Light variants

**Browse:** `:SGT <Tab>` to cycle through available themes

### Keybindings Reference

**Press `<Space>` (leader key) to activate Which-Key and see all mappings!**

> **Total:** 39 keybindings across normal, visual, and terminal modes

#### **Core Navigation**

| Key | Mode | Description |
|-----|------|-------------|
| `m` + 2 chars | `n` | Leap forward to location |
| `M` + 2 chars | `n` | Leap backward |
| `gm` + 2 chars | `n` | Leap from window (cross-window jump) |
| `<Tab>` | `n` | Next buffer |
| `-` | `n` | Open Oil.nvim file explorer |
| `<Space>yo` + seq | `n` | Yazi visual file manager |
| `<Space>sb` | `n` | Snipe buffers (visual picker) |

#### **LSP & Code Preview**

| Key | Mode | Description |
|-----|------|-------------|
| `K` | `n` | LSP hover documentation |
| `gpd` | `n` | Preview definition |
| `gpt` | `n` | Preview type definition |
| `gpi` | `n` | Preview implementation |
| `gpD` | `n` | Preview declaration |
| `gpr` | `n` | Preview references |
| `gP` | `n` | Close all preview windows |

#### **Fuzzy Finding & Search**

| Key | Mode | Description |
|-----|------|-------------|
| `<Space>f` + seq | `n` | FzfLua file finder |
| `<Space>hf` | `n` | Help tags (FzfLua) |

#### **Editing & Text Manipulation**

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>rs` | `n` | Range substitute |
| `<leader>rs` | `v` | Replace in selection |
| `<leader>ra` | `n` | Replace in whole file |
| `<leader>rm` | `n` | Replace in matching lines |
| `<leader>m` | `v` | Move block to line |
| `<C-x>s` | `n` | Spelling suggestions |

#### **Advanced Replace Operations**

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>rrc` | `n` | Replace operation (custom) |
| `<leader>rrf` | `n` | Replace operation (custom) |
| `<leader>rrb` | `n` | Replace operation (custom) |
| `<leader>rrl` | `n` | Replace operation (custom) |
| `<leader>rsl` | `n` | Replace operation (custom) |
| `<leader>rsv` | `v` | Replace operation (custom) |
| `<leader>rsr` | `n` | Replace operation (custom) |
| `<leader>rsm` | `n` | Replace operation (custom) |
| `<leader>rsa` | `n` | Replace operation (custom) |

#### **LSP Management**

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>llp` | `n` | LSP operation (custom) |
| `<leader>llu` | `n` | LSP operation (custom) |
| `<leader>lls` | `n` | LSP operation (custom) |
| `<leader>lsi` | `n` | LSP operation (custom) |
| `<leader>lsl` | `n` | LSP operation (custom) |
| `<leader>lsr` | `n` | LSP operation (custom) |

#### **Diagnostics**

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>dr` | `n` | Force diagnostic refresh |
| `<leader>dd` | `n` | Show diagnostic debug info |

#### **Tools & Utilities**

| Key | Mode | Description |
|-----|------|-------------|
| `<Space>zz` | `n` | Run code (execute current file) |
| `<Space>gl` | `n` | Lazygit UI |
| `<C-\>` | `n` | Toggle terminal |
| `<M-Space>` | `t` | Enter terminal normal mode |
| `<Space>ut` | `n` | Toggle Undotree (visual undo) |
| `<leader>cr` | `n` | Check file changes / reload |

#### **Sessions**

| Key | Mode | Description |
|-----|------|-------------|
| `<Space>ss` | `n` | Save session |
| `<Space>sl` | `n` | Load session |
| `<Space>si` | `n` | Session info |

> **Note:** Many bindings in `lua/user/other/keymaps/general.lua` are custom workflow helpers. Explore with Which-Key (`<Space>`) or check the source files for details.

### Adding LSP Servers

Create a file in the appropriate category:

```lua
-- File: lua/user/config/server/Web/svelte_ls.lua
return {
  cmd = { "svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_dir = require("lspconfig.util").root_pattern("package.json"),
  settings = {
    svelte = {
      plugin = {
        html = { completions = { enable = true } }
      }
    }
  }
}
```

Auto-loads on restart!

---

## 📁 Architecture

DustNvim uses **staged loading** for optimal performance:

```
dusn/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin versions (63 plugins)
└── lua/user/
    ├── stages/                 # 🚀 Sequential loading (01→07)
    │   ├── 01_sys.lua          #    Core (options, mappings)
    │   ├── 02_uiCore.lua       #    UI foundation
    │   ├── 03_mini.lua         #    Mini.nvim ecosystem
    │   ├── 04_server.lua       #    LSP (20 servers)
    │   ├── 05_tools.lua        #    Completion, formatting
    │   ├── 06_dap.lua          #    Debug adapters
    │   └── 07_ide.lua          #    IDE features
    │
    ├── sys/                    # 🔧 Core system
    │   ├── options.lua         #    Vim options
    │   ├── mappings.lua        #    Global keybindings
    │   ├── plugins.lua         #    Lazy.nvim setup
    │   └── inbuilt/            #    Built-in enhancements
    │
    ├── config/
    │   ├── server/             # 📡 LSP by category
    │   │   ├── LowLevel/       #    Rust, C/C++, Zig, ASM, CMake
    │   │   ├── HighLevel/      #    Python, Lua
    │   │   ├── Web/            #    Go, TS, HTML, CSS, PHP
    │   │   ├── GameDev/        #    Godot
    │   │   ├── Productive/     #    Bash, Markdown, Vim, Vale
    │   │   └── Utilities/      #    Docker, JSON, YAML
    │   │
    │   ├── tools/              # 🛠️ LSP tooling
    │   │   ├── blink.lua       #    Completion
    │   │   ├── lsp.lua         #    LSP config
    │   │   ├── formatter.lua   #    Formatting
    │   │   └── goto_preview.lua#    Code preview
    │   │
    │   ├── dap/                # 🐛 Debugging
    │   │   └── langs/rust.lua  #    Rust debugger (codelldb)
    │   │
    │   └── ide/                # 💡 IDE features
    │       ├── file/           #    fzf, oil, leap, snipe
    │       └── ide/            #    sessions, undotree, treesitter
    │
    ├── ui/core/                # 🎨 UI components
    │   ├── statusline.lua      #    Lualine
    │   ├── cokeline.lua        #    Buffer tabs
    │   ├── sgt.lua             #    Theme switcher
    │   └── dashboard.lua       #    Startup screen
    │
    ├── mini/                   # 🔷 Mini.nvim
    │   ├── mini_icons.lua
    │   ├── mini_notify.lua
    │   └── mini_pairs.lua
    │
    └── snippets/               # ✂️ Code snippets (JSON)
        ├── rust.json
        ├── lua.json
        └── ...
```

### Design Principles

1. **Staged Loading** — Plugins load sequentially (01→07) for speed
2. **Category-Based LSP** — Servers grouped by language family
3. **Modular Design** — Each feature is self-contained
4. **Clean Separation** — UI, tools, and IDE features isolated
5. **Performance First** — Lazy loading, minimal dependencies

**Audit Stats:**
- **63 unique plugins** (76 total references)
- **20 LSP servers** across 6 categories
- **39 keybindings** with no duplicates
- **57 functions** (3 intentional duplicates for compatibility)

---

## 🤝 Contributing

Contributions welcome! Fix bugs, add servers, improve docs—all help appreciated.

### How to Contribute

1. **Fork & Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/DustNvim.git
   ```

2. **Create Branch**
   ```bash
   git checkout -b feature/add-rust-snippets
   ```

3. **Test Changes**
   - Test on desktop and Termux if possible
   - Run `:checkhealth` to verify
   - Profile with `nvim --startuptime startup.log`

4. **Submit PR**
   - Describe changes clearly
   - Reference related issues
   - Update docs if needed

### Contribution Ideas

- 🌍 Add LSP servers in `config/server/<Category>/`
- 🎨 Enhance UI components
- 📚 Improve documentation
- 🐛 Fix bugs and optimize performance
- ✂️ Add language snippets
- 📱 Improve Termux compatibility

### Guidelines

- **Keep it minimal** — Speed over features
- **Test thoroughly** — Especially on Termux
- **Follow architecture** — Staged loading pattern
- **One feature per PR** — Easier to review

---

## 📚 Resources

### Built-in Docs

- **`Books/basics.md`** — Neovim fundamentals
- **`Books/lesson_1.md`** — DustNvim workflows
- **`Books/_dustTerm.md`** — Terminal integration

### Useful Commands

```vim
:checkhealth           " Diagnose issues
:Lazy                  " Manage plugins
:SGT <theme>           " Switch colorscheme
:help <topic>          " Built-in help
```

### External Links

- [Neovim Docs](https://neovim.io/doc/)
- [LSP Configuration](https://github.com/neovim/nvim-lspconfig)
- [Lua Guide](https://github.com/nanotee/nvim-lua-guide)
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

---

## 🙏 Credits

Built with incredible open-source tools:

- [lazy.nvim](https://github.com/folke/lazy.nvim) — Plugin manager
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) — LSP configs
- [blink.cmp](https://github.com/Saghen/blink.cmp) — Completion
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) — Fuzzy finder
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — Syntax
- **60+ other plugins** — See `lazy-lock.json`

Special thanks to theme creators: Catppuccin, Rose Pine, Tokyo Night, Nightfox, and Gruvbox teams.

---

## 📜 License

MIT License — Free to use, modify, distribute. No warranty.

See [LICENSE](LICENSE) for details.

---

## 💬 Support

- 🐛 **Report Bugs:** [GitHub Issues](https://github.com/visrust/DustNvim/issues)
- 💡 **Discussions:** [GitHub Discussions](https://github.com/visrust/DustNvim/discussions)
- ⭐ **Star the Repo:** Show support!

---

<div align="center">

**Built with ❤️ by developers, for developers**

*Stop configuring. Start coding.*

[⬆ Back to Top](#dustnvim)

</div>
