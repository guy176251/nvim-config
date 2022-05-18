local function local_map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
end

local function silent_map(mode, lhs, rhs)
	local_map(mode, lhs, rhs, { silent = true })
end

silent_map("n", "<Up>", "gk")
silent_map("n", "<Down>", "gj")
silent_map("n", "<Home>", "g<Home>")
silent_map("n", "<End>", "g<End>")

silent_map("i", "<Up>", "<C-o>gk")
silent_map("i", "<Down>", "<C-o>gj")
silent_map("i", "<Home>", "<C-o>g<Home>")
silent_map("i", "<End>", "<C-o>g<End>")
