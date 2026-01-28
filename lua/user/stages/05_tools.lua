-- In user/stages/06_lspB.lua
-- Move DAP to the end and defer it

vim.defer_fn(function ()
    require('user.config.tools.blink')
    require('user.config.tools.goto_preview')
    require('user.config.tools.formatter')
    require('user.config.tools.luasnip')
    require('user.config.tools.lspkind')
    require('user.config.tools.navic')
end, 200)

