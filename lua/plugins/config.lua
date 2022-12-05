local helpers = require("helpers")
local map = helpers.map
local lsp_config_defaults = helpers.lsp_config_defaults

local function nmap(...)
    map("n", ...)
end

local M = {}

function M.hop()
    require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })

    local hop_opts = "{ create_hl_autocmd = true }"
    local hopword = [[<cmd>lua require'hop'.hint_words(]] .. hop_opts .. [[)<cr>]]
    local hopline = [[<cmd>lua require'hop'.hint_lines_skip_whitespace(]] .. hop_opts .. [[)<cr>]]

    map("n", "W", hopline, { silent = true })
    map("v", "W", hopline, { silent = true })
    map("n", "w", hopword, { silent = true })
    map("v", "w", hopword, { silent = true })
end

function M.onedark()
    require("onedark").setup({
        style = "darker",
        toggle_style_key = "<nop>",
    })
    require("onedark").load()
end

function M.fzf()
    map("n", "<Leader>o", ":Files<CR>")
    map("n", "<Leader>O", ":Files ~/<CR>")
    map("n", "<Leader>p", ":Buffers<CR>")
    map("n", "<Leader>h", ":Helptags<CR>")
    map("n", "<Leader>;", ":History:<CR>")
    map("n", "<Leader>c", ":Commands<CR>")
    map("n", "<Leader>r", ":Rg <C-R><C-W><CR>")
    map("n", "<Leader>R", ":Rg<CR>")
    map("n", "<Leader>s", ":BLines<CR>")
    map("n", "<Leader>gl", ":GFiles<CR>")
    map("n", "<Leader>gs", ":GFiles?<CR>")
    map("n", "<Leader>gc", ":Commits<CR>")
    map("n", "<Leader>l", ":lua require('fzf_funcs').cwd()<CR>")
end

function M.fzf_checkout()
    map("n", "<Leader>gb", ":GBranches<CR>")
end

function M.rnvimr()
    map("n", "<Leader>f", [[:RnvimrToggle<CR>]])
end

function M.nvim_fzf()
    require("fzf").default_options = {
        fzf_cli_args = " --height 100% --preview='[[ -n \"$(command -v bat)\" ]] && bat --color=always --style=header,grid --line-range :300 {} || strings {+}' ",
    }
end

function M.harpoon()
    require("harpoon").setup({
        global_settings = {
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            tmux_autoclose_windows = false,
            excluded_filetypes = { "harpoon" },
        },
    })
    nmap("<Leader>a", ":lua require('harpoon.mark').add_file()<CR>")
    nmap("<Leader>m", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
end

function M.auto_session()
    require("auto-session").setup({
        log_level = "info",
        auto_session_suppress_dirs = { "~/", "~/Projects" },
        auto_session_use_git_branch = true,
    })
end

function M.indent_blankline()
    vim.opt.list = true

    require("indent_blankline").setup({
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
    })
end

function M.lualine()
    -- Out of 6 total columns
    local function columns(num)
        return vim.o.columns * num / 6
    end

    -- config options
    local function buffer_window(type, cond)
        return {
            type,
            cond = cond,
            show_filename_only = true,
            show_modified_status = true,
            max_length = function()
                return columns(5)
            end,
            filetype_names = {
                TelescopePrompt = "Telescope",
                dashboard = "Dashboard",
                packer = "Packer",
                fzf = "FZF",
                alpha = "Alpha",
                ["lsp-installer"] = "LSP Installer",
            },
        }
    end

    require("lualine").setup({
        options = { theme = "onedark", icons_enabled = true },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "FugitiveHead",
            },
            lualine_c = { "filename" },
            lualine_x = {
                "encoding",
                "fileformat",
                "filetype",
                [[string.format("%d Lines", vim.fn.line('$'))]],
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", "ale" },
                },
            },
            lualine_y = {
                "progress",
            },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {
            lualine_a = {
                {
                    "tabs",
                    max_length = function()
                        return columns(1)
                    end,
                },
            },
            lualine_b = {
                buffer_window("windows", function()
                    return require("dynamic_tab").window_mode()
                end),
                buffer_window("buffers", function()
                    return not require("dynamic_tab").window_mode()
                end),
            },
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {
            },
        },
        extensions = {},
    })
end

function M.nvim_treesitter()
    local highlight_disable = {
        typescript = true,
        tsx = true,
        html = true,
        javascript = true,
        cpp = true,
    }
    local rainbow_disable = vim.tbl_extend("force", highlight_disable, { svelte = true })

    local too_many_lines = function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) > 5000
    end

    require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = {
            enable = true,
            disable = function(lang, bufnr)
                return highlight_disable[lang] or too_many_lines(bufnr)
            end,
        },
        rainbow = {
            enable = true,
            disable = function(lang, bufnr)
                return rainbow_disable[lang] or too_many_lines(bufnr)
            end,
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            --colors = {}, -- table of hex strings
            --termcolors = {},
        },
    })

    local version = vim.version()
    if version.api_level ~= 9 then
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end
end

function M.nvim_lspconfig()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        update_in_insert = false,
    })
end

function M.nvim_lsp_installer()
    local config = lsp_config_defaults()
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
        elseif server.name == "ccls" then
            opts.capabilities.offsetEncoding = { "utf-32" }
        end

        server:setup(opts)
        vim.cmd([[do User LspAttachBuffers]])
    end)

    local lsp_installer_servers = require("nvim-lsp-installer.servers")
    local auto_servers = {
        "sumneko_lua",
        "tsserver",
        "bashls",
        "vimls",
        "rust_analyzer",
        "html",
        "cssls",
        "jsonls",
        "jedi_language_server",
        --"pylsp",
        "svelte",
        "tailwindcss",
        "zls",
    }

    for _, s in ipairs(auto_servers) do
        local ok, server = lsp_installer_servers.get_server(s)
        if ok and not server:is_installed() then
            server:install()
        end
    end
end

function M.null_ls()
    local null_ls = require("null-ls")
    local config = lsp_config_defaults()

    -- ORDER IN TABLE DETERMINES EXECUTION ORDER
    local sources = {
        -- python
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        --null_ls.builtins.diagnostics.djlint,
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
    }
    null_ls.setup({
        sources = sources,
        on_attach = config.on_attach,
        root_dir = config.root_dir,
        -- removed error "warning: multiple different client offset_encodings detected for buffer, this is not supported yet"
        --on_init = function(client, _)
        --    client.offset_encoding = "utf-32"
        --end,
    })
end

function M.nvim_autopairs()
    require("nvim-autopairs").setup({ check_ts = true })
end

function M.nvim_cmp()
    vim.opt.completeopt = "menuone,noselect"

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
end

return M
