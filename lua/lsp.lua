-- ooooo   ooooo                           .o8
-- `888'   `888'                          "888
--  888     888   .ooooo.   .oooo.    .oooo888   .ooooo.  oooo d8b
--  888ooooo888  d88' `88b `P  )88b  d88' `888  d88' `88b `888""8P
--  888     888  888ooo888  .oP"888  888   888  888ooo888  888
--  888     888  888    .o d8(  888  888   888  888    .o  888
-- o888o   o888o `Y8bod8P' `Y888""8o `Y8bod88P" `Y8bod8P' d888b

-- https://patorjk.com/software/taag/#p=display&f=Roman&t=WORD_TO_MAKE_HEADER

--   .oooooo.    oooo             .o8                 oooo
--  d8P'  `Y8b   `888            "888                 `888
-- 888            888   .ooooo.   888oooo.   .oooo.    888
-- 888            888  d88' `88b  d88' `88b `P  )88b   888
-- 888     ooooo  888  888   888  888   888  .oP"888   888
-- `88.    .88'   888  888   888  888   888 d8(  888   888
--  `Y8bood8P'   o888o `Y8bod8P'  `Y8bod8P' `Y888""8o o888o

local opt = vim.opt -- to set options

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
})

local config = {

    root_dir = require("lspconfig.util").root_pattern(
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
        buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
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

--   .oooooo.   ooo        ooooo ooooooooo.
--  d8P'  `Y8b  `88.       .888' `888   `Y88.
-- 888           888b     d'888   888   .d88'
-- 888           8 Y88. .P  888   888ooo88P'
-- 888           8  `888'   888   888
-- `88b    ooo   8    Y     888   888
--  `Y8bood8P'  o8o        o888o o888o

require("nvim-autopairs").setup({ check_ts = true })

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

-- CMP NVIM ULTISNIP
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local ultisnip = {
    expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
    end,
    tab = cmp.mapping(function(fallback)
        cmp_ultisnips_mappings.compose({ "select_next_item" })(fallback)
    end, { "i", "s" }),
    shift_tab = cmp.mapping(function(fallback)
        cmp_ultisnips_mappings.compose({ "select_prev_item" })(fallback)
    end, { "i", "s" }),
}

cmp.setup({
    snippet = {
        expand = ultisnip.expand,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            select = true,
        }),
        ["<Tab>"] = ultisnip.tab,
        ["<S-Tab>"] = ultisnip.shift_tab,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "ultisnips" },
    },
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- ooooo      ooo             oooo  oooo       ooooo         .oooooo..o
-- `888b.     `8'             `888  `888       `888'        d8P'    `Y8
--  8 `88b.    8  oooo  oooo   888   888        888         Y88bo.
--  8   `88b.  8  `888  `888   888   888        888          `"Y8888o.
--  8     `88b.8   888   888   888   888        888              `"Y88b
--  8       `888   888   888   888   888        888       o oo     .d8P
-- o8o        `8   `V88V"V8P' o888o o888o      o888ooooood8 8""88888P'

local null_ls = require("null-ls")

-- ORDER IN TABLE DETERMINES EXECUTION ORDER
local sources = {
    -- python
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    -- js
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.code_actions.eslint,
    null_ls.builtins.formatting.prettier.with({
        extra_filetypes = { "svelte" },
    }),
    -- lua
    null_ls.builtins.formatting.stylua,
    -- bash
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.code_actions.shellcheck,
    -- cpp
    null_ls.builtins.formatting.clang_format,
    -- latex
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.diagnostics.chktex,
    -- golang
    null_ls.builtins.diagnostics.golangci_lint,
    -- sql
    --null_ls.builtins.diagnostics.sqlfluff.with({
    --	--filetypes = { "sql", "html" },
    --	args = { "lint", "--dialect", "ansi", "-f", "github-annotation", "-n", "--disable_progress_bar", "-" },
    --}),
    --null_ls.builtins.formatting.sqlfluff.with({
    --	--filetypes = { "sql", "html" },
    --	args = { "fix", "--dialect", "ansi", "--disable_progress_bar", "-f", "-n", "-" },
    --}),
}
null_ls.setup({
    sources = sources,
    on_attach = config.on_attach,
    root_dir = config.root_dir,
})

-- ooooo         .oooooo..o ooooooooo.        ooooo                          .             oooo  oooo
-- `888'        d8P'    `Y8 `888   `Y88.      `888'                        .o8             `888  `888
--  888         Y88bo.       888   .d88'       888  ooo. .oo.    .oooo.o .o888oo  .oooo.    888   888   .ooooo.  oooo d8b
--  888          `"Y8888o.   888ooo88P'        888  `888P"Y88b  d88(  "8   888   `P  )88b   888   888  d88' `88b `888""8P
--  888              `"Y88b  888               888   888   888  `"Y88b.    888    .oP"888   888   888  888ooo888  888
--  888       o oo     .d8P  888               888   888   888  o.  )88b   888 . d8(  888   888   888  888    .o  888
-- o888ooooood8 8""88888P'  o888o             o888o o888o o888o 8""888P'   "888" `Y888""8o o888o o888o `Y8bod8P' d888b

local on_attach_tsserver = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")
    ts_utils.setup({
        eslint_bin = "eslint_d",
        eslint_enable_diagnostics = true,
        eslint_enable_code_actions = true,
        enable_import_on_completion = true,
        filter_out_diagnostics_by_severity = {
            "information",
            "hint",
            --"warning",
            --"error",
        },
    })
    ts_utils.setup_client(client)

    -- no default maps, so you may want to define some here
    local o = { silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", o)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "rN", ":TSLspRenameFile<CR>", o)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", ":TSLspImportAll<CR>", o)
end

require("nvim-lsp-installer").on_server_ready(function(server)
    --Enable (broadcasting) snippet capability for completion
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local disable_diag = {
        ["textDocument/publishDiagnostics"] = function() end,
    }

    local on_attach_generic = function(client, bufnr)
        -- Disables document formatting by lsp
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false

        config.on_attach(client, bufnr)
    end

    local opts = {
        on_attach = on_attach_generic,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        settings = {
            format = { enable = true },
        },
        root_dir = config.root_dir,
    }

    if server.name == "tsserver" then
        opts.on_attach = function(...)
            on_attach_tsserver(...)
            on_attach_generic(...)
        end
    elseif server.name == "sumneko_lua" then
        opts.settings.Lua = {
            diagnostics = {
                globals = {
                    "vim",
                    "awesome",
                    "client",
                },
            },
        }
    elseif server.name == "html" then
        opts.filetypes = { "html", "htmldjango" }
    elseif server.name == "tailwindcss" then
        opts.init_options = {
            userLanguages = {
                htmldjango = "html",
            },
        }
    end

    server:setup(opts)
    vim.cmd([[do User LspAttachBuffers]])
end)

local lsp_installer_servers = require("nvim-lsp-installer.servers")
local auto_servers = {
    --"pylsp",
    --"pyright",
    "sumneko_lua",
    "tsserver",
    "bashls",
    "vimls",
    "rust_analyzer",
    "html",
    "cssls",
    "jsonls",
    --"omnisharp",
    "ltex",
    "jedi_language_server",
    "vuels",
    "svelte",
    "gopls",
    "golangci_lint_ls",
    "tailwindcss",
}

for _, s in ipairs(auto_servers) do
    local ok, server = lsp_installer_servers.get_server(s)
    if ok and not server:is_installed() then
        server:install()
    end
end
