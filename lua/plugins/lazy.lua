local M = {}

function M.bootstrap()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if vim.fn.isdirectory(lazypath) == 0 then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)
end

function M.install_plugins()
	require("lazy").setup({
		spec = {
			-- NAVIGATION
			"phaazon/hop.nvim",

			-- VIM THEMING
			"folke/tokyonight.nvim",

			-- FILE MANAGEMENT
			"junegunn/fzf",
			"junegunn/fzf.vim",
			"kevinhwang91/rnvimr",
			"vijaymarupudi/nvim-fzf",
			"vijaymarupudi/nvim-fzf-commands",

			-- SESSION
			"nvim-lua/plenary.nvim",
			"rmagatti/auto-session",
			"mbbill/undotree",

			-- GIT
			"tpope/vim-fugitive",
			"stsewd/fzf-checkout.vim",
			"lewis6991/gitsigns.nvim",

			-- EDITOR
			"lukas-reineke/indent-blankline.nvim",
			{
				"nvim-lualine/lualine.nvim",
				dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
			},

			-- LSP
			{
				"nvim-treesitter/nvim-treesitter",
				build = ":TSUpdate",
			},
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/playground",
			"nvimtools/none-ls.nvim",
			"windwp/nvim-autopairs",
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",

			{

				"L3MON4D3/LuaSnip",
				dependencies = {
					"honza/vim-snippets",
				},
			},

			{
				"hrsh7th/nvim-cmp",
				event = "InsertEnter", -- load cmp on InsertEnter
				dependencies = {
					"hrsh7th/cmp-nvim-lsp",
					"hrsh7th/cmp-buffer",
					"saadparwaiz1/cmp_luasnip",
				},
			},

			-- HTML
			"mattn/emmet-vim",

			-- RUST
			{
				"mrcjkb/rustaceanvim",
				version = "^6", -- Recommended
				lazy = false, -- This plugin is already lazy
			},

			-- TAILWIND
			{
				"luckasRanarison/tailwind-tools.nvim",
				name = "tailwind-tools",
				build = ":UpdateRemotePlugins",
				dependencies = {
					"nvim-treesitter/nvim-treesitter",
					"neovim/nvim-lspconfig", -- optional
				},
			},

			-- LUA
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {},
			},
		},
	})
end

return M
