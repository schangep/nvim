local plugins = {
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
        opts = function() require("plugins.config.lastplace") end,
        -- config = function() require("nvim-lastplace").setup(opts) end, -- implied by 'opts'
    },

    -- Treesitter syntax highlighting
    { "nvim-treesitter/nvim-treesitter",
        init = function() require("core.utils").lazy_load("nvim-treesitter") end,
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate", -- build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
        opts = function() return require("plugins.config.treesitter") end,
        config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end, -- NOT implied by 'opts'
    },

    -- Mason package manager for LSP servers
    { "williamboman/mason.nvim",
        lazy = false, -- lazy loading is not recommended
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        config = function() require("mason").setup() end,
    },
}

return plugins
