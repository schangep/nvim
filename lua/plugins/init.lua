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

    -- remember cursor position
    { "ethanholz/nvim-lastplace",
        lazy = false,
        opts = require("plugins.config.lastplace"),
        -- config = function() require("nvim-lastplace").setup(opts) end, -- implied by 'opts'
    },

    -- toggle comments
    { "numToStr/Comment.nvim",
        event = "VeryLazy",
        config = function() require("Comment").setup() end,
    },

    -- TMUX navigation
    { "aserowy/tmux.nvim",
        event = "VeryLazy",
        config = function() require("tmux").setup() end,
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
        lazy = false, -- lazy loading is not recommended
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
            "saadparwaiz1/cmp_luasnip", -- snippet completions
            "hrsh7th/cmp-nvim-lua", -- enhanced Neovim config editing
            "hrsh7th/cmp-nvim-lsp", -- LSP completion
            "hrsh7th/cmp-nvim-lsp-signature-help", -- signature help completion
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "f3fora/cmp-spell", -- spellsuggest completion
        },
    },

    -- Neo-tree file system browser
    { "nvim-neo-tree/neo-tree.nvim",
        config = function() require("plugins.config.neotree").setup() end,
        init = function() require("plugins.config.neotree").init() end,
        cmd = { "Neotree", },
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- optional image support in preview window
        }
    },

    -- Telescope fuzzy finder
    { "nvim-telescope/telescope.nvim",
        init = function() utils.lazy_load("telescope.nvim") end,
        branch = "0.1.x", -- release branch, gets consistent updates
        dependencies = { "nvim-lua/plenary.nvim", },
        config = function() require("plugins.config.telescope") end,
    },

    -- Neovim builtin DAP (debug adapter protocol)

    -- bridge Mason with bultin DAP
    { "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        opts = {
            handlers = {},
            ensure_installed = { "codelldb", },
        },
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap", -- builtin Neovim DAP
        },
    },

    -- enhanced interface for builtin DAP
    { "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
        dependencies = {
            "mfussenegger/nvim-dap", -- builtin Neovim DAP
            "folke/neodev.nvim", -- recommended to enable type checking
            "ChristianChiarulli/neovim-codicons", -- default icons with alignment issues fixed
        },
    },

}

return plugins

