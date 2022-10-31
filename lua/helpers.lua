local M = {}

function M.map(mode, lhs, rhs, opts)
    local default_opts = { noremap = true }
    if opts then
        default_opts = vim.tbl_extend("force", default_opts, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, default_opts)
end

function M.lsp_config_defaults()
    return {
        root_dir = require("lspconfig.util").root_pattern(
            ".ccls",
            "manage.py",
            "pyproject.toml",
            "package.json",
            ".null-ls-root",
            "Makefile",
            ".git"
        ),

        on_attach = function(client, bufnr)
            local function buf_set_keymap(...)
                vim.api.nvim_buf_set_keymap(bufnr, ...)
            end

            local function buf_set_option(...)
                vim.api.nvim_buf_set_option(bufnr, ...)
            end

            ---- Disables document formatting by lsp
            --client.resolved_capabilities.document_formatting = false
            --client.resolved_capabilities.document_range_formatting = false

            -- Enable completion triggered by <c-x><c-o>
            buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

            -- Mappings.
            local opts = { noremap = true, silent = true }

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
            buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
            buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
            buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
            buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
            buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
            buf_set_keymap(
                "n",
                "<space>wl",
                "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                opts
            )
            buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
            buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({wrap = true})<CR>", opts)
            buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({wrap = true})<CR>", opts)
            buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
            buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)

            local version = vim.version()
            if version.api_level == 9 then
                buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
            else
                buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
            end
        end,
    }
end

function M.set_tab(length)
    vim.bo.shiftwidth = length
    vim.bo.tabstop = length
end

return M
