local M = {}

M.opts = {
    source_selector = {
        -- set one of these to true to show a clickable source selector
        winbar = false,
        statusline = true,
    },

    filesystem = {
        -- any command that would open a directory will open Neotree in the specified window
        hijack_netrw_behavior = "open_current", -- default value: "open_default"
    },
}

-- show Neotree when calling vim with a directory as argument
function M.init()
    if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
            require("neo-tree")
        end
    end
end

-- call setup function with my options
function M.setup()
    require("neo-tree").setup(M.opts)
end


return M
