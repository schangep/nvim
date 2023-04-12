local M = {}
local merge_tb = vim.tbl_deep_extend

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load { plugins = plugin }

            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end, 0)
        else
          require("lazy").load { plugins = plugin }
        end
      end
    end,
  })
end


M.load_lsp_mappings = function(bufopts)
	-- set keymap with bufopts in normal mode
    local function nnoremap(rhs, lhs, opts, desc)
        opts.desc = desc
        vim.keymap.set("n", rhs, lhs, opts)
    end

    -- set keymap with bufopts in visual mode
    local function vnoremap(rhs, lhs, opts, desc)
        opts.desc = desc
        vim.keymap.set("v", rhs, lhs, opts)
    end

    ---- Regular Neovim LSP client keymappings
    nnoremap('gD', vim.lsp.buf.declaration, bufopts, "LSP declaration")
    nnoremap('gd', vim.lsp.buf.definition, bufopts, "LSP definition")
    nnoremap('gi', vim.lsp.buf.implementation, bufopts, "LSP implementation")
    nnoremap('K', vim.lsp.buf.hover, bufopts, "LSP hover")
    nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "LSP signature")
    nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, "LSP add workspace folder")
    nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "LSP remove workspace folder")
    nnoremap('<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts, "LSP list workspace folders")
    nnoremap('<space>gd', vim.lsp.buf.type_definition, bufopts, "LSP type definition")
    nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "LSP rename")
    nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, "LSP code action")
    vnoremap("<space>ca", vim.lsp.buf.range_code_action, bufopts, "LSP range code action")
    nnoremap('<space>FF', function() vim.lsp.buf.format { async = true } end, bufopts, "LSP format")
end

return M
