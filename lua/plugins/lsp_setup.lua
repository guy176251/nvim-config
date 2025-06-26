local function check_back_space()
	local col = vim.fn.col(".") - 1
	if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
		return true
	else
		return false
	end
end

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes"
vim.o.winborder = "rounded"

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require("lspconfig").util.default_config
lspconfig_defaults.capabilities =
	vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		if client == nil then
			return
		end

		if client:supports_method("textDocument/completion") == false then
			return
		end

		local is_rust_analyzer = client.name == "rust-analyzer"
		require("plugins.lsp_keymaps").set_lsp_keymaps(ev.buf, is_rust_analyzer)
	end,
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local select_opts = { behavior = cmp.SelectBehavior.Select }

local mapping = {
	-- confirm selection
	["<CR>"] = cmp.mapping.confirm({ select = false }),
	["<C-y>"] = cmp.mapping.confirm({ select = false }),

	-- navigate items on the list
	["<Up>"] = cmp.mapping.select_prev_item(select_opts),
	["<Down>"] = cmp.mapping.select_next_item(select_opts),
	["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
	["<C-n>"] = cmp.mapping.select_next_item(select_opts),

	-- scroll up and down in the completion documentation
	["<C-f>"] = cmp.mapping.scroll_docs(5),
	["<C-u>"] = cmp.mapping.scroll_docs(-5),

	-- toggle completion
	["<C-e>"] = cmp.mapping(function()
		if cmp.visible() then
			cmp.abort()
		else
			cmp.complete()
		end
	end),

	-- when menu is visible, navigate to next item
	-- when line is empty, insert a tab character
	-- else, activate completion
	["<Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item(select_opts)
		elseif check_back_space() then
			fallback()
		else
			cmp.complete()
		end
	end, { "i", "s" }),

	-- when menu is visible, navigate to previous item on list
	-- else, revert to default behavior
	["<S-Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item(select_opts)
		else
			fallback()
		end
	end, { "i", "s" }),

	-- go to next placeholder in the snippet
	["<C-d>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
	end, { "i", "s" }),

	-- go to previous placeholder in the snippet
	["<C-b>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s" }),
}

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 2 },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert(mapping),
})

require("mason").setup()

vim.lsp.config("ts_ls", {
	settings = {
		implicitProjectConfiguration = {
			--checkJs = true,
			experimentalDecorators = true,
		},
	},
})

vim.lsp.enable({
	"angular-language-server",
	"bashls",
	"clangd",
	"cssls",
	"gopls",
	"html",
	--"htmx",
	"jsonls",
	"lua_ls",
	"pyright",
	"svelte",
	"tailwindcss",
	"taplo",
	"templ",
	"ts_ls",
})
