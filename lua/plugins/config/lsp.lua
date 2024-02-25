-- get Lua runtime path
local lua_runtime_path = vim.split(package.path, ";")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath "data" .. "/mason/bin"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- export capabilities for custom lspconfigs
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- enable LSP enhanced autocomplete
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

-- table of language servers and their specific configurations
local handlers = {
    -- default handler (optional)
    function(server)
        local lspconfig = require("lspconfig")
        lspconfig[server].setup { capabilities = capabilities }
    end,

    -- Lua language server
    ["lua_ls"] = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using
                        -- (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                        path = lua_runtime_path,
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { "vim" },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = {
                            vim.api.nvim_get_runtime_file("", true),
                            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                            [vim.fn.expand "$VIMRUNTIME/lua/core"] = true,
                            [vim.fn.expand "$VIMRUNTIME/lua/plugins"] = true,
                        },
                        -- Disable environment emulation
                        checkThirdParty = false,
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
    end,

    -- Bash language server
    -- 'bashls' requires 'shellcheck' (https://github.com/koalaman/shellcheck)
    -- :MasonInstall shellcheck

    -- LaTeX language server
    ["texlab"] = function()
        local lspconfig = require("lspconfig")
        lspconfig.texlab.setup {
            -- 'texlab' uses 'tectonic' by default, but 'lspconfig' replaces it with 'latexmk'
            settings = {
                texlab = {
                    build = {
                        args = { "-pdflua", "-interaction=nonstopmode", "-synctex=1", "%f" },
                        executable = "latexmk",
                    },
                },
            },
        }
        -- additional LaTeX commands
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_create_user_command(buf, "TexlabBuild", lspconfig.texlab.commands.TexlabBuild[1], {})
        vim.api.nvim_buf_create_user_command(buf, "TexlabForward", lspconfig.texlab.commands.TexlabForward[1], {})
    end,

    -- LTeX language server (LanguageTool integration)
    ["ltex"] = function()
        local lspconfig = require("lspconfig")
        lspconfig.ltex.setup {
            language = "de-DE",
        }
    end,
}

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup {
    handlers = handlers,
    automatic_installation = true,
    ensure_installed = {
        "bashls",
        "clangd",
        "lua_ls",
        "pyright",
    },
}

