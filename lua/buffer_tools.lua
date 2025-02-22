local function get_active_buffers()
	local active_buffers = {}
	for tabnr = 1, vim.fn.tabpagenr("$") do
		for _, bufnr in ipairs(vim.fn.tabpagebuflist(tabnr)) do
			active_buffers[bufnr] = true
		end
	end
	return active_buffers
end

local function get_all_buffers()
	local all_buffers = {}
	for bufnr = 1, vim.fn.bufnr("$") do
		if vim.fn.buflisted(bufnr) == 1 then
			all_buffers[bufnr] = true
		end
	end
	return all_buffers
end

local function remove_unused_buffers()
	local active_buffers = get_active_buffers()
	local all_buffers = get_all_buffers()
	local buffers_to_remove = {}

	for bufnr, _ in pairs(all_buffers) do
		if active_buffers[bufnr] == nil then
			buffers_to_remove[bufnr] = true
		end
	end

	for bufnr, _ in pairs(buffers_to_remove) do
		vim.cmd("bd " .. bufnr)
	end
end

vim.keymap.set("n", "<Leader>b", remove_unused_buffers, { noremap = true })
