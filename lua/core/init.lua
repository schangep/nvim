-- install package manager and language servers
require("core.bootstrap")

-- initialize auto commands
require("core.autocmd").setup()

-- leader key
vim.g.mapleader = " "

-- show line number and cursorline
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.cursorline = true

-- set indentation rules
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- improve search behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- completion menus
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- spell suggestions
--vim.opt.spell = true
vim.opt.spelllang = { "en_us", "de" }
vim.opt.spellsuggest = { "best", 9 }

-- enable persistent undo
vim.opt.undofile = true

-- colorscheme options
vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = "dark"

-- global mappings
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
