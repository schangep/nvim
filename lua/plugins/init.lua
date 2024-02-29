local plugins = {
    -- plugin manager
    { "folke/lazy.nvim", },

    -- In principle we can lazy-load colorschemes,
    -- since the plugin gets loaded on ":colorscheme foobar",
    -- but then they don't get to appear in the completion list.
    -- Thus, we use the "VeryLazy" event to load all colorscheme plugins.
    -- The initial colorscheme is loaded and set by last-color.

    -- tokyonight colorscheme
    { "folke/tokyonight.nvim",
        event = "VeryLazy",
    },

    -- rose-pine colorscheme
    { "rose-pine/neovim",
        name = "rose-pine",
        event = "VeryLazy",
    },

    -- catppuccin colorscheme
    { "catppuccin/nvim",
        name = "catppuccin",
        event = "VeryLazy",
    },

    -- nightfox colorscheme
    { "EdenEast/nightfox.nvim",
        event = "VeryLazy",
    },

    -- remember colorscheme
    { "raddari/last-color.nvim",
        lazy = false,
        priority = 1000, -- recommended for colorschemes
        config = function()
            vim.cmd.colorscheme(require("last-color").recall() or "tokyonight")
        end,
    },

    -- remember cursor position
    { "ethanholz/nvim-lastplace",
        lazy = false,
        opts = require("plugins.config.lastplace"),
        -- config = function() require("nvim-lastplace").setup(opts) end, -- implied by 'opts'
    },
    -- "ethanholz/nvim-lastplace" has been archived by its owner, a possible replacement might be
    -- { "vladdoster/remember.nvim", config = function() require("remember") end, },

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
        event = "VeryLazy",
        build = ":TSUpdate",
        opts = require("plugins.config.treesitter"),
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end, -- NOT implied by 'opts'
    },

    -- GitHub Copilot
    { "github/copilot.vim",
        cmd = "Copilot",
        -- use ':Copilot setup' to configure GitHub Copilot
        -- use ':Copilot enable' to enable, see also ':help copilot'
    },

    -- Mason package manager for LSP servers
    { "williamboman/mason.nvim",
        lazy = false, -- lazy loading is not recommended
        build = ":MasonUpdate", -- update registry contents
        config = function() require("plugins.config.lsp") end,
        dependencies = {
            "neovim/nvim-lspconfig", -- Neovim builtin LSP
            "williamboman/mason-lspconfig.nvim", -- bridge Mason with builtin nvim-lspconfig
        },
        opts = {
            -- add additional registry for Java LSP
            registries = {
                'github:nvim-java/mason-registry',
                'github:mason-org/mason-registry',
            },
        },
    },

    -- Auto completion plugin for LSP completions
    { "hrsh7th/nvim-cmp",
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
        lazy = false,
        branch = "0.1.x", -- release branch, gets consistent updates
        dependencies = { "nvim-lua/plenary.nvim", },
        config = function() require("plugins.config.telescope") end,
    },

    -- Telescope file browser
    { "nvim-telescope/telescope-file-browser.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- optional
        },
        config = function()
            require("telescope").load_extension("file_browser")
            vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
        end,
    },

    -- bridge Mason with Neovim bultin DAP (debug adapter protocol)
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

    -- Java LSP is tricky to get working
    { "nvim-java/nvim-java",
        tag = "v1.0.4", -- release tag
        dependencies = {
            "nvim-java/lua-async-await",
            "nvim-java/nvim-java-core",
            "nvim-java/nvim-java-test",
            "nvim-java/nvim-java-dap",
            "MunifTanjim/nui.nvim",
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "williamboman/mason.nvim",
        },
    },
}

return plugins

