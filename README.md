# DustNvim

<div align="center">

**A blazingly fast Neovim distribution that just works—from desktop to smartphone.**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Neovim](https://img.shields.io/badge/neovim-0.10+-green.svg)](https://neovim.io)
[![Platform](https://img.shields.io/badge/platform-Linux%20|%20macOS%20|%20Termux-lightgrey.svg)]()

[Features](#-features) • [Installation](#-installation) • [Screenshots](#-screenshots) • [Structure](#-project-structure) • [Contributing](#-contributing)

</div>

---

## 🎯 Why DustNvim?

Born from the frustration of complex configurations and bloated distributions that break on resource-constrained environments, DustNvim delivers a **production-ready IDE experience** without the configuration headache.

**What makes it different:**
- 🚀 **Sub-400ms startup** on modest hardware (tested on Snapdragon 4 Gen 1)
- 📱 **Termux-native** — Built and battle-tested on mobile environments
- 🎨 **105 curated themes** — Visual variety without plugin bloat
- 🦀 **Rust-first** — Best-in-class Rust support with zero-config rust-analyzer
- 🔧 **Opinionated but flexible** — Sensible defaults, easy to customize
- 💼 **Only 105KB** — Minimal footprint, maximum features

---

## ✨ Features

### **Developer Experience**
- 🔍 **Smart LSP integration** — Pre-configured servers for 15+ languages (Rust, Go, C/C++, Python, TypeScript, and more)
- 🐛 **Built-in debugging** — DAP setup for Rust (extensible to other languages)
- 💬 **Intelligent completion** — Blink.cmp with LuaSnip snippets
- 🎯 **Precision navigation** — Leap.nvim for 2-character jumps, Snipe for buffer/file selection
- 📝 **Live diagnostics** — Cursor-hold popups with Trouble.nvim integration

### **Productivity Boosters**
- 💾 **Auto-save** — `<Space>as` double-tap to toggle
- 📂 **Dual file explorers** — Oil.nvim for buffer-like editing + Yazi for visual navigation
- 🔎 **Fuzzy everything** — Fzf.lua for files, buffers, grep, and more
- 🕰️ **Persistent undo** — Never lose work with visual undo tree
- 💻 **Integrated terminal** — Floating terminal (`Ctrl+Space`) + Lazygit (`<Space>gg`)
- 📋 **Session management** — Save/load project sessions effortlessly

### **UI & Polish**
- 🌈 **Nightfox default** — 105 themes available via `:SGT <colorscheme>`
- 📊 **Informative statusline** — File info, LSP status, git integration
- 🗂️ **Smart tabline** — Buffer management with cokeline
- 🔔 **Clean notifications** — Non-intrusive mini.notify popups
- 📐 **Indent guides** — Visual indentation with rainbow highlights

---

## 📸 Screenshots

<div align="center">

### Main Interface
![Main Interface](https://github.com/user-attachments/assets/f0cafcf7-5e85-426e-b689-8b0e13a1b101)

### Coding View
![Coding View](https://github.com/user-attachments/assets/448f5763-c4c7-4157-9d70-48baae2b0dad)

### File Navigation
![File Navigation](https://github.com/user-attachments/assets/2a345bc7-32eb-4692-ae71-45f6cfc0938b)

<details>
<summary>📷 Show more screenshots</summary>

![Diagnostics](https://github.com/user-attachments/assets/13fa7537-bb8a-4add-bcdb-25d652a417ad)
![LSP Features](https://github.com/user-attachments/assets/e045b264-80f2-4ff7-b4da-77f487e748d4)
![Terminal](https://github.com/user-attachments/assets/cd27e86e-707d-46ab-95a3-5f11da96dcee)

</details>

</div>

---

## 🚀 Installation

### Quick Start (30 seconds)

```bash
# Clone the configuration
mkdir -p ~/.config/nv && cd ~/.config/nv
git clone --depth=1 https://github.com/visrust/DustNvim.git .

# First launch (plugins will auto-install)
NVIM_APPNAME=nv nvim
```

### Add Convenient Alias

```bash
# For Bash
echo "alias nv='NVIM_APPNAME=nv nvim'" >> ~/.bashrc && source ~/.bashrc

# For Zsh
echo "alias nv='NVIM_APPNAME=nv nvim'" >> ~/.zshrc && source ~/.zshrc
```

Launch with: `nv`
### 📦 Dependencies

DustNvim requires some external tools for full functionality:

**Essential:**
- `fzf` - Fuzzy finder
- `ripgrep` - Fast grep alternative
- `fd` - Fast find alternative
- `yazi` - Terminal file manager
- `lazygit` - Git TUI
- `git` - Version control

**Install all at once:**
```bash
# Termux
pkg install fzf ripgrep fd yazi lazygit git

# Debian/Ubuntu
apt install fzf ripgrep fd-find yazi lazygit git

# Arch Linux
pacman -S fzf ripgrep fd yazi lazygit git

# macOS
brew install fzf ripgrep fd yazi lazygit git
```

### Uninstall

```bash
rm -rf ~/.config/nv/ ~/.local/share/nv/ ~/.local/state/nv/
```

---

## 📁 Project Structure

DustNvim uses a staged loading architecture for optimal performance:

```
nvim/
└── lua/
    └── user/                    # Root namespace
        ├── stages/              # Sequential loading stages
        │   ├── 01_sys.lua       # Core system (options, mappings)
        │   ├── 02_uiCore.lua    # UI foundation
        │   ├── 03_mini.lua      # Mini.nvim ecosystem
        │   ├── 04_server.lua    # LSP servers
        │   ├── 05_tools.lua     # Completion, formatting
        │   ├── 06_dap.lua       # Debug adapters
        │   └── 07_ide.lua       # IDE features
        │
        ├── sys/                 # Core system configuration
        │   ├── options.lua      # Neovim options
        │   ├── mappings.lua     # Keybindings
        │   ├── plugins.lua      # Lazy.nvim setup
        │   └── inbuilt/         # Built-in enhancements
        │
        ├── config/
        │   ├── server/          # LSP configurations by category
        │   │   ├── LowLevel/    # Rust, C/C++, Zig, ASM
        │   │   ├── HighLevel/   # Python, Lua
        │   │   ├── Web/         # Go, TypeScript, HTML, CSS
        │   │   ├── GameDev/     # Godot
        │   │   ├── Productive/  # Bash, Markdown, Vim
        │   │   └── Utilities/   # Docker, JSON, YAML
        │   │
        │   ├── tools/           # LSP tools & completion
        │   ├── dap/             # Debugger configurations
        │   └── ide/             # IDE features
        │       ├── file/        # File navigation (Oil, Fzf, Yazi)
        │       └── ide/         # Editor features (sessions, undo, etc.)
        │
        ├── ui/core/             # UI components
        ├── mini/                # Mini.nvim plugins
        └── snippets/            # Language snippets (JSON format)
```

### Tree View Command

```bash
# Using eza (modern replacement for tree)
eza --tree --level=3 --icons --git-ignore

# With more details
eza --tree --level=3 --icons --git-ignore --long --no-permissions --no-user

# Install eza: https://github.com/eza-community/eza
```

---

## 🎨 Customization

### Change Theme
```vim
:SGT catppuccin    " Set theme (tab-complete available)
```

### Key Mappings Cheatsheet
Press `<Space>` (leader key) to see all mappings via which-key, or check out:
- **File navigation:** `<Space>ff` (find files), `<Space>fg` (live grep)
- **Buffers:** `<Space>sb` (snipe buffers), `<Space>fb` (fuzzy buffers)
- **LSP:** `gd` (definition), `gr` (references), `K` (hover), `gp` (preview)
- **Git:** `<Space>gg` (lazygit)
- **Sessions:** `<Space>ss/sf/sl/sd` (save/find/load/delete)
- **Terminal:** `<Ctrl+Space>` (toggle floating terminal)

### Add Custom LSP Server

Create a file in `lua/user/config/server/<Category>/<server>.lua`:

```lua
return {
  cmd = { "your-lsp-server" },
  filetypes = { "yourfiletype" },
  root_dir = require("lspconfig.util").root_pattern("pattern"),
  settings = {
    -- Server-specific settings
  }
}
```

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **For full contribution:**
   ```bash
   git clone https://github.com/visrust/DustNvim.git
   cd DustNvim
   ```

2. **For quick testing:**
   ```bash
   git clone --depth=1 https://github.com/visrust/DustNvim.git
   # Test your changes, then migrate to full clone if contributing
   ```

3. **Guidelines:**
   - Follow the staged loading architecture
   - Keep plugins minimal and purposeful
   - Test on both desktop and Termux if possible
   - Update documentation for new features

### Contribution Ideas
- 🌍 Add more language servers (in appropriate `server/` categories)
- 🎨 Improve UI components
- 📚 Expand documentation and tutorials
- 🐛 Bug fixes and performance improvements

---

## 📚 Learning Resources

Check the `Books/` directory for guides:
- **basics.md** — Neovim fundamentals
- **lesson_1.md** — DustNvim-specific workflows
- **_dustTerm.md** — Terminal integration guide

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built with ❤️ for developers who value speed and simplicity**

[⬆ Back to top](#dustnvim)

</div>
