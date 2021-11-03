--local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ","

map("v", "<C-C>", '"+y')
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprevious<CR>")
map("n", "<esc>", ":noh<cr><esc>", {silent = true}) --After searching, pressing escape stops the highlight

map("n", "<Leader>w", [[:%s/\s\+$//e <CR>]])
map("n", "<Leader>x", ":Bclose <CR>")
map("n", "<Leader>t", ":tabnew <CR>")

-- Split navigations
map("n", "<C-Right>", "<C-W><C-L>")
map("n", "<C-Left>", "<C-W><C-H>")
map("n", "<C-Up>", "<C-W><C-K>")
map("n", "<C-Down>", "<C-W><C-J>")

-- Resize split
map("n", "<M-j>", "<C-W>-")
map("n", "<M-k>", "<C-W>+")
map("n", "<M-h>", "<C-W><")
map("n", "<M-l>", "<C-W>>")

-- Scroll viewport
map("n", "<S-Up>", "<C-Y>")
map("n", "<S-Down>", "<C-E>")
map("v", "<S-Up>", "<C-Y>")
map("v", "<S-Down>", "<C-E>")
map("i", "<S-Up>", "<C-X><C-Y>")
map("i", "<S-Down>", "<C-X><C-E>")

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- map Enter to switch tabs
--map("n", "<Enter>", ":tabnext<CR>")
--map("n", "<Backspace>", ":tabprevious<CR>")

---------
-- HOP --
---------
local hopword = [[<cmd>lua require'hop'.hint_words()<cr>]]
local hopline = [[<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>]]
--map("n", "<m-l>", hopline, {silent = true})
--map("v", "<m-l>", hopline, {silent = true})
--map("n", "<m-w>", hopword, {silent = true})
--map("v", "<m-w>", hopword, {silent = true})
map("n", "W", hopline, {silent = true})
map("v", "W", hopline, {silent = true})
map("n", "w", hopword, {silent = true})
map("v", "w", hopword, {silent = true})

---------
-- FZF --
---------
map("n", "<Leader>o", ":Files <CR>")
map("n", "<Leader>p", ":Buffers <CR>")
map("n", "<Leader>h", ":Helptags <CR>")
map("n", "<Leader>;", ":History: <CR>")
map("n", "<Leader>c", ":Commands <CR>")
map("n", "<Leader>/", ":Rg <CR>")
--map("n", "<Leader>[", ":Windows <CR>")

---------
-- ALE --
---------
--map("n", "<c-k>", ":ALEPreviousWrap <CR>", {silent = true})
--map("n", "<c-j>", ":ALENextWrap <CR>", {silent = true})
