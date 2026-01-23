vim.defer_fn(function ()
require('leap').setup({
    max_phase_one_targets = nil,
    highlight_unlabeled_phase_one_targets = false,
    max_highlighted_traversal_targets = 10,
    case_sensitive = false,
    equivalence_classes = { ' \t\r\n' },
    substitute_chars = {},
    safe_labels = 'sfnut/SFNLHMUGTZ?',
    labels = 'sfnjklhodweimbuyvrgtaqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ?',
    special_keys = {
        repeat_search = '<enter>',
        next_phase_one_target = '<enter>',
        next_target = { '<enter>', ';' },
        prev_target = { '<tab>', ',' },
        next_group = '<space>',
        prev_group = '<tab>',
        multi_accept = '<enter>',
        multi_revert = '<backspace>',
    },
})
end, 150)

-- Leap in all windows
vim.keymap.set('n', 'm', '<Plug>(leap-forward)', { desc = 'Leap forward' })
vim.keymap.set('n', 'M', '<Plug>(leap-backward)', { desc = 'Leap backward' })
vim.keymap.set('n', 'gm', '<Plug>(leap-from-window)', { desc = 'Leap from window' })

-- Visual and operator-pending mode
vim.keymap.set({ 'x', 'o' }, 'm', '<Plug>(leap-forward)', { desc = 'Leap forward' })
vim.keymap.set({ 'x', 'o' }, 'M', '<Plug>(leap-backward)', { desc = 'Leap backward' })

