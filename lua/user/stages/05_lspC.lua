-- HighLevel Languages
require('user.config.LspConfig.HighLevel.lua_ls')
require('user.config.LspConfig.HighLevel.pyright')

-- LowLevel Languages
require('user.config.LspConfig.LowLevel.asm')
require('user.config.LspConfig.LowLevel.clang')
require('user.config.LspConfig.LowLevel.cmake')
require('user.config.LspConfig.LowLevel.rust_analyzer')
require('user.config.LspConfig.LowLevel.zls')

-- Productive Languages
require('user.config.LspConfig.Productive.bash_ls')
require('user.config.LspConfig.Productive.marksman')
require('user.config.LspConfig.Productive.vale')
require('user.config.LspConfig.Productive.vimls')

-- Utilities
require('user.config.LspConfig.Utilities.dockerls')
require('user.config.LspConfig.Utilities.jsonls')
require('user.config.LspConfig.Utilities.yamlls')

-- Web Languages
require('user.config.LspConfig.Web.css_ls')
require('user.config.LspConfig.Web.gopls')
require('user.config.LspConfig.Web.html')
require('user.config.LspConfig.Web.phpactor')
require('user.config.LspConfig.Web.ts_ls')

-- GameDev
require('user.config.LspConfig.GameDev.Godot_ls')

-- CRITICAL: Must be last in this stage
require('user.config.LspBatch.lsp')
