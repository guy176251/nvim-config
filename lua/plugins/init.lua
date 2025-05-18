local package_manager = require("plugins.lazy")
local config = require("plugins.config")

package_manager.bootstrap()
package_manager.install_plugins()

-- KEEPING
config.rnvimr()
config.fzf()
config.fzf_checkout()
config.nvim_fzf()
config.gitsigns()
config.auto_session()
config.undotree()
config.indent_blankline()
config.lualine()
config.nvim_treesitter()
config.tokyonight()

-- UPDATING
config.hop()
config.rustaceanvim()

-- LSP STUFF
config.nvim_autopairs()
config.luasnip()
config.lsp_zero()
config.null_ls()
config.tailwind_tools()

-- REMOVING
--config.harpoon()
