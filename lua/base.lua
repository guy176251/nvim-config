-- SHOULD NOT CONTAIN ANY SETTINGS RELATED TO EXTERNAL PLUGINS
-- OR CUSTOM CODE YOU YOURSELF WROTE.

local map = require("helpers").map
local opt = vim.opt
local g = vim.g

g.mapleader = ","

map("v", "<C-C>", '"+y')
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")
map("n", "<Esc>", ":noh<CR><Esc>", { silent = true }) --After searching, pressing escape stops the highlight

map("n", "<Leader>w", [[:%s/\s\+$//e<CR>]])
map("n", "<Leader>x", ":bp|bd #<CR>")
map("n", "<Leader>t", ":tabnew<CR>")

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

-- Terminal binds
--local term_command = "split | set norelativenumber | set nonumber | term"
local term_command = "split | term"
map("t", "<C-Space>", [[<C-\><C-n>]])
map("n", [[<Leader>\]], ":" .. term_command .. "<CR>")
map("n", [[<Leader>|]], ":v" .. term_command .. "<CR>")

-- Move cursor relative to visual line breaks
local function silent_map(mode, lhs, rhs)
    map(mode, lhs, rhs, { silent = true })
end

silent_map("n", "<Up>", "gk")
silent_map("n", "<Down>", "gj")
silent_map("n", "<Home>", "g<Home>")
silent_map("n", "<End>", "g<End>")

silent_map("v", "<Up>", "gk")
silent_map("v", "<Down>", "gj")
silent_map("v", "<Home>", "g<Home>")
silent_map("v", "<End>", "g<End>")

silent_map("i", "<Up>", "<C-o>gk")
silent_map("i", "<Down>", "<C-o>gj")
silent_map("i", "<Home>", "<C-o>g<Home>")
silent_map("i", "<End>", "<C-o>g<End>")

opt.autoindent = true
opt.autoread = true
opt.cursorcolumn = true
opt.cursorline = true
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
opt.foldlevelstart = 10

vim.cmd([[hi CursorLine cterm=NONE ctermbg=darkgray ctermfg=white]])
vim.cmd([[au BufRead,BufNewFile .env.* set filetype=sh]])
vim.cmd([[au BufRead,BufNewFile Dockerfile.* set filetype=dockerfile]])

-- redo folds on write
vim.cmd([[au BufWrite * normal zx]])
