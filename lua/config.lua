-- env file highlighting
vim.cmd [[au BufRead,BufNewFile .env.* set filetype=sh]]

local opt = vim.opt -- to set options
local fn = vim.fn

opt.autoindent = true
opt.autoread = true
--opt.autowrite = true
opt.expandtab = true
opt.foldenable = false
opt.hlsearch = true
opt.ignorecase = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.showcmd = true
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.title = true
opt.wildmenu = true
opt.termguicolors = true
opt.linebreak = true

opt.inccommand = "split" -- Get a preview of replacements
opt.incsearch = true -- Shows the match while typing

--opt.undofile = true
--opt.undodir = "~/.local/share/nvim/undodir"

opt.encoding = "utf-8"
opt.fileformat = "unix"
opt.scrolloff = 4 -- Lines of context
opt.shiftwidth = 4
opt.synmaxcol = 4000
opt.tabstop = 4
opt.textwidth = 0
--opt.titlestring = "NVIM: %f"
opt.titlestring = [[NVIM: [%{fnamemodify(getcwd(), ':t')}] %t]]

opt.cursorline = true
opt.cursorcolumn = true

-- "rbgrouleff/bclose.vim"
vim.g.bclose_no_plugin_maps = true

-----------------------
-- TREESITTER CONFIG --
-----------------------
require("nvim-treesitter.configs").setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {"typescript", "tsx", "html"}
    }
}

--------------
-- NVIM-CMP --
--------------

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            --behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            {"i", "s"}
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            {"i", "s"}
        )
    },
    sources = {
        {name = "nvim_lsp"},
        {name = "luasnip"}
    }
}

--------------------
-- NVIM-AUTOPAIRS --
--------------------

--require("nvim-autopairs").setup {}
--
---- you need setup cmp first put this after cmp.setup()
--require("nvim-autopairs.completion.cmp").setup(
--    {
--        map_cr = true, --  map <CR> on insert mode
--        map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
--        auto_select = true, -- automatically select the first item
--        insert = false, -- use insert confirm behavior instead of replace
--        map_char = {
--            -- modifies the function or method delimiter by filetypes
--            all = "(",
--            tex = "{"
--        }
--    }
--)

------------------------
-- NVIM-LSP-INSTALLER --
------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local common_on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    client.resolved_capabilities.document_formatting = false
    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    --buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<c-k>", "<cmd>lua vim.lsp.diagnostic.goto_prev({wrap = false})<CR>", opts)
    buf_set_keymap("n", "<c-j>", "<cmd>lua vim.lsp.diagnostic.goto_next({wrap = false})<CR>", opts)
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
end

-- enable null-ls integration (optional)
require("null-ls").config {}
require("lspconfig")["null-ls"].setup {}

require("nvim-lsp-installer").on_server_ready(
    function(server)
        --Enable (broadcasting) snippet capability for completion
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local opts = {
            on_attach = common_on_attach,
            flags = {
                debounce_text_changes = 150
            },
            capabilities = capabilities,
            settings = {
                format = {enable = false}
            }
        }

        local vscode_servers = {html = "html", jsonls = "json", cssls = "css"}
        local lang = vscode_servers[server.name]

        if lang ~= nil then
            opts.cmd = {("vscode-" .. lang .. "-language-server"), "--stdio"}
        end

        if server.name == "tsserver" then
            opts.on_attach = function(client, bufnr)
                local ts_utils = require("nvim-lsp-ts-utils")

                ts_utils.setup {enable_import_on_completion = true}

                -- required to fix code action ranges and filter diagnostics
                ts_utils.setup_client(client)

                -- no default maps, so you may want to define some here
                local o = {silent = true}
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", o)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "rN", ":TSLspRenameFile<CR>", o)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", ":TSLspImportAll<CR>", o)

                common_on_attach(client, bufnr)
            end
        end

        server:setup(opts)
        vim.cmd [[do User LspAttachBuffers]]
    end
)

local lsp_installer_servers = require("nvim-lsp-installer.servers")
local auto_servers = {
    "pylsp",
    "sumneko_lua",
    "tsserver",
    "bashls",
    "vimls",
    "rust_analyzer",
    "html",
    "cssls",
    "jsonls"
    --"eslintls"
}

for _, s in ipairs(auto_servers) do
    local ok, server = lsp_installer_servers.get_server(s)
    if ok and not server:is_installed() then
        server:install()
    end
end

-------------
-- LUALINE --
-------------

require("lualine").setup {
    options = {theme = "onedark", icons_enabled = true},
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            "branch"
        },
        lualine_c = {"filename"},
        lualine_x = {
            "encoding",
            "fileformat",
            "filetype",
            [[string.format("%d Lines", vim.fn.line('$'))]],
            {
                "diagnostics",
                sources = {"nvim_lsp", "ale"}
            }
        },
        lualine_y = {
            "progress"
        },
        lualine_z = {"location"}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                "buffers",
                show_filename_only = false, -- shows shortened relative path when false
                show_modified_status = true, -- shows indicator then bufder is modified
                max_length = vim.o.columns * 1, -- maximum width of buffers component
                filetype_names = {
                    TelescopePrompt = "Telescope",
                    dashboard = "Dashboard",
                    packer = "Packer",
                    fzf = "FZF",
                    alpha = "Alpha",
                    ["lsp-installer"] = "LSP Installer"
                }, -- shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )
                buffers_color = {
                    active = nil, -- color for active buffer
                    inactive = nil -- color for inactive buffer
                }
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
            {
                [[string.format("Tab %d/%d", vim.fn.tabpagenr(), vim.fn.tabpagenr('$'))]],
                cond = function()
                    return fn.tabpagenr("$") > 1
                end
            }
        }
    },
    extensions = {}
}
