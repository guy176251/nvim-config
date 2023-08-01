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
		cpp = true,
		--javascript = true,
	}
	--local rainbow_disable = vim.tbl_extend("force", highlight_disable, {
	--	html = true,
	--	typescript = true,
	--	tsx = true,
	--	svelte = true,
	--})

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
			"html",
			"query",
		},
		highlight = {
			enable = true,
			disable = function(lang, bufnr)
				return highlight_disable[lang] or too_many_lines(bufnr)
			end,
			--additional_vim_regex_highlighting = { "htmldjango", "html" },
		},
		--rainbow = {
		--	enable = true,
		--	disable = function(lang, bufnr)
		--		return rainbow_disable[lang] or too_many_lines(bufnr)
		--	end,
		--	extended_mode = false,
		--	max_file_lines = nil,
		--},
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

	local version = vim.version()
	if version.api_level ~= 9 then
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	end

	--local htmldjango_path = "/home/guy/code/treesitter/tree-sitter-htmldjango-myown"
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

function M.null_ls()
	local null_ls = require("null-ls")
	local config = lsp_config_defaults()

	local sqlfluff_args = {
		extra_args = { "--dialect", "postgres" },
	}

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
			extra_args = { "--tab-width", "4" },
		}),

		-- lua
		null_ls.builtins.formatting.stylua,

		-- bash
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.code_actions.shellcheck,

		-- cpp
		null_ls.builtins.formatting.clang_format,

		-- golang
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.formatting.gofmt,

		-- sql
		-- null_ls.builtins.diagnostics.sqlfluff.with(sqlfluff_args),
		-- null_ls.builtins.formatting.sqlfluff.with(sqlfluff_args),
		-- null_ls.builtins.formatting.sqlfmt,
		null_ls.builtins.formatting.sql_formatter,

		-- elixir
		null_ls.builtins.diagnostics.credo,
		null_ls.builtins.formatting.mix,
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

	lsp.ensure_installed({
		"pyright",
		"lua_ls",
		"bashls",
		"gopls",

		-- js web shit
		"html",
		"cssls",
		"tsserver",
		"svelte",
		"angularls",
		"tailwindcss",
	})

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
