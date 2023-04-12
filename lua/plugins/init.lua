local utils = require("core.utils")

local plugins = {
    -- plugin manager
    { "folke/lazy.nvim", },

    -- the main colorscheme should be available when starting Neovim
    { "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function() vim.cmd.colorscheme("tokyonight") end,
    },

    --[[
    -- use the 'VeryLazy' event for colorschemes that can load later and are
    -- not important for the initial UI
   
    -- rose-pine colorscheme
    { "rose-pine/neovim",
        name = "rose-pine",
        event = "VeryLazy",
    },
    
    -- nightfox colorscheme
    { "EdenEast/nightfox.nvim",
        event = "VeryLazy",
    },
    --]]


    -- remember cursor position
    { "ethanholz/nvim-lastplace",
        lazy = false,
        opts = require("plugins.config.lastplace"),
        -- config = function() require("nvim-lastplace").setup(opts) end, -- implied by 'opts'
    },

    -- Treesitter syntax highlighting
    { "nvim-treesitter/nvim-treesitter",
        init = function() utils.lazy_load("nvim-treesitter") end,
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate", -- build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
        opts = require("plugins.config.treesitter"),
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end, -- NOT implied by 'opts'
    },

    -- Mason package manager for LSP servers
    { "williamboman/mason.nvim",
        --lazy = false, -- lazy loading is not recommended, but we'll try anyways
        init = function() utils.lazy_load("mason.nvim") end,
        build = ":MasonUpdate", -- update registry contents
        config = function() require("plugins.config.lsp") end,
    },
    -- bridge Mason with builtin nvim-lspconfig
    { "williamboman/mason-lspconfig.nvim",
        init = function() utils.lazy_load("mason-lspconfig.nvim") end,
    },

    -- Neovim builtin LSP
    { "neovim/nvim-lspconfig",
        init = function() utils.lazy_load("nvim-lspconfig") end,
    },

    -- Auto completion plugin for LSP completions
    { "hrsh7th/nvim-cmp",
        init = function() utils.lazy_load("nvim-cmp") end,
        event = "InsertEnter",
        config = function() require("plugins.config.cmp") end,
        dependencies = {
            -- snippet engine
            { "L3MON4D3/LuaSnip",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                -- useful snippets
                dependencies = { "rafamadriz/friendly-snippets", },
            },
            -- cmp sources plugins
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
    },

}

return plugins

