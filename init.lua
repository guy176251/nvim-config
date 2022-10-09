--require("ale")
require("packer_check")
require("plugins")
require("config")
require("keybinds")
--require("save_buffer_position")
require("lsp")

--local theme = vim.env.LIGHTMODE == "1" and "onehalflight" or "onedark"
--vim.cmd("colorscheme " .. theme)

--vim.g.onedark_terminal_italics = true
--vim.opt.background = "light"
--vim.opt.background = "dark"
vim.cmd("colorscheme onedark")
