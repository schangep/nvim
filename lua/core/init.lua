-- install package manager and language servers
require("core.bootstrap")

-- initialise auto commands
require("core.autocmd").setup()

-- leader key
vim.g.mapleader = " "

-- show line number and cursorline
vim.opt.number = true
vim.opt.cursorline = true

-- set indentation rules
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- improve search behaviour
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- colorscheme options
vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = "dark"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath "data" .. "/mason/bin"

