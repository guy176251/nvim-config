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
			--"ThePrimeagen/harpoon",
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
			--"p00f/nvim-ts-rainbow",
			--"nvimtools/none-ls.nvim",
			{
				"nvim-treesitter/nvim-treesitter",
				build = ":TSUpdate",
			},
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/playground",
			"nvimtools/none-ls.nvim",
			"windwp/nvim-autopairs",

			{
				"VonHeikemen/lsp-zero.nvim",
				branch = "v1.x",
				dependencies = {
					-- LSP Support
					{ "neovim/nvim-lspconfig" }, -- Required
					{ "williamboman/mason.nvim" }, -- Optional
					{ "williamboman/mason-lspconfig.nvim" }, -- Optional

					-- Autocompletion
					{ "hrsh7th/nvim-cmp" }, -- Required
					{ "hrsh7th/cmp-nvim-lsp" }, -- Required
					{ "hrsh7th/cmp-buffer" }, -- Optional
					{ "hrsh7th/cmp-path" }, -- Optional
					{ "saadparwaiz1/cmp_luasnip" }, -- Optional
					{ "hrsh7th/cmp-nvim-lua" }, -- Optional

					-- Snippets
					{ "L3MON4D3/LuaSnip" }, -- Required
					{ "rafamadriz/friendly-snippets" }, -- Optional
					{ "honza/vim-snippets" }, -- Optional
				},
			},

			-- JS
			"HerringtonDarkholme/yats.vim",
			"chemzqm/vim-jsx-improve",
			"yuezk/vim-js", -- js
			"maxmellon/vim-jsx-pretty", -- react/tsx syntax highlight & indent

			-- HTML/CSS
			"mattn/emmet-vim",

			-- ZIG
			"ziglang/zig.vim",

			-- C#
			"jlcrochet/vim-razor",

			-- RUST
			{
				"mrcjkb/rustaceanvim",
				version = "^5", -- Recommended
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
		},
	})
end

return M
