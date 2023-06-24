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
	--map("n", "<Leader>l", ":lua require('fzf_funcs').cwd()<CR>")
	--map("n", "<Leader>f", ":lua require('fzf_funcs').cwd()<CR>")

	local fzf = require("fzf_funcs")
	map("n", "<Leader>l", fzf.cwd)
end

function M.fzf_checkout()
	map("n", "<Leader>gb", ":GBranches<CR>")
end

function M.rnvimr()
	map("n", "<Leader>f", [[:RnvimrToggle<CR>]])
end

function M.nvim_fzf()
	local bat_command = "bat --color=always --style=header,grid --line-range :300 {}"
	local default_command = "strings {+}"
	local preview = '[[ -n "$(command -v bat)" ]] && ' .. bat_command .. " || " .. default_command

	require("fzf").default_options = {
		fzf_cli_args = " --height 100% --preview='" .. preview .. "' ",
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

	for i = 1, 4, 1 do
		nmap("<C-" .. i .. ">", ':lua require("harpoon.ui").nav_file(' .. i .. ")<CR>")
	end
end

function M.auto_session()
	require("auto-session").setup({
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
		--options = { theme = "onedark", icons_enabled = true },
		options = { theme = "tokyonight", icons_enabled = true },
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
					cond = function()
						return require("dynamic_tab").tab_mode()
					end,
					max_length = function()
						return columns(1)
					end,
				},
			},
			lualine_b = {
				buffer_window("windows", function()
					return require("dynamic_tab").tab_mode()
				end),
				buffer_window("buffers", function()
					return not require("dynamic_tab").tab_mode()
				end),
			},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		extensions = {},
	})
end

function M.nvim_treesitter()
	local highlight_disable = {
		tsx = true,
		cpp = true,
	}
	local rainbow_disable = vim.tbl_extend("force", highlight_disable, {
		html = true,
		javascript = true,
		typescript = true,
		--svelte = true,
		query = true,
	})

	local too_many_lines = function(bufnr)
		return vim.api.nvim_buf_line_count(bufnr) > 5000
	end

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"python",
			"lua",
			"javascript",
			"typescript",
			"tsx",
			"json",
			"svelte",
			"vim",
			"css",
			"scheme",
		},
		highlight = {
			enable = true,
			disable = function(lang, bufnr)
				return highlight_disable[lang] or too_many_lines(bufnr)
			end,
			--additional_vim_regex_highlighting = { "htmldjango", "html" },
		},
		rainbow = {
			enable = true,
			disable = function(lang, bufnr)
				return rainbow_disable[lang] or too_many_lines(bufnr)
			end,
			extended_mode = false,
			max_file_lines = nil,
		},
		indent = {
			enable = true,
		},
	})

	local version = vim.version()
	if version.api_level ~= 9 then
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end

	local htmldjango_path = "/home/guy/code/treesitter/tree-sitter-htmldjango-myown"

	--if vim.fn.filereadable(htmldjango_path .. "/src/parser.c") then
	--	-- old
	--	--local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	--	--parser_config.htmldjango = {
	--	--	install_info = {
	--	--		url = htmldjango_path,
	--	--		files = { "src/parser.c" },
	--	--		requires_generate_from_grammar = true,
	--	--	},
	--	--	filetype = "html",
	--	--}
	--	--local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
	--	--ft_to_parser.html = "htmldjango"

	--	-- new
	--	vim.treesitter.language.add("htmldjango", {
	--		install_info = {
	--			url = htmldjango_path,
	--			files = { "src/parser.c" },
	--			requires_generate_from_grammar = true,
	--		},
	--		filetype = "html",
	--	})
	--	vim.treesitter.language.register("htmldjango", "html")
	--end
end

function M.nvim_lspconfig()
	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		update_in_insert = false,
	})
	local lspconfig = require("lspconfig")

	lspconfig.tailwindcss.setup({
		init_options = {
			userLanguages = {
				htmldjango = "html",
			},
		},
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
		"emmet_ls",
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
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.ruff.with({
			extra_args = { "--extend-select", "I001", "--unfixable", "F841,F842,F401" },
		}),
		--null_ls.builtins.formatting.isort,
		--null_ls.builtins.diagnostics.flake8,
		--null_ls.builtins.diagnostics.djlint,
		--null_ls.builtins.diagnostics.mypy,

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
	})
end

function M.nvim_autopairs()
	require("nvim-autopairs").setup({ check_ts = true, enable_moveright = false })
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

function M.tokyonight()
	require("tokyonight").setup()
	vim.cmd([[colorscheme tokyonight-night]])
end

function M.gitsigns()
	require("gitsigns").setup({
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function gs_map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			gs_map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			gs_map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			-- Actions
			gs_map("n", "<leader>hs", gs.stage_hunk)
			gs_map("n", "<leader>hr", gs.reset_hunk)
			gs_map("v", "<leader>hs", function()
				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			gs_map("v", "<leader>hr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			gs_map("n", "<leader>hS", gs.stage_buffer)
			gs_map("n", "<leader>hu", gs.undo_stage_hunk)
			gs_map("n", "<leader>hR", gs.reset_buffer)
			gs_map("n", "<leader>hp", gs.preview_hunk)
			gs_map("n", "<leader>hb", function()
				gs.blame_line({ full = true })
			end)
			gs_map("n", "<leader>tb", gs.toggle_current_line_blame)
			gs_map("n", "<leader>hd", gs.diffthis)
			gs_map("n", "<leader>hD", function()
				gs.diffthis("~")
			end)
			gs_map("n", "<leader>td", gs.toggle_deleted)

			-- Text object
			gs_map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
		end,
	})
end

function M.lsp_zero()
	--
	-- https://github.com/VonHeikemen/lsp-zero.nvim
	--

	local lsp = require("lsp-zero")
	lsp.preset("recommended")

	lsp.configure("pyright", {
		root_dir = lsp_config_defaults().root_dir,
	})

	-- (Optional) Configure lua language server for neovim
	lsp.nvim_workspace()

	lsp.setup()
end

function M.undotree()
	nmap("<Leader>u", ":UndotreeToggle<CR>")
end

return M
