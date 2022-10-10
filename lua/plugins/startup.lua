require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- NAVIGATION
    use("phaazon/hop.nvim")

    -- VIM THEMING
    use("navarasu/onedark.nvim")

    -- FILE MANAGEMENT
    use("junegunn/fzf")
    use("junegunn/fzf.vim")
    use("kevinhwang91/rnvimr")
    use("vijaymarupudi/nvim-fzf")
    use("vijaymarupudi/nvim-fzf-commands")

    -- SESSION
    use("ThePrimeagen/harpoon")
    use("rmagatti/auto-session")

    -- GIT
    use("tpope/vim-fugitive")
    use("stsewd/fzf-checkout.vim")

    -- EDITOR
    use("lukas-reineke/indent-blankline.nvim")
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- SNIPPETS
    use("SirVer/ultisnips")
    use("honza/vim-snippets")
    use("L3MON4D3/LuaSnip") -- Snippets plugin

    -- LSP
    use("p00f/nvim-ts-rainbow")
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    use("nvim-treesitter/nvim-treesitter-context")
    use("neovim/nvim-lspconfig")
    use("williamboman/nvim-lsp-installer")
    use("nvim-lua/plenary.nvim")
    use("jose-elias-alvarez/nvim-lsp-ts-utils")
    use("jose-elias-alvarez/null-ls.nvim")
    use("windwp/nvim-autopairs")
    use({
        "hrsh7th/cmp-nvim-lsp",
        requires = "quangnguyen30192/cmp-nvim-ultisnips",
    })
    use("hrsh7th/nvim-cmp")

    -- JS
    use("HerringtonDarkholme/yats.vim")
    use("chemzqm/vim-jsx-improve")
    use("yuezk/vim-js") -- js
    use("maxmellon/vim-jsx-pretty") -- react/tsx syntax highlight & indent

    -- HTML/CSS
    use("mattn/emmet-vim")

    -- ZIG
    use("ziglang/zig.vim")
end)
