vim.keymap.set('n', '<leader>tc', function()
    require('telescope.builtin').find_files({
        cwd = vim.fn.expand('$MYVIMRC'):match('(.*/)'),
        prompt_title = '< Neovim Config >'
    })
end, { desc = 'Find config files' })
