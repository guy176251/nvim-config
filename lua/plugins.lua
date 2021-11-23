local use = require("packer").use

require("packer").startup(
    function()
        use "wbthomason/packer.nvim"

        -- NAVIGATION
        use {
            "phaazon/hop.nvim",
            as = "hop",
            config = function()
                -- you can configure Hop the way you like here; see :h hop-config
                require "hop".setup {}
                --require "hop".setup {keys = "etovxqpdygfblzhckisuran"}
            end
        }

        -- TABLE
        use "dhruvasagar/vim-table-mode"

        -- VIM THEMING
        --use "rafi/awesome-vim-colorschemes" -- vim themes
        use "projekt0n/github-nvim-theme"

        -- FILE MANAGEMENT
        use "junegunn/fzf"
        use "junegunn/fzf.vim"
        use "rbgrouleff/bclose.vim"
        use "francoiscabrol/ranger.vim"

        -- AIRLINE
        use {
            "nvim-lualine/lualine.nvim",
            requires = {"kyazdani42/nvim-web-devicons", opt = true}
        }

        -- EDITOR
        use "windwp/nvim-autopairs"
        --use "jiangmiao/auto-pairs"
        use "dense-analysis/ale"
        --use "nathanmsmith/nvim-ale-diagnostic"
        use "turbio/bracey.vim"

        -- LSP
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use "neovim/nvim-lspconfig" -- Collection of configurations for built-in LSP client
        use "williamboman/nvim-lsp-installer"
        use "hrsh7th/cmp-nvim-lsp" -- LSP source for nvim-cmp

        use "nvim-lua/plenary.nvim"
        use "jose-elias-alvarez/nvim-lsp-ts-utils"
        use "jose-elias-alvarez/null-ls.nvim"

        use "L3MON4D3/LuaSnip" -- Snippets plugin
        use "hrsh7th/nvim-cmp" -- Autocompletion plugin
        use "saadparwaiz1/cmp_luasnip" -- Snippets source for nvim-cmp

        -- JS
        use "HerringtonDarkholme/yats.vim"
        use "chemzqm/vim-jsx-improve"
        use "yuezk/vim-js" -- js
        use "maxmellon/vim-jsx-pretty" -- react/tsx syntax highlight & indent
        --use "leafOfTree/vim-vue-plugin" -- vue syntax highlight & indent

        -- PYTHON
        use {"numirias/semshi", run = ":UpdateRemotePlugins"} -- python
        use "Vimjas/vim-python-pep8-indent"

        -- HTML/CSS
        use "mattn/emmet-vim"
    end
)
