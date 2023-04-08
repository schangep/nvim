-- load general configs
require ("core")

-- load plugins
local plugins = require("plugins")
local opts = require("plugins.config.lazy")
require("lazy").setup(plugins, opts)

