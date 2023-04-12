local options = {

    defaults = {
        -- lazy-load plugins by default
        lazy = true,
    },

    install = {
        -- try to load one of these colorschemes when starting an installation during startup
        colorscheme = { "tokyonight", "habamax" },
    },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        --"ftplugin",
      },
    },
  },
}

return options
