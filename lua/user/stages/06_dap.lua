-- Defer DAP - you don't debug immediately on startup
vim.defer_fn(function()
  require('user.config.dap.setup')
  require('user.config.dap.keymaps')
end, 200)

vim.defer_fn(function ()
  require('user.config.dap.langs.rust')
end, 200)
