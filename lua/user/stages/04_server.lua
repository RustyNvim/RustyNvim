require('user.config.tools.lsp')
-- HighLevel Languages
require('user.config.server.HighLevel.lua_ls')
require('user.config.server.HighLevel.pyright')

-- LowLevel Languages
require('user.config.server.LowLevel.asm')
require('user.config.server.LowLevel.clang')
require('user.config.server.LowLevel.cmake')
require('user.config.server.LowLevel.rust_analyzer')
require('user.config.server.LowLevel.zls')

-- Productive Languages
require('user.config.server.Productive.bash_ls')
require('user.config.server.Productive.marksman')
require('user.config.server.Productive.vale')
require('user.config.server.Productive.vimls')

-- Utilities
require('user.config.server.Utilities.dockerls')
require('user.config.server.Utilities.jsonls')
require('user.config.server.Utilities.yamlls')

-- Web Languages
require('user.config.server.Web.css_ls')
require('user.config.server.Web.gopls')
require('user.config.server.Web.html')
require('user.config.server.Web.phpactor')
require('user.config.server.Web.ts_ls')

-- GameDev
require('user.config.server.GameDev.Godot_ls')
