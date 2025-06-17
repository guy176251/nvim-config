local function map(mode, lhs, rhs, opts)
	local default_opts = { noremap = true }
	if opts then
		default_opts = vim.tbl_extend("force", default_opts, opts)
	end
	vim.keymap.set(mode, lhs, rhs, default_opts)
end

local function silent_map(mode, lhs, rhs)
	map(mode, lhs, rhs, { silent = true })
end

local function nmap(...)
	map("n", ...)
end

---@param params { no_formatting: boolean | nil, rust_lsp: boolean | nil } | nil
local function lsp_config_defaults(params)
	local rust_lsp = params and params.rust_lsp

	return {
		root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "package.json", ".null-ls-root", ".git"),

		on_attach = function(client, bufnr)
			vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

			local opts = { noremap = true, silent = true, buffer = bufnr }

			if params and params.no_formatting then
				-- diagnostics for other lsp get messed up when formatting is enabled
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end

			if rust_lsp then
				nmap("gm", function()
					vim.cmd.RustLsp("expandMacro")
				end, opts)

				nmap("ge", function()
					vim.cmd.RustLsp("relatedDiagnostics")
				end, opts)
			end

			nmap("K", function()
				if rust_lsp then
					vim.cmd.RustLsp({ "hover", "actions" })
				else
					vim.lsp.buf.hover()
				end
			end, opts)

			nmap("[d", function()
				if rust_lsp then
					vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
				else
					vim.diagnostic.jump({ count = -1, float = true, wrap = true })
				end
			end, opts)

			nmap("]d", function()
				if rust_lsp then
					vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
				else
					vim.diagnostic.jump({ count = 1, float = true, wrap = true })
				end
			end, opts)

			nmap("<C-k>", vim.lsp.buf.signature_help, opts)
			nmap("<space>D", vim.lsp.buf.type_definition, opts)
			nmap("<space>ca", vim.lsp.buf.code_action, opts)
			nmap("<space>e", vim.diagnostic.open_float, opts)
			nmap("<space>q", vim.diagnostic.setloclist, opts)
			nmap("<space>rn", vim.lsp.buf.rename, opts)
			nmap("<space>wa", vim.lsp.buf.add_workspace_folder, opts)
			nmap("<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
			nmap("gD", vim.lsp.buf.declaration, opts)
			nmap("gd", vim.lsp.buf.definition, opts)
			nmap("gi", vim.lsp.buf.implementation, opts)
			nmap("gr", vim.lsp.buf.references, opts)
			nmap("<space>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
		end,
	}
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
	local function cwd()
		local path = vim.fn.expand("%:p:h")
		vim.cmd("Files " .. path)
	end

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
	map("n", "<Leader>l", cwd)
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
		auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		auto_session_use_git_branch = true,
	})

	vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
end

function M.indent_blankline()
	require("ibl").setup()
end

function M.lualine()
	-- Out of 6 total columns
	local function columns(num)
		return vim.o.columns * num / 6
	end

	local function tab_mode()
		return vim.fn.tabpagenr("$") > 1
	end

	local function tab()
		vim.cmd(tab_mode() and "tabn" or "bnext")
	end

	local function shift_tab()
		vim.cmd(tab_mode() and "tabp" or "bprevious")
	end

	-- dynamic tab
	silent_map("n", "<Tab>", tab)
	silent_map("n", "<S-Tab>", shift_tab)

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
						return tab_mode()
					end,
					max_length = function()
						return columns(1)
					end,
				},
			},
			lualine_b = {
				buffer_window("windows", function()
					return tab_mode()
				end),
				buffer_window("buffers", function()
					return not tab_mode()
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
		cpp = true,
	}

	local too_many_lines = function(bufnr)
		return vim.api.nvim_buf_line_count(bufnr) > 5000
	end

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"python",

			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"svelte",
			"angular",

			"json",
			"query",

			"bash",
			"lua",
			"vim",

			"glimmer",
			"templ",
			"go",
			"rust",
		},
		highlight = {
			enable = true,
			disable = function(lang, bufnr)
				return highlight_disable[lang] or too_many_lines(bufnr)
			end,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				scope_incremental = false,
				node_incremental = "<CR>",
				node_decremental = "<S-CR>",
			},
		},
	})

	if vim.version().api_level ~= 9 then
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end

	-- potentially load .so from this repo
	--print(debug.getinfo(2, "S").source:sub(2))
	--vim.fn.getchar()

	--local shared_lib = "/home/guy/code/treesitter/tree-sitter-htmldjango-myown/src/parser.so"
	--if vim.fn.filereadable(shared_lib) == 1 then
	--	vim.treesitter.language.add("htmldjango", {
	--		path = shared_lib,
	--	})
	--end
end

function M.null_ls()
	local null_ls = require("null-ls")
	local config = lsp_config_defaults()

	local builtins = require("plugins.null_ls_builtins")
	local formatters = builtins.formatters
	local diagnostics = builtins.diagnostics

	-- ORDER IN TABLE DETERMINES EXECUTION ORDER
	local sources = {
		-- python
		diagnostics.ruff(),
		formatters.ruff_imports(),
		formatters.ruff_code(),
		null_ls.builtins.diagnostics.djlint,
		null_ls.builtins.formatting.djlint,

		-- js
		null_ls.builtins.formatting.prettier.with({
			extra_filetypes = { "svelte" },
			extra_args = { "--tab-width", "4" },
		}),

		-- lua
		null_ls.builtins.formatting.stylua,

		-- bash
		null_ls.builtins.formatting.shfmt,
		diagnostics.shellcheck(),

		-- cpp
		null_ls.builtins.formatting.clang_format,

		-- golang
		--null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.formatting.gofmt,
		formatters.templ(),

		-- sql
		-- null_ls.builtins.diagnostics.sqlfluff.with(sqlfluff_args),
		-- null_ls.builtins.formatting.sqlfluff.with(sqlfluff_args),
		-- null_ls.builtins.formatting.sqlfmt,
		null_ls.builtins.formatting.sql_formatter,

		-- elixir
		null_ls.builtins.diagnostics.credo,
		null_ls.builtins.formatting.mix,

		-- c_sharp
		null_ls.builtins.formatting.csharpier,
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

	lsp.configure("ts_ls", {
		settings = {
			implicitProjectConfiguration = {
				checkJs = true,
			},
		},
	})

	local html_filetypes = { "html", "htmldjango", "templ", "glimmer", "handlebars" }

	lsp.configure("html", { filetypes = html_filetypes })
	lsp.configure("htmx", { filetypes = html_filetypes })

	lsp.on_attach(function(client, _)
		-- diagnostics for other lsp get messed up when formatting is enabled
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		if client.name == "svelte" then
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
				end,
			})
		end

		local function filter_duplicates(array)
			local unique = {}
			for _, tableA in ipairs(array) do
				local is_duplicate = false
				for _, tableB in ipairs(unique) do
					if vim.deep_equal(tableA, tableB) then
						is_duplicate = true
						break
					end
				end
				if not is_duplicate then
					table.insert(unique, tableA)
				end
			end
			return unique
		end

		local function on_list(options)
			options.items = filter_duplicates(options.items)
			vim.fn.setqflist({}, " ", options)
			vim.cmd("botright copen")
		end

		vim.keymap.set("n", "gr", function()
			vim.lsp.log.error("GETTING REFERENCES")
			vim.lsp.buf.references(nil, { on_list = on_list })
		end, { noremap = true })
	end)

	-- (Optional) Configure lua language server for neovim
	lsp.nvim_workspace()

	lsp.setup()

	vim.lsp.log.error("SETTING UP LSP")
	vim.lsp.enable("angular-language-server")
end

function M.undotree()
	nmap("<Leader>u", ":UndotreeToggle<CR>")
end

function M.luasnip()
	local luasnip = require("luasnip")
	luasnip.filetype_extend("htmldjango", { "html" })
	luasnip.filetype_extend("templ", { "html" })
	luasnip.filetype_extend("handlebars", { "html" })
	require("luasnip.loaders.from_snipmate").lazy_load()
end

function M.rustaceanvim()
	vim.g.rustaceanvim = {
		server = {
			on_attach = lsp_config_defaults({ rust_lsp = true }).on_attach,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						features = "all",
					},
				},
			},
		},
	}
end

function M.tailwind_tools()
	require("tailwind-tools").setup({
		server = {
			init_options = {
				userLanguages = {
					rust = "html",
				},
			},
			settings = {
				includeLanguages = {
					rust = "html",
				},
			},
			filetypes = {
				"rust",
			},
		},
	})
end

return M
