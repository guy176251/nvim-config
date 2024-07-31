local setup = require("plugins.setup")
local config = require("plugins.config")

setup.install_packer()
setup.install_plugins()

config.auto_session()
config.fzf()
config.fzf_checkout()
--config.harpoon()
config.hop()
config.indent_blankline()
config.lualine()
config.nvim_autopairs()
config.nvim_fzf()
config.nvim_treesitter()
config.rnvimr()
config.tokyonight()
config.gitsigns()
config.luasnip()
config.lsp_zero()
config.null_ls()
config.undotree()
config.rustaceanvim()
