local function filter_duplicates(array)
	local unique = {}
	for _, table_a in ipairs(array) do
		local is_duplicate = false

		for _, table_b in ipairs(unique) do
			if vim.deep_equal(table_a, table_b) then
				is_duplicate = true
				break
			end
		end

		if not is_duplicate then
			table.insert(unique, table_a)
		end
	end
	return unique
end

local function on_list(options)
	options.items = filter_duplicates(options.items)
	vim.fn.setqflist({}, " ", options)
	vim.cmd("botright copen")
end

local M = {}

---@param bufnr integer
---@param is_rust_analyzer boolean
function M.set_lsp_keymaps(bufnr, is_rust_analyzer)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	if is_rust_analyzer then
		vim.keymap.set("n", "gm", function()
			vim.cmd.RustLsp("expandMacro")
		end, opts)

		vim.keymap.set("n", "ge", function()
			vim.cmd.RustLsp("relatedDiagnostics")
		end, opts)
	end

	vim.keymap.set("n", "K", function()
		if is_rust_analyzer then
			vim.cmd.RustLsp({ "hover", "actions" })
		else
			vim.lsp.buf.hover()
		end
	end, opts)

	vim.keymap.set("n", "[d", function()
		if is_rust_analyzer then
			vim.cmd.RustLsp({ "renderDiagnostic", "cycle_prev" })
		else
			vim.diagnostic.jump({ count = -1, float = true, wrap = true })
		end
	end, opts)

	vim.keymap.set("n", "]d", function()
		if is_rust_analyzer then
			vim.cmd.RustLsp({ "renderDiagnostic", "cycle" })
		else
			vim.diagnostic.jump({ count = 1, float = true, wrap = true })
		end
	end, opts)

	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)

	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references(nil, { on_list = on_list })
	end, opts)
end

function M.on_attach(client, bufnr)
	local is_rust_analyzer = client.name == "rust-analyzer"
	M.set_lsp_keymaps(bufnr, is_rust_analyzer)
end

return M
