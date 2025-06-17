-- SHOULD NOT CONTAIN ANY SETTINGS RELATED TO EXTERNAL PLUGINS
-- OR CUSTOM CODE YOU YOURSELF WROTE.

local function map(mode, lhs, rhs, opts)
	local default_opts = { noremap = true }
	if opts then
		default_opts = vim.tbl_extend("force", default_opts, opts)
	end
	vim.keymap.set(mode, lhs, rhs, default_opts)
end

local function silent_map(mode, lhs, rhs)
	map(mode, lhs, rhs, { silent = true })
end

local opt = vim.opt
local g = vim.g

g.mapleader = ","

silent_map("v", "<C-C>", '"+y')
silent_map("n", "<Esc>", ":noh<CR><Esc>") --After searching, pressing escape stops the highlight

map("n", "<Leader>w", [[:%s/\s\+$//e<CR>]])
map("n", "<Leader>x", ":bp|bd #<CR>")
map("n", "<Leader>t", ":tabnew<CR>:bp|bd #<CR>")

-- Move split
map("n", "<A-Right>", "<C-W><S-L>")
map("n", "<A-Left>", "<C-W><S-H>")
map("n", "<A-Up>", "<C-W><S-K>")
map("n", "<A-Down>", "<C-W><S-J>")

-- Split navigations
map("n", "<C-Right>", "<C-W><C-L>")
map("n", "<C-Left>", "<C-W><C-H>")
map("n", "<C-Up>", "<C-W><C-K>")
map("n", "<C-Down>", "<C-W><C-J>")

-- Resize split
map("n", "-", "<C-W>-")
map("n", "+", "<C-W>+")
map("n", "(", "<C-W><")
map("n", ")", "<C-W>>")

-- Scroll viewport
map("n", "<S-Up>", "<C-Y>")
map("n", "<S-Down>", "<C-E>")
map("v", "<S-Up>", "<C-Y>")
map("v", "<S-Down>", "<C-E>")
map("i", "<S-Up>", "<C-X><C-Y>")
map("i", "<S-Down>", "<C-X><C-E>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- line-break movement
--silent_map("n", "<Up>", "gk")
--silent_map("n", "<Down>", "gj")
--silent_map("n", "<Home>", "g<Home>")
--silent_map("n", "<End>", "g<End>")
--
--silent_map("v", "<Up>", "gk")
--silent_map("v", "<Down>", "gj")
--silent_map("v", "<Home>", "g<Home>")
--silent_map("v", "<End>", "g<End>")
--
--silent_map("i", "<Up>", "<C-o>gk")
--silent_map("i", "<Down>", "<C-o>gj")
--silent_map("i", "<Home>", "<C-o>g<Home>")
--silent_map("i", "<End>", "<C-o>g<End>")

-- half page movement, primeagen version
silent_map("n", "<PageDown>", "<C-d>zz")
silent_map("n", "<PageUp>", "<C-u>zz")
silent_map("v", "<PageDown>", "<C-d>zz")
silent_map("v", "<PageUp>", "<C-u>zz")
silent_map("i", "<PageDown>", "<C-o><C-d><C-o>zz")
silent_map("i", "<PageUp>", "<C-o><C-u><C-o>zz")

-- tab buffer movement
silent_map("n", "<Tab>", ":bnext<CR>")
silent_map("n", "<S-Tab>", ":bprevious<CR>")

opt.autoindent = true
opt.autoread = true
opt.expandtab = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true -- Shows the match while typing
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.showcmd = true
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = false
opt.title = true
opt.undofile = true
opt.wildmenu = true

opt.encoding = "utf-8"
opt.fileformat = "unix"
opt.inccommand = "split" -- Get a preview of replacements
opt.titlestring = [[NVIM: [%{fnamemodify(getcwd(), ':t')}] %t]]

opt.scrolloff = 4 -- Lines of context
opt.shiftwidth = 4
opt.synmaxcol = 4000
opt.tabstop = 4
opt.textwidth = 0

opt.foldmethod = "indent"
opt.foldlevelstart = 30

opt.mouse = ""
opt.backupcopy = "yes"

opt.winborder = "rounded"

vim.cmd([[au BufRead,BufNewFile .env.* set filetype=sh]])
vim.cmd([[au BufRead,BufNewFile Dockerfile.* set filetype=dockerfile]])
--vim.cmd([[au BufRead,BufNewFile *.html set filetype=html]])
vim.filetype.add({ extension = { templ = "templ" } })

-- redo folds on write
vim.cmd([[au BufWrite * normal zx]])

-- vscode doesn't like cursorline stuff
if not vim.g.vscode then
	vim.cmd([[hi CursorLine cterm=NONE ctermbg=darkgray ctermfg=white]])
	opt.cursorcolumn = true
	opt.cursorline = true
end
