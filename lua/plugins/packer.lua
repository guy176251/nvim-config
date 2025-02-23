local M = {}

function M.bootstrap()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd("packadd packer.nvim")
		vim.cmd(":PackerSync")
	end
end

function M.install_plugins()
	require("packer").startup(function(use)
		use("wbthomason/packer.nvim")

		-- NAVIGATION
		use("phaazon/hop.nvim")

		-- VIM THEMING
		use("folke/tokyonight.nvim")

		-- FILE MANAGEMENT
		use("junegunn/fzf")
		use("junegunn/fzf.vim")
		use("kevinhwang91/rnvimr")
		use("vijaymarupudi/nvim-fzf")
		use("vijaymarupudi/nvim-fzf-commands")

		-- SESSION
		--use("ThePrimeagen/harpoon")
		use("nvim-lua/plenary.nvim")
		use({
			"rmagatti/auto-session",
			config = function()
				require("auto-session").setup({
					log_level = "error",
					auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
				})
			end,
		})
		use("mbbill/undotree")

		-- GIT
		use("tpope/vim-fugitive")
		use("stsewd/fzf-checkout.vim")
		use("lewis6991/gitsigns.nvim")

		-- EDITOR
		use("lukas-reineke/indent-blankline.nvim")
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		-- LSP
		--use("p00f/nvim-ts-rainbow")
		--use("nvimtools/none-ls.nvim")
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
		})
		use("nvim-treesitter/nvim-treesitter-context")
		use("nvim-treesitter/playground")
		use("jose-elias-alvarez/null-ls.nvim")
		use("windwp/nvim-autopairs")

		use({
			"VonHeikemen/lsp-zero.nvim",
			branch = "v1.x",
			requires = {
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
		})

		-- JS
		use("HerringtonDarkholme/yats.vim")
		use("chemzqm/vim-jsx-improve")
		use("yuezk/vim-js") -- js
		use("maxmellon/vim-jsx-pretty") -- react/tsx syntax highlight & indent

		-- HTML/CSS
		use("mattn/emmet-vim")

		-- ZIG
		use("ziglang/zig.vim")

		-- C#
		use("jlcrochet/vim-razor")

		-- RUST
		use({
			"mrcjkb/rustaceanvim",
			version = "^5", -- Recommended
			lazy = false, -- This plugin is already lazy
		})
	end)
end

return M
