local use = require("packer").use

require("packer").startup(function()
    use("wbthomason/packer.nvim")

    -- OPENAI CODEX
    --use "tom-doerr/vim_codex"

    -- NAVIGATION
    use({
        "phaazon/hop.nvim",
        --branch = "v1.2", -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
        end,
    })

    -- TABLE
    --use "dhruvasagar/vim-table-mode"

    -- VIM THEMING
    --use "rafi/awesome-vim-colorschemes" -- vim themes
    use("navarasu/onedark.nvim")
    --use("projekt0n/github-nvim-theme")
    --use("wojciechkepka/vim-github-dark")
    --use("folke/tokyonight.nvim")

    -- FILE MANAGEMENT
    use("junegunn/fzf")
    use("junegunn/fzf.vim")
    use("rbgrouleff/bclose.vim")
    --use("francoiscabrol/ranger.vim")
    use("kevinhwang91/rnvimr")
    use("vijaymarupudi/nvim-fzf")
    use("vijaymarupudi/nvim-fzf-commands")
    --use({ "tpope/vim-obsession" })

    -- GIT
    use("tpope/vim-fugitive")
    use("stsewd/fzf-checkout.vim")

    -- AIRLINE
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- EDITOR
    use("windwp/nvim-autopairs")
    --use "jiangmiao/auto-pairs"
    --use "dense-analysis/ale"
    --use "nathanmsmith/nvim-ale-diagnostic"
    use("turbio/bracey.vim")
    use("lukas-reineke/indent-blankline.nvim")
    --use "sheerun/vim-polyglot"

    -- SNIPPETS
    use("SirVer/ultisnips")
    use("honza/vim-snippets")

    -- LSP
    use("hrsh7th/nvim-cmp") -- Autocompletion plugin
    --use "saadparwaiz1/cmp_luasnip" -- Snippets source for nvim-cmp
    use("p00f/nvim-ts-rainbow")
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/nvim-treesitter-context")
    use("neovim/nvim-lspconfig") -- Collection of configurations for built-in LSP client
    use("williamboman/nvim-lsp-installer")
    use({
        "hrsh7th/cmp-nvim-lsp",
        requires = "quangnguyen30192/cmp-nvim-ultisnips",
    }) -- LSP source for nvim-cmp

    use("nvim-lua/plenary.nvim")
    use("jose-elias-alvarez/nvim-lsp-ts-utils")
    use("jose-elias-alvarez/null-ls.nvim")

    use("ThePrimeagen/harpoon")

    use("L3MON4D3/LuaSnip") -- Snippets plugin

    -- JS
    use("HerringtonDarkholme/yats.vim")
    use("chemzqm/vim-jsx-improve")
    use("yuezk/vim-js") -- js
    use("maxmellon/vim-jsx-pretty") -- react/tsx syntax highlight & indent
    --use "leafOfTree/vim-vue-plugin" -- vue syntax highlight & indent

    -- PYTHON
    --use {"numirias/semshi", run = ":UpdateRemotePlugins"} -- python
    --use("Vimjas/vim-python-pep8-indent")
    --use("petobens/poet-v")

    -- HTML/CSS
    use("mattn/emmet-vim")
    use({
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({
                log_level = "info",
                auto_session_suppress_dirs = { "~/", "~/Projects" },
                auto_session_use_git_branch = true,
            })
        end,
    })
    --use({
    --    "olimorris/persisted.nvim",
    --    config = function()
    --        require("persisted").setup({
    --            use_git_branch = true,
    --            autoload = true,
    --        })
    --    end,
    --})

    -- ZIG
    use("ziglang/zig.vim")
end)
