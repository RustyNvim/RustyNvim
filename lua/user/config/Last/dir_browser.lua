vim.keymap.set('n', '<leader>ts', function()
  require('telescope.builtin').find_files({
    cwd = vim.fn.stdpath('config') .. '/lua/user/stages',
    prompt_title = '< User Stages >',
  })
end, { desc = 'Find user stage files' })
