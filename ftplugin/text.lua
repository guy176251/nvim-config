local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true })
end

map("n", "<Up>", "gk")
map("n", "<Down>", "gj")
map("n", "<Home>", "g<Home>")
map("n", "<End>", "g<End>")

map("v", "<Up>", "gk")
map("v", "<Down>", "gj")
map("v", "<Home>", "g<Home>")
map("v", "<End>", "g<End>")

map("i", "<Up>", "<C-o>gk")
map("i", "<Down>", "<C-o>gj")
map("i", "<Home>", "<C-o>g<Home>")
map("i", "<End>", "<C-o>g<End>")
