local M = {}
M.setup = function()
    -- dont list quickfix buffers
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
            vim.opt_local.buflisted = false
        end,
    })

    -- set filetype to GNU Assembler for ETH courses
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile" }, {
        pattern = vim.tbl_map(
            function(s)
                return vim.env.HOME .. "/ETH/*" .. s
            end,
            { ".s", ".as", ".asm" }),
        callback = function()
            vim.bo.filetype = "gas"
        end,
    })

    -- not working with markdown LSP
    -- vim.cmd [[ " requires highlight groups hl-LspReferenceText, hl-LspReferenceRead, hl-LspReferenceWrite
    -- autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    -- autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    -- autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    -- ]]

    -- Neovim LSP client keymappings
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end
            local capabilities = client.server_capabilities
            local opts = { buffer = args.buf, noremap = true, silent = true, }

            local function description(desc)
                return vim.tbl_deep_extend("error", opts, { desc = desc })
            end

            if capabilities and capabilities.hoverProvider then
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, description("LSP hover"))
            end

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, description("LSP definition"))
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, description("LSP declaration"))
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, description("LSP implementation"))
            vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, description("LSP signature help"))
            vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, description("LSP add workspace folder"))
            vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, description("LSP remove workspace folder"))
            vim.keymap.set('n', '<leader>wl', vim.lsp.buf.list_workspace_folders, description("LSP list workspace folders"))
            vim.keymap.set('n', '<leader>gd', vim.lsp.buf.type_definition, description("LSP type definition"))
            vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, description("LSP rename"))
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, description("LSP code action"))
            vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, description("LSP range code action"))
            vim.keymap.set('n', '<leader>FF', function() vim.lsp.buf.format { async = true } end, description("LSP format"))
        end,
    })
end

return M
