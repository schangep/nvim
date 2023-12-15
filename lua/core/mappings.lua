-- leader key
vim.g.mapleader = " "

-- Global mappings for LSP
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Toggle Neotree side view
vim.keymap.set('n', '<leader>n', "<cmd>Neotree toggle<CR>")

-- DAP mappings
vim.keymap.set('n', '<leader>b', "<cmd>DapToggleBreakpoint<CR>") -- add breakpoint at line
vim.keymap.set('n', '<leader>d', "<cmd>DapContinue<CR>") -- start or continue the debugger
vim.keymap.set('n', '<leader>j', "<cmd>DapStepOver<CR>")
vim.keymap.set('n', '<leader>l', "<cmd>DapStepInto<CR>")
vim.keymap.set('n', '<leader>h', "<cmd>DapStepOut<CR>")
